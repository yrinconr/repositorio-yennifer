resource "aws_vpc" "vpc_crud" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true

    tags = {
        Name = "Vpc-crud"
    }
}

resource "aws_subnet" "subnet_crud_1" {
    vpc_id = aws_vpc.vpc_crud.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1c"

    tags = {
      Name = "subnet_crud_1"
    }
}

resource "aws_subnet" "subnet_crud_2" {
    vpc_id = aws_vpc.vpc_crud.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1e"

    tags = {
      Name = "subnet_crud_2"
    }
}

resource "aws_db_subnet_group" "db_crud_subnet_group" {
  name       = "my-subnet-group-vpc"
  subnet_ids = [aws_subnet.subnet_crud_1.id, aws_subnet.subnet_crud_2.id]
  description = "Subnet group for VPC"
}

resource "aws_internet_gateway" "gw_crud" {
     vpc_id = aws_vpc.vpc_crud.id

     tags = {
       Name = "Gw_crud"
     }
  
}
resource "aws_route_table" "rt_default_crud" {
    vpc_id = aws_vpc.vpc_crud.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw_crud.id
  }

  tags = {
    Name = "rt_default_crud"
  }
}

resource "aws_route_table_association" "a_rt_default_crud_subnet_crud_1" {
  subnet_id = aws_subnet.subnet_crud_1.id
  route_table_id = aws_route_table.rt_default_crud.id
}

resource "aws_security_group" "rds_sg" {
        name = "rds_security_group"
        description = "Security group for RDS instance"
        vpc_id = aws_vpc.vpc_crud.id
 
        ingress {
            from_port   = 80
            to_port     = 80
            protocol    = "tcp"
            cidr_blocks = ["0.0.0.0/0"]

        }

        ingress {
            from_port = 3306
            to_port = 3306
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
            description = "Permite acceso puerto 3306"
        }

        ingress {
            from_port = 22
            to_port = 22
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
            description = "Permite acceso puerto 22"

        }

        egress {
            from_port = 0
            to_port = 0
            protocol = "-1"
            cidr_blocks = ["0.0.0.0/0"]
            description = "permite salida a cualquier ip y puerto"
        }
    }
