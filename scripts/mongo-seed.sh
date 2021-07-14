#!/bin/bash

# user can specify connection settings separately
MONGO_AUTH_DB="${MONGO_AUTH_DB:-"admin"}"
MONGO_HOST="${MONGO_HOST:-"127.0.0.1"}"
MONGO_DB="${MONGO_DB:-"seed"}"
MONGO_PORT="${MONGO_PORT:-"27017"}"
MONGO_USERNAME="${MONGO_USERNAME:-"admin"}"
MONGO_PASSWORD="${MONGO_PASSWORD:-"123"}"
MONGO_CREATE_COLLECTIONS="${MONGO_CREATE_COLLECTIONS:-"true"}"
IGNORE_NON_EMPTY="${IGNORE_NON_EMPTY:-"false"}"

# user can specify an uri instead, most other settings will be ignored.
MONGO_URI="${MONGO_URI:-"mongodb://$MONGO_USERNAME:$MONGO_PASSWORD@$MONGO_HOST:$MONGO_PORT/$MONGO_DB?authSource=$MONGO_AUTH_DB"}"

# user can specify a custom seed files path
SEED_FILES_PATH="${SEED_FILES_PATH:-"/tmp/mongoseed/"}"


collectionsWithCount=$(mongo "${MONGO_URI}" --quiet --eval "
    var result = [];
    db.getCollectionInfos().forEach(function(collection) {
        var collectionResult = {name: collection.name, count: db[collection.name].count()}
        result.push(collectionResult);
    });
    printjson(result);
")

for currentFile in "$SEED_FILES_PATH"*.json; do
    echo "Processing ${currentFile}"

    # filename without extension
    fileName=$(echo "${currentFile##*/}" | cut -f 1 -d '.')
    
    # look for a collection that matches the current filename in our list of known collections
    collectionWithFileName=$(echo "$collectionsWithCount" | jq ".[] | select(.name==\"$fileName\")")

    # if collection is found
    if [ $(echo "$collectionWithFileName" | wc -l) -gt "1" ]; then
        # if ignore empty == true && collection.count > 0 then...
        if [ "$IGNORE_NON_EMPTY" == "true" ] && [ $(echo "$collectionWithFileName" | jq ".count") -gt "0" ]; then
            echo "Collection $fileName is not empty, skipping.."
        else
            mongoimport --uri "$MONGO_URI" --file="$currentFile" --mode=upsert
        fi
    else
        if [ "$MONGO_CREATE_COLLECTIONS" == "false" ]; then
            echo "Collection $fileName doesn't exist. Exiting.."
            exit 1
        fi
        mongoimport --uri "$MONGO_URI" --file="$currentFile" --mode=upsert
    fi
done