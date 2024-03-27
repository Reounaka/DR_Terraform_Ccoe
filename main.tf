# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

terraform {
  required_version = ">= 0.12"
}

# First account owns the transit gateway and accepts the VPC attachment.
provider "aws" {
  alias = "first"

  region     = var.aws_region
  access_key = var.aws_network_account_key
  secret_key = var.aws_network_account_secret_key
}

# Second account owns the VPC and creates the VPC attachment.
provider "aws" {
  alias = "second"

  region     = var.aws_region
  access_key = var.aws_backup_account_access_key
  secret_key = var.aws_backup_account_secret_key
}

# Third account for creating another attachment
provider "aws" {
  alias = "third"

  region     = var.aws_region
  access_key = var.aws_production_account_access_key
  secret_key = var.aws_production_account_secret_key
}

data "aws_availability_zones" "available" {
  provider = aws.second

  state = "available"
}

data "aws_caller_identity" "second" {
  provider = aws.second
}

data "aws_caller_identity" "third" {
  provider = aws.third
}

resource "aws_ram_resource_share" "example" {
  provider = aws.first
  allow_external_principals = true

  name = "terraform-example"

  tags = {
    Name = "terraform-example"
  }
}

# Share the transit gateway...
resource "aws_ram_resource_association" "example" {
  provider = aws.first

  resource_arn       = var.transit_gateway_arn  # Use existing transit gateway ARN
  resource_share_arn = aws_ram_resource_share.example.id
}

# ...with the second account.
resource "aws_ram_principal_association" "second" {
  provider = aws.first

  principal          = data.aws_caller_identity.second.account_id
  resource_share_arn = aws_ram_resource_share.example.id
}

# ...with the third account.
resource "aws_ram_principal_association" "third" {
  provider = aws.first

  principal          = data.aws_caller_identity.third.account_id
  resource_share_arn = aws_ram_resource_share.example.id
}

# Accept the resource share in the second account.
resource "aws_ram_resource_share_accepter" "second" {
  provider = aws.second

  share_arn = aws_ram_resource_share.example.arn
}

# Accept the resource share in the third account.
resource "aws_ram_resource_share_accepter" "third" {
  provider = aws.third

  share_arn = aws_ram_resource_share.example.arn
}

data "aws_vpc" "second" {
  provider = aws.second

  id = var.backup_account_vpc_id
}

data "aws_subnet" "second" {
  provider   = aws.second
  id         = var.backup_account_subnet_id  # Use subnet ID from variable
}

data "aws_vpc" "third" {
  provider = aws.third

  id = var.production_account_vpc_id
}

data "aws_subnet" "third" {
  provider   = aws.third
  id         = var.production_account_subnet_id  # Use subnet ID from variable

}

# Create the VPC attachment in the second account...
resource "aws_ec2_transit_gateway_vpc_attachment" "second" {
  provider = aws.second

  depends_on = [
    aws_ram_principal_association.second,
    aws_ram_resource_association.example,
    aws_ram_resource_share_accepter.second
  ]

  subnet_ids         = [data.aws_subnet.second.id]
  transit_gateway_id = var.transit_gateway_id  # Use existing transit gateway ID
  vpc_id             = data.aws_vpc.second.id

  tags = {
    Name = "terraform-example"
    Side = "Creator"
  }
}

# Create the VPC attachment in the third account...
resource "aws_ec2_transit_gateway_vpc_attachment" "third" {
  provider = aws.third

  depends_on = [
    aws_ram_principal_association.third,
    aws_ram_resource_association.example,
    aws_ram_resource_share_accepter.third
  ]

  subnet_ids         = [data.aws_subnet.third.id]
  transit_gateway_id = var.transit_gateway_id  # Use existing transit gateway ID
  vpc_id             = data.aws_vpc.third.id

  tags = {
    Name = "terraform-example"
    Side = "Creator"
  }
}



