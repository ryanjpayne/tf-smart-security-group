/*
This configuration will create a Security group then add rules of four different types:
CIDR-based ingress rules, SG-based ingress rules, Self-Referencing ingress rules and an egress rule

Attributes of each rule are passed in a list to the following modules:
tf-aws-modules/security-group
tf-aws-modules/cidr-source-sg-rule
tf-aws-modules/sg-source-sg-rule
tf-aws-modules/self-source-sg-rule
tf-aws-modules/egress-sg-rule
*/

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