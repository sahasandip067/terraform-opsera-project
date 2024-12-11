output "load_balancer_dns" {
  description = "DNS name of the Load Balancer"
  value       = aws_lb.example.dns_name
}
