output "alb_dns_name" {
  description = "Application Load Balancer DNS name — open this in your browser"
  value       = aws_lb.alb.dns_name
}

output "web_instance_ids" {
  description = "EC2 instance IDs for the Web Tier"
  value       = aws_instance.web[*].id
}

output "app_instance_ids" {
  description = "EC2 instance IDs for the App Tier"
  value       = aws_instance.app[*].id
}

output "rds_endpoint" {
  description = "RDS MySQL endpoint — accessible from App Tier only"
  value       = aws_db_instance.mysql.endpoint
}

output "vpc_id" {
  description = "VPC ID for the three-tier architecture"
  value       = aws_vpc.main.id
}
