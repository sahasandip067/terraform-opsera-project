resource "aws_security_group" "web_sg" {
  vpc_id     = var.vpc_id
  name_prefix = "${var.name}-web-"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ssh_sg" {
  vpc_id     = var.vpc_id
  name_prefix = "${var.name}-ssh-"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "web_sg_id" {
  value = aws_security_group.web_sg.id
}

output "ssh_sg_id" {
  value = aws_security_group.ssh_sg.id
}
