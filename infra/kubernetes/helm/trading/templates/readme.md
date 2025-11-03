
1.
kubectl -n monitoring create configmap custom-rules --from-file=alert-rules.yaml



2.
kubectl -n monitoring edit configmap prometheus-server


3.In rule_files: add：

rule_files:
  - /etc/config/alert-rules.yaml
  - /etc/config/custom-rules/alert-rules.yaml


4.restart Prometheus：

kubectl -n monitoring rollout restart deploy prometheus-server