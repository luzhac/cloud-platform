
---

#  Architecture Overview

This project follows a layered platform architecture with clear separation of responsibilities.

It is divided into **three logical layers**:

1. Infrastructure Layer (AWS)
2. Platform Layer (ArgoCD & GitOps Bootstrap)
3. Application Layer (Kubernetes Workloads)

---

# 1️⃣ Infrastructure Layer – `infra/terraform`

### Purpose

Provision and manage AWS infrastructure.

### Managed Resources

* VPC
* Subnets
* IAM Roles & Policies
* EKS Cluster
* Node Groups
* ECR
* S3 (Terraform backend only)
* DynamoDB (Terraform lock table)
* EKS Access Entry & Access Policy

### What it MUST NOT manage

* Kubernetes namespaces
* Helm releases
* Deployments
* ArgoCD
* Any Kubernetes workload

### Why?

Terraform operates at the AWS control plane level.
Kubernetes resources belong to a different control plane.

---

## Execution

```bash
cd infra/terraform/environments/dev
terraform apply
```

After this step:

* EKS cluster exists
* Access policies are configured
* You can access cluster via kubectl

---

# 2️⃣ Platform Layer – `infra/argocd`

This layer installs and bootstraps ArgoCD.

It has two parts:

---

## A. ArgoCD Installation (install phase)

This is a one-time cluster bootstrap step.

Example (manual):

```bash
helm repo add argo https://argoproj.github.io/argo-helm
helm install argocd argo/argo-cd -n argocd --create-namespace
```

Or via script:

```
infra/argocd/install.sh
```

### What `install.sh` does

* Ensures namespace exists
* Installs ArgoCD via Helm
* Optionally waits for readiness

It is NOT part of Terraform intentionally.

Why?
Because ArgoCD lives inside Kubernetes.
It must be installed after EKS is accessible.

---

## B. GitOps Bootstrap – `infra/bootstrap/root-app.yaml`

This is the critical GitOps entry point.

`root-app.yaml` defines:

* A top-level ArgoCD Application
* Points ArgoCD to your Git repo
* Tells ArgoCD which folders to manage

Example responsibilities:

* Deploy app-dev.yaml
* Deploy app-prod.yaml
* Deploy Helm charts under kubernetes/helm

After applying root-app:

```bash
kubectl apply -f infra/bootstrap/root-app.yaml
```

ArgoCD now controls everything under Git.

This is called:

> GitOps Bootstrap

---

# 3️⃣ Application Layer – `kubernetes/`

This is the workload layer.

It contains:

```
kubernetes/
  helm/
    challenge/
```

These are Helm charts or raw manifests for your application.

These resources are:

* namespace
* deployment
* service
* ingress
* hpa
* configmap
* etc

They are NOT installed manually.

They are deployed automatically by ArgoCD.

---

# Full Execution Flow

---

## Phase 1 – Infrastructure Bootstrap

```bash
cd infra/terraform/environments/dev
terraform apply
```

Result:

* AWS infrastructure ready
* EKS accessible

---

## Phase 2 – ArgoCD Installation

```bash
aws eks update-kubeconfig --region eu-west-2 --name challenge-dev-cluster
bash infra/argocd/install.sh
```

Result:

* ArgoCD installed in cluster

---

## Phase 3 – GitOps Bootstrap

```bash
kubectl apply -f infra/bootstrap/root-app.yaml
```

Result:

* ArgoCD starts syncing Git
* Applications are deployed automatically

---

# Responsibility Boundaries

| Layer     | Manages              | Does NOT Manage      |
| --------- | -------------------- | -------------------- |
| Terraform | AWS infra            | Kubernetes resources |
| ArgoCD    | Kubernetes workloads | AWS infrastructure   |
| Git       | Desired state        | Runtime state        |

---

# Why This Separation Exists

Because:

AWS Control Plane ≠ Kubernetes Control Plane

Terraform and ArgoCD use different authentication, state models, and reconciliation logic.

Combining them into one apply leads to:

* RBAC race conditions
* Bootstrap deadlocks
* Destroy risks
* State conflicts

---

# What S3 Backend Is Used For

The S3 backend is ONLY for Terraform state.

It has no relationship with ArgoCD.

ArgoCD uses Git as its source of truth.

---

# Final Architecture Diagram (Conceptual)

```
Terraform (AWS)
        ↓
EKS Cluster
        ↓
ArgoCD Installed
        ↓
root-app.yaml
        ↓
Git Repository
        ↓
Kubernetes Applications
```

---

# Important Design Principle

Terraform provisions infrastructure.

ArgoCD manages Kubernetes workloads.

Never let both manage the same resource type.

---

If you want, next we can:

* Refine install.sh into a production-ready script
* Convert ArgoCD install into a Terraform phase-2 module
* Or optimize your repo structure further

But now your architecture is clean and aligned with enterprise patterns.
