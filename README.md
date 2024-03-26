# Terraform Configuration for AWS Networking Setup

This repository contains Terraform configurations to set up networking resources in AWS across multiple accounts. The configurations include setting up networking resources such as VPCs, subnets, route tables, and connecting multiple AWS accounts using a transit gateway.
## Prerequisites

Before you begin, make sure you have:


- AWS Credentials: You need valid AWS credentials with appropriate permissions to create networking resources in AWS accounts (Network,Backup,Production).
- Terraform Installed: Ensure Terraform is installed on your local machine. You can download Terraform from the official website and follow the installation instructions.
- VPC and Subnets for Backup & Production accounts.
- Transit Gateway ARN + ID
- AWS CLI (Optional): Having AWS CLI installed can be helpful for configuring AWS credentials and verifying resources.

## Configuration

### Editing Configuration Files

There are two files that require editing:

#### 1. `terraform.tfvars`

In this file, you should provide:

- **AWS Access and Secret Keys**: Add the access and secret keys for three AWS accounts: network, backup, and production.
- **Region**: Specify the AWS region where you want to deploy the resources. The default is `tlv`.

Example of `terraform.tfvars`:

```
# AWS access and secret keys for three accounts
aws_network_account_key = "YOUR_NETWORK_ACCOUNT_ACCESS_KEY"
aws_network_account_secret_key = "YOUR_NETWORK_ACCOUNT_SECRET_KEY"
aws_backup_account_access_key = "YOUR_BACKUP_ACCOUNT_ACCESS_KEY"
aws_backup_account_secret_key = "YOUR_BACKUP_ACCOUNT_SECRET_KEY"
aws_production_account_access_key = "YOUR_PRODUCTION_ACCOUNT_ACCESS_KEY"
aws_production_account_secret_key = "YOUR_PRODUCTION_ACCOUNT_SECRET_KEY"

# Specify the AWS region
aws_region = "il-central-1"
```

#### 2. `variables.var`

In this file, you should specify:

- **VPCs and Subnets ID**: Add the IDs of existing VPCs and subnets in the backup and production accounts.
- **Transit Gateway ARN and ID**: Add the ARN and ID of the existing transit gateway in the network account.
Example of variables.tf:

```
variable "transit_gateway_arn" {
  description = "The ARN of the existing transit gateway."
  type        = string
  default     = "YOUR_TRANSIT_GATEWAY_ARN_HERE"
}

variable "transit_gateway_id" {
  description = "The ID of the existing transit gateway."
  type        = string
  default     = "YOUR_TRANSIT_GATEWAY_ID_HERE"
}

variable "backup_account_vpc_id" {
  description = "ID of the existing VPC in the backup account"
  default     = "YOUR_BACKUP_VPC_ID_HERE"
}

variable "backup_account_subnet_id" {
  description = "ID of the existing subnet in the backup account"
  default     = "YOUR_BACKUP_SUBNET_ID_HERE"
}

variable "production_account_vpc_id" {
  description = "ID of the existing VPC in the production account"
  default     = "YOUR_PRODUCTION_VPC_ID_HERE"
}

variable "production_account_subnet_id" {
  description = "ID of the existing subnet in the production account"
  default     = "YOUR_PRODUCTION_SUBNET_ID_HERE"
}
```
#### 3. Initializing Terraform**
Run the following command to initialize Terraform:
```
terraform init
```

#### 4. Reviewing and Applying Changes**
Review the Terraform plan to ensure it will create the desired resources:
```
terraform plan
```
If everything looks good, apply the changes:
```
terraform apply
```
## Customization

You may need to customize the Terraform files further based on your specific requirements. Refer to the variables.tf file for configurable options.

## Cleaning Up

To destroy the resources created by Terraform, run:
```
terraform destroy
```
## Contributing

If you find any issues or have suggestions for improvement, feel free to open an issue or create a pull request.

## License

This project is licensed under the MPL-2.0 License. See the LICENSE file for details.
