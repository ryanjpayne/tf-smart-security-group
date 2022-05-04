# CDM Prestaging Security Configuration
Configure and manage AWS Security Groups and rules.  
  
## Required Modules  
- $DBOPS/CDM-Terraform/modules/security-group  
<<<<<<< HEAD
=======
  
## Optional Modules  
>>>>>>> 87be709e0a45374c5beeaa640cdf19ad85605a04
- $DBOPS/CDM-Terraform/modules/cidr-source-sg-rule  
- $DBOPS/CDM-Terraform/modules/egress-sg-rule  
- $DBOPS/CDM-Terraform/modules/self-source-sg-rule  
- $DBOPS/CDM-Terraform/modules/sg-source-sg-rule  
  
## Dependencies  
The $DBOPS/CDM-Terraform/prestaging/network configuration manages the following dependencies:  
- VPC  
- ${var.env}_vpc_id parameter  
- ${var.env}_vpc_cidr parameter  
  
## Structure  
**main.tf** - Defines Terraform settings such as provider and backend.  
**foo-sg.tf** - Defines values, such as rule attributes, to pass to modules. Each Security Group requires this file.  
  
## Inputs  
**name** - (Required) The name of the security group.  
**description** - (Required) The description of the security group.  
**environment** - (Required) The environment tag to get vpcId value and tag security group.  
<<<<<<< HEAD
=======
**cidr-source-rules** - (Optional) List ingress security group rules in which the source is a CIDR range.  
**sg-source-rules** - (Optional) List ingress security group rules in which the source is another Security Group.  
**self-source-rules** - (Optional) List ingress security group rules in which the source is itself. (for cluster of like instances all communicate with eachother on a given port)  
**egress-rules** - (Optional) List egress security group rules.  
>>>>>>> 87be709e0a45374c5beeaa640cdf19ad85605a04
  
## Example foo-sg.tf  
  
```
# Create a security group
module "foo-security-group" {
  source = "../../modules/security-group"

  name         = "example-sg"
  description  = "Example description of the Security Group"
  environment  = "prestaging"
}

<<<<<<< HEAD
# Create local to apply Security Group output ID to each rule module
locals {
    sg-id = module.foo-security-group.sg-id
}

# Create an ingress security group rule in which the source is a CIDR range 
module "foo-cidr-source-rule" {
  source = "../../modules/cidr-source-sg-rule"
  sg-id  = local.sg-id
=======
# Create list of ingress security group rules in which the source is a CIDR range 
module "foo-cidr-source-rule" {
  source = "../../modules/cidr-source-sg-rule"
  sg-id  = module.foo-security-group.sg-id
>>>>>>> 87be709e0a45374c5beeaa640cdf19ad85605a04

  cidr-source-rules = [
    {index=1, cidr=["0.0.0.0/0"], protocol="tcp", from_port=0, to_port=65535, description=""},
    {index=2, cidr=["0.0.0.0/0"], protocol="tcp", from_port=0, to_port=65535, description=""}
  ]
}

<<<<<<< HEAD
# Create an ingress security group rule in which the source is another security group 
module "foo-sg-source-rule" {
  source = "../../modules/sg-source-sg-rule"
  sg-id  = local.sg-id
=======
# Create list of ingress security group rules in which the source is another security group 
module "foo-sg-source-rule" {
  source = "../../modules/sg-source-sg-rule"
  sg-id  = module.foo-security-group.sg-id
>>>>>>> 87be709e0a45374c5beeaa640cdf19ad85605a04

  sg-source-rules = [
    # If sg refers to a group created by this configruation, it must refer to the sg-id output of that module eg: module.bar-security-group.sg-id
    # Otherwise, sg may equal an AWS Security Group ID of type string (wrapped in quotes)
    {index=1, sg=module.bar-security-group.sg-id, protocol="tcp", from_port="0", to_port="65535", description=""},
    {index=2, sg="sg-1234567890", protocol="tcp", from_port="0", to_port="65535", description=""}    
  ]
}

<<<<<<< HEAD
# Create an ingress security group rule in which the source is the same security group 
module "foo-self-source-rule" {
  source = "../../modules/self-source-sg-rule"
  sg-id  = local.sg-id
=======
# Create list of ingress security group rules in which the source is this Security Group
module "foo-self-source-rule" {
  source = "../../modules/self-source-sg-rule"
  sg-id  = module.foo-security-group.sg-id
>>>>>>> 87be709e0a45374c5beeaa640cdf19ad85605a04

  self-source-rules = [
    {index=1, protocol="tcp", from_port="0", to_port="65535", description=""},
    {index=2, protocol="tcp", from_port="0", to_port="65535", description=""}
  ]
}

<<<<<<< HEAD
# Create an egress security group rule
module "foo-egress-rule" {
  source = "../../modules/egress-sg-rule"
  sg-id  = local.sg-id
=======
# Create list of egress security group rules
module "foo-egress-rule" {
  source = "../../modules/egress-sg-rule"
  sg-id  = module.foo-security-group.sg-id
>>>>>>> 87be709e0a45374c5beeaa640cdf19ad85605a04

  egress-rules = [
    {index=1, cidr=["0.0.0.0/0"], protocol="all", from_port="0", to_port="65535", description="Allow all egress traffic."}
  ]
}
```