kubectl run python-test --image=python:3.10-slim --restart=Never -it -- bash

 

 kubectl exec -it mlflow-6c9fd684c5-q8qh8      -c mlflow   -n mlflow -- bash
 
kubectl logs mlflow-6c9fd684c5-q8qh8               -n mlflow  -f


```dockerignore


```

**  setup ssl access**
# 1 using alb
create Certificates the AWS Web Ui 



# 2 using kubernetes
## ingress-nginx
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/baremetal/deploy.yaml

**eks onley**
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml

##  cert-manager

kubectl apply kube

##  Create a username/password file:

htpasswd -c auth mlflowuser


##   Create secret:

kubectl create secret generic mlflow-basic-auth --from-file=auth -n mlflow

##  certificate
kubectl get certificate

kubectl get ClusterIssuer

kubectl delete certificate mlflow-tls

kubectl apply -f ./infra/kubernetes/helm/trading/templates/mlflow.yaml







 
