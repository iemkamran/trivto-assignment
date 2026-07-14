#Security Group for Interface Endpoints
resource "aws_security_group" "vpce" {

  name_prefix = "${local.name}-vpce"

  description = "Security Group for VPC Interface Endpoints"

  vpc_id = module.vpc.vpc_id

  ingress {

    from_port = 443
    to_port = 443
    protocol = "tcp"

    cidr_blocks = [var.cidr]

  }

  egress {

    from_port = 0
    to_port = 0
    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = local.common_tags

}

#S3 Gateway Endpoint
resource "aws_vpc_endpoint" "s3" {

  vpc_id = module.vpc.vpc_id

  service_name = "com.amazonaws.${data.aws_region.current.name}.s3"

  vpc_endpoint_type = "Gateway"

  route_table_ids = module.vpc.private_route_table_ids

  tags = local.common_tags

}

#Need region dynamically.

data "aws_region" "current" {}


#ECR API

resource "aws_vpc_endpoint" "ecr_api" {

  vpc_id = module.vpc.vpc_id

  service_name = "com.amazonaws.${data.aws_region.current.name}.ecr.api"

  vpc_endpoint_type = "Interface"

  subnet_ids = module.vpc.private_subnets

  security_group_ids = [

    aws_security_group.vpce.id

  ]

  private_dns_enabled = true

}

#ECR DKR

resource "aws_vpc_endpoint" "ecr_dkr" {

  vpc_id = module.vpc.vpc_id

  service_name = "com.amazonaws.${data.aws_region.current.name}.ecr.dkr"

  subnet_ids = module.vpc.private_subnets

  security_group_ids = [

    aws_security_group.vpce.id

  ]

  private_dns_enabled = true

  vpc_endpoint_type = "Interface"

}

#STS Endpoint

resource "aws_vpc_endpoint" "sts" {

  vpc_id = module.vpc.vpc_id

  service_name = "com.amazonaws.${data.aws_region.current.name}.sts"

  subnet_ids = module.vpc.private_subnets

  security_group_ids = [

    aws_security_group.vpce.id

  ]

  private_dns_enabled = true

  vpc_endpoint_type = "Interface"

}


#CloudWatch Logs

resource "aws_vpc_endpoint" "logs" {

  vpc_id = module.vpc.vpc_id

  service_name = "com.amazonaws.${data.aws_region.current.name}.logs"

  subnet_ids = module.vpc.private_subnets

  security_group_ids = [

    aws_security_group.vpce.id

  ]

  private_dns_enabled = true

  vpc_endpoint_type = "Interface"

}