//===================================================================================================== data
data "aws_vpc" "default" {
  default = true
}
data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.default.id
}
data "aws_ami" "manager_ami" {
  most_recent      = true
  owners           = var.arrays.ami_owners

  filter {
    name   = "name"
    values = ["meetBack-v*"]
  }
}

data "aws_eip" "meetBack_ip" {

  filter {
    name   = "tag:Name"
    values = ["meetBack-ip"]
  }
}
//===================================================================================================== prep

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"

  name        = "meetBack--tf"
  description = "Security group for Recorder Manager"
  vpc_id      = data.aws_vpc.default.id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp","https-443-tcp","ssh-tcp"]
  egress_rules        = ["all-all"]

  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "Service Port"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 4096
      to_port     = 4096
      protocol    = "tcp"
      description = "Service Port"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 1935
      to_port     = 1935
      protocol    = "tcp"
      description = "Service Port"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 10000
      to_port     = 20000
      protocol    = "udp"
      description = "Service Port"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 9090
      to_port     = 9090
      protocol    = "tcp"
      description = "Service Port"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 5222
      to_port     = 5222
      protocol    = "tcp"
      description = "Service Port"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = {
    "Name"      = "meetBack-v0--tf"
    "Role"      = "meetBack"
    "Env"       = "prod"
    "managedBy" : "myken-infras-manger@terrafom",
  }
}
//===================================================================================================== main
resource "aws_instance" "this" {
  ami                         = data.aws_ami.manager_ami.id
  instance_type               = "t2.xlarge"
  subnet_id     = tolist(data.aws_subnet_ids.all.ids)[1]
  #  private_ips                 = ["172.31.32.5", "172.31.46.20"]
  key_name                    = "meet"
  vpc_security_group_ids      = [module.security_group.this_security_group_id]
  associate_public_ip_address = true

  #user_data_base64 = base64encode(local.user_data)

  tags = {
    "Name"      = "meetBack-v0--tf"
    //"Name"      = data.aws_ami.manager_ami.name
    "id" : "meetBack-v0--tf",
    "Role"      = "meetBack"
    "Env"       = "prod"
    "managedBy" : "myken-infras-manger@terrafom",
  }
}
//===================================================================================================== prep
resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.this.id
  allocation_id = data.aws_eip.meetBack_ip.id
}
//===================================================================================================== END