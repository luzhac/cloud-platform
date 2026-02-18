# Solution

This solution demonstrates the design, development, and deployment of a production-ready Python API service using Docker, Infrastructure as Code (Terraform), Kubernetes (EKS), Helm, and GitHub Actions CI/CD, ArgoCd with a strong focus on reliability, security, and scalability.


The solution is built and tested on Eks nodes(x86_64).Although the implementation currently targets x86 instances for simplicity, it can be easily adapted to ARM-based EC2 instances, which are typically 10% more cost-efficient in production environments.

A key feature of this solution is maximum automation:
most infrastructure and operational logic is implemented via Terraform and Kubernetes, minimizing manual CLI operations.


# Architecture Overview

Delivery Workflow:
- Python application is developed and tested locally.
- Infrastructure code (Terraform and Kubernetes) is developed locally.
- Source code is managed using GitHub.
- When code is pushed to GitHub, the CI pipeline runs tests, linting, image scanning, and image build,image push, terraform plan.
- Infrastructure changes are applied manually using Terraform apply during the challenge phase.
- Application deployments are performed using Helm upgrades or Kubernetes rollouts.


Security
- The EKS cluster is deployed in private subnets.
- Kubernetes workloads access AWS services using IRSA via OIDC instead of AWS access keys.
- Docker images are scanned during CI.
- GitHub Actions uses OIDC authentication instead of  AWS access keys.

Scalability
- EKS managed node groups with autoscaling.
- Kubernetes HPA for application-level scaling.

Reliability
- Kubernetes health checks ensure failed pods are automatically restarted.
- Infrastructure defined declaratively to ensure repeatability and recovery.

# Limitations 

In a real production system , the following improvements would be implemented:

Observability
- Prometheus for Kubernetes and application metrics
- Loki for container and application logs
- Grafana for dashboards and alerting
- OpenTelemetry for  tracing

Audit 
- Multi-account AWS structure (e.g. dev / staging / prod)
- Fine-grained IAM policies

Disaster Recovery
- Multi-region deployment strategy
- DynamoDB global tables
- S3 cross-region replication
- Automated backup and restore procedures

## prerequisites

- Create a User:user-admin with AdministratorAccess Policy,In production environments, permissions would follow the principle of least privilege.
- Create AWS access key for CLI.
- Using aws configure  to use the new account.
- There is one terraform file,it create  S3 for terraform backend such as for dev env, run bellow local.
Terraform environment:
```
/infra/terraform/environments/setup
``` 
 
# Develop the Python API Server


- When run local, provide env DYNAMODB_TABLE and S3_BUCKET.
- When run in Github action, provide environments `challenge` with ACCOUNT,REGION,S3_BUCKET,DYNAMODB_TABLE,GIT_HUB_ROLE(github-action-role),ENVIRONMENT(dev)
- When run in Eks,modify env DYNAMODB_TABLE and S3_BUCKET in the deployment.

# Dockerise  Application
- Docker image built using Python 3.10 slim.
- Dependency management via Poetry
- Image optimized for size and reproducibility

# Infrastructure as Code

Most AWS infrastructure is provisioned using Terraform
Modular structure for reusability and clarity
Supports multiple environments 
Terraform backend uses S3 for state locking and collaboration

Provisioned resources include:
- VPC and networking
- EKS cluster and node groups
- ECR
- DynamoDB
- S3
- IAM roles and policies
- OIDC provider and IRSA roles for Kubernetes ServiceAccounts and Github Action

Terraform environment(dev):
```
/infra/terraform/environments/dev
```

After provisioning, a minimal CLI(associate-access-policy) step is required to grant user-admin access to the EKS cluster for kubectl usage.


# Kubernetes Deployment with ARGOCD

 

 
#  CI Implementation
A GitHub Actions workflow is implemented to provide a reliable CI/CD pipeline:
- Run tests and linting
- Scan Docker images
- Build and push Docker images to ECR
- Authenticate to AWS using OIDC  
- Terraform Plan
 
#  CD Implementation
- with ARGOCD

##
- Custom Helm chart created for the application
- Supports multi-environment configuration

Includes:
- Deployment
- Service
- Horizontal Pod Autoscaler
- Health checks

Release Strategy
- GitOps with Argo CD to deploy  blue/green, canary, rollback


## manul Installation example:
Helm chart location:
```
/infra/kubernetes/helm
```

```
helm install challenge ./challenge -n challenge-dev --create-namespace -f challenge/values-dev.yaml

helm upgrade challenge ./challenge  -n challenge-dev -f challenge/values-dev.yaml

```

 