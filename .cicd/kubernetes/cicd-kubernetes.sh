#############################################################################
# ai-titanic App - Kubernetes
#############################################################################
# set context
kubectl config get-contexts
kubectl config use-context docker-desktop
kubectl config current-context

# deploy
kubectl apply -f .cicd/kubernetes/deploy.yaml

# check deployment
kubectl get all -n ai-titanic

# launch webapp & api
start http://localhost:8010
start http://localhost:8011/__docs__/

# clean-up
kubectl delete namespace ai-titanic