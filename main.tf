# Intentionally wrong Terraform configuration file

# SYNTAX ERROR 1: Missing double quotes for string interpolation
variable "vm_name" {
  default = "test-vm"
  type    = string
}

resource "azurerm_resource_group" rg {
  # This line has incorrect string interpolation syntax (missing quotes)
  name     = ${var.vm_name}-rg
  location = "eastus"
}

# SYNTAX ERROR 2: Invalid resource type or typo
resource "azurerm_invalid_resource_type" "example" {
  name                = "invalid-resource"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

# LOGIC ERROR 1: Missing required provider configuration
# The 'aws' provider is used below but not defined in a 'provider' block
resource "aws_instance" "web" {
  ami           = "ami-0abcdef1234567890" # Example AMI ID, likely won't work in reality
  instance_type = "t2.micro"
}

# LOGIC ERROR 2: Invalid index access (accessing an element out of bounds)
variable "subnet_ids" {
  type    = list(string)
  default = ["subnet-abc", "subnet-def"]
}

output "invalid_subnet_id" {
  # This will cause an "Invalid index" error because index 2 doesn't exist
  value = var.subnet_ids[2]
}

# LOGIC ERROR 3: Cyclic Dependency (if two resources depend on each other)
# This example creates a conceptual cycle, in a real scenario this might involve
# two network security groups referencing each other's IDs in rules.
/*
resource "aws_security_group" "sg_a" {
  name = "security_group_a"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    # Depends on sg_b
    security_groups = [aws_security_group.sg_b.id]
  }
}

resource "aws_security_group" "sg_b" {
  name = "security_group_b"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    # Depends on sg_a
    security_groups = [aws_security_group.sg_a.id]
  }
}
*/
