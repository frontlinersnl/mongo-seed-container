#!/bin/bash

# user can specify connection settings separately
MONGO_AUTH_DB="${MONGO_AUTH_DB:-"admin"}"
MONGO_HOST="${MONGO_HOST:-"127.0.0.1"}"
MONGO_DB="${MONGO_DB:-"seed"}"
MONGO_PORT="${MONGO_PORT:-"27017"}"
MONGO_USERNAME="${MONGO_USERNAME:-"admin"}"
MONGO_PASSWORD="${MONGO_PASSWORD:-"123"}"
MONGO_CREATE_COLLECTIONS="${MONGO_CREATE_COLLECTIONS:-"true"}"

# user can specify an uri instead, most other settings will be ignored.
MONGO_URI="${MONGO_URI:-"mongodb://$MONGO_USERNAME:$MONGO_PASSWORD@$MONGO_HOST:$MONGO_PORT/$MONGO_DB?authSource=$MONGO_AUTH_DB"}"

# user can specify a custom seed files path
SEED_FILES_PATH="${SEED_FILES_PATH:-"/tmp/mongoseed/"}"

if [ "$MONGO_CREATE_COLLECTIONS" == "false" ]; then
    # get a list of collection
    listCollectionsResult=$(mongo "${MONGO_URI}" --quiet --eval "db.runCommand( { listCollections: 1, nameOnly: true } );")
    # filter out NumberLong(0) because that is what the id returns. Next select everything in cursor.firstBatch and map it to an array of names
    collectionList=$(echo "${listCollectionsResult/"NumberLong(0)"/"\"\""}" | jq -c ".cursor.firstBatch" | jq 'map(.name)')
fi

# ./seed
for currentFile in "$SEED_FILES_PATH"*.json; do
    echo "Processing ${currentFile}"
    if [ -n "$collectionList" ]; then
        # get filename without extension
        fileName=$(echo "$currentFile" | cut -f 1 -d '.')
        
        # check whether collection exists by searching for it in the collectionList
        numberOfCollectionsFound=$(echo "$collectionList" | jq ".[] | select(.==\"$fileName\")" | wc -l)

        # if not found, error out...
        if [ "$numberOfCollectionsFound" -lt "1" ]; then
            echo "Collection $fileName doesn't exist. Exiting.."
            exit 1
        fi
    fi
    echo "importing $currentFile"
    mongoimport --uri "$MONGO_URI" --file="$currentFile" --mode=upsert
    if [ $? -eq 1 ]
    then
        exit 1
    fi
done