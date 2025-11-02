#!/bin/bash
set -e

# Step 1:
kubectl create namespace monitoring || true

# Step 2:
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

kubectl label node ip-10-0-11-87  role=monitor



# Step 3:
helm install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --set grafana.adminPassword='admin123' \
  --set prometheus.prometheusSpec.nodeSelector.role=monitor \
  --set grafana.nodeSelector.role=monitor \
  --set alertmanager.alertmanagerSpec.nodeSelector.role=monitor \
  --set prometheus.prometheusSpec.resources.requests.memory="512Mi" \
  --set grafana.resources.requests.memory="256Mi" \
  --set alertmanager.alertmanagerSpec.resources.requests.memory="128Mi"

# Step 4:
echo " ..."
kubectl get pods -n monitoring




#  kubectl patch svc prometheus-grafana -n monitoring -p '{"spec": {"type": "NodePort"}}'