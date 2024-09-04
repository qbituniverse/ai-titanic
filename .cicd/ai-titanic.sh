### Tests ###

## Manual ##
# r studio
sudo docker run --name ai-titanic-rstudio -d -p 8012:8787 -v ai-titanic-rstudio:/home/rstudio -e DISABLE_AUTH=true qbituniverse/ai-titanic-rstudio:latest
curl http://192.168.1.15:8012
curl http://192.168.1.20:8012

# network
sudo docker network create ai-titanic-bridge

# r api
#sudo docker run --name ai-titanic-api -it --rm -p 8011:8000 qbituniverse/ai-titanic-api:latest
sudo docker run --name ai-titanic-api -d -p 8011:8000 --network=ai-titanic-bridge qbituniverse/ai-titanic-api:latest
curl http://192.168.1.15:8011/api/ping
curl http://192.168.1.20:8011/api/ping
curl http://192.168.1.15:8011/api/stats
curl http://192.168.1.20:8011/api/stats
curl http://192.168.1.15:8011/api/predict?sex=male'&'age=34'&'pclass=1'&'fare=22.00'&'sibsp=1'&'parch=2
curl http://192.168.1.20:8011/api/predict?sex=male'&'age=34'&'pclass=1'&'fare=22.00'&'sibsp=1'&'parch=2

# webapi
sudo docker run --name ai-titanic-webapi -d -p 8021:8080 --network=ai-titanic-bridge -e WebApi__RApiUrl=http://192.168.1.15:8011 qbituniverse/ai-titanic-webapi:latest
curl http://192.168.1.15:8021/api/status
curl http://192.168.1.15:8021/api/model
curl http://192.168.1.20:8021/api/status
curl http://192.168.1.20:8021/api/model

# webapp
sudo docker run --name ai-titanic-webapp -d -p 8010:8080 --network=ai-titanic-bridge -e WebApp__AiApi__BaseUri=http://192.168.1.15:8011 qbituniverse/ai-titanic-webapp:latest
curl http://192.168.1.15:8010
curl http://192.168.1.20:8010


## Compose ##
sudo docker compose -f .cicd/compose/docker-compose.DockerHub.yaml up
sudo docker compose -f .cicd/compose/docker-compose.DockerHub.yaml down
