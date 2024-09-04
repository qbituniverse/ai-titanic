#############################################################################
# ai-titanic App - Docker Compose
#############################################################################

#############################################################################
# Option 1: Build Images from GitHub Sources
#############################################################################
# start up
docker compose -f .cicd/compose/docker-compose.GitHub.yaml up

# launch webapp & api
start http://localhost:8010
start http://localhost:8011/__docs__/

# clean-up
docker compose -f .cicd/compose/docker-compose.GitHub.yaml down

#############################################################################
# Option 2: Pull Images from DockerHub
#############################################################################
# start up
docker compose -f .cicd/compose/docker-compose.DockerHub.yaml up

# launch webapp & api
start http://localhost:8010
start http://localhost:8011/__docs__/

# clean-up
docker compose -f .cicd/compose/docker-compose.DockerHub.yaml down