



kubectl run python-test --image=python:3.10-slim --restart=Never -it -- bash




 kubectl exec -it mlflow-8595595bb8-87sh9     -c mlflow   -n mlflow -- bash
 
kubectl logs mlflow-8595595bb8-87sh9           -n mlflow  -f


[notice] A new release of pip is available: 23.0.1 -> 25.3
[notice] To update, run: pip install --upgrade pip
bash: line 1:  mlflow: command not found
