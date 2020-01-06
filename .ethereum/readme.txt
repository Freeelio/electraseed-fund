vi ~/.ethereum/passfile
dev
chmod 700 passfile

vi ~/.ethereum/createGethAccts.sh
for ((n=0;n<10;n++)); do geth account new --password ~/.ethereum/passfile; done
chmod +x createGethAccts.sh

vi ~/.ethereum/credentials.txt
## all the wallets created with createGethAccts.sh

puppeth
## make a new genesis file with poa using credentials created

geth --datadir .ethereum/ init ./ethereum/electraseed.json

vi startGeth.sh
geth --nodiscover --networkid 42 --datadir .ethereum/ --allow-insecure-unlock --unlock 0x9334C07308a59aeC890D127be503837e67fE75EE --password ./.ethereum/passfile --mine --rpc --rpcapi eth,net,web3 --rpcaddr 0.0.0.0 2>> ./.ethereum/electraseed.log &
chmod +x startGeth.sh

vi createGethAccts.sh
for ((n=0;n<10;n++)); do geth account new --password ./passfile; done
chmod +x createGethAccts.sh
