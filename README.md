# Terraform Configuration for AWS Networking Setup

This repository contains Terraform configurations to set up networking resources in AWS across multiple accounts. This README will guide you through configuring and using these Terraform files.

## Prerequisites

Before you begin, make sure you have:

- [Terraform](https://www.terraform.io/downloads.html) installed.
- AWS credentials with sufficient permissions (for 3 accounts: Network,Backup,Production).
- VPC and Subnets for Backup & Production accounts.
- Transit Gateway ARN + ID

## Configuration

### Editing Configuration Files

There are two files that require editing:

#### 1. `terraform.tfvars`

In this file, you should provide:

- **AWS Access and Secret Keys**: Add the access and secret keys for three AWS accounts: network, backup, and production.
- **Region**: Specify the AWS region where you want to deploy the resources. The default is `tlv`.

Example of `terraform.tfvars`:

```hcl
# AWS access and secret keys for three accounts
aws_network_account_key = "YOUR_NETWORK_ACCOUNT_ACCESS_KEY"
aws_network_account_secret_key = "YOUR_NETWORK_ACCOUNT_SECRET_KEY"
aws_backup_account_access_key = "YOUR_BACKUP_ACCOUNT_ACCESS_KEY"
aws_backup_account_secret_key = "YOUR_BACKUP_ACCOUNT_SECRET_KEY"
aws_production_account_access_key = "YOUR_PRODUCTION_ACCOUNT_ACCESS_KEY"
aws_production_account_secret_key = "YOUR_PRODUCTION_ACCOUNT_SECRET_KEY"

# Specify the AWS region
aws_region = "il-central-1"


