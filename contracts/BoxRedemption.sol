// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

// import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
// import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
// import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

interface ERC1155_CONTRACT {
    function balanceOf(address account, uint256 id)
        external
        view
        returns (uint256);

    function safeMint(address to, string memory partCode) external;

    function burn(
        address account,
        uint256 id,
        uint256 value
    ) external;
}

interface ERC721_CONTRACT {
    function safeMint(address to, string memory partCode) external;
}

interface RANDOM_CONTRACT {
    function startRandom() external returns (uint256);
}

contract BoxRedemption is Ownable {
    using Strings for string;
    uint8 private constant CM_BOX = 0;
    uint8 private constant R_BOX = 1;
    uint8 private constant E_BOX = 2;
    uint8 private constant NFT_TYPE = 0; //Kingdom
    uint8 private constant KINGDOM = 1; //Kingdom
    uint8 private constant TRANING_CAMP = 2; //Training Camp
    uint8 private constant GEAR = 3; //Battle Gear
    uint8 private constant DRONE = 4; //Battle Drone
    uint8 private constant SUITE = 5; //Battle Suit
    uint8 private constant BOT = 6; //Battle Bot
    uint8 private constant GENOME = 7; //Human Genome
    uint8 private constant WEAPON = 8; //Weapon
    uint8 private constant COMBAT_RANKS = 9; //Combat Ranks
    uint8 private constant BLUEPRINT_FRAGMENT_COMMON = 0;
    uint8 private constant BLUEPRINT_FRAGMENT_RARE = 1;
    uint8 private constant BLUEPRINT_FRAGMENT_EPIC = 2;
    uint8 private constant GENOMIC_FRAGMENT_COMMON = 3;
    uint8 private constant GENOMIC_FRAGMENT_RARE = 4;
    uint8 private constant GENOMIC_FRAGMENT_EPIC = 5;
    uint8 private constant SPACE_WARRIOR = 6;

    uint8 private constant COMMON = 0;
    uint8 private constant RARE = 1;
    uint8 private constant EPIC = 2;

    //Testnet
    address public constant MISTORY_BOX_CONTRACT =
        0xfB684dC65DE6C27c63fa7a00B9b9fB70d2125Ea1;
    address public constant ECIO_NFT_CORE_CONTRACT =
        0x7E8eEe5be55A589d5571Be7176172f4DEE7f47aF;
    address public constant RANDOM_WORKER_CONTRACT =
        0x5ABF279B87F84C916d0f34c2dafc949f86ffb887;

    //Mainnet
    // address public constant GALAXY_CONTRACT_CM = 0xaae9f9d4fb8748feba405cE25856DC57C91BbB92;
    // address public constant GALAXY_CONTRACT_RARE = 0xc04581BEA69A9C781532A17169C59980F4faC757;
    // address public constant GALAXY_CONTRACT_EPIC = 0x9C90ba4C8834e92A771e4Fc0f486F1460e7b7a34;

    //Testnet
    address public constant GAX_CM = 0x80Bf5dbD599769Eb008a61da6a20a347db35Fd0e;
    address public constant GAX_RARE =
        0x0253Bbd5874f775100BCec873383a2AfdA466273;
    address public constant GAX_EPIC =
        0x36b6eA8bc7E0F4817D3b0212a6797E9b4316eC4C;

    mapping(uint256 => address) ranNumToSender;
    mapping(uint256 => uint256) requestToNFTId;

    //NFTPool
    mapping(uint256 => mapping(uint256 => uint256)) public NFTPool;

    //EPool
    mapping(uint256 => uint256) public EPool;

    //BlueprintFragmentPool
    mapping(uint256 => mapping(uint256 => mapping(uint256 => mapping(uint256 => uint256))))
        public BPPool;

    //GenomicPool
    mapping(uint256 => mapping(uint256 => mapping(uint256 => uint256)))
        public GenomicPool;

    //SpaceWarriorPool
    mapping(uint256 => mapping(uint256 => mapping(uint256 => uint256)))
        public SWPool;

    event OpenBox(address _by, uint256 _nftId, string partCode);

    constructor() {}

    function initial() public onlyOwner {
        //NFT Type
        // NFTPool[CM_BOX][0] = 0; //BLUEPRINT_FRAGMENT_COMMON
        // NFTPool[CM_BOX][1] = 0;
        // NFTPool[CM_BOX][2] = 0;
        // NFTPool[CM_BOX][3] = 0;
        // NFTPool[CM_BOX][4] = 0;
        // NFTPool[CM_BOX][5] = 0;
        NFTPool[CM_BOX][6] = 1; //BLUEPRINT_FRAGMENT_RARE
        NFTPool[CM_BOX][7] = 1;
        NFTPool[CM_BOX][8] = 1;
        NFTPool[CM_BOX][9] = 1;
        NFTPool[CM_BOX][10] = 3; //GENOMIC_FRAGMENT_COMMON
        NFTPool[CM_BOX][11] = 3;
        NFTPool[CM_BOX][12] = 3;
        NFTPool[CM_BOX][13] = 3;
        NFTPool[CM_BOX][14] = 3;
        NFTPool[CM_BOX][15] = 3;
        NFTPool[CM_BOX][16] = 3;
        NFTPool[CM_BOX][17] = 3;
        NFTPool[CM_BOX][18] = 6; //SPACE_WARRIOR
        NFTPool[CM_BOX][19] = 6;

        // NFTPool[R_BOX][0] = 0;//BLUEPRINT_FRAGMENT_COMMON
        // NFTPool[R_BOX][1] = 0;
        NFTPool[R_BOX][2] = 1; //BLUEPRINT_FRAGMENT_RARE
        NFTPool[R_BOX][3] = 1;
        NFTPool[R_BOX][4] = 2; //BLUEPRINT_FRAGMENT_EPIC
        NFTPool[R_BOX][5] = 3; //GENOMIC_FRAGMENT_COMMON
        NFTPool[R_BOX][6] = 3;
        NFTPool[R_BOX][7] = 3;
        NFTPool[R_BOX][8] = 3;
        NFTPool[R_BOX][9] = 4; //GENOMIC_FRAGMENT_RARE
        NFTPool[R_BOX][10] = 4;
        NFTPool[R_BOX][11] = 4;
        NFTPool[R_BOX][12] = 4;
        NFTPool[R_BOX][13] = 4;
        NFTPool[R_BOX][14] = 4;
        NFTPool[R_BOX][15] = 6; //SPACE_WARRIOR
        NFTPool[R_BOX][16] = 6;
        NFTPool[R_BOX][17] = 6;
        NFTPool[R_BOX][18] = 6;
        NFTPool[R_BOX][19] = 6;

        NFTPool[E_BOX][0] = 2; //BLUEPRINT_FRAGMENT_EPIC
        NFTPool[E_BOX][1] = 2;
        NFTPool[E_BOX][2] = 4; //GENOMIC_FRAGMENT_RARE
        NFTPool[E_BOX][3] = 4;
        NFTPool[E_BOX][4] = 5; //GENOMIC_FRAGMENT_EPIC
        NFTPool[E_BOX][5] = 5;
        NFTPool[E_BOX][6] = 6; //SPACE_WARRIOR
        NFTPool[E_BOX][7] = 6;
        NFTPool[E_BOX][8] = 6;
        NFTPool[E_BOX][9] = 6;
        NFTPool[E_BOX][10] = 6;
        NFTPool[E_BOX][11] = 6;
        NFTPool[E_BOX][12] = 6;
        NFTPool[E_BOX][13] = 6;
        NFTPool[E_BOX][14] = 6;
        NFTPool[E_BOX][15] = 6;
        NFTPool[E_BOX][16] = 6;
        NFTPool[E_BOX][17] = 6;
        NFTPool[E_BOX][18] = 6;
        NFTPool[E_BOX][19] = 6;

        EPool[0] = GEAR; //Battle Gear
        EPool[1] = DRONE; //Battle Drone
        EPool[2] = SUITE; //Battle Suit
        EPool[3] = BOT; //Battle Bot
        EPool[4] = WEAPON; //Weapon

        // SWPool[TRANING_CAMP][CM_BOX][0] = 0;
        SWPool[TRANING_CAMP][CM_BOX][1] = 1;
        SWPool[TRANING_CAMP][CM_BOX][2] = 2;
        SWPool[TRANING_CAMP][CM_BOX][3] = 3;
        SWPool[TRANING_CAMP][CM_BOX][4] = 4;

        // SWPool[TRANING_CAMP][R_BOX][0] = 0;
        SWPool[TRANING_CAMP][R_BOX][1] = 1;
        SWPool[TRANING_CAMP][R_BOX][2] = 2;
        SWPool[TRANING_CAMP][R_BOX][3] = 3;
        SWPool[TRANING_CAMP][R_BOX][4] = 4;

        // SWPool[TRANING_CAMP][E_BOX][0] = 0;
        SWPool[TRANING_CAMP][E_BOX][1] = 1;
        SWPool[TRANING_CAMP][E_BOX][2] = 2;
        SWPool[TRANING_CAMP][E_BOX][3] = 3;
        SWPool[TRANING_CAMP][E_BOX][4] = 4;
    }

    function initialRandomData() public onlyOwner {
        // --- For Common Box ------
        BPPool[CM_BOX][COMMON][GEAR][0] = 1;
        BPPool[CM_BOX][COMMON][GEAR][1] = 2;
        BPPool[CM_BOX][COMMON][GEAR][2] = 3;
        BPPool[CM_BOX][COMMON][GEAR][3] = 4;

        BPPool[CM_BOX][COMMON][DRONE][0] = 1;
        BPPool[CM_BOX][COMMON][DRONE][1] = 2;
        BPPool[CM_BOX][COMMON][DRONE][2] = 3;
        BPPool[CM_BOX][COMMON][DRONE][3] = 4;

        // BPPool[CM_BOX][COMMON][SUITE][0] = 0;
        BPPool[CM_BOX][COMMON][SUITE][1] = 1;
        BPPool[CM_BOX][COMMON][SUITE][2] = 2;

        BPPool[CM_BOX][COMMON][BOT][0] = 1;
        BPPool[CM_BOX][COMMON][BOT][1] = 2;
        BPPool[CM_BOX][COMMON][BOT][2] = 3;
        BPPool[CM_BOX][COMMON][BOT][3] = 4;

        // BPPool[CM_BOX][COMMON][WEAPON][0] = 0;
        BPPool[CM_BOX][COMMON][WEAPON][1] = 1;
        BPPool[CM_BOX][COMMON][WEAPON][2] = 2;
        BPPool[CM_BOX][COMMON][WEAPON][3] = 3;
        //
        BPPool[CM_BOX][RARE][GEAR][0] = 5;
        BPPool[CM_BOX][RARE][GEAR][1] = 6;
        BPPool[CM_BOX][RARE][GEAR][2] = 7;

        BPPool[CM_BOX][RARE][DRONE][0] = 5;
        BPPool[CM_BOX][RARE][DRONE][1] = 6;
        BPPool[CM_BOX][RARE][DRONE][2] = 7;

        BPPool[CM_BOX][RARE][SUITE][0] = 3;
        BPPool[CM_BOX][RARE][SUITE][1] = 4;
        BPPool[CM_BOX][RARE][SUITE][2] = 5;

        BPPool[CM_BOX][RARE][BOT][0] = 5;
        BPPool[CM_BOX][RARE][BOT][1] = 6;
        BPPool[CM_BOX][RARE][BOT][2] = 7;

        BPPool[CM_BOX][RARE][WEAPON][0] = 4;
        BPPool[CM_BOX][RARE][WEAPON][1] = 5;
        BPPool[CM_BOX][RARE][WEAPON][2] = 6;
        BPPool[CM_BOX][RARE][WEAPON][3] = 7;

        // GenomicPool[CM_BOX][COMMON][0] = 0;
        GenomicPool[CM_BOX][COMMON][1] = 1;
        GenomicPool[CM_BOX][COMMON][2] = 2;
        GenomicPool[CM_BOX][COMMON][3] = 3;
        GenomicPool[CM_BOX][COMMON][4] = 4;
        GenomicPool[CM_BOX][COMMON][5] = 5;
        GenomicPool[CM_BOX][COMMON][6] = 6;

        // --- For  Rare Box ------
        BPPool[R_BOX][COMMON][GEAR][0] = 1;
        BPPool[R_BOX][COMMON][GEAR][1] = 2;
        BPPool[R_BOX][COMMON][GEAR][2] = 3;
        BPPool[R_BOX][COMMON][GEAR][3] = 4;

        BPPool[R_BOX][COMMON][DRONE][0] = 1;
        BPPool[R_BOX][COMMON][DRONE][1] = 2;
        BPPool[R_BOX][COMMON][DRONE][2] = 3;
        BPPool[R_BOX][COMMON][DRONE][3] = 4;

        // BPPool[R_BOX][COMMON][SUITE][0] = 0;
        BPPool[R_BOX][COMMON][SUITE][1] = 1;
        BPPool[R_BOX][COMMON][SUITE][2] = 2;

        BPPool[R_BOX][COMMON][BOT][0] = 1;
        BPPool[R_BOX][COMMON][BOT][1] = 2;
        BPPool[R_BOX][COMMON][BOT][2] = 3;
        BPPool[R_BOX][COMMON][BOT][3] = 4;

        // BPPool[R_BOX][COMMON][WEAPON][0] = 0;
        BPPool[R_BOX][COMMON][WEAPON][1] = 1;
        BPPool[R_BOX][COMMON][WEAPON][2] = 2;
        BPPool[R_BOX][COMMON][WEAPON][3] = 3;
        //
        BPPool[R_BOX][RARE][GEAR][0] = 5;
        BPPool[R_BOX][RARE][GEAR][1] = 6;
        BPPool[R_BOX][RARE][GEAR][2] = 7;

        BPPool[R_BOX][RARE][DRONE][0] = 5;
        BPPool[R_BOX][RARE][DRONE][1] = 6;
        BPPool[R_BOX][RARE][DRONE][2] = 7;

        BPPool[R_BOX][RARE][SUITE][0] = 3;
        BPPool[R_BOX][RARE][SUITE][1] = 4;
        BPPool[R_BOX][RARE][SUITE][2] = 5;

        BPPool[R_BOX][RARE][BOT][0] = 5;
        BPPool[R_BOX][RARE][BOT][1] = 6;
        BPPool[R_BOX][RARE][BOT][2] = 7;

        BPPool[R_BOX][RARE][WEAPON][0] = 4;
        BPPool[R_BOX][RARE][WEAPON][1] = 5;
        BPPool[R_BOX][RARE][WEAPON][2] = 6;
        BPPool[R_BOX][RARE][WEAPON][3] = 7;
        BPPool[R_BOX][RARE][WEAPON][4] = 8;

        //Epic
        BPPool[R_BOX][EPIC][GEAR][0] = 8;
        BPPool[R_BOX][EPIC][GEAR][1] = 9;
        BPPool[R_BOX][EPIC][GEAR][2] = 10;

        BPPool[R_BOX][EPIC][DRONE][0] = 8;
        BPPool[R_BOX][EPIC][DRONE][1] = 9;
        BPPool[R_BOX][EPIC][DRONE][2] = 10;

        BPPool[R_BOX][EPIC][SUITE][0] = 6;
        BPPool[R_BOX][EPIC][SUITE][1] = 7;
        BPPool[R_BOX][EPIC][SUITE][2] = 8;
        BPPool[R_BOX][EPIC][SUITE][3] = 9;

        BPPool[R_BOX][EPIC][BOT][0] = 8;
        BPPool[R_BOX][EPIC][BOT][1] = 9;
        BPPool[R_BOX][EPIC][BOT][2] = 10;

        BPPool[R_BOX][EPIC][WEAPON][0] = 9;
        BPPool[R_BOX][EPIC][WEAPON][1] = 10;
        BPPool[R_BOX][EPIC][WEAPON][2] = 11;
        BPPool[R_BOX][EPIC][WEAPON][3] = 12;
        BPPool[R_BOX][EPIC][WEAPON][4] = 13;
        BPPool[R_BOX][EPIC][WEAPON][5] = 14;

        // GenomicPool[R_BOX][COMMON][0] = 0;
        GenomicPool[R_BOX][COMMON][1] = 1;
        GenomicPool[R_BOX][COMMON][2] = 2;
        GenomicPool[R_BOX][COMMON][3] = 3;
        GenomicPool[R_BOX][COMMON][4] = 4;
        GenomicPool[R_BOX][COMMON][5] = 5;
        GenomicPool[R_BOX][COMMON][6] = 6;

        GenomicPool[R_BOX][RARE][0] = 7;
        GenomicPool[R_BOX][RARE][1] = 8;
        GenomicPool[R_BOX][RARE][2] = 9;
        GenomicPool[R_BOX][RARE][3] = 10;
        GenomicPool[R_BOX][RARE][4] = 11;
        GenomicPool[R_BOX][RARE][5] = 12;

        // --- For Epic Box ------
        BPPool[E_BOX][RARE][GEAR][0] = 8;
        BPPool[E_BOX][RARE][GEAR][1] = 9;
        BPPool[E_BOX][RARE][GEAR][2] = 10;

        BPPool[E_BOX][RARE][DRONE][0] = 8;
        BPPool[E_BOX][RARE][DRONE][1] = 9;
        BPPool[E_BOX][RARE][DRONE][2] = 10;

        BPPool[E_BOX][RARE][SUITE][0] = 6;
        BPPool[E_BOX][RARE][SUITE][1] = 7;
        BPPool[E_BOX][RARE][SUITE][2] = 8;
        BPPool[E_BOX][RARE][SUITE][3] = 9;

        BPPool[E_BOX][RARE][BOT][0] = 8;
        BPPool[E_BOX][RARE][BOT][1] = 9;
        BPPool[E_BOX][RARE][BOT][2] = 10;

        BPPool[E_BOX][RARE][WEAPON][0] = 9;
        BPPool[E_BOX][RARE][WEAPON][1] = 10;
        BPPool[E_BOX][RARE][WEAPON][2] = 11;
        BPPool[E_BOX][RARE][WEAPON][3] = 12;
        BPPool[E_BOX][RARE][WEAPON][4] = 13;
        BPPool[E_BOX][RARE][WEAPON][5] = 14;

        //Epic
        BPPool[E_BOX][EPIC][GEAR][0] = 8;
        BPPool[E_BOX][EPIC][GEAR][1] = 9;
        BPPool[E_BOX][EPIC][GEAR][2] = 10;

        BPPool[E_BOX][EPIC][DRONE][0] = 8;
        BPPool[E_BOX][EPIC][DRONE][1] = 9;
        BPPool[E_BOX][EPIC][DRONE][2] = 10;

        BPPool[E_BOX][EPIC][SUITE][0] = 6;
        BPPool[E_BOX][EPIC][SUITE][1] = 7;
        BPPool[E_BOX][EPIC][SUITE][2] = 8;
        BPPool[E_BOX][EPIC][SUITE][3] = 9;

        BPPool[E_BOX][EPIC][BOT][0] = 8;
        BPPool[E_BOX][EPIC][BOT][1] = 9;
        BPPool[E_BOX][EPIC][BOT][2] = 10;

        BPPool[E_BOX][EPIC][WEAPON][0] = 9;
        BPPool[E_BOX][EPIC][WEAPON][1] = 10;
        BPPool[E_BOX][EPIC][WEAPON][2] = 11;
        BPPool[E_BOX][EPIC][WEAPON][3] = 12;
        BPPool[E_BOX][EPIC][WEAPON][4] = 13;
        BPPool[E_BOX][EPIC][WEAPON][5] = 14;

        // GenomicPool[E_BOX][COMMON][0] = 0;
        // GenomicPool[E_BOX][COMMON][1] = 1;
        // GenomicPool[E_BOX][COMMON][2] = 2;
        // GenomicPool[E_BOX][COMMON][3] = 3;
        // GenomicPool[E_BOX][COMMON][4] = 4;
        // GenomicPool[E_BOX][COMMON][5] = 5;
        // GenomicPool[E_BOX][COMMON][6] = 6;

        GenomicPool[E_BOX][RARE][0] = 7;
        GenomicPool[E_BOX][RARE][1] = 8;
        GenomicPool[E_BOX][RARE][2] = 9;
        GenomicPool[E_BOX][RARE][3] = 10;
        GenomicPool[E_BOX][RARE][4] = 11;
        GenomicPool[E_BOX][RARE][5] = 12;

        GenomicPool[E_BOX][EPIC][0] = 13;
        GenomicPool[E_BOX][EPIC][1] = 14;
        GenomicPool[E_BOX][EPIC][2] = 15;
        GenomicPool[E_BOX][EPIC][3] = 16;
    }

    function initialSpaceData1() public onlyOwner {
        //BattleGearCampPool
        // SWPool[GEAR][CM_BOX][0] = 0;
        // SWPool[GEAR][CM_BOX][1] = 0;
        // SWPool[GEAR][CM_BOX][2] = 0;
        // SWPool[GEAR][CM_BOX][3] = 0;
        // SWPool[GEAR][CM_BOX][4] = 0;
        // SWPool[GEAR][CM_BOX][5] = 0;
        // SWPool[GEAR][CM_BOX][6] = 0;
        // SWPool[GEAR][CM_BOX][7] = 0;
        // SWPool[GEAR][CM_BOX][8] = 0;
        // SWPool[GEAR][CM_BOX][9] = 0;
        // SWPool[GEAR][CM_BOX][10] = 0;
        // SWPool[GEAR][CM_BOX][11] = 0;
        // SWPool[GEAR][CM_BOX][12] = 0;
        // SWPool[GEAR][CM_BOX][13] = 0;
        // SWPool[GEAR][CM_BOX][14] = 0;
        // SWPool[GEAR][CM_BOX][15] = 0;
        // SWPool[GEAR][CM_BOX][16] = 0;
        // SWPool[GEAR][CM_BOX][17] = 0;
        // SWPool[GEAR][CM_BOX][18] = 0;
        // SWPool[GEAR][CM_BOX][19] = 0;
        // SWPool[GEAR][CM_BOX][20] = 0;
        // SWPool[GEAR][CM_BOX][21] = 0;
        // SWPool[GEAR][CM_BOX][22] = 0;
        // SWPool[GEAR][CM_BOX][23] = 0;
        SWPool[GEAR][CM_BOX][24] = 1;
        SWPool[GEAR][CM_BOX][25] = 2;
        SWPool[GEAR][CM_BOX][26] = 3;
        SWPool[GEAR][CM_BOX][27] = 4;
        SWPool[GEAR][CM_BOX][28] = 5;
        SWPool[GEAR][CM_BOX][29] = 6;

        //DRONE
        // SWPool[DRONE][CM_BOX][0] = 0;
        // SWPool[DRONE][CM_BOX][1] = 0;
        // SWPool[DRONE][CM_BOX][2] = 0;
        // SWPool[DRONE][CM_BOX][3] = 0;
        // SWPool[DRONE][CM_BOX][4] = 0;
        // SWPool[DRONE][CM_BOX][5] = 0;
        // SWPool[DRONE][CM_BOX][6] = 0;
        // SWPool[DRONE][CM_BOX][7] = 0;
        // SWPool[DRONE][CM_BOX][8] = 0;
        // SWPool[DRONE][CM_BOX][9] = 0;
        // SWPool[DRONE][CM_BOX][10] = 0;
        // SWPool[DRONE][CM_BOX][11] = 0;
        // SWPool[DRONE][CM_BOX][12] = 0;
        // SWPool[DRONE][CM_BOX][13] = 0;
        // SWPool[DRONE][CM_BOX][14] = 0;
        // SWPool[DRONE][CM_BOX][15] = 0;
        // SWPool[DRONE][CM_BOX][16] = 0;
        // SWPool[DRONE][CM_BOX][17] = 0;
        // SWPool[DRONE][CM_BOX][18] = 0;
        // SWPool[DRONE][CM_BOX][19] = 0;
        // SWPool[DRONE][CM_BOX][20] = 0;
        // SWPool[DRONE][CM_BOX][21] = 0;
        // SWPool[DRONE][CM_BOX][22] = 0;
        // SWPool[DRONE][CM_BOX][23] = 0;
        SWPool[DRONE][CM_BOX][24] = 1;
        SWPool[DRONE][CM_BOX][25] = 2;
        SWPool[DRONE][CM_BOX][26] = 3;
        SWPool[DRONE][CM_BOX][27] = 4;
        SWPool[DRONE][CM_BOX][28] = 5;
        SWPool[DRONE][CM_BOX][29] = 6;

        //SUITE
        // SWPool[SUITE][CM_BOX][0] = 0;
        // SWPool[SUITE][CM_BOX][1] = 0;
        // SWPool[SUITE][CM_BOX][2] = 0;
        // SWPool[SUITE][CM_BOX][3] = 0;
        // SWPool[SUITE][CM_BOX][4] = 0;
        SWPool[SUITE][CM_BOX][5] = 1;
        SWPool[SUITE][CM_BOX][6] = 1;
        SWPool[SUITE][CM_BOX][7] = 1;
        SWPool[SUITE][CM_BOX][8] = 1;
        SWPool[SUITE][CM_BOX][9] = 1;
        SWPool[SUITE][CM_BOX][10] = 2;
        SWPool[SUITE][CM_BOX][11] = 2;
        SWPool[SUITE][CM_BOX][12] = 2;
        SWPool[SUITE][CM_BOX][13] = 2;
        SWPool[SUITE][CM_BOX][14] = 2;
        SWPool[SUITE][CM_BOX][15] = 3;
        SWPool[SUITE][CM_BOX][16] = 4;
        SWPool[SUITE][CM_BOX][17] = 5;

        //BOT
        // SWPool[BOT][CM_BOX][0] = 0;
        // SWPool[BOT][CM_BOX][1] = 0;
        // SWPool[BOT][CM_BOX][2] = 0;
        // SWPool[BOT][CM_BOX][3] = 0;
        // SWPool[BOT][CM_BOX][4] = 0;
        // SWPool[BOT][CM_BOX][5] = 0;
        // SWPool[BOT][CM_BOX][6] = 0;
        // SWPool[BOT][CM_BOX][7] = 0;
        // SWPool[BOT][CM_BOX][8] = 0;
        // SWPool[BOT][CM_BOX][9] = 0;
        // SWPool[BOT][CM_BOX][10] = 0;
        // SWPool[BOT][CM_BOX][11] = 0;
        // SWPool[BOT][CM_BOX][12] = 0;
        // SWPool[BOT][CM_BOX][13] = 0;
        // SWPool[BOT][CM_BOX][14] = 0;
        // SWPool[BOT][CM_BOX][15] = 0;
        // SWPool[BOT][CM_BOX][16] = 0;
        // SWPool[BOT][CM_BOX][17] = 0;
        // SWPool[BOT][CM_BOX][18] = 0;
        SWPool[BOT][CM_BOX][19] = 1;
        SWPool[BOT][CM_BOX][20] = 1;
        SWPool[BOT][CM_BOX][21] = 2;
        SWPool[BOT][CM_BOX][22] = 2;
        SWPool[BOT][CM_BOX][23] = 3;
        SWPool[BOT][CM_BOX][24] = 3;
        SWPool[BOT][CM_BOX][25] = 4;
        SWPool[BOT][CM_BOX][26] = 4;
        SWPool[BOT][CM_BOX][27] = 5;
        SWPool[BOT][CM_BOX][28] = 6;
        SWPool[BOT][CM_BOX][29] = 7;

        //GENOME
        // SWPool[GENOME][CM_BOX][0] = 0;
        // SWPool[GENOME][CM_BOX][1] = 0;
        // SWPool[GENOME][CM_BOX][2] = 0;
        // SWPool[GENOME][CM_BOX][3] = 0;
        SWPool[GENOME][CM_BOX][4] = 1;
        SWPool[GENOME][CM_BOX][5] = 1;
        SWPool[GENOME][CM_BOX][6] = 1;
        SWPool[GENOME][CM_BOX][7] = 1;
        SWPool[GENOME][CM_BOX][8] = 2;
        SWPool[GENOME][CM_BOX][9] = 2;
        SWPool[GENOME][CM_BOX][10] = 2;
        SWPool[GENOME][CM_BOX][11] = 2;
        SWPool[GENOME][CM_BOX][12] = 3;
        SWPool[GENOME][CM_BOX][13] = 3;
        SWPool[GENOME][CM_BOX][14] = 3;
        SWPool[GENOME][CM_BOX][15] = 3;
        SWPool[GENOME][CM_BOX][16] = 4;
        SWPool[GENOME][CM_BOX][17] = 4;
        SWPool[GENOME][CM_BOX][18] = 4;
        SWPool[GENOME][CM_BOX][19] = 4;
        SWPool[GENOME][CM_BOX][20] = 5;
        SWPool[GENOME][CM_BOX][21] = 5;
        SWPool[GENOME][CM_BOX][22] = 5;
        SWPool[GENOME][CM_BOX][23] = 5;
        SWPool[GENOME][CM_BOX][24] = 6;
        SWPool[GENOME][CM_BOX][25] = 6;
        SWPool[GENOME][CM_BOX][26] = 6;
        SWPool[GENOME][CM_BOX][27] = 6;

        //WEAPON
        // SWPool[WEAPON][CM_BOX][0] = 0;
        // SWPool[WEAPON][CM_BOX][1] = 0;
        // SWPool[WEAPON][CM_BOX][2] = 0;
        // SWPool[WEAPON][CM_BOX][3] = 0;
        // SWPool[WEAPON][CM_BOX][4] = 0;
        // SWPool[WEAPON][CM_BOX][5] = 0;
        SWPool[WEAPON][CM_BOX][6] = 1;
        SWPool[WEAPON][CM_BOX][7] = 1;
        SWPool[WEAPON][CM_BOX][8] = 1;
        SWPool[WEAPON][CM_BOX][9] = 1;
        SWPool[WEAPON][CM_BOX][10] = 1;
        SWPool[WEAPON][CM_BOX][11] = 1;
        SWPool[WEAPON][CM_BOX][12] = 2;
        SWPool[WEAPON][CM_BOX][13] = 2;
        SWPool[WEAPON][CM_BOX][14] = 2;
        SWPool[WEAPON][CM_BOX][15] = 2;
        SWPool[WEAPON][CM_BOX][16] = 2;
        SWPool[WEAPON][CM_BOX][17] = 2;
        SWPool[WEAPON][CM_BOX][18] = 3;
        SWPool[WEAPON][CM_BOX][19] = 3;
        SWPool[WEAPON][CM_BOX][20] = 3;
        SWPool[WEAPON][CM_BOX][21] = 3;
        SWPool[WEAPON][CM_BOX][22] = 3;
        SWPool[WEAPON][CM_BOX][23] = 3;
        SWPool[WEAPON][CM_BOX][24] = 4;
        SWPool[WEAPON][CM_BOX][25] = 5;
        SWPool[WEAPON][CM_BOX][26] = 6;
        SWPool[WEAPON][CM_BOX][27] = 7;
        SWPool[WEAPON][CM_BOX][28] = 8;
    }

    function initialSpaceData2() public onlyOwner {
        // ------- RARE -------
        //BattleGearCampPool
        // SWPool[GEAR][R_BOX][0] = 0;
        // SWPool[GEAR][R_BOX][1] = 0;
        // SWPool[GEAR][R_BOX][2] = 0;
        // SWPool[GEAR][R_BOX][3] = 0;
        // SWPool[GEAR][R_BOX][4] = 0;
        // SWPool[GEAR][R_BOX][5] = 0;
        // SWPool[GEAR][R_BOX][6] = 0;
        // SWPool[GEAR][R_BOX][7] = 0;
        // SWPool[GEAR][R_BOX][8] = 0;
        // SWPool[GEAR][R_BOX][9] = 0;
        // SWPool[GEAR][R_BOX][10] = 0;
        // SWPool[GEAR][R_BOX][11] = 0;
        // SWPool[GEAR][R_BOX][12] = 0;
        // SWPool[GEAR][R_BOX][13] = 0;
        // SWPool[GEAR][R_BOX][14] = 0;
        // SWPool[GEAR][R_BOX][15] = 0;
        // SWPool[GEAR][R_BOX][16] = 0;
        // SWPool[GEAR][R_BOX][17] = 0;
        // SWPool[GEAR][R_BOX][18] = 0;
        // SWPool[GEAR][R_BOX][19] = 0;
        SWPool[GEAR][R_BOX][20] = 1;
        SWPool[GEAR][R_BOX][21] = 2;
        SWPool[GEAR][R_BOX][22] = 3;
        SWPool[GEAR][R_BOX][23] = 4;
        SWPool[GEAR][R_BOX][24] = 5;
        SWPool[GEAR][R_BOX][25] = 6;
        SWPool[GEAR][R_BOX][26] = 7;
        SWPool[GEAR][R_BOX][27] = 8;
        SWPool[GEAR][R_BOX][28] = 9;
        SWPool[GEAR][R_BOX][29] = 10;

        //DRONE
        // SWPool[DRONE][R_BOX][0] = 0;
        // SWPool[DRONE][R_BOX][1] = 0;
        // SWPool[DRONE][R_BOX][2] = 0;
        // SWPool[DRONE][R_BOX][3] = 0;
        // SWPool[DRONE][R_BOX][4] = 0;
        // SWPool[DRONE][R_BOX][5] = 0;
        // SWPool[DRONE][R_BOX][6] = 0;
        // SWPool[DRONE][R_BOX][7] = 0;
        // SWPool[DRONE][R_BOX][8] = 0;
        // SWPool[DRONE][R_BOX][9] = 0;
        // SWPool[DRONE][R_BOX][10] = 0;
        // SWPool[DRONE][R_BOX][11] = 0;
        // SWPool[DRONE][R_BOX][12] = 0;
        // SWPool[DRONE][R_BOX][13] = 0;
        // SWPool[DRONE][R_BOX][14] = 0;
        // SWPool[DRONE][R_BOX][15] = 0;
        // SWPool[DRONE][R_BOX][16] = 0;
        // SWPool[DRONE][R_BOX][17] = 0;
        // SWPool[DRONE][R_BOX][18] = 0;
        // SWPool[DRONE][R_BOX][19] = 0;
        SWPool[DRONE][R_BOX][20] = 1;
        SWPool[DRONE][R_BOX][21] = 2;
        SWPool[DRONE][R_BOX][22] = 3;
        SWPool[DRONE][R_BOX][23] = 4;
        SWPool[DRONE][R_BOX][24] = 5;
        SWPool[DRONE][R_BOX][25] = 6;
        SWPool[DRONE][R_BOX][26] = 7;
        SWPool[DRONE][R_BOX][27] = 8;
        SWPool[DRONE][R_BOX][28] = 9;
        SWPool[DRONE][R_BOX][29] = 10;

        //SUITE
        // SWPool[SUITE][R_BOX][0] = 0;
        // SWPool[SUITE][R_BOX][1] = 0;
        // SWPool[SUITE][R_BOX][2] = 0;
        SWPool[SUITE][R_BOX][3] = 1;
        SWPool[SUITE][R_BOX][4] = 1;
        SWPool[SUITE][R_BOX][5] = 1;
        SWPool[SUITE][R_BOX][6] = 2;
        SWPool[SUITE][R_BOX][7] = 2;
        SWPool[SUITE][R_BOX][8] = 2;
        SWPool[SUITE][R_BOX][9] = 4;
        SWPool[SUITE][R_BOX][10] = 4;
        SWPool[SUITE][R_BOX][11] = 5;
        SWPool[SUITE][R_BOX][12] = 5;
        SWPool[SUITE][R_BOX][13] = 6;
        SWPool[SUITE][R_BOX][14] = 7;
        SWPool[SUITE][R_BOX][15] = 8;
        SWPool[SUITE][R_BOX][16] = 9;

        //BOT
        // SWPool[BOT][R_BOX][0] = 0;
        // SWPool[BOT][R_BOX][1] = 0;
        // SWPool[BOT][R_BOX][2] = 0;
        // SWPool[BOT][R_BOX][3] = 0;
        // SWPool[BOT][R_BOX][4] = 0;
        // SWPool[BOT][R_BOX][5] = 0;
        // SWPool[BOT][R_BOX][6] = 0;
        // SWPool[BOT][R_BOX][7] = 0;
        // SWPool[BOT][R_BOX][8] = 0;
        // SWPool[BOT][R_BOX][9] = 0;
        // SWPool[BOT][R_BOX][10] = 0;
        // SWPool[BOT][R_BOX][11] = 0;
        // SWPool[BOT][R_BOX][12] = 0;
        // SWPool[BOT][R_BOX][13] = 0;
        // SWPool[BOT][R_BOX][14] = 0;
        // SWPool[BOT][R_BOX][15] = 0;
        // SWPool[BOT][R_BOX][16] = 0;
        // SWPool[BOT][R_BOX][17] = 0;
        SWPool[BOT][R_BOX][18] = 1;
        SWPool[BOT][R_BOX][19] = 1;
        SWPool[BOT][R_BOX][20] = 2;
        SWPool[BOT][R_BOX][21] = 2;
        SWPool[BOT][R_BOX][22] = 4;
        SWPool[BOT][R_BOX][23] = 4;
        SWPool[BOT][R_BOX][24] = 5;
        SWPool[BOT][R_BOX][25] = 6;
        SWPool[BOT][R_BOX][26] = 7;
        SWPool[BOT][R_BOX][27] = 8;
        SWPool[BOT][R_BOX][28] = 9;
        SWPool[BOT][R_BOX][29] = 10;

        //GENOME
        // SWPool[GENOME][R_BOX][0] = 0;
        // SWPool[GENOME][R_BOX][1] = 0;
        // SWPool[GENOME][R_BOX][2] = 0;
        SWPool[GENOME][R_BOX][3] = 1;
        SWPool[GENOME][R_BOX][4] = 1;
        SWPool[GENOME][R_BOX][5] = 1;
        SWPool[GENOME][R_BOX][6] = 2;
        SWPool[GENOME][R_BOX][7] = 2;
        SWPool[GENOME][R_BOX][8] = 2;
        SWPool[GENOME][R_BOX][9] = 3;
        SWPool[GENOME][R_BOX][10] = 3;
        SWPool[GENOME][R_BOX][11] = 3;
        SWPool[GENOME][R_BOX][12] = 4;
        SWPool[GENOME][R_BOX][13] = 4;
        SWPool[GENOME][R_BOX][14] = 4;
        SWPool[GENOME][R_BOX][15] = 5;
        SWPool[GENOME][R_BOX][16] = 5;
        SWPool[GENOME][R_BOX][17] = 5;
        SWPool[GENOME][R_BOX][18] = 6;
        SWPool[GENOME][R_BOX][19] = 6;
        SWPool[GENOME][R_BOX][20] = 6;
        SWPool[GENOME][R_BOX][21] = 7;
        SWPool[GENOME][R_BOX][22] = 8;
        SWPool[GENOME][R_BOX][23] = 9;
        SWPool[GENOME][R_BOX][24] = 10;

        //WEAPON
        // SWPool[WEAPON][R_BOX][0] = 0;
        // SWPool[WEAPON][R_BOX][1] = 0;
        // SWPool[WEAPON][R_BOX][2] = 0;
        // SWPool[WEAPON][R_BOX][3] = 0;
        // SWPool[WEAPON][R_BOX][4] = 0;
        SWPool[WEAPON][R_BOX][5] = 1;
        SWPool[WEAPON][R_BOX][6] = 1;
        SWPool[WEAPON][R_BOX][7] = 1;
        SWPool[WEAPON][R_BOX][8] = 1;
        SWPool[WEAPON][R_BOX][9] = 1;
        SWPool[WEAPON][R_BOX][10] = 1;
        SWPool[WEAPON][R_BOX][11] = 2;
        SWPool[WEAPON][R_BOX][12] = 2;
        SWPool[WEAPON][R_BOX][13] = 2;
        SWPool[WEAPON][R_BOX][14] = 2;
        SWPool[WEAPON][R_BOX][15] = 2;
        SWPool[WEAPON][R_BOX][16] = 2;
        SWPool[WEAPON][R_BOX][17] = 3;
        SWPool[WEAPON][R_BOX][18] = 3;
        SWPool[WEAPON][R_BOX][19] = 3;
        SWPool[WEAPON][R_BOX][20] = 3;
        SWPool[WEAPON][R_BOX][21] = 3;
        SWPool[WEAPON][R_BOX][22] = 3;
        SWPool[WEAPON][R_BOX][23] = 4;
        SWPool[WEAPON][R_BOX][24] = 5;
        SWPool[WEAPON][R_BOX][25] = 6;
        SWPool[WEAPON][R_BOX][26] = 7;
        SWPool[WEAPON][R_BOX][27] = 8;
        SWPool[WEAPON][R_BOX][28] = 9;
        SWPool[WEAPON][R_BOX][29] = 10;
        SWPool[WEAPON][R_BOX][30] = 11;
        SWPool[WEAPON][R_BOX][31] = 12;
        SWPool[WEAPON][R_BOX][32] = 13;
        SWPool[WEAPON][R_BOX][33] = 14;
    }

    function initialSpaceData3() public onlyOwner {
        // ------- EPIC -------

        //BattleGearCampPool
        // SWPool[GEAR][E_BOX][0] = 0;
        // SWPool[GEAR][E_BOX][1] = 0;
        // SWPool[GEAR][E_BOX][2] = 0;
        // SWPool[GEAR][E_BOX][3] = 0;
        // SWPool[GEAR][E_BOX][4] = 0;
        // SWPool[GEAR][E_BOX][5] = 0;
        // SWPool[GEAR][E_BOX][6] = 0;
        // SWPool[GEAR][E_BOX][7] = 0;
        // SWPool[GEAR][E_BOX][8] = 0;
        // SWPool[GEAR][E_BOX][9] = 0;
        // SWPool[GEAR][E_BOX][10] = 0;
        // SWPool[GEAR][E_BOX][11] = 0;
        // SWPool[GEAR][E_BOX][12] = 0;
        // SWPool[GEAR][E_BOX][13] = 0;
        // SWPool[GEAR][E_BOX][14] = 0;
        // SWPool[GEAR][E_BOX][15] = 0;
        SWPool[GEAR][E_BOX][16] = 1;
        SWPool[GEAR][E_BOX][17] = 1;
        SWPool[GEAR][E_BOX][18] = 2;
        SWPool[GEAR][E_BOX][19] = 2;
        SWPool[GEAR][E_BOX][20] = 3;
        SWPool[GEAR][E_BOX][21] = 3;
        SWPool[GEAR][E_BOX][22] = 4;
        SWPool[GEAR][E_BOX][23] = 4;
        SWPool[GEAR][E_BOX][24] = 5;
        SWPool[GEAR][E_BOX][25] = 6;
        SWPool[GEAR][E_BOX][26] = 7;
        SWPool[GEAR][E_BOX][27] = 8;
        SWPool[GEAR][E_BOX][28] = 9;
        SWPool[GEAR][E_BOX][29] = 10;

        //DRONE
        // SWPool[DRONE][E_BOX][0] = 0;
        // SWPool[DRONE][E_BOX][1] = 0;
        // SWPool[DRONE][E_BOX][2] = 0;
        // SWPool[DRONE][E_BOX][3] = 0;
        // SWPool[DRONE][E_BOX][4] = 0;
        // SWPool[DRONE][E_BOX][5] = 0;
        // SWPool[DRONE][E_BOX][6] = 0;
        // SWPool[DRONE][E_BOX][7] = 0;
        // SWPool[DRONE][E_BOX][8] = 0;
        // SWPool[DRONE][E_BOX][9] = 0;
        // SWPool[DRONE][E_BOX][10] = 0;
        // SWPool[DRONE][E_BOX][11] = 0;
        // SWPool[DRONE][E_BOX][12] = 0;
        // SWPool[DRONE][E_BOX][13] = 0;
        // SWPool[DRONE][E_BOX][14] = 0;
        // SWPool[DRONE][E_BOX][15] = 0;
        SWPool[DRONE][E_BOX][16] = 1;
        SWPool[DRONE][E_BOX][17] = 1;
        SWPool[DRONE][E_BOX][18] = 2;
        SWPool[DRONE][E_BOX][19] = 2;
        SWPool[DRONE][E_BOX][20] = 3;
        SWPool[DRONE][E_BOX][21] = 3;
        SWPool[DRONE][E_BOX][22] = 4;
        SWPool[DRONE][E_BOX][23] = 4;
        SWPool[DRONE][E_BOX][24] = 5;
        SWPool[DRONE][E_BOX][25] = 6;
        SWPool[DRONE][E_BOX][26] = 7;
        SWPool[DRONE][E_BOX][27] = 8;
        SWPool[DRONE][E_BOX][28] = 9;
        SWPool[DRONE][E_BOX][29] = 10;

        //SUITE
        // SWPool[SUITE][E_BOX][0] = 0;
        // SWPool[SUITE][E_BOX][1] = 0;
        // SWPool[SUITE][E_BOX][2] = 0;
        // SWPool[SUITE][E_BOX][3] = 0;
        SWPool[SUITE][E_BOX][4] = 1;
        SWPool[SUITE][E_BOX][5] = 1;
        SWPool[SUITE][E_BOX][6] = 1;
        SWPool[SUITE][E_BOX][7] = 1;
        SWPool[SUITE][E_BOX][8] = 2;
        SWPool[SUITE][E_BOX][9] = 2;
        SWPool[SUITE][E_BOX][10] = 2;
        SWPool[SUITE][E_BOX][11] = 2;
        SWPool[SUITE][E_BOX][12] = 3;
        SWPool[SUITE][E_BOX][13] = 4;
        SWPool[SUITE][E_BOX][14] = 5;
        SWPool[SUITE][E_BOX][15] = 6;
        SWPool[SUITE][E_BOX][16] = 7;
        SWPool[SUITE][E_BOX][17] = 8;
        SWPool[SUITE][E_BOX][18] = 9;

        //BOT
        // SWPool[BOT][E_BOX][0] = 0;
        // SWPool[BOT][E_BOX][1] = 0;
        // SWPool[BOT][E_BOX][2] = 0;
        // SWPool[BOT][E_BOX][3] = 0;
        // SWPool[BOT][E_BOX][4] = 0;
        // SWPool[BOT][E_BOX][5] = 0;
        // SWPool[BOT][E_BOX][6] = 0;
        // SWPool[BOT][E_BOX][7] = 0;
        // SWPool[BOT][E_BOX][8] = 0;
        // SWPool[BOT][E_BOX][9] = 0;
        // SWPool[BOT][E_BOX][10] = 0;
        // SWPool[BOT][E_BOX][11] = 0;
        // SWPool[BOT][E_BOX][12] = 0;
        // SWPool[BOT][E_BOX][13] = 0;
        // SWPool[BOT][E_BOX][14] = 0;
        // SWPool[BOT][E_BOX][15] = 0;
        // SWPool[BOT][E_BOX][16] = 0;
        // SWPool[BOT][E_BOX][17] = 0;
        SWPool[BOT][E_BOX][18] = 1;
        SWPool[BOT][E_BOX][19] = 1;
        SWPool[BOT][E_BOX][20] = 2;
        SWPool[BOT][E_BOX][21] = 2;
        SWPool[BOT][E_BOX][22] = 4;
        SWPool[BOT][E_BOX][23] = 4;
        SWPool[BOT][E_BOX][24] = 5;
        SWPool[BOT][E_BOX][25] = 6;
        SWPool[BOT][E_BOX][26] = 7;
        SWPool[BOT][E_BOX][27] = 8;
        SWPool[BOT][E_BOX][28] = 9;
        SWPool[BOT][E_BOX][29] = 10;

        //GENOME
        // SWPool[GENOME][E_BOX][0] = 0;
        // SWPool[GENOME][E_BOX][1] = 0;
        // SWPool[GENOME][E_BOX][2] = 0;
        SWPool[GENOME][E_BOX][3] = 1;
        SWPool[GENOME][E_BOX][4] = 1;
        SWPool[GENOME][E_BOX][5] = 1;
        SWPool[GENOME][E_BOX][6] = 2;
        SWPool[GENOME][E_BOX][7] = 2;
        SWPool[GENOME][E_BOX][8] = 2;
        SWPool[GENOME][E_BOX][9] = 3;
        SWPool[GENOME][E_BOX][10] = 3;
        SWPool[GENOME][E_BOX][11] = 3;
        SWPool[GENOME][E_BOX][12] = 4;
        SWPool[GENOME][E_BOX][13] = 4;
        SWPool[GENOME][E_BOX][14] = 4;
        SWPool[GENOME][E_BOX][15] = 5;
        SWPool[GENOME][E_BOX][16] = 5;
        SWPool[GENOME][E_BOX][17] = 6;
        SWPool[GENOME][E_BOX][18] = 6;
        SWPool[GENOME][E_BOX][19] = 7;
        SWPool[GENOME][E_BOX][20] = 8;
        SWPool[GENOME][E_BOX][21] = 9;
        SWPool[GENOME][E_BOX][22] = 10;
        SWPool[GENOME][E_BOX][23] = 11;
        SWPool[GENOME][E_BOX][24] = 12;
        SWPool[GENOME][E_BOX][25] = 13;
        SWPool[GENOME][E_BOX][26] = 14;
        SWPool[GENOME][E_BOX][27] = 15;
        SWPool[GENOME][E_BOX][28] = 16;

        //WEAPON
        // SWPool[WEAPON][R_BOX][0] = 0;
        // SWPool[WEAPON][R_BOX][1] = 0;
        // SWPool[WEAPON][R_BOX][2] = 0;
        // SWPool[WEAPON][R_BOX][3] = 0;
        SWPool[WEAPON][R_BOX][4] = 1;
        SWPool[WEAPON][R_BOX][5] = 1;
        SWPool[WEAPON][R_BOX][6] = 1;
        SWPool[WEAPON][R_BOX][7] = 1;
        SWPool[WEAPON][R_BOX][8] = 2;
        SWPool[WEAPON][R_BOX][9] = 2;
        SWPool[WEAPON][R_BOX][10] = 2;
        SWPool[WEAPON][R_BOX][11] = 2;
        SWPool[WEAPON][R_BOX][12] = 3;
        SWPool[WEAPON][R_BOX][13] = 3;
        SWPool[WEAPON][R_BOX][14] = 3;
        SWPool[WEAPON][R_BOX][15] = 3;
        SWPool[WEAPON][R_BOX][16] = 4;
        SWPool[WEAPON][R_BOX][17] = 4;
        SWPool[WEAPON][R_BOX][18] = 5;
        SWPool[WEAPON][R_BOX][19] = 5;
        SWPool[WEAPON][R_BOX][20] = 6;
        SWPool[WEAPON][R_BOX][21] = 6;
        SWPool[WEAPON][R_BOX][22] = 7;
        SWPool[WEAPON][R_BOX][23] = 7;
        SWPool[WEAPON][R_BOX][24] = 8;
        SWPool[WEAPON][R_BOX][25] = 8;
        SWPool[WEAPON][R_BOX][26] = 9;
        SWPool[WEAPON][R_BOX][27] = 10;
        SWPool[WEAPON][R_BOX][28] = 11;
        SWPool[WEAPON][R_BOX][29] = 12;
        SWPool[WEAPON][R_BOX][30] = 13;
        SWPool[WEAPON][R_BOX][31] = 14;
    }

    function openBoxFromGalaxy(uint256 _nftType, uint256 _galaxy_id) public {
        ERC1155_CONTRACT _token;
        if (_nftType == 0) {
            _token = ERC1155_CONTRACT(GAX_CM);
        } else if (_nftType == 1) {
            _token = ERC1155_CONTRACT(GAX_RARE);
        } else if (_nftType == 2) {
            _token = ERC1155_CONTRACT(GAX_EPIC);
        }

        uint256 _balance = _token.balanceOf(msg.sender, _galaxy_id);
        require(_balance >= 1, "Your balance is insufficient.");
        burnAndMint(_token, _nftType, _galaxy_id);
    }

    function burnAndMint(
        ERC1155_CONTRACT _token,
        uint256 _nftType,
        uint256 _id
    ) internal {
        uint256 randomNumber = RANDOM_CONTRACT(RANDOM_WORKER_CONTRACT)
            .startRandom();
        ranNumToSender[randomNumber] = msg.sender;
        requestToNFTId[randomNumber] = _nftType;
        _token.burn(msg.sender, _id, 1);
        string memory partCode = createNFTCode(randomNumber, _nftType);
        mintNFT(randomNumber, partCode);
        emit OpenBox(msg.sender, _nftType, partCode);
    }

    function openBox(uint256 _id) public {
        ERC1155_CONTRACT _token = ERC1155_CONTRACT(MISTORY_BOX_CONTRACT);
        uint256 _balance = _token.balanceOf(msg.sender, _id);
        require(_balance >= 1, "Your balance is insufficient.");
        burnAndMint(_token, _id, _id);
    }

    function mintNFT(uint256 randomNumber, string memory concatedCode) private {
        ERC721_CONTRACT _nftCore = ERC721_CONTRACT(ECIO_NFT_CORE_CONTRACT);
        _nftCore.safeMint(ranNumToSender[randomNumber], concatedCode);
    }

    function createGenomic(
        uint256 _id,
        uint256 _nftTypeCode,
        uint256 _number,
        uint256 _rarity
    ) private view returns (string memory) {
        uint256 genomicType = GenomicPool[_id][_rarity][_number];
        return
            createPartCode(
                0,
                0, //combatRanksCode
                0, //weaponCode
                genomicType, //humanGenomeCode
                0, //battleBotCode
                0, //battleSuiteCode
                0, //battleDroneCode
                0, //battleGearCode
                0, //trainingCode
                0, //kingdomCode
                _nftTypeCode
            );
    }

    function createNFTCode(uint256 _ranNum, uint256 _id)
        internal
        view
        returns (string memory)
    {
        uint256 randomNFTType = ranNumWithMod(_ranNum, 1, 20);
        uint256 nftTypeCode = NFTPool[_id][randomNFTType];
        string memory partCode;
        uint256 eRandom = ranNumWithMod(_ranNum, 2, 5);
        uint256 eTypeId = EPool[eRandom];
        if (nftTypeCode == GENOMIC_FRAGMENT_COMMON) {
            uint256 number = ranNumWithMod(_ranNum, 2, 7);
            partCode = createGenomic(_id, nftTypeCode, number, COMMON);
        } else if (nftTypeCode == GENOMIC_FRAGMENT_RARE) {
            uint256 number = ranNumWithMod(_ranNum, 2, 6);
            partCode = createGenomic(_id, nftTypeCode, number, RARE);
        } else if (nftTypeCode == GENOMIC_FRAGMENT_EPIC) {
            uint256 number = ranNumWithMod(_ranNum, 2, 4);
            partCode = createGenomic(_id, nftTypeCode, number, EPIC);
        } else if (nftTypeCode == BLUEPRINT_FRAGMENT_COMMON) {
            uint256 maxRan = maxRanForBluePrintCommon(_id, eTypeId);
            eRandom = ranNumWithMod(_ranNum, 2, maxRan);
            uint256 ePartId = BPPool[_id][COMMON][eTypeId][eRandom];
            partCode = createBlueprintPartCode(nftTypeCode, eTypeId, ePartId);
        } else if (nftTypeCode == BLUEPRINT_FRAGMENT_RARE) {
            uint256 maxRan = maxRanForBluePrintRare(_id, eTypeId);
            eRandom = ranNumWithMod(_ranNum, 2, maxRan);
            uint256 ePartId = BPPool[_id][RARE][eTypeId][eRandom];
            partCode = createBlueprintPartCode(nftTypeCode, eTypeId, ePartId);
        } else if (nftTypeCode == BLUEPRINT_FRAGMENT_EPIC) {
            uint256 maxRan = maxRanForBluePrintEpic(_id, eTypeId);
            eRandom = ranNumWithMod(_ranNum, 2, maxRan);
            uint256 ePartId = BPPool[_id][EPIC][eTypeId][eRandom];
            partCode = createBlueprintPartCode(nftTypeCode, eTypeId, ePartId);
        } else if (nftTypeCode == SPACE_WARRIOR) {
            partCode = createSW(_ranNum, _id);
        }

        return partCode;
    }

    function ranNumWithMod(
        uint256 _ranNum,
        uint256 digit,
        uint256 mod
    ) public view virtual returns (uint256) {
        if (digit == 1) {
            return (_ranNum % 100) % mod;
        } else if (digit == 2) {
            return ((_ranNum % 10000) / 100) % mod;
        } else if (digit == 3) {
            return ((_ranNum % 1000000) / 10000) % mod;
        } else if (digit == 4) {
            return ((_ranNum % 100000000) / 1000000) % mod;
        } else if (digit == 5) {
            return ((_ranNum % 10000000000) / 100000000) % mod;
        } else if (digit == 6) {
            return ((_ranNum % 1000000000000) / 10000000000) % mod;
        } else if (digit == 7) {
            return ((_ranNum % 100000000000000) / 1000000000000) % mod;
        } else if (digit == 8) {
            return ((_ranNum % 10000000000000000) / 100000000000000) % mod;
        }

        return 0;
    }

    function extactDigit(uint256 _ranNum) internal pure returns (Digit memory) {
        Digit memory digit;
        digit.digit1 = (_ranNum % 100);
        digit.digit2 = ((_ranNum % 10000) / 100);
        digit.digit3 = ((_ranNum % 1000000) / 10000);
        digit.digit4 = ((_ranNum % 100000000) / 1000000);
        digit.digit5 = ((_ranNum % 10000000000) / 100000000);
        digit.digit6 = ((_ranNum % 1000000000000) / 10000000000);
        digit.digit7 = ((_ranNum % 100000000000000) / 1000000000000);
        digit.digit8 = ((_ranNum % 10000000000000000) / 100000000000000);
        return digit;
    }

    function maxRanForBluePrintCommon(uint256 _id, uint256 eTypeId)
        private
        pure
        returns (uint256)
    {
        uint256 maxRan;
        if (_id == CM_BOX || _id == R_BOX) {
            if (eTypeId == SUITE) {
                maxRan = 3;
            } else {
                maxRan = 4;
            }
        } else if (_id == E_BOX) {
            if (eTypeId == GEAR || eTypeId == DRONE || eTypeId == BOT) {
                maxRan = 3;
            } else if (eTypeId == SUITE) {
                maxRan = 4;
            } else if (eTypeId == WEAPON) {
                maxRan = 6;
            }
        }

        return maxRan;
    }

    function maxRanForBluePrintRare(uint256 _id, uint256 eTypeId)
        private
        pure
        returns (uint256)
    {
        uint256 maxRan;
        if (_id == CM_BOX) {
            if (eTypeId == WEAPON) {
                maxRan = 4;
            } else {
                maxRan = 3;
            }
        } else if (_id == R_BOX) {
            if (eTypeId == WEAPON) {
                maxRan = 5;
            } else {
                maxRan = 3;
            }
        } else if (_id == E_BOX) {
            if (eTypeId == GEAR || eTypeId == DRONE || eTypeId == BOT) {
                maxRan = 3;
            } else if (eTypeId == SUITE) {
                maxRan = 4;
            } else if (eTypeId == WEAPON) {
                maxRan = 6;
            }
        }
        return maxRan;
    }

    function maxRanForBluePrintEpic(uint256 _id, uint256 eTypeId)
        private
        pure
        returns (uint256)
    {
        uint256 maxRan;
        if (_id == R_BOX || _id == E_BOX) {
            if (eTypeId == GEAR || eTypeId == DRONE || eTypeId == BOT) {
                maxRan = 3;
            } else if (eTypeId == SUITE) {
                maxRan = 4;
            } else if (eTypeId == WEAPON) {
                maxRan = 6;
            }
        }
        return maxRan;
    }

    struct Digit {
        uint256 digit1;
        uint256 digit2;
        uint256 digit3;
        uint256 digit4;
        uint256 digit5;
        uint256 digit6;
        uint256 digit7;
        uint256 digit8;
    }

    function createSW(uint256 _random, uint256 _id)
        private
        view
        returns (string memory)
    {
        Digit memory digit = extactDigit(_random);
        uint256 kingdomCode = 0; //fix first kingdom only
        uint256 combatRanksCode = 0; //fix
        uint256 trainingCode;
        uint256 battleGearCode;
        uint256 battleDroneCode;
        uint256 battleSuiteCode;
        uint256 battleBotCode;
        uint256 humanGenomeCode;
        uint256 weaponCode;
        uint256 equipmentTypeId = 0; //Default
        if (_id == CM_BOX) {
            trainingCode = digit.digit2 % 5;
            battleGearCode = digit.digit3 % 30;
            battleDroneCode = digit.digit4 % 30;
            battleSuiteCode = digit.digit5 % 18;
            battleBotCode = digit.digit6 % 30;
            humanGenomeCode = digit.digit7 % 28;
            weaponCode = digit.digit8 % 29;
        } else if (_id == R_BOX) {
            trainingCode = digit.digit2 % 5;
            battleGearCode = digit.digit3 % 30;
            battleDroneCode = digit.digit4 % 30;
            battleSuiteCode = digit.digit5 % 17;
            battleBotCode = digit.digit6 % 30;
            humanGenomeCode = digit.digit7 % 25;
            weaponCode = digit.digit8 % 34;
        } else if (_id == E_BOX) {
            trainingCode = digit.digit2 % 5;
            battleGearCode = digit.digit3 % 30;
            battleDroneCode = digit.digit4 % 30;
            battleSuiteCode = digit.digit5 % 19;
            battleBotCode = digit.digit6 % 30;
            humanGenomeCode = digit.digit7 % 29;
            weaponCode = digit.digit8 % 32;
        }

        weaponCode = SWPool[WEAPON][_id][weaponCode];
        humanGenomeCode = SWPool[GENOME][_id][humanGenomeCode]; //humanGenomeCode
        battleBotCode = SWPool[BOT][_id][battleBotCode]; //battleBotCode
        battleSuiteCode = SWPool[SUITE][_id][battleSuiteCode]; //battleSuiteCode
        battleDroneCode = SWPool[DRONE][_id][battleDroneCode]; //battleDroneCode
        battleGearCode = SWPool[GEAR][_id][battleGearCode]; //battleGearCode
        trainingCode = SWPool[TRANING_CAMP][_id][trainingCode]; //trainingCode
        string memory concatedCode = convertCodeToStr(6);
        concatedCode = concateCode(concatedCode, kingdomCode);
        concatedCode = concateCode(concatedCode, trainingCode);
        concatedCode = concateCode(concatedCode, battleGearCode);
        concatedCode = concateCode(concatedCode, battleDroneCode);
        concatedCode = concateCode(concatedCode, battleSuiteCode);
        concatedCode = concateCode(concatedCode, battleBotCode);
        concatedCode = concateCode(concatedCode, humanGenomeCode);
        concatedCode = concateCode(concatedCode, weaponCode);
        concatedCode = concateCode(concatedCode, combatRanksCode);
        concatedCode = concateCode(concatedCode, equipmentTypeId);
        concatedCode = concateCode(concatedCode, 0); //Reserved
        concatedCode = concateCode(concatedCode, 0); //Reserved
        return concatedCode;
    }

    function createBlueprintPartCode(
        uint256 nftTypeCode,
        uint256 equipmentTypeId,
        uint256 equipmentPartId
    ) private pure returns (string memory) {
        string memory partCode;

        if (equipmentTypeId == GEAR) {
            //Battle Gear
            partCode = createPartCode(
                equipmentTypeId, //equipmentTypeId
                0, //combatRanksCode
                0, //weaponCode
                0, //humanGenomeCode
                0, //battleBotCode
                0, //battleSuiteCode
                0, //battleDroneCode
                equipmentPartId, //battleGearCode
                0, //trainingCode
                0, //kingdomCode
                nftTypeCode
            );
        } else if (equipmentTypeId == DRONE) {
            //battleDroneCode
            partCode = createPartCode(
                equipmentTypeId, //equipmentTypeId
                0, //combatRanksCode
                0, //weaponCode
                0, //humanGenomeCode
                0, //battleBotCode
                0, //battleSuiteCode
                equipmentPartId, //battleDroneCode
                0, //battleGearCode
                0, //trainingCode
                0, //kingdomCode
                nftTypeCode
            );
        } else if (equipmentTypeId == SUITE) {
            //battleSuiteCode
            partCode = createPartCode(
                equipmentTypeId, //equipmentTypeId
                0, //combatRanksCode
                0, //weaponCode
                0, //humanGenomeCode
                0, //battleBotCode
                equipmentPartId, //battleSuiteCode
                0, //battleDroneCode
                0, //battleGearCode
                0, //trainingCode
                0, //kingdomCode
                nftTypeCode
            );
        } else if (equipmentTypeId == BOT) {
            //Battle Bot
            partCode = createPartCode(
                equipmentTypeId, //equipmentTypeId
                0, //combatRanksCode
                0, //weaponCode
                0, //humanGenomeCode
                equipmentPartId, //battleBotCode
                0, //battleSuiteCode
                0, //battleDroneCode
                0, //battleGearCode
                0, //trainingCode
                0, //kingdomCode
                nftTypeCode
            );
        } else if (equipmentTypeId == WEAPON) {
            //weapon
            partCode = createPartCode(
                equipmentTypeId, //equipmentTypeId
                0, //combatRanksCode
                equipmentPartId, //weaponCode
                0, //humanGenomeCode
                0, //battleBotCode
                0, //battleSuiteCode
                0, //battleDroneCode
                0, //battleGearCode
                0, //trainingCode
                0, //kingdomCode
                nftTypeCode
            );
        }

        return partCode;
    }

    function createPartCode(
        uint256 equipmentCode,
        uint256 starCode,
        uint256 weaponCode,
        uint256 humanGenomeCode,
        uint256 battleBotCode,
        uint256 battleSuiteCode,
        uint256 battleDroneCode,
        uint256 battleGearCode,
        uint256 trainingCode,
        uint256 kingdomCode,
        uint256 nftTypeCode
    ) internal pure returns (string memory) {
        string memory concatedCode = convertCodeToStr(nftTypeCode);
        concatedCode = concateCode(concatedCode, kingdomCode);
        concatedCode = concateCode(concatedCode, trainingCode);
        concatedCode = concateCode(concatedCode, battleGearCode);
        concatedCode = concateCode(concatedCode, battleDroneCode);
        concatedCode = concateCode(concatedCode, battleSuiteCode);
        concatedCode = concateCode(concatedCode, battleBotCode);
        concatedCode = concateCode(concatedCode, humanGenomeCode);
        concatedCode = concateCode(concatedCode, weaponCode);
        concatedCode = concateCode(concatedCode, starCode);
        concatedCode = concateCode(concatedCode, equipmentCode); //Reserved
        concatedCode = concateCode(concatedCode, 0); //Reserved
        concatedCode = concateCode(concatedCode, 0); //Reserved
        return concatedCode;
    }

    function concateCode(string memory concatedCode, uint256 digit)
        internal
        pure
        returns (string memory)
    {
        concatedCode = string(
            abi.encodePacked(convertCodeToStr(digit), concatedCode)
        );

        return concatedCode;
    }

    function convertCodeToStr(uint256 code)
        private
        pure
        returns (string memory)
    {
        if (code <= 9) {
            return string(abi.encodePacked("0", Strings.toString(code)));
        }

        return Strings.toString(code);
    }
}
