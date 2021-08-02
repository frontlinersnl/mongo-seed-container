[![logo](./logo.jpg)](https://inforit.nl)

# Mongo-seed container

This container enables someone to seed a mongo database given \*.json seed files.

## Usage

### build your own container

Every seed file ending in .json will be picked up from the main working directory.
All you have to do is add them in the base container :)

``` dockerfile
FROM inforitnl/mongo-seed
COPY ./seed-files .
```

### use your container in compose files

```sh
version: "3.4"

services:
  seed:
    image: inforitnl/mongo-seed:2.0.0
    hostname: host.docker.internal
    environment:
      MONGO_URI: "mongodb://admin:supersecretpassword@host.docker.internal:27017/db-name?authSource=admin&replicaSet=replicaset-name"

    volumes:
      - ./seed/seed-files/:/tmp/mongoseed/

    # windows users: use your docker instance IP here instead of 172.17.0.1
    extra_hosts:
      host.docker.internal: 172.17.0.1

```

## container variables

| Variable                 | Purpose                                                                                      |
| ------------------------ | -------------------------------------------------------------------------------------------- |
| MONGO_URI                | Uri to which the script connects. If not specified will be made from the other env variables |
| MONGO_CREATE_COLLECTIONS | whether to create the collections if they don't exist. defaults to true                      |
| MONGO_AUTH_DB            | authsource                                                                                   |
| MONGO_HOST               | hostname                                                                                     |
| MONGO_DB                 | databasename                                                                                 |
| MONGO_PORT               | port                                                                                         |
| MONGO_USERNAME           | username                                                                                     |
| MONGO_PASSWORD           | password                                                                                     |
| SEED_FILES_PATH          | custom path to seed files, defaults to /tmp/mongoseed                                       |
| IGNORE_NON_EMPTY         | when set to true will prevent seed data from importing when the collection exists and has more than 0 records |
| DYNAMIC_DATABASE_NAME    | when set to true will replace $DB_NAME_PATTERN in the connectionstring with $MONGO_DB |
| DB_NAME_PATTERN         | pattern to replace with $DYNAMIC_DATABASE_NAME |

## update instructions

1. update dockerfile
2. build local version:

   ```sh
   docker build -t inforitnl/mongo-seed .
   ```

3. push new version to dockerhub:

   ```sh
   docker push inforitnl/mongo-seed
   ```

4. tag and push again (optional but recommended):

   ```sh
   docker tag inforitnl/mongo-seed inforitnl/mongo-seed:1.0.0
   docker push inforitnl/mongo-seed:1.0.0
   ```
