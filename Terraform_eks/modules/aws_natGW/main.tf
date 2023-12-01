resource "aws_nat_gateway" "example" {
  allocation_id = var.elasticIP_id
  subnet_id     = var.subnet_id
  tags = var.tags
}

