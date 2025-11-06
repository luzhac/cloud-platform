```dockerignore
apiVersion: v1
kind: Namespace
metadata:
  name: kubeflow
---
# MySQL (Bitnami ARM64)
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql
  namespace: kubeflow
spec:
  selector:
    matchLabels:
      app: mysql
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
      - name: mysql
        image: bitnami/mysql:8.0
        env:
        - name: MYSQL_ROOT_PASSWORD
          value: root
        ports:
        - containerPort: 3306
---
apiVersion: v1
kind: Service
metadata:
  name: mysql
  namespace: kubeflow
spec:
  selector:
    app: mysql
  ports:
  - port: 3306
    targetPort: 3306
---
# MinIO (ARM multi-arch)
apiVersion: apps/v1
kind: Deployment
metadata:
  name: minio
  namespace: kubeflow
spec:
  selector:
    matchLabels:
      app: minio
  template:
    metadata:
      labels:
        app: minio
    spec:
      containers:
      - name: minio
        image: minio/minio:RELEASE.2024-09-22T00-00-00Z
        args: ["server", "/data"]
        env:
        - name: MINIO_ACCESS_KEY
          value: minio
        - name: MINIO_SECRET_KEY
          value: minio123
        ports:
        - containerPort: 9000
---
apiVersion: v1
kind: Service
metadata:
  name: minio
  namespace: kubeflow
spec:
  selector:
    app: minio
  ports:
  - port: 9000
    targetPort: 9000
---
# Simplified Kubeflow Pipelines UI (Lightweight ARM)
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ml-pipeline-ui
  namespace: kubeflow
spec:
  selector:
    matchLabels:
      app: ml-pipeline-ui
  template:
    metadata:
      labels:
        app: ml-pipeline-ui
    spec:
      containers:
      - name: ui
        image: public.ecr.aws/docker/library/python:3.11-slim
        command: ["python3"]
        args:
          - "-c"
          - |
            from flask import Flask
            app = Flask(__name__)
            @app.route('/')
            def home():
                return "Kubeflow Pipelines UI (ARM64 lightweight demo)"
            app.run(host='0.0.0.0', port=80)
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: ml-pipeline-ui
  namespace: kubeflow
spec:
  type: NodePort
  selector:
    app: ml-pipeline-ui
  ports:
  - port: 80
    targetPort: 80
    nodePort: 30080

```