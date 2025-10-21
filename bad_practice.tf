# Example of WRONG Terraform practices
provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAFAKEACCESSKEY"
  secret_key = "my-plaintext-secret"
}

# Hardcoded AMI ID and instance details
resource "aws_instance" "bad_example" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "t2.micro"
  key_name      = "my-plain-key"

  # No tags for resource identification
  # No security group assigned (uses default SG)
  # User data with sensitive info
  user_data = <<EOF
#!/bin/bash
echo "DB_PASSWORD=SuperSecret123" >> /etc/environment
EOF

  # Insecure root volume configuration
  root_block_device {
    volume_size = 8
    encrypted   = false
  }

  # Public IP enabled for private instance
  associate_public_ip_address = true
}

# Security Group with wide-open ingress
resource "aws_security_group" "bad_sg" {
  name        = "insecure-sg"
  description = "Allow all inbound traffic"
  vpc_id      = "vpc-12345678"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# S3 bucket with no encryption, versioning, or logging
resource "aws_s3_bucket" "bad_bucket" {
  bucket = "insecure-bucket-example"
  acl    = "public-read"
}

# IAM user with inline policy and hardcoded creds
resource "aws_iam_user" "bad_user" {
  name = "bad-user"
  force_destroy = true
}

resource "aws_iam_access_key" "bad_key" {
  user = aws_iam_user.bad_user.name
}

resource "aws_iam_user_policy" "bad_policy" {
  name = "bad-policy"
  user = aws_iam_user.bad_user.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "*",
      "Resource": "*"
    }
  ]
}
EOF
}

# Unused variables, poor naming convention, and missing outputs
variable "InstanceType" {
  default = "t2.micro"
}

# Output referencing undeclared resource
output "instance_ip" {
  value = aws_instance.nonexistent.public_ip
}
