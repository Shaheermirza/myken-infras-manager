
#================================================================================================= data
data "aws_ami" "LB_ami" {
  most_recent      = true
  owners           = var.arrays.ami_owners

  filter {
    name   = "name"
    values = ["websocket-LB-v*"]
  }
}

data "aws_eip" "LB_ip" {

  filter {
    name   = "tag:Name"
    values = ["websocket-LB-ip"]
  }
}
data "template_file" "init" {
  template = "${file("${path.module}/data/socket-LB.user-data.sh")}"
  vars = {
    region = var.module_region
    aws_user_access_key = lookup(lookup(lookup(var.maps,"users"),"web-recorder-scaler"),"access_key")
    aws_user_secret_key = lookup(lookup(lookup(var.maps,"users"),"web-recorder-scaler"),"secret_key")
  }
}
#================================================================================================= ressources
module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"

  name        = "websocket-LB-v0"
  description = "Security group for websocket LB"
  vpc_id      = data.aws_vpc.default.id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp"]
  egress_rules        = ["all-all"]
}

resource "aws_instance" "this" {

  #name                       = "websocket-LB-v1"
  ami                         = data.aws_ami.LB_ami.id
  instance_type               = "t2.small"
  subnet_id     = local.subnets[0]
  #  private_ips                 = ["172.31.32.5", "172.31.46.20"]
  key_name                    = "meet"
  vpc_security_group_ids      = [module.security_group.this_security_group_id]
  associate_public_ip_address = true

  #user_data_base64 = base64encode(local.user_data)
  user_data = base64encode(data.template_file.init.rendered)

  tags = {
    "Name"      = data.aws_ami.LB_ami.name
    "Role"      = "websocket-LB"
    "Env"       = "prod"
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.this.id
  allocation_id = data.aws_eip.LB_ip.id
}
#================================================================================================= ressources