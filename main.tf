# main.tf - Monolithic and Brittle Configuration

# 1. Hardcoded Provider Configuration
provider "aws" {
  region = "us-east-1"
  # Hardcoding credentials is a major security failure
  access_key = "AKIAJ4BTESTKEYFORGET"
  secret_key = "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" 
}

# 2. Hardcoded Resource Names and Values
resource "aws_vpc" "bad_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name        = "project-X-production-vpc" # Inflexible environment name
    Environment = "prod"
    Owner       = "alice"
  }
}

# 3. Using depends_on for an Implicit Dependency
resource "aws_subnet" "bad_subnet" {
  cidr_block        = "10.0.1.0/24"
  vpc_id            = aws_vpc.bad_vpc.id # Creates an implicit dependency
  availability_zone = "us-east-1a"
  
  # UNNECESSARY: The dependency is already implicit above.
  depends_on = [aws_vpc.bad_vpc] 
  
  tags = {
    Name = "my-public-subnet"
  }
}

# 4. Conditional Logic with Clumsy Referencing
resource "aws_db_instance" "bad_database" {
  # Inflexible, using a ternary expression to conditionally deploy a single resource
  count             = var.deploy_db ? 1 : 0 
  
  allocated_storage = 20
  engine            = "mysql"
  engine_version    = "8.0.35"
  instance_class    = "db.t3.micro"
  
  # Hardcoding secrets directly - DO NOT DO THIS!
  username          = "admin"
  password          = "WeakPass2025" 
  
  skip_final_snapshot = true
  
  # Referencing a resource that might not exist if count=0
  db_subnet_group_name = aws_subnet.bad_subnet.id
}
