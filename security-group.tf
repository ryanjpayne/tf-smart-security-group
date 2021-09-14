/*
This configuration will create a Security group with three different rule types:
CIDR-based rules, SG-based rules and Self-Referencing rules
Individual rules for each type are defined in the respective locals blocks
Please complete parameters in locals block prior to use
This configuration relies on get-vpc.tf
*/

locals {
  name        = ""
  description = ""
  env         = "" # Enviroment tag and prefix to get-vpc.tf data sources

  # Rules that reference a CIDR range as the source 
  cidr-based-rules = [
    {cidr="0.0.0.0/0", protocol="tcp", from_port=0, to_port=0, description=""}
    # Add rows separated by commas
  ]

  # Rules that reference another Security group as the source
  sg-based-rules = [    
    {order=1, sg=aws_security_group.other-sg.id, protocol="tcp", from_port=0, to_port=0, description="Allows traffic from ${aws_security_group.other-sg.id}"}
    # Add rows with ascending 'order' value separated by commas
  ]

  # Rules that reference itself
  self-rules = [
    {protocol="tcp", from_port="0", to_port="0", description="Allows traffic within this Security Group"}
    # Add rows separated by commas
  ]
}

variable "env" {
  default = local.env
}

resource "aws_security_group" "new-sg" {
  name        = "${local.env}-${local.name}
  description = local.description 
  vpc_id      = data.aws_ssm_parameter.vpc_id.value

  # Ingress block for CIDR Based Rules
  dynamic "ingress" {
    for_each = [for i in local.cidr-based-rules: {
    description = i.description
    from_port   = i.from_port
    to_port     = i.to_port
    protocol    = i.protocol
    cidr_blocks = [i.cidr]
    }]
    content {
     description = ingress.value.description
     from_port   = ingress.value.from_port
     to_port     = ingress.value.to_port
     protocol    = ingress.value.protocol
     cidr_blocks = ingress.value.cidr_blocks
    }
  }

  # Ingress block for self-referencing rules
  dynamic "ingress" {
    for_each = [for f in local.self-rules: {
    description = f.description
    from_port   = f.from_port
    to_port     = f.to_port
    protocol    = f.protocol
    }]
    content {
     description = ingress.value.description
     from_port   = ingress.value.from_port
     to_port     = ingress.value.to_port
     protocol    = ingress.value.protocol
     self        = "true"
    }
  }

  tags = {
    Name        = local.name
    Environment = local.env
  }
}

# Resource block for SG based rules
resource "aws_security_group_rule" "new-sg-rules" {
  for_each = {for s in local.sg-based-rules : s.order => s}
  type                     = "ingress"
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  protocol                 = each.value.protocol
  description              = each.value.description
  security_group_id        = aws_security_group.new-sg.id  # Update this reference if you change the resource block identifier
  source_security_group_id = each.value.sg
}
