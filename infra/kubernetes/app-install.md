export KUBECONFIG=/etc/kubernetes/admin.conf

kubectl create ns trading
kubectl create ns monitoring

# 1
cd infra/kubernetes/helm
helm dependency update
helm install monitoring . -n monitoring -f values-monitoring.yaml
helm upgrade monitoring . -n monitoring -f values-monitoring.yaml


# 2
helm install trading ./infra/kubernetes/helm/trading --namespace trading --create-namespace
helm uninstall trading -n trading

kubectl delete ns trading

helm upgrade trading ./infra/kubernetes/helm/trading -n trading

# 3
kubectl apply -f ./infra/kubernetes/helm/trading/templates/deployment-fetch-data.yaml  -n trading

helm upgrade trading . -n trading

kubectl exec -it -n trading generate-signal-8459977486-6t72j  -- bash
cd /mnt/efs
touch test.txt
ls -l test.txt



## config  ecr login in working node

```
aws ecr get-login-password --region ap-northeast-1 \
| sudo ctr --namespace k8s.io images pull \
--user AWS:$(aws ecr get-login-password --region ap-northeast-1) \
--platform linux/arm64 \
173381466759.dkr.ecr.ap-northeast-1.amazonaws.com/quant:latest

```

# 3 ebs 
helm repo add aws-ebs-csi-driver https://kubernetes-sigs.github.io/aws-ebs-csi-driver
helm repo update 
helm upgrade --install aws-ebs-csi-driver aws-ebs-csi-driver/aws-ebs-csi-driver \
  --namespace kube-system \

# 4 efs
 