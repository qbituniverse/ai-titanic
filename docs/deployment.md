# Deployment Process

## Docker Compose

Location: **.cicd/compose** and **.cicd/compose/cicd-compose.sh**

### Start up with Docker Compose

```bash
# using GitHub local source code
docker compose -f .cicd/compose/docker-compose.GitHub.yaml up

# using DockerHub image repository
docker compose -f .cicd/compose/docker-compose.DockerHub.yaml up
```

### Launch

```bash
start http://localhost:8010
```

### Take Down with Docker Compose

```bash
# using GitHub local source code
docker compose -f .cicd/compose/docker-compose.GitHub.yaml down

# using DockerHub image repository
docker compose -f .cicd/compose/docker-compose.DockerHub.yaml down
```

## Kubernetes

Location: **.cicd/kubernetes** and **.cicd/kubernetes/cicd-kubernetes.sh**

### Configure Kubernetes Context

```bash
kubectl config get-contexts
kubectl config use-context docker-desktop
kubectl config current-context
```

### Deploy to Kubernetes

```bash
# deploy
kubectl apply -f .cicd/kubernetes/deploy.yaml

# check deployment
kubectl get all -n ai-titanic
```

### Launch

```bash
start http://localhost:8010
```

### Take Down from Kubernetes

```bash
kubectl delete namespace ai-titanic
```

## Helm

Location: **.cicd/helm** and **.cicd/helm/cicd-helm.sh**

### Configure Kubernetes Context

```bash
kubectl config get-contexts
kubectl config use-context docker-desktop
kubectl config current-context
```

### Deploy to Kubernetes with Helm

```bash
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
```

### Launch

```bash
start http://web.ai-titanic.localhost
start http://api.ai-titanic.localhost/__docs__/
```

### Take Down from Kubernetes

```bash
kubectl delete namespace ai-titanic
```