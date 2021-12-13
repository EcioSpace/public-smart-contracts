// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

interface IBPContract {
    function protect(
        address sender,
        address receiver,
        uint256 amount
    ) external;
}

contract EcioSpace is
    Initializable,
    ERC20Upgradeable,
    ERC20BurnableUpgradeable,
    PausableUpgradeable,
    AccessControlUpgradeable
{
    uint256 private constant TOTAL_SUPPLY = 7000 * 10**(6 + 18); // 7000M tokens
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    IBPContract public bpContract;

    bool public bpEnabled;
    bool public bpDisabledForever;

    constructor() initializer {}

    function initialize() public initializer {
        __ERC20_init("ECIO Space", "ECIO");
        __ERC20Burnable_init();
        __Pausable_init();
        __AccessControl_init();

        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(PAUSER_ROLE, msg.sender);
        _setupRole(MINTER_ROLE, msg.sender);
    }

    function setBPContract(address addr) public onlyRole(DEFAULT_ADMIN_ROLE) {
        require(addr != address(0), "BP adress cannot be 0x0");
        bpContract = IBPContract(addr);
    }

    function setBPEnabled(bool enabled) public onlyRole(DEFAULT_ADMIN_ROLE) {
        bpEnabled = enabled;
    }

    function setBPDisableForever() public onlyRole(DEFAULT_ADMIN_ROLE) {
        require(!bpDisabledForever, "Bot protection disabled");

        bpDisabledForever = true;
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override whenNotPaused {
        if (bpEnabled && !bpDisabledForever) {
            bpContract.protect(from, to, amount);
        }

        super._beforeTokenTransfer(from, to, amount);
    }

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        require(
            totalSupply() + amount <= TOTAL_SUPPLY,
            "The token amount exceeded the total supply."
        );
        _mint(to, amount);
    }
}
