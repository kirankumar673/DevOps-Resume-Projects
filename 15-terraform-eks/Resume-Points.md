# Resume Points — Project 15: Terraform EKS

---

## Fresher

- Provisioned a production-ready Amazon EKS cluster using Terraform with full VPC networking — public subnets for Load Balancers, private subnets for worker nodes, and a NAT Gateway for outbound connectivity.
- Created all required IAM roles from scratch: EKS Cluster Role (`AmazonEKSClusterPolicy`) and Node Group Role with three required policies (`AmazonEKSWorkerNodePolicy`, `AmazonEKS_CNI_Policy`, `AmazonEC2ContainerRegistryReadOnly`).
- Configured EKS Managed Node Group with `scaling_config` (desired: 2, min: 1, max: 4) and `update_config.max_unavailable: 1` for zero-downtime node rolling updates.
- Used `aws eks update-kubeconfig` to authenticate kubectl with the cluster and deployed a test nginx workload exposed via an AWS Load Balancer.

---

## Experienced DevOps Engineer

- Designed a complete production-aligned EKS Terraform stack: VPC with proper Kubernetes subnet tags (`kubernetes.io/role/elb`, `kubernetes.io/role/internal-elb`), NAT Gateway for private subnet egress, all IAM roles with least-privilege policy attachments, and a versioned EKS cluster with private endpoint access enabled.
- Implemented all Terraform best practices: `required_providers` with pinned AWS provider version (`~> 5.0`), `required_version` constraint, typed variables with descriptions, and descriptive outputs including a `kubeconfig_command` output for immediate kubectl access.
- Used `count` and `list(string)` variables for multi-AZ subnet provisioning — adding a new AZ requires only updating the `availability_zones`, `public_subnet_cidrs`, and `private_subnet_cidrs` lists.
- Documented production upgrade paths: S3 remote state, EKS control plane logging, Cluster Autoscaler, and Spot instances with mixed instance types for 70% cost reduction.

---

## LinkedIn Project Description

Provisioned a production-ready Amazon EKS cluster using Terraform: VPC with public subnets (Load Balancers) and private subnets (worker nodes) tagged for Kubernetes, NAT Gateway for private egress, all IAM roles with correct policy attachments (EKS Cluster + Node Group), versioned EKS cluster (1.29) with private endpoint, and Managed Node Group with autoscaling config. Used `required_providers` with pinned AWS provider, typed variables, `count` for multi-AZ subnets, and outputs including auto-generated `kubeconfig_command`. Documented S3 remote state, Cluster Autoscaler, and Spot instance patterns.

---

## GitHub Project Description

Terraform EKS — Production-ready EKS cluster with full VPC (public/private subnets, NAT Gateway, proper K8s subnet tags), IAM roles from scratch, Managed Node Group with scaling config, pinned provider versions, typed variables, and descriptive outputs. Includes kubeconfig_command output and documented Cluster Autoscaler + Spot instance patterns.

---

## How to Explain in an Interview (30 Seconds)

"I provisioned Amazon EKS using Terraform. The key thing people get wrong is the networking — EKS needs public subnets tagged for external Load Balancers and private subnets tagged for internal Load Balancers, with worker nodes in the private subnets and a NAT Gateway for their outbound traffic. I also created all the required IAM roles from scratch — the cluster role and the node group role with three policies: worker node, CNI, and ECR read. I used a Managed Node Group with autoscaling config and `update_config.max_unavailable: 1` so node updates happen without downtime."

---

## Skills Demonstrated

- Amazon EKS (managed Kubernetes control plane)
- EKS VPC networking (public + private subnets, Kubernetes subnet tags)
- NAT Gateway (private subnet outbound internet for worker nodes)
- AWS IAM roles and policy attachments from scratch
- `AmazonEKSClusterPolicy`, `AmazonEKSWorkerNodePolicy`, `AmazonEKS_CNI_Policy`, `AmazonEC2ContainerRegistryReadOnly`
- EKS Managed Node Group (`scaling_config`, `update_config`)
- `count` meta-argument with `list(string)` for multi-AZ resources
- Kubernetes subnet tags (`elb`, `internal-elb`)
- `required_providers` with pinned provider version
- `required_version` Terraform constraint
- Typed variables with descriptions and defaults
- Descriptive outputs with `kubeconfig_command`
- `aws eks update-kubeconfig` (kubectl cluster authentication)
- Remote state with S3 + DynamoDB (production pattern)
- EKS Cluster Autoscaler (production pattern)
- Spot instances with mixed instance types (cost optimisation)
