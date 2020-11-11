[![logo](./logo.jpg)](https://inforit.nl)

# Mongo-seed container

This container enables someone to seed a mongo database given \*.json seed files.

## Usage

### build your own container

Every seed file ending in .json will be picked up from the main working directory.
All you have to do is add them in the base container :)

```
FROM inforitnl/mongo-seed
COPY ./seed-files .
```

### use your container in compose files

```sh
version: "3.4"

services:
  seed:
    image: seed-container-name
    container_name: seed-container-name
    # this host works for Windows by default.. that's why I chose this
    hostname: host.docker.internal
    environment:
      MONGO_URI: "mongodb://admin:supersecretpassword@172.17.0.1:27017/db-name?authSource=admin&replicaSet=replicaset-name"

    # windows users: comment out extra_hosts section
    # linux/mac/wsl users: make sure the extra_hosts section ISN'T commented out
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
