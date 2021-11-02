# ECIO Space - Public Smart Contracts
## Token

### ECIO Token
Currency for trading between stars, Ecio Token represents Government Token of the platform. The token can be used for trading, buying or selling items as well as the activities listed below:
- Farm with Stable Coin – earn interest in Lakrima tokens.
- Purchase Premium Lottery – receive Epic level reward.
- Upgrade Rank of Space crew
- Enhancement of weapon and equipment
- Purchase Event Items 
#### Smart Contract Address: 0x44Cf35278e75cb527801ac37CB766dCB83DBde0E
#### BSC Scan : https://bscscan.com/token/0x44Cf35278e75cb527801ac37CB766dCB83DBde0E
#### Source code: [EcioSpace.sol](contracts/EcioSpace.sol)

### Lakrima Token
Luminous gemstones is recognized by many stars as a valuable thing that is hard to find even in the vast universe. Having said that it originated from the beginning of the universe formed. In ECIO, players can receive Lakrima by defeating enemies or earning as interest when depositing a pair of Ecio with BUSD or Ecio with BNB. 
#### Smart Contract Address: 0xf1315d516a57c81f75f92358173a2a995a0fcf38
#### BSC Scan : https://bscscan.com/token/0xf1315d516a57c81f75f92358173a2a995a0fcf38
#### Source code: [Lakrima.sol](contracts/Lakrima.sol)



Readmore whitepapre: https://ecio-space.gitbook.io


Testnet Address
ERC1155
0xfB684dC65DE6C27c63fa7a00B9b9fB70d2125Ea1

ERC721
0x64F6bcDb65faC6339e89ad3A8bf2317C7CE8D5aE



abigen --bin=abigenBindings/bin/ECIONFTCore.bin --abi=abigenBindings/abi/ECIONFTCore.abi --pkg=abi --out=ECIONFTCore.go




title ECIO Random Process

RandomCaller->RandomProxy: randomnessRequest(_seed)
RandomProxy->RandomWorker: randomnessRequest(_seed)

alt Frist Time
	RandomWorker->Chainlink: randomnessRequest(_seed)
    Chainlink->RandomWorker: reqId,result := fulfillRandomness()
    RandomWorker->RandomWorker: _randomNumber := Random2nd(result[0])
    RandomWorker->RandomWorker: fulfillRandomness()
else Reuse
	RandomWorker->RandomWorker: _randomNumber := Random2nd(result[count])
end

RandomWorker->RandomProxy: _randomNumber
RandomProxy->RandomCaller: _randomNumber




Random Worker
https://testnet.bscscan.com/address/0x5abf279b87f84c916d0f34c2dafc949f86ffb887