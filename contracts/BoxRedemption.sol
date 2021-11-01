// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

interface ERC721_CONTRACT is IERC721 {
    function safeMint(address to, string memory partCode) external;
}

interface RANDOM_CONTRACT {
    function startRandom() external returns (uint256);
}

contract BoxRedemption is Ownable {
    using Strings for string;
    uint256 private constant CM_BOX = 0;
    uint256 private constant R_BOX = 1;
    uint256 private constant E_BOX = 2;
    uint256 private constant NFT_TYPE = 0; //Kingdom
    uint256 private constant KINGDOM = 1; //Kingdom
    uint256 private constant TRANING_CAMP = 2; //Training Camp
    uint256 private constant GEAR = 3; //Battle Gear
    uint256 private constant DRONE = 4; //Battle Drone
    uint256 private constant SUITE = 5; //Battle Suit
    uint256 private constant BOT = 6; //Battle Bot
    uint256 private constant GENOME = 7; //Human Genome
    uint256 private constant WEAPON = 8; //Weapon
    uint256 private constant COMBAT_RANKS = 9; //Combat Ranks
    uint256 private constant BLUEPRINT_FRAGMENT_COMMON = 0;
    uint256 private constant BLUEPRINT_FRAGMENT_RARE = 1;
    uint256 private constant BLUEPRINT_FRAGMENT_EPIC = 2;
    uint256 private constant GENOMIC_FRAGMENT_COMMON = 3;
    uint256 private constant GENOMIC_FRAGMENT_RARE = 4;
    uint256 private constant GENOMIC_FRAGMENT_EPIC = 5;
    uint256 private constant SPACE_WARRIOR = 6;

    uint256 private constant COMMON = 0;
    uint256 private constant RARE = 1;
    uint256 private constant EPIC = 2;

    address public constant MISTORY_BOX_CONTRACT =
        0xfB684dC65DE6C27c63fa7a00B9b9fB70d2125Ea1;
    address public constant ECIO_NFT_CORE_CONTRACT =
        0x7E8eEe5be55A589d5571Be7176172f4DEE7f47aF;
    address public constant RANDOM_WORKER_CONTRACT =
        0x5ABF279B87F84C916d0f34c2dafc949f86ffb887;

    mapping(uint256 => address) randomNumberToSender;
    mapping(uint256 => uint256) requestToNFTId;

    //NFTPool
    mapping(uint256 => mapping(uint256 => uint256)) public NFTPool;

    //EquipmentPool
    mapping(uint256 => uint256) public EquipmentPool;

    //BlueprintFragmentPool
    mapping(uint256 => mapping(uint256 => mapping(uint256 => mapping(uint256 => uint256))))
        public BlueprintPool;

    //GenomicPool
    mapping(uint256 => mapping(uint256 => mapping(uint256 => uint256)))
        public GenomicPool;

    //SpaceWarriorPool
    mapping(uint256 => mapping(uint256 => mapping(uint256 => uint256)))
        public SWPool;

    event OpenBox(address _by, uint256 _nftId, string partCode);

    constructor() {}

    function initialMain() public onlyOwner {
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
        NFTPool[E_BOX][6] = 6;  //SPACE_WARRIOR
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

        EquipmentPool[0] = GEAR; //Battle Gear
        EquipmentPool[1] = DRONE; //Battle Drone
        EquipmentPool[2] = SUITE; //Battle Suit
        EquipmentPool[3] = BOT; //Battle Bot
        EquipmentPool[4] = WEAPON; //Weapon
    }

    function initialRandomData() public onlyOwner {
        // --- For Common Box ------
        BlueprintPool[CM_BOX][COMMON][GEAR][0] = 1;
        BlueprintPool[CM_BOX][COMMON][GEAR][1] = 2;
        BlueprintPool[CM_BOX][COMMON][GEAR][2] = 3;
        BlueprintPool[CM_BOX][COMMON][GEAR][3] = 4;

        BlueprintPool[CM_BOX][COMMON][DRONE][0] = 1;
        BlueprintPool[CM_BOX][COMMON][DRONE][1] = 2;
        BlueprintPool[CM_BOX][COMMON][DRONE][2] = 3;
        BlueprintPool[CM_BOX][COMMON][DRONE][3] = 4;

        BlueprintPool[CM_BOX][COMMON][SUITE][0] = 0;
        BlueprintPool[CM_BOX][COMMON][SUITE][1] = 1;
        BlueprintPool[CM_BOX][COMMON][SUITE][2] = 2;

        BlueprintPool[CM_BOX][COMMON][BOT][0] = 1;
        BlueprintPool[CM_BOX][COMMON][BOT][1] = 2;
        BlueprintPool[CM_BOX][COMMON][BOT][2] = 3;
        BlueprintPool[CM_BOX][COMMON][BOT][3] = 4;

        BlueprintPool[CM_BOX][COMMON][WEAPON][0] = 0;
        BlueprintPool[CM_BOX][COMMON][WEAPON][1] = 1;
        BlueprintPool[CM_BOX][COMMON][WEAPON][2] = 2;
        BlueprintPool[CM_BOX][COMMON][WEAPON][3] = 3;
        //
        BlueprintPool[CM_BOX][RARE][GEAR][0] = 5;
        BlueprintPool[CM_BOX][RARE][GEAR][1] = 6;
        BlueprintPool[CM_BOX][RARE][GEAR][2] = 7;

        BlueprintPool[CM_BOX][RARE][DRONE][0] = 5;
        BlueprintPool[CM_BOX][RARE][DRONE][1] = 6;
        BlueprintPool[CM_BOX][RARE][DRONE][2] = 7;

        BlueprintPool[CM_BOX][RARE][SUITE][0] = 3;
        BlueprintPool[CM_BOX][RARE][SUITE][1] = 4;
        BlueprintPool[CM_BOX][RARE][SUITE][2] = 5;

        BlueprintPool[CM_BOX][RARE][BOT][0] = 5;
        BlueprintPool[CM_BOX][RARE][BOT][1] = 6;
        BlueprintPool[CM_BOX][RARE][BOT][2] = 7;

        BlueprintPool[CM_BOX][RARE][WEAPON][0] = 4;
        BlueprintPool[CM_BOX][RARE][WEAPON][1] = 5;
        BlueprintPool[CM_BOX][RARE][WEAPON][2] = 6;
        BlueprintPool[CM_BOX][RARE][WEAPON][3] = 7;

        GenomicPool[CM_BOX][COMMON][0] = 0;
        GenomicPool[CM_BOX][COMMON][1] = 1;
        GenomicPool[CM_BOX][COMMON][2] = 2;
        GenomicPool[CM_BOX][COMMON][3] = 3;
        GenomicPool[CM_BOX][COMMON][4] = 4;
        GenomicPool[CM_BOX][COMMON][5] = 5;
        GenomicPool[CM_BOX][COMMON][6] = 6;

        // --- For  Rare Box ------
        BlueprintPool[R_BOX][COMMON][GEAR][0] = 1;
        BlueprintPool[R_BOX][COMMON][GEAR][1] = 2;
        BlueprintPool[R_BOX][COMMON][GEAR][2] = 3;
        BlueprintPool[R_BOX][COMMON][GEAR][3] = 4;

        BlueprintPool[R_BOX][COMMON][DRONE][0] = 1;
        BlueprintPool[R_BOX][COMMON][DRONE][1] = 2;
        BlueprintPool[R_BOX][COMMON][DRONE][2] = 3;
        BlueprintPool[R_BOX][COMMON][DRONE][3] = 4;

        BlueprintPool[R_BOX][COMMON][SUITE][0] = 0;
        BlueprintPool[R_BOX][COMMON][SUITE][1] = 1;
        BlueprintPool[R_BOX][COMMON][SUITE][2] = 2;

        BlueprintPool[R_BOX][COMMON][BOT][0] = 1;
        BlueprintPool[R_BOX][COMMON][BOT][1] = 2;
        BlueprintPool[R_BOX][COMMON][BOT][2] = 3;
        BlueprintPool[R_BOX][COMMON][BOT][3] = 4;

        BlueprintPool[R_BOX][COMMON][WEAPON][0] = 0;
        BlueprintPool[R_BOX][COMMON][WEAPON][1] = 1;
        BlueprintPool[R_BOX][COMMON][WEAPON][2] = 2;
        BlueprintPool[R_BOX][COMMON][WEAPON][3] = 3;
        //
        BlueprintPool[R_BOX][RARE][GEAR][0] = 5;
        BlueprintPool[R_BOX][RARE][GEAR][1] = 6;
        BlueprintPool[R_BOX][RARE][GEAR][2] = 7;

        BlueprintPool[R_BOX][RARE][DRONE][0] = 5;
        BlueprintPool[R_BOX][RARE][DRONE][1] = 6;
        BlueprintPool[R_BOX][RARE][DRONE][2] = 7;

        BlueprintPool[R_BOX][RARE][SUITE][0] = 3;
        BlueprintPool[R_BOX][RARE][SUITE][1] = 4;
        BlueprintPool[R_BOX][RARE][SUITE][2] = 5;

        BlueprintPool[R_BOX][RARE][BOT][0] = 5;
        BlueprintPool[R_BOX][RARE][BOT][1] = 6;
        BlueprintPool[R_BOX][RARE][BOT][2] = 7;

        BlueprintPool[R_BOX][RARE][WEAPON][0] = 4;
        BlueprintPool[R_BOX][RARE][WEAPON][1] = 5;
        BlueprintPool[R_BOX][RARE][WEAPON][2] = 6;
        BlueprintPool[R_BOX][RARE][WEAPON][3] = 7;
        BlueprintPool[R_BOX][RARE][WEAPON][4] = 8;

        //Epic
        BlueprintPool[R_BOX][EPIC][GEAR][0] = 8;
        BlueprintPool[R_BOX][EPIC][GEAR][1] = 9;
        BlueprintPool[R_BOX][EPIC][GEAR][2] = 10;

        BlueprintPool[R_BOX][EPIC][DRONE][0] = 8;
        BlueprintPool[R_BOX][EPIC][DRONE][1] = 9;
        BlueprintPool[R_BOX][EPIC][DRONE][2] = 10;

        BlueprintPool[R_BOX][EPIC][SUITE][0] = 6;
        BlueprintPool[R_BOX][EPIC][SUITE][1] = 7;
        BlueprintPool[R_BOX][EPIC][SUITE][2] = 8;
        BlueprintPool[R_BOX][EPIC][SUITE][3] = 9;

        BlueprintPool[R_BOX][EPIC][BOT][0] = 8;
        BlueprintPool[R_BOX][EPIC][BOT][1] = 9;
        BlueprintPool[R_BOX][EPIC][BOT][2] = 10;

        BlueprintPool[R_BOX][EPIC][WEAPON][0] = 9;
        BlueprintPool[R_BOX][EPIC][WEAPON][1] = 10;
        BlueprintPool[R_BOX][EPIC][WEAPON][2] = 11;
        BlueprintPool[R_BOX][EPIC][WEAPON][3] = 12;
        BlueprintPool[R_BOX][EPIC][WEAPON][4] = 13;
        BlueprintPool[R_BOX][EPIC][WEAPON][5] = 14;

        GenomicPool[R_BOX][COMMON][0] = 0;
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
        BlueprintPool[E_BOX][RARE][GEAR][0] = 8;
        BlueprintPool[E_BOX][RARE][GEAR][1] = 9;
        BlueprintPool[E_BOX][RARE][GEAR][2] = 10;

        BlueprintPool[E_BOX][RARE][DRONE][0] = 8;
        BlueprintPool[E_BOX][RARE][DRONE][1] = 9;
        BlueprintPool[E_BOX][RARE][DRONE][2] = 10;

        BlueprintPool[E_BOX][RARE][SUITE][0] = 6;
        BlueprintPool[E_BOX][RARE][SUITE][1] = 7;
        BlueprintPool[E_BOX][RARE][SUITE][2] = 8;
        BlueprintPool[E_BOX][RARE][SUITE][3] = 9;

        BlueprintPool[E_BOX][RARE][BOT][0] = 8;
        BlueprintPool[E_BOX][RARE][BOT][1] = 9;
        BlueprintPool[E_BOX][RARE][BOT][2] = 10;

        BlueprintPool[E_BOX][RARE][WEAPON][0] = 9;
        BlueprintPool[E_BOX][RARE][WEAPON][1] = 10;
        BlueprintPool[E_BOX][RARE][WEAPON][2] = 11;
        BlueprintPool[E_BOX][RARE][WEAPON][3] = 12;
        BlueprintPool[E_BOX][RARE][WEAPON][4] = 13;
        BlueprintPool[E_BOX][RARE][WEAPON][5] = 14;

        //Epic
        BlueprintPool[E_BOX][EPIC][GEAR][0] = 8;
        BlueprintPool[E_BOX][EPIC][GEAR][1] = 9;
        BlueprintPool[E_BOX][EPIC][GEAR][2] = 10;

        BlueprintPool[E_BOX][EPIC][DRONE][0] = 8;
        BlueprintPool[E_BOX][EPIC][DRONE][1] = 9;
        BlueprintPool[E_BOX][EPIC][DRONE][2] = 10;

        BlueprintPool[E_BOX][EPIC][SUITE][0] = 6;
        BlueprintPool[E_BOX][EPIC][SUITE][1] = 7;
        BlueprintPool[E_BOX][EPIC][SUITE][2] = 8;
        BlueprintPool[E_BOX][EPIC][SUITE][3] = 9;

        BlueprintPool[E_BOX][EPIC][BOT][0] = 8;
        BlueprintPool[E_BOX][EPIC][BOT][1] = 9;
        BlueprintPool[E_BOX][EPIC][BOT][2] = 10;

        BlueprintPool[E_BOX][EPIC][WEAPON][0] = 9;
        BlueprintPool[E_BOX][EPIC][WEAPON][1] = 10;
        BlueprintPool[E_BOX][EPIC][WEAPON][2] = 11;
        BlueprintPool[E_BOX][EPIC][WEAPON][3] = 12;
        BlueprintPool[E_BOX][EPIC][WEAPON][4] = 13;
        BlueprintPool[E_BOX][EPIC][WEAPON][5] = 14;

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
        //TrainingCampPool
        SWPool[TRANING_CAMP][CM_BOX][0] = 0;
        SWPool[TRANING_CAMP][CM_BOX][1] = 1;
        SWPool[TRANING_CAMP][CM_BOX][2] = 2;
        SWPool[TRANING_CAMP][CM_BOX][3] = 3;
        SWPool[TRANING_CAMP][CM_BOX][4] = 4;
        
        SWPool[TRANING_CAMP][R_BOX][0] = 0;
        SWPool[TRANING_CAMP][R_BOX][1] = 1;
        SWPool[TRANING_CAMP][R_BOX][2] = 2;
        SWPool[TRANING_CAMP][R_BOX][3] = 3;
        SWPool[TRANING_CAMP][R_BOX][4] = 4;

        SWPool[TRANING_CAMP][E_BOX][0] = 0;
        SWPool[TRANING_CAMP][E_BOX][1] = 1;
        SWPool[TRANING_CAMP][E_BOX][2] = 2;
        SWPool[TRANING_CAMP][E_BOX][3] = 3;
        SWPool[TRANING_CAMP][E_BOX][4] = 4;

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

    function openBox(uint256 _id) public {
        ERC1155Burnable _token = ERC1155Burnable(MISTORY_BOX_CONTRACT);
        uint256 _balance = _token.balanceOf(msg.sender, _id);
        require(_balance >= 1, "Your balance is insufficient.");

        uint256 randomNumber = RANDOM_CONTRACT(RANDOM_WORKER_CONTRACT)
            .startRandom();

        randomNumberToSender[randomNumber] = msg.sender;
        requestToNFTId[randomNumber] = _id;
        _token.burn(msg.sender, _id, 1);
        string memory partCode = GenerateNFTCode(randomNumber, _id);

        mintNFT(randomNumber, partCode);

        emit OpenBox(msg.sender, _id, partCode);
    }

    function mintNFT(uint256 randomNumber, string memory concatedCode) private {
        ERC721_CONTRACT _nftCore = ERC721_CONTRACT(ECIO_NFT_CORE_CONTRACT);
        _nftCore.safeMint(randomNumberToSender[randomNumber], concatedCode);
    }

    function GetRandomNumberWithMod(
        uint256 _randomNumber,
        uint256 digit,
        uint256 mod
    ) public view virtual returns (uint256) {
        if (digit == 1) {
            return (_randomNumber % 100) % mod;
        } else if (digit == 2) {
            return ((_randomNumber % 10000) / 100) % mod;
        } else if (digit == 3) {
            return ((_randomNumber % 1000000) / 10000) % mod;
        } else if (digit == 4) {
            return ((_randomNumber % 100000000) / 1000000) % mod;
        } else if (digit == 5) {
            return ((_randomNumber % 10000000000) / 100000000) % mod;
        } else if (digit == 6) {
            return ((_randomNumber % 1000000000000) / 10000000000) % mod;
        } else if (digit == 7) {
            return ((_randomNumber % 100000000000000) / 1000000000000) % mod;
        } else if (digit == 8) {
            return
                ((_randomNumber % 10000000000000000) / 100000000000000) % mod;
        } else if (digit == 9) {
            return
                ((_randomNumber % 1000000000000000000) / 10000000000000000) %
                mod;
        } else if (digit == 10) {
            return
                ((_randomNumber % 100000000000000000000) /
                    1000000000000000000) % mod;
        }

        return 0;
    }

    function extactDigit(uint256 _randomNumber)
        internal
        pure
        returns (Digit memory)
    {
        Digit memory digit;
        digit.digit1 = (_randomNumber % 100);
        digit.digit2 = ((_randomNumber % 10000) / 100);
        digit.digit3 = ((_randomNumber % 1000000) / 10000);
        digit.digit4 = ((_randomNumber % 100000000) / 1000000);
        digit.digit5 = ((_randomNumber % 10000000000) / 100000000);
        digit.digit6 = ((_randomNumber % 1000000000000) / 10000000000);
        digit.digit7 = ((_randomNumber % 100000000000000) / 1000000000000);
        digit.digit8 = ((_randomNumber % 10000000000000000) / 100000000000000);
        return digit;
    }

    function GenerateNFTCode(uint256 _randomNumber, uint256 _id)
        internal
        view
        returns (string memory)
    {
        uint256 randomNFTType = GetRandomNumberWithMod(_randomNumber, 1, 20);
        uint256 nftTypeCode = NFTPool[_id][randomNFTType];
        string memory partCode;

        if (nftTypeCode == BLUEPRINT_FRAGMENT_COMMON) {
            //Random Equipment Part
            uint256 equipmemtRandom = GetRandomNumberWithMod(
                _randomNumber,
                2,
                5
            );

            uint256 equipmemtTypeId = EquipmentPool[equipmemtRandom];

            uint256 maxRandom;
            if (_id == CM_BOX || _id == R_BOX) {
                if (equipmemtTypeId == SUITE) {
                    maxRandom = 3;
                } else {
                    maxRandom = 4;
                }
            } else if (_id == E_BOX) {
                if (
                    equipmemtTypeId == GEAR ||
                    equipmemtTypeId == DRONE ||
                    equipmemtTypeId == BOT
                ) {
                    maxRandom = 3;
                } else if (equipmemtTypeId == SUITE) {
                    maxRandom = 4;
                } else if (equipmemtTypeId == WEAPON) {
                    maxRandom = 6;
                }
            }

            equipmemtRandom = GetRandomNumberWithMod(
                _randomNumber,
                2,
                maxRandom
            );

            uint256 equipmemtPartId = BlueprintPool[_id][COMMON][
                equipmemtTypeId
            ][equipmemtRandom];
            partCode = createBlueprintFragmentPartCode(
                nftTypeCode,
                equipmemtTypeId,
                equipmemtPartId
            );
        } else if (nftTypeCode == BLUEPRINT_FRAGMENT_RARE) {
            uint256 equipmemtRandom = GetRandomNumberWithMod(
                _randomNumber,
                2,
                5
            );

            uint256 equipmemtTypeId = EquipmentPool[equipmemtRandom];

            uint256 maxRandom;
            if (_id == CM_BOX) {
                if (equipmemtTypeId == WEAPON) {
                    maxRandom = 4;
                } else {
                    maxRandom = 3;
                }
            } else if (_id == R_BOX) {
                if (equipmemtTypeId == WEAPON) {
                    maxRandom = 5;
                } else {
                    maxRandom = 3;
                }
            } else if (_id == E_BOX) {
                if (
                    equipmemtTypeId == GEAR ||
                    equipmemtTypeId == DRONE ||
                    equipmemtTypeId == BOT
                ) {
                    maxRandom = 3;
                } else if (equipmemtTypeId == SUITE) {
                    maxRandom = 4;
                } else if (equipmemtTypeId == WEAPON) {
                    maxRandom = 6;
                }
            }

            uint256 equipmemtPartId = BlueprintPool[_id][RARE][equipmemtTypeId][
                equipmemtRandom
            ];
            partCode = createBlueprintFragmentPartCode(
                nftTypeCode,
                equipmemtTypeId,
                equipmemtPartId
            );
        } else if (nftTypeCode == BLUEPRINT_FRAGMENT_EPIC) {
            uint256 equipmemtRandom = GetRandomNumberWithMod(
                _randomNumber,
                2,
                5
            );

            uint256 equipmemtTypeId = EquipmentPool[equipmemtRandom];

            uint256 maxRandom;
            if (_id == R_BOX || _id == E_BOX) {
                if (
                    equipmemtTypeId == GEAR ||
                    equipmemtTypeId == DRONE ||
                    equipmemtTypeId == BOT
                ) {
                    maxRandom = 3;
                } else if (equipmemtTypeId == SUITE) {
                    maxRandom = 4;
                } else if (equipmemtTypeId == WEAPON) {
                    maxRandom = 6;
                }
            } 

            uint256 equipmemtPartId = BlueprintPool[_id][EPIC][equipmemtTypeId][
                equipmemtRandom
            ];
            partCode = createBlueprintFragmentPartCode(
                nftTypeCode,
                equipmemtTypeId,
                equipmemtPartId
            );
        } else if (nftTypeCode == GENOMIC_FRAGMENT_COMMON) {

            uint256 number = GetRandomNumberWithMod(_randomNumber, 2, 7);
            uint256 genomicFragmentType = GenomicPool[_id][COMMON][number];
            partCode = createPartCode(
                0,
                0, //combatRanksCode
                0, //weaponCode
                genomicFragmentType, //humanGenomeCode
                0, //battleBotCode
                0, //battleSuiteCode
                0, //battleDroneCode
                9, //battleGearCode
                0, //trainingCode
                0, //kingdomCode
                nftTypeCode
            );
        } else if (nftTypeCode == GENOMIC_FRAGMENT_RARE) {
          
            uint256 number = GetRandomNumberWithMod(_randomNumber, 2, 6);
            uint256 genomicFragmentType = GenomicPool[_id][RARE][number];
            partCode = createPartCode(
                0,
                0, //combatRanksCode
                0, //weaponCode
                genomicFragmentType, //humanGenomeCode
                0, //battleBotCode
                0, //battleSuiteCode
                0, //battleDroneCode
                9, //battleGearCode
                0, //trainingCode
                0, //kingdomCode
                nftTypeCode
            );
        } else if (nftTypeCode == GENOMIC_FRAGMENT_EPIC) {
            uint256 number = GetRandomNumberWithMod(_randomNumber, 2, 4);
            uint256 genomicFragmentType = GenomicPool[_id][EPIC][number];
            partCode = createPartCode(
                0,
                0, //combatRanksCode
                0, //weaponCode
                genomicFragmentType, //humanGenomeCode
                0, //battleBotCode
                0, //battleSuiteCode
                0, //battleDroneCode
                9, //battleGearCode
                0, //trainingCode
                0, //kingdomCode
                nftTypeCode
            );
        } else if (nftTypeCode == SPACE_WARRIOR) {
            partCode = createSW(_randomNumber, _id);
        }

        return partCode;
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

    function createBlueprintFragmentPartCode(
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
