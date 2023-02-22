module "ssh_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "ssh-new"
  description = "Security group for user-service with custom ports open within VPC, and PostgreSQL publicly open"
  vpc_id      = module.vpc.vpc_id


  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "User-service ports"
      cidr_blocks = "0.0.0.0/0"
    },

    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "User-service ports"
      cidr_blocks = "0.0.0.0/0"
    },

    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "User-service ports"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  egress_rules = [ "all-all" ]
}



module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "c38-instance"

  ami                    = "ami-06878d265978313ca"
  instance_type          = "t2.micro"
  key_name               = "upgrad"
  monitoring             = true
  vpc_security_group_ids = [module.ssh_sg.security_group_id]
  subnet_id              = module.vpc.public_subnets[0]

  tags = {
    Terraform = "true"
    Environment = "devlopment"
    project = "wordpress"
  }
}