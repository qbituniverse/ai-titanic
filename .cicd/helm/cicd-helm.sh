#############################################################################
# ai-titanic App - Helm
#############################################################################
# set context
kubectl config get-contexts
kubectl config use-context docker-desktop
kubectl config current-context

# deploy webapp & api
helm upgrade ai-titanic-webapp -i --create-namespace --namespace ai-titanic .cicd/helm/ai-titanic-webapp
helm upgrade ai-titanic-api -i --create-namespace --namespace ai-titanic .cicd/helm/ai-titanic-api

# deploy ingress controller
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install nginx-ingress ingress-nginx/ingress-nginx \
--namespace ai-titanic \
--set controller.replicaCount=1 \
--set controller.admissionWebhooks.enabled=false \
--set controller.service.externalTrafficPolicy=Local

# check deployments
kubectl get all -n ai-titanic
kubectl get ingress -n ai-titanic
helm list --all -n ai-titanic

# launch webapp & api
start http://web.ai-titanic.localhost
start http://api.ai-titanic.localhost/__docs__/

# clean-up
kubectl delete namespace ai-titanic