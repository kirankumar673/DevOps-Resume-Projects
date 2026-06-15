# Resume Points — Project 20: Terraform Modules

---

## Fresher

- Built reusable Terraform modules for VPC, EC2, ALB, and RDS — each module has its own `main.tf`, `variables.tf`, and `outputs.tf`, and is called from the root module.
- Eliminated Terraform code duplication by encapsulating resource configuration in modules — a change to the VPC module applies consistently everywhere it's used.
- Used module output chaining — the VPC module outputs `vpc_id` and `subnet_ids` which are passed as inputs to the EC2 and ALB modules.
- Ran `terraform init` to verify module discovery and `terraform validate` to confirm all module variable contracts are satisfied.

---

## Experienced DevOps Engineer

- Designed a modular Terraform architecture with clean separation of concerns: root module (`main.tf`) only calls child modules and wires their inputs/outputs — no direct resource definitions at root level.
- Implemented module output chaining: VPC module → outputs `vpc_id`, `public_subnet_ids`, `private_subnet_ids` → consumed as inputs by EC2, ALB, and RDS modules, enforcing correct dependency ordering without explicit `depends_on`.
- Applied Terraform module best practices: each module has typed variables with descriptions and defaults, meaningful outputs with descriptions, and no hardcoded values — making modules reusable across dev/staging/prod by changing only `terraform.tfvars`.
- Documented the path to versioned module publishing: local `./modules/` path → Git source `git::https://github.com/org/terraform-modules.git//vpc?ref=v1.0.0` → Terraform Registry.

---

## LinkedIn Project Description

Built a modular Terraform framework with reusable VPC, EC2, ALB, and RDS modules — each with its own `variables.tf`, `outputs.tf`, and `main.tf`. Root module wires all modules via output chaining (VPC outputs feed EC2/ALB/RDS inputs) with no hardcoded values. Applied module best practices: typed variables with descriptions, meaningful outputs, no direct resource definitions at root level. Documented versioned module publishing via Git sources and Terraform Registry for team-wide reuse.

---

## GitHub Project Description

Terraform Modules — Reusable VPC, EC2, ALB, RDS modules with typed variables, descriptive outputs, and output chaining. Root module wires all modules with no hardcoded values. Documents versioned module publishing (Git source, Terraform Registry) for enterprise IaC standardisation.

---

## How to Explain in an Interview (30 Seconds)

"I built reusable Terraform modules for VPC, EC2, ALB, and RDS. The key design is that the root module only calls child modules and wires their outputs to inputs — it has no direct resource definitions. So the VPC module outputs `vpc_id` and `subnet_ids`, which get passed as inputs to the EC2 and ALB modules. This means the modules naturally declare their dependencies without `depends_on`. Once you have modules like this, deploying a new environment is just creating a new `terraform.tfvars` — all the infrastructure logic stays in the modules."

---

## Skills Demonstrated

- Terraform module structure (`main.tf`, `variables.tf`, `outputs.tf`)
- Root module calling child modules (module blocks with `source`)
- Module output chaining (outputs as inputs between modules)
- Typed module variables with descriptions and defaults
- Descriptive module outputs
- No hardcoded values — all configuration via variables
- Multi-environment deployment via `terraform.tfvars`
- `terraform init` module discovery (`.terraform/modules/`)
- Local module source (`./modules/vpc`)
- Versioned Git module source (`git::https://...?ref=v1.0.0`)
- Terraform Registry module publishing (production pattern)
- DRY infrastructure (Don't Repeat Yourself)
