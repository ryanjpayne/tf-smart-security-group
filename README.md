# Smart Security Group Configuration
Configure and manage AWS Security Groups and rules.  
  
## Required Modules  
- tf-aws-modules/security-group  
  
## Optional Modules  
- tf-aws-modules/cidr-source-sg-rule  
- tf-aws-modules/egress-sg-rule  
- tf-aws-modules/self-source-sg-rule  
- tf-aws-modules/sg-source-sg-rule  
  
## Dependencies  
The tf-basic-vpc configuration manages the following dependencies:  
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
**cidr-source-rules** - (Optional) List ingress security group rules in which the source is a CIDR range.  
**sg-source-rules** - (Optional) List ingress security group rules in which the source is another Security Group.  
**self-source-rules** - (Optional) List ingress security group rules in which the source is itself. (for cluster of like instances all communicate with eachother on a given port)  
**egress-rules** - (Optional) List egress security group rules.  
  
## Example foo-sg.tf  

/*
# Create a security group
module "my-instance-sg1" {
  source = "../../modules/security-group"

  name         = "my-sg1"
  description  = ""
  environment  = ""
}

# Create an ingress security group rule in which the source is a CIDR range
module "my-sg1-cidr-source-rule" {
  source = "../../modules/cidr-source-sg-rule"
  sg-id  = module.my-instance-sg1.sg-id

  cidr-source-rules = [
    {index=1, cidr=["0.0.0.0/0"], protocol="tcp", from_port=1, to_port=1, description="1 - Description"},
    {index=2, cidr=["0.0.0.0/0"], protocol="tcp", from_port=1, to_port=1, description="2 - Description"}
  ]
}

# Create an ingress security group rule in which the source is another security group 
module "my-sg1-sg-source-rule" {
  source = "../../modules/sg-source-sg-rule"
  sg-id  = module.my-instance-sg1.sg-id

  sg-source-rules = [
    {index=1, sg=module.my-instance-sg2.sg-id, protocol="tcp", from_port=1, to_port=1, description="1 - Descritpion"}
  ]
}

# Create an ingress security group rule in which the source is this security group
# This is useful for clusters of instances that share a security group and must communicate with eachother
module "my-sg1-self-source-rule" {
  source = "../../modules/self-source-sg-rule"
  sg-id  = module.my-instance-sg1.sg-id

  self-source-rules = [
    {index=1, protocol="tcp", from_port=1, to_port=1, description="1 - Description"}
  ]
}

# Create an egress security group rule
module "my-sg1-egress-rule" {
  source = "../../modules/egress-sg-rule"
  sg-id  = module.my-instance-sg1.sg-id

  egress-rules = [
    {index=1, cidr=["0.0.0.0/0"], protocol="all", from_port=0, to_port=65535, description="1 - Allow all egress traffic."}
  ]
}
*/
