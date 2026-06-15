# Resume Points — Project 11: Terraform EC2 + Nginx Automation

---

## Fresher

- Automated EC2 provisioning and Nginx web server configuration using Terraform with a `user_data` bootstrap script — zero manual steps required.
- Wrote a production-grade `user-data.sh` with `set -e` for fail-fast error handling and output logging to `/var/log/user-data.log` for debugging.
- Deployed a full HTML5 website automatically to `/var/www/html/` on EC2 boot using a bash heredoc in the user-data script.
- Used `terraform output -raw public_ip` to dynamically access deployed infrastructure without manual AWS Console lookups.

---

## Experienced DevOps Engineer

- Automated end-to-end web server provisioning using Terraform `user_data` — Terraform creates the EC2 instance and the bootstrap script installs Nginx, deploys the website, and configures auto-start with `systemctl enable` in a single `terraform apply`.
- Implemented production-grade bash scripting in user-data: `set -e` for fail-fast behaviour, `exec > /var/log/user-data.log 2>&1` for full debug logging, and `DEBIAN_FRONTEND=noninteractive` to prevent apt from hanging on prompts.
- Used typed Terraform variables (`variables.tf`), tagged all resources for cost tracking, added a Security Group `egress` rule, and restricted SSH to a configurable `ssh_allowed_cidr` variable instead of `0.0.0.0/0`.
- Documented upgrade paths using Ansible or AWS Systems Manager as alternatives to user-data for complex, idempotent server configuration at scale.

---

## LinkedIn Project Description

Automated full EC2 web server provisioning using Terraform and user-data scripting — single `terraform apply` creates the instance and automatically installs Nginx, deploys an HTML5 website, and enables auto-start. Implemented production-grade bash with `set -e`, debug logging to `/var/log/user-data.log`, and `DEBIAN_FRONTEND=noninteractive`. Used typed Terraform variables, resource tags, egress rules, and SSH IP restriction via configurable `ssh_allowed_cidr` variable. Documented remote state and Ansible/SSM upgrade paths.

---

## GitHub Project Description

Terraform EC2 Nginx Automation — Zero-touch web server provisioning: Terraform creates EC2 + Security Group, `user-data.sh` installs Nginx and deploys website on boot. Production-grade bash (`set -e`, logging, DEBIAN_FRONTEND), typed variables, tagged resources, SSH restriction, and egress rules.

---

## How to Explain in an Interview (30 Seconds)

"I used Terraform to fully automate EC2 web server provisioning. One `terraform apply` creates the Security Group and EC2 instance, and a `user_data` script runs automatically on first boot — it installs Nginx, enables auto-start, and deploys the website. I made the script production-grade with `set -e` so it stops on any error, and logs everything to `/var/log/user-data.log` so I can SSH in and debug if something goes wrong. I also restricted SSH to a configurable IP variable instead of `0.0.0.0/0`, added egress rules, and tagged all resources."

---

## Skills Demonstrated

- Terraform `user_data` with `file()` function (EC2 bootstrap automation)
- Bash scripting (`set -e`, heredoc `<<EOF`, logging with `exec >`)
- `DEBIAN_FRONTEND=noninteractive` (non-interactive apt installs)
- `/var/log/user-data.log` (user-data debugging)
- `systemctl enable` (Nginx auto-start on reboot)
- HTML5 deployment via bash heredoc
- Terraform typed variables (`type`, `description`, `default`)
- AWS Security Group (ingress + egress, SSH IP restriction)
- Resource tagging (`Name`, `Project`)
- `terraform output -raw` (shell-consumable outputs)
- Remote state with S3 + DynamoDB (production pattern)
- Ansible / AWS Systems Manager (user-data alternatives)
