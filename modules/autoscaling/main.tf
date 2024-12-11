# Fetch latest AMI
data "aws_ami" "latest" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
}

resource "aws_launch_template" "web" {
  name_prefix = "${var.name}-"
  instance_type = var.instance_type
  image_id = data.aws_ami.latest.id
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = var.security_group_ids
  }
  user_data = base64encode(
              <<-EOF
              #!/bin/bash
              yum install -y nginx
              systemctl start nginx
              EOF
              )
}

resource "aws_autoscaling_group" "web_asg" {
  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }
  vpc_zone_identifier = var.subnet_ids
  desired_capacity    = var.desired_capacity
  min_size            = var.min_size
  max_size            = var.max_size
}

output "asg_name" {
  value = aws_autoscaling_group.web_asg.name
}
