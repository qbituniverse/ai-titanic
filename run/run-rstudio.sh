#############################################################################
# ai-titanic R Studio
#############################################################################
# variables
dockerfile="Dockerfile-ai-titanic-rstudio"
image="qbituniverse/ai-titanic-rstudio:local"
container="ai-titanic-rstudio"

#############################################################################
# Create, configure and work with R Studio
#############################################################################
# build image
docker build -t $image -f .cicd/docker/$dockerfile .

# create container
docker run --name $container -d -p 8012:8787 -v $container:/home/rstudio -e DISABLE_AUTH=true $image

# launch R Studio
start http://localhost:8012

#############################################################################
# Container operations
#############################################################################
# start, stop, exec
docker start $container
docker stop $container
docker exec -it $container bash

#############################################################################
# Pull code down from container to local file system
#############################################################################
# pull code from container
docker cp $container:/home/rstudio/code/. ./src/model/code/
docker cp $container:/home/rstudio/input/. ./src/model/input/
docker cp $container:/home/rstudio/output/. ./src/model/output/
docker cp $container:/home/rstudio/models/. ./src/model/models/

#############################################################################
# Clean-up
#############################################################################
docker rm -fv $container
docker volume rm -f $container
docker rmi -f $image