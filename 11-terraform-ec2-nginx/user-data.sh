#!/bin/bash
# Exit immediately if any command fails
set -e

# Log all output for debugging
exec > /var/log/user-data.log 2>&1

echo "=== Starting user-data script ==="

# Update packages (non-interactive to avoid prompts)
export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get upgrade -y

# Install Nginx
apt-get install -y nginx

# Enable and start Nginx
systemctl enable nginx
systemctl start nginx

# Deploy website
cat > /var/www/html/index.html <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Terraform EC2</title>
  <style>
    body { text-align: center; margin-top: 100px; font-family: Arial, sans-serif; }
  </style>
</head>
<body>
  <h1>Hello From Terraform</h1>
  <p>EC2 instance provisioned and configured automatically via Terraform user-data</p>
</body>
</html>
EOF

echo "=== user-data script completed successfully ==="
