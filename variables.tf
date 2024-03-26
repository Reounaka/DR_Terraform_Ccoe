# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "aws_network_account_key" {}

variable "aws_network_account_secret_key" {}

variable "aws_backup_account_access_key" {}

variable "aws_backup_account_secret_key" {}

variable "aws_production_account_access_key" {}

variable "aws_production_account_secret_key" {}

variable "aws_region" {
    default = ""
}

variable "transit_gateway_arn" {
  description = "The ARN of the existing transit gateway."
  type        = string
  default = ""
}

variable "transit_gateway_id" {
  description = "The ID of the existing transit gateway."
  type        = string
  default = ""
}

variable "backup_account_vpc_id" {
  description = "ID of the existing VPC in the second account"
  default = ""
}

variable "backup_account_subnet_id" {
  description = "ID of the existing subnet in the second account"
  default = ""
}

variable "production_account_vpc_id" {
  description = "ID of the existing VPC in the third account"
  default = ""
}

variable "production_account_subnet_id" {
  description = "ID of the existing subnet in the third account"
  default = ""
  }