# ai-titanic

**ai-titanic** is built entirely on container technology with [Docker](https://www.docker.com). To be able to run the code from this repository, all you need on your local workstation is [Docker Installation](https://docs.docker.com/get-docker/).

|Documentation|Packages|Showcase|
|-----|-----|-----|
|[Project Overview](/docs/overview.md)|[DockerHub Api Image](https://hub.docker.com/repository/docker/qbituniverse/ai-titanic-api)|[Gallery](/docs/gallery.md)|
|[Project Description](/docs/description.md)|[DockerHub Webapp Image](https://hub.docker.com/repository/docker/qbituniverse/ai-titanic-webapp)||
|[R Model Code Overview](/docs/model.md)|||
|[C# Webapi Code Overview](/docs/webapi.md)|||
|[C# Webapp Code Overview](/docs/webapp.md)|||
|[Development Process](/docs/development.md)|||
|[Deployment Process](/docs/deployment.md)|||

### Try ai-titanic Now

#### Option 1: Docker Compose

Copy this YAML into a new **docker-compose.yaml** file on your file system.

```yaml
version: '3'
services:
  api:
    image: qbituniverse/ai-titanic-api:latest
    container_name: ai-titanic-api
    ports:
      - 8011:8000
    tty: true
    networks:
      - ai-titanic-bridge

  webapp:
    image: qbituniverse/ai-titanic-webapp:latest
    depends_on:
      - api
    container_name: ai-titanic-webapp
    environment:
      - ASPNETCORE_ENVIRONMENT=Development
      - WebApp__AiApi__BaseUri=http://ai-titanic-api:8000
    ports:
      - 8010:8080
    tty: true
    networks:
      - ai-titanic-bridge

networks:
  ai-titanic-bridge:
    driver: bridge
```

Then use the commands below to start **ai-titanic** up and use it.

```bash
# start up ai-titanic
docker compose up

# ai-titanic Webapp
start http://localhost:8010

# ai-titanic Api docs
start http://localhost:8011/__docs__/

# finish and clean up ai-titanic
docker compose down
```

#### Option 2: Docker Run

Alternatively, you can run **ai-titanic** without compose, just simply use docker commands below.

```bash
# create network
docker network create ai-titanic-bridge

# start up ai-titanic containers
docker run --name ai-titanic-api -d -p 8011:8000 \
--network=ai-titanic-bridge qbituniverse/ai-titanic-api:latest

docker run --name ai-titanic-webapp -d -p 8010:8080 \
-e ASPNETCORE_ENVIRONMENT=Development \
-e WebApp__AiApi__BaseUri=http://ai-titanic-api:8000 \
--network=ai-titanic-bridge qbituniverse/ai-titanic-webapp:latest

# ai-titanic Webapp
start http://localhost:8010

# ai-titanic Api docs
start http://localhost:8011/__docs__/

# finish and clean up ai-titanic
docker rm -fv ai-titanic-api
docker volume rm -f ai-titanic-api
docker rm -fv ai-titanic-webapp
docker volume rm -f ai-titanic-webapp
docker network rm ai-titanic-bridge
```
