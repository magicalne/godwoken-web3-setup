#!/bin/bash

set -o errexit
#set -o xtrace

# read eth_lock_hash from json config file
LOCKSCRIPTS=/code/scripts-deploy-result.json

EthAccountLockCodeHash=$(jq -r '.eth_account_lock.script_type_hash' $LOCKSCRIPTS)
PolyjuiceValidatorCodeHash=$(jq -r '.polyjuice_validator.script_type_hash' $LOCKSCRIPTS)
L2SudtValidatorCodeHash=$(jq -r '.l2_sudt_validator.script_type_hash' $LOCKSCRIPTS)
TronAccountLockCodeHash=$(jq -r '.tron_account_lock.script_type_hash' $LOCKSCRIPTS)

# create folder for address mapping store
mkdir -p /usr/local/godwoken-web3/address-mapping

cat > godwoken-web3/packages/api-server/.env <<EOF
DATABASE_URL=postgres://user:password@postgres:5432/lumos
GODWOKEN_JSON_RPC=$GODWOKEN_JSON_RPC
ETH_ACCOUNT_LOCK_HASH=$EthAccountLockCodeHash
ROLLUP_TYPE_HASH=$ROLLUP_TYPE_HASH
PORT=$PORT
CHAIN_ID=1024777
CREATOR_ACCOUNT_ID=$CREATOR_ACCOUNT_ID
DEFAULT_FROM_ADDRESS=0x6daf63d8411d6e23552658e3cfb48416a6a2ca78
POLYJUICE_VALIDATOR_TYPE_HASH=$PolyjuiceValidatorCodeHash
L2_SUDT_VALIDATOR_SCRIPT_TYPE_HASH=$L2SudtValidatorCodeHash
TRON_ACCOUNT_LOCK_HASH=$TronAccountLockCodeHash
REDIS_URL=redis://redis:6379
EOF

cat godwoken-web3/packages/api-server/.env
# start web3 server
#for debug, you can run: yarn workspace @godwoken-web3/api-server start
cd godwoken-web3/packages/api-server 

DEBUG=godwoken-web3-api:server NODE_ENV=production node ./bin/www
# yarn workspace @godwoken-web3/api-server start

