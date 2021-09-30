// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract EcioWhitelist is OwnableUpgradeable {
   
   using Counters for Counters.Counter;

   mapping(uint => mapping(address => bool)) private activitiesRegisteredUser;
   
   mapping(uint256 => address[])  private activitiesUsers; 
   
   mapping(uint => mapping(address => Counters.Counter)) private activityReferralScore;
    
   mapping(uint => Activity) private activities;
   
   Counters.Counter private acId;

   constructor(){
        __Ownable_init();
   }
   
    struct Activity { 
      uint acId;       //Activity Id
      uint startDate;  //Start Datetime
      uint endDate;    //End Datetime
      bool isEnable;   //Enable activity flag
      Counters.Counter limitUser; //Limit user register
    }

    /**
     * @dev activity open/close modifier function
    */
    modifier isEnable(uint _acId) {
      require(activities[_acId].isEnable, "This activity is disabled.");
       _;
    }

    /**
     * @dev Register quota modifier function
    */
    modifier isNoNore(uint _acId) {
      require(activities[_acId].limitUser.current() > 0,"This activity quota is no more.");
       _;
      
    }
    
    /**
     * @dev Time up modifier function
    */
    modifier isTimeup(uint _acId) {
      require (
          activities[_acId].startDate <= block.timestamp && activities[_acId].endDate >= block.timestamp,
      "This activity is time up.");
         _;
    
    }
   
    /**
     * @dev Create new activity to support whitelist register.
    */
   function createActivity(uint _limitUser,uint _start, uint _end, bool _isEnable) public onlyOwner {
       
        activities[acId.current()].acId =  acId.current();
        activities[acId.current()].limitUser._value = _limitUser;
        activities[acId.current()].startDate = _start;
        activities[acId.current()].endDate = _end;
        activities[acId.current()].isEnable = _isEnable;
        acId.increment();
       
   } 

   /**
     * @dev Register with referral address.
     * Set a referral address equal address(0) if don't have it.
   */
   function registerWhitelist(uint _acId, address _referralAddress) external isTimeup(_acId) isNoNore(_acId) isEnable(_acId) {
         
        require(!activitiesRegisteredUser[_acId][msg.sender],"Your address has registered");
         
        activitiesRegisteredUser[_acId][msg.sender] = true;
        
        activitiesUsers[_acId].push(msg.sender);

        if(_referralAddress != address(0)){
             activityReferralScore[_acId][_referralAddress].increment();
         }
         
        activities[_acId].limitUser.decrement();
   }
   
    /**
     * @dev use to check referal score of address in activity.
    */
   function referralScore(uint _acId, address _referralAddress) public view virtual returns (uint){
       return activityReferralScore[_acId][_referralAddress].current();
   }

   function getAllRegister(uint _acId)
        public
        view
        virtual
        returns (uint256[] memory, address[] memory)
    {
      
        uint256[] memory scores   = new uint256[](activitiesUsers[_acId].length);
        address[] memory accounts = new address[](activitiesUsers[_acId].length);

        for (uint256 i = 0; i < activitiesUsers[_acId].length; ++i) {
            
            address _address =  activitiesUsers[_acId][i];
            accounts[i] = _address;
            scores[i]   = activityReferralScore[_acId][_address].current();
           
        }

        return (scores, accounts);
 
   }

   function isEnableActivity(uint _acId) public view virtual returns (bool){
       return activities[_acId].isEnable;
   }

   function enableActivity(uint _acId, bool _isEnable) public onlyOwner {
       activities[_acId].isEnable = _isEnable;
   }

   function hasRegister(uint _acId, address _address) public view virtual returns (bool) {
        return activitiesRegisteredUser[_acId][_address];
   }
   
}
   
   
   
