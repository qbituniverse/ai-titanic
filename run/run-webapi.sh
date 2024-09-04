#############################################################################
# ai-titanic R Webapi
#############################################################################
# variables
dockerfile="Dockerfile-ai-titanic-webapi"
image="qbituniverse/ai-titanic-webapi:local"
container="ai-titanic-webapi"
network="ai-titanic-bridge"

#############################################################################
# Create, configure and work with Webapi
#############################################################################
# build image
docker build -t $image -f .cicd/docker/$dockerfile .

# create network & container
docker network create $network
docker run --name $container -d -p 8021:8080 --network=$network \
-e ASPNETCORE_ENVIRONMENT=Development \
-e WebApi__RApiUrl=http://ai-titanic-api:8000 \
$image

# launch Webapi
start http://localhost:8021

#############################################################################
# Container operations
#############################################################################
# start, stop, exec
docker start $container
docker stop $container
docker exec -it $container bash

#############################################################################
# Clean-up
#############################################################################
docker rm -fv $container
docker volume rm -f $container
docker rmi -f $image
docker network rm $network