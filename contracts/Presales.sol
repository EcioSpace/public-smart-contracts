// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @author ECIO Engineer Team
/// @title Pre-Sales Smart Contract
contract Presales is Ownable {
    
    uint256 private constant LOT1 = 1;
    uint256 private constant LOT2 = 2;
    uint256 private constant LOT3 = 3;
    
    //maximum BUSD per account.
    uint256 private constant MAXIMUM_BUY  = 200000000000000000000;
    
    //maximum BUSD in presale. 
    uint256 private constant MAXIMUM_BUSD = 300000000000000000000000;
    
    //BUSD token address.
    address private constant BUSD_TOKEN_ADDRESS = 0xeD24FC36d5Ee211Ea25A80239Fb8C4Cfd80f12Ee; //Testnet
    //address private constant BUSD_TOKEN_ADDRESS = 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56; //Maintest
    
    //lotsStartTime is start timestamp of each pre-sale lot.
    mapping(uint => uint) public lotsStartTime;
    
    //lotsEndTime is start timestamp of each pre-sale lot.
    mapping(uint => uint) public lotsEndTime;
    
    //accountBalances is user's balances BUSD Token.
    mapping(address => uint) public accountBalances;
    
    //accountLotId use to keep id of pre-sale lot.
    mapping(address => uint) public accountLotId;
    
    //lot's balances.
    mapping(uint => uint) public lotsBalances;
   
    event BuyPresale(address indexed _from, uint _amount);
   
    
    //Validate the account has registered or not ? 
    modifier hasWhitelistRegistered(address _account){
        require(lotId(_account) != 0,"The account is not whitelist listed.");
        _;
    }
    
    //Validate amount of buying to makesure that it not over maximun buying per account.
    modifier isNotMaximumBuy(address _account, uint _amount){
       require(accountBalances[_account] + _amount <= MAXIMUM_BUY ,"Over Maximum");
        _;
    }

    //Validate start and end timestamp to allow users to access buying function.
    modifier isOpenPresale(address _account){
        
       uint _lotId = accountLotId[_account];
       require(lotsStartTime[_lotId] !=0 && lotsEndTime[_lotId] !=0 ,"Pre-sale hasn't started.");
       require(lotsStartTime[_lotId] <= block.timestamp,"Pre-sale hasn't started.");
       require(lotsEndTime[_lotId] >= block.timestamp,"Pre-sale has closed.");
        _;
    }


    /**
    * @dev Balances of all lots. 
    */
    function totalBalances() public view returns(uint) {
        return lotsBalances[LOT1] + lotsBalances[LOT2] + lotsBalances[LOT3];
    }

 
    /**
    * @dev SetPresaleTime is function for setup pre-sale's timestamp.
    * @param _lotId lotId of pre-sale
    * @param _startTime start timestamp
    * @param _endTime end timestamp
    */
    function setPresaleTime(uint _lotId, uint _startTime, uint _endTime) external onlyOwner {
        lotsStartTime[_lotId] = _startTime;
        lotsEndTime[_lotId]   = _endTime;
    }
    

    /**
    * @dev ImportWhitelist is function for manually import addresses that are allowed to buying. 
    */
    function importWhitelist(address[] memory _accounts, uint[] memory _lotIds) public onlyOwner {
        for(uint256 i = 0; i < _accounts.length; ++i){
            accountLotId[_accounts[i]] = _lotIds[i];
            accountBalances[_accounts[i]] = 0;
        }
    }

    /**
    * @dev Show account's lotId
    */
    function lotId(address _account) public view returns(uint){
        return accountLotId[_account];
    }


    /**
    * @dev The number of tokens available for buying.
    */
    function tokenAvailable(address _account) public view returns(uint) {
        
        if(lotId(_account) == 0){
            return  0;
        }
        
        return MAXIMUM_BUY - accountBalances[_account];
    }


    /**
    * @dev a function for transfer BUSD token to this contract address and waiting for claim ECIO Token later.
    */
    function buyPresale(address _account, uint _amount) external hasWhitelistRegistered(_account) isNotMaximumBuy(_account, _amount) isOpenPresale(_account) {
       
        require(_amount > 0, "Your amount is too small.");
        
        IERC20 _token = IERC20(BUSD_TOKEN_ADDRESS);
        
        uint _balance = _token.balanceOf(msg.sender);
        
        require(_balance >= _amount, "Your balance is insufficient.");
        
        
        uint _lotId = accountLotId[_account];
       
        if(_lotId == LOT3){
           require(lotsBalances[_lotId] + _amount <= MAXIMUM_BUSD / 2,"");
        }
        
        //transfer token from user's account into this smart contract address.
        _token.transferFrom(msg.sender, address(this), _amount);
        
        //Increase user's balances.
        accountBalances[_account] = accountBalances[_account] + _amount;
        
        //Increase lot's balances.
        lotsBalances[_lotId] = lotsBalances[_lotId] + _amount;
        
        emit BuyPresale(msg.sender, _amount);

    }
    

    /**
    * @dev ContractBalances is function to show Token balance in smart contract. 
    */
    function contractBalances(address _contractAddress) public view returns(uint)  {
        IERC20 _token = IERC20(_contractAddress);
        uint256 _balance = _token.balanceOf(address(this));
        return _balance;
    }
    

    /**
    * @dev Transfer is function to transfer token from contract to other account.
    */

    function transfer(address _contractAddress, address  _to, uint _amount) public onlyOwner {
        IERC20 _token = IERC20(_contractAddress);
        _token.transfer(_to, _amount);
    }
}