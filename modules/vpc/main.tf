resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  tags = {
    Name = "${var.name}-vpc"
  }
}

resource "aws_subnet" "subnets" {
  count = 2
  vpc_id     = aws_vpc.main.id
  cidr_block = element(var.subnet_cidr_blocks, count.index)
  availability_zone = element(var.availability_zones, count.index)
  tags = {
    Name = "${var.name}-subnet-${count.index}"
  }
}

resource "aws_internet_gateway" "myIgw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.name}-igw"
  }
}

resource "aws_route_table" "myRt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myIgw.id
  }

  tags = {
    Name = "${var.name}-rt"
  }
}

resource "aws_route_table_association" "rta" {
  count          = 2
  subnet_id      = aws_subnet.subnets[count.index].id
  route_table_id = aws_route_table.myRt.id
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_ids" {
  value = aws_subnet.subnets[*].id
}
