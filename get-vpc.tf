/*
If configuring EC2 layers separate from existing VPC configuration
(see ryanjpayne/tf-basic-vpc/vpc-put-parameters.tf)
*/

data "aws_ssm_parameter" "vpc_id" {
name = "${var.env}_vpc_id"
}

data "aws_ssm_parameter" "vpc_cidr" {
name = "${var.env}_vpc_cidr"
}
