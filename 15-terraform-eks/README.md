# Project 15 - Provision Amazon EKS Using Terraform

## Problem Statement

Your company wants to run production Kubernetes workloads on AWS without managing the control plane manually.

Current Problems:

- Manual EKS cluster creation via AWS Console — time-consuming and not repeatable
- No version control over cluster configuration
- Inconsistent networking setup across environments
- Missing required IAM roles causes cluster creation failures

Build a production-ready Amazon EKS cluster using Terraform with full VPC networking, IAM roles, public/private subnets, NAT Gateway, and a managed node group.

---

## Architecture

```
Terraform (local)
      │
      ▼ terraform apply (~15 mins)
AWS Cloud
      │
      ├── VPC (10.0.0.0/16)  dns_hostnames=true
      │     ├── Public Subnets  (10.0.1.0/24, 10.0.2.0/24)  — Load Balancers
      │     │     └── NAT Gateway (for private subnet outbound)
      │     └── Private Subnets (10.0.3.0/24, 10.0.4.0/24)  — Worker Nodes
      │
      ├── IAM Roles
      │     ├── EKS Cluster Role  (AmazonEKSClusterPolicy)
      │     └── Node Group Role   (AmazonEKSWorkerNodePolicy
      │                            AmazonEKS_CNI_Policy
      │                            AmazonEC2ContainerRegistryReadOnly)
      │
      └── EKS Cluster (Kubernetes 1.29)
            └── Managed Node Group (t3.medium × 2, min 1, max 4)
                  └── Worker Nodes in Private Subnets
```

---

## Project Structure

```
15-terraform-eks/
├── providers.tf       ← AWS provider + terraform version constraints
├── main.tf            ← VPC, Subnets, IGW, NAT, IAM Roles, EKS Cluster, Node Group
├── variables.tf       ← All typed variables with descriptions and defaults
├── outputs.tf         ← Cluster name, endpoint, kubeconfig command, VPC ID
└── terraform.tfvars   ← Environment-specific values
```

---

## Prerequisites

- AWS Account with sufficient IAM permissions (EKS, EC2, IAM, VPC)
- Terraform ≥ 1.3.0 → [Install Terraform](https://developer.hashicorp.com/terraform/install)
- AWS CLI installed and configured → [Install AWS CLI](https://aws.amazon.com/cli/)
- kubectl installed → [Install kubectl](https://kubernetes.io/docs/tasks/tools/)

Verify:

```bash
terraform version
aws --version
kubectl version --client
aws sts get-caller-identity
```

---

## Step 1 - Configure AWS CLI

```bash
aws configure
```

Verify credentials:

```bash
aws sts get-caller-identity
```

Expected:

```json
{
  "UserId": "AIDA...",
  "Account": "123456789012",
  "Arn": "arn:aws:iam::123456789012:user/your-user"
}
```

---

## Step 2 - Review terraform.tfvars

```hcl
aws_region         = "ap-south-1"
cluster_name       = "devops-cluster"
kubernetes_version = "1.29"

vpc_cidr             = "10.0.0.0/16"
availability_zones   = ["ap-south-1a", "ap-south-1b"]
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]

node_instance_type = "t3.medium"
node_desired_size  = 2
node_min_size      = 1
node_max_size      = 4
```

> ⚠️ EKS clusters cost money — `t3.medium × 2` nodes + NAT Gateway runs approximately **$3–5/day**. Run `terraform destroy` when done.

---

## Step 3 - Initialize Terraform

```bash
terraform init
```

Expected:

```
Terraform has been successfully initialized!
Providers: hashicorp/aws ~> 5.0
```

---

## Step 4 - Validate and Plan

```bash
terraform validate
terraform plan
```

Expected from plan:

```
Plan: 22 to add, 0 to change, 0 to destroy.

Resources include:
  + aws_vpc.main
  + aws_subnet.public[0] / [1]
  + aws_subnet.private[0] / [1]
  + aws_internet_gateway.main
  + aws_nat_gateway.main
  + aws_eip.nat
  + aws_route_table.public / .private
  + aws_iam_role.eks_cluster / .eks_nodes
  + aws_iam_role_policy_attachment × 4
  + aws_eks_cluster.main
  + aws_eks_node_group.workers
```

---

## Step 5 - Apply Infrastructure

```bash
terraform apply
```

Type `yes` when prompted.

> ⚠️ EKS cluster creation takes **10–15 minutes**. Node group creation takes another **5 minutes**. This is normal.

Expected when complete:

```
Apply complete! Resources: 22 added, 0 changed, 0 destroyed.

Outputs:

cluster_name      = "devops-cluster"
cluster_endpoint  = "https://XXXX.gr7.ap-south-1.eks.amazonaws.com"
cluster_version   = "1.29"
kubeconfig_command = "aws eks update-kubeconfig --region ap-south-1 --name devops-cluster"
vpc_id            = "vpc-0abc123def456"
```

---

## Step 6 - Configure kubectl

Run the kubeconfig command from the Terraform output:

```bash
aws eks update-kubeconfig --region ap-south-1 --name devops-cluster
```

Or use the Terraform output directly:

```bash
$(terraform output -raw kubeconfig_command)
```

Verify nodes are ready:

```bash
kubectl get nodes
```

Expected:

```
NAME                                         STATUS   ROLES    AGE   VERSION
ip-10-0-3-xx.ap-south-1.compute.internal     Ready    <none>   2m    v1.29.x
ip-10-0-4-xx.ap-south-1.compute.internal     Ready    <none>   2m    v1.29.x
```

---

## Step 7 - Deploy a Test Workload

```bash
kubectl create deployment nginx --image=nginx:1.27
kubectl expose deployment nginx --type=LoadBalancer --port=80
```

Watch the Load Balancer get provisioned (takes ~2 minutes):

```bash
kubectl get svc nginx -w
```

Expected — once `EXTERNAL-IP` is populated:

```
NAME    TYPE           CLUSTER-IP    EXTERNAL-IP                                      PORT(S)
nginx   LoadBalancer   10.100.xx.x   abc123.ap-south-1.elb.amazonaws.com              80:3xxxx/TCP
```

Open the EXTERNAL-IP in your browser to see the Nginx welcome page.

---

## Verification Checklist

✅ `terraform apply` — 22 resources created

✅ EKS cluster visible in AWS Console → EKS → Clusters

✅ Node group with 2 worker nodes in `Running` state

✅ `kubectl get nodes` — both nodes `Ready`

✅ Test deployment accessible via LoadBalancer EXTERNAL-IP

✅ Worker nodes in **private** subnets (not publicly exposed)

---

## Troubleshooting

**`Error: error creating EKS Cluster: InvalidParameterException`**
- Check the `availability_zones` in `terraform.tfvars` exist in your region
- Run: `aws ec2 describe-availability-zones --region ap-south-1`

**`kubectl get nodes` returns nothing after apply:**
- Wait 5 more minutes — node group takes time after cluster is ready
- Check: `aws eks describe-nodegroup --cluster-name devops-cluster --nodegroup-name devops-cluster-workers`

**`Error: IAM role ... is not ready`**
- Terraform `depends_on` handles this — if it fails, re-run `terraform apply`

---

## Cleanup

> ⚠️ Delete the test workload first (to remove the AWS Load Balancer) — otherwise `terraform destroy` will hang waiting for it:

```bash
kubectl delete svc nginx
kubectl delete deployment nginx
```

Then destroy all infrastructure:

```bash
terraform destroy
```

Type `yes`. Takes ~10 minutes.

---

## Production Notes

> **1. Use Remote State (S3 + DynamoDB)**
> ```hcl
> terraform {
>   backend "s3" {
>     bucket         = "my-tfstate-bucket"
>     key            = "eks/terraform.tfstate"
>     region         = "ap-south-1"
>     dynamodb_table = "terraform-lock"
>   }
> }
> ```

> **2. Enable EKS Control Plane Logging**
> ```hcl
> enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
> ```

> **3. Add Cluster Autoscaler**
> Configure the Kubernetes Cluster Autoscaler to automatically scale the node group based on pending pod demand.

> **4. Use Spot Instances for Cost Savings**
> Replace `instance_types = ["t3.medium"]` with a mix: `["t3.medium", "t3.large", "t2.medium"]` and add `capacity_type = "SPOT"` to save up to 70% on node costs.

---

## Key Learnings

- Amazon EKS (managed Kubernetes control plane)
- EKS VPC networking: public subnets (LBs) + private subnets (nodes)
- Kubernetes subnet tags (`kubernetes.io/role/elb`, `internal-elb`)
- NAT Gateway (outbound internet for private subnet worker nodes)
- IAM roles for EKS cluster and node group (with correct policy attachments)
- `AmazonEKSClusterPolicy`, `AmazonEKSWorkerNodePolicy`, `AmazonEKS_CNI_Policy`
- Managed Node Group with `scaling_config` (desired/min/max)
- `update_config.max_unavailable` (rolling node updates)
- `aws eks update-kubeconfig` (kubectl cluster authentication)
- `terraform output -raw` in shell commands
- Remote state with S3 + DynamoDB
- EKS Cluster Autoscaler (production pattern)
- Spot instances for cost optimisation
