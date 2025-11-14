



kubectl run python-test --image=python:3.10-slim --restart=Never -it -- bash




 kubectl exec -it mlflow-6c9fd684c5-q8qh8      -c mlflow   -n mlflow -- bash
 
kubectl logs mlflow-6c9fd684c5-q8qh8               -n mlflow  -f


 
