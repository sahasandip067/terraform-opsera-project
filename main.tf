# VPC Module
module "vpc" {
  source               = "./modules/vpc"

  cidr_block           = "10.0.0.0/16"
  subnet_cidr_blocks   = ["10.0.1.0/24", "10.0.2.0/24"]
  availability_zones   = ["us-east-2a", "us-east-2b"]
  name                 = "web-app"
}

# Security Group Module
module "security_groups" {
  source          = "./modules/security_groups"

  vpc_id            = module.vpc.vpc_id
  name            = "web-app"
  allowed_ssh_cidr = "203.0.113.0/24" # Replace with your CIDR
}

# Auto Scaling Module
module "autoscaling" {
  source            = "./modules/autoscaling"
  
  name              = "web-app"
  instance_type     = var.environment == "prod" ? "t3.medium" : "t2.micro"
  security_group_ids = [module.security_groups.web_sg_id, module.security_groups.ssh_sg_id]
  subnet_ids        = module.vpc.subnet_ids
  desired_capacity  = 2
  min_size          = 1
  max_size          = 3
}

# Load Balancer
resource "aws_lb" "example" {
  name               = "example-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.security_groups.web_sg_id]
  subnets            = module.vpc.subnet_ids
}

resource "aws_lb_target_group" "tg" {
  name     = "myTG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    path = "/"
    port = "traffic-port"
  }
}

resource "aws_lb_listener" "example" {
  load_balancer_arn = aws_lb.example.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
