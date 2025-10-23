# =====================================================================
# 🚫 WRONG PRACTICES — TERRAFORM STATE HANDLING
# =====================================================================

terraform {
  required_version = ">= 1.0.0"

  backend "local" {
    path = "./terraform.tfstate"
  }
}

provider "aws" {
  region     = "us-east-1"
  access_key = "FAKEACCESSKEY"
  secret_key = "SuperSecretKey"
}

resource "aws_s3_bucket" "demo_bucket" {
  bucket = "bad-state-demo-bucket"
  acl    = "private"
}


resource "aws_instance" "console_instance" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "t2.micro"
  tags = {
    Name = "console-instance"
  }
}

# ❌ Manual modification of the local state
# (e.g., editing terraform.tfstate file directly)
# or using a fake import:
# terraform import aws_instance.console_instance i-1234567890fake
# but resource config doesn’t match, leading to drift.

resource "aws_ssm_parameter" "db_password" {
  name  = "/app/db_password"
  type  = "SecureString"
  value = "PlainTextPassword123"  # Sensitive value stored in state file!
}
