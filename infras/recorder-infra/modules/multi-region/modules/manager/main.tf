//===================================================================================================== data
data "aws_ami" "manager_ami" {
  most_recent      = true
  owners           = var.arrays.ami_owners

  filter {
    name   = "name"
    values = ["recorder-manager-v*"]
  }
}
data "aws_ami" "worker_ami" {
  most_recent      = true
  owners           = var.arrays.ami_owners

  filter {
    name   = "name"
    values = ["web-recorder-worker-v*"]
  }
}

data "aws_eip" "manager_ip" {

  filter {
    name   = "tag:Name"
    values = ["recorder-manager-ip"]
  }
}
data "template_file" "init" {
  template = "${file("${path.module}/data/main.sh")}"
  vars = {
    region = var.module_region
    aws_user_access_key = lookup(lookup(lookup(var.maps,"users"),"web-recorder-scaler"),"access_key")
    aws_user_access_secret = lookup(lookup(lookup(var.maps,"users"),"web-recorder-scaler"),"secret_key")

    config_file_content = base64encode(data.template_file.json.rendered)
  }
}
data "template_file" "json" {
  template = "${file("${path.module}/data/main.json")}"
  vars = {
    region = var.module_region
    subnetId = local.subnets[0]
    aws_worker_ami_id = data.aws_ami.worker_ami.id
  }
}
//===================================================================================================== prep

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"

  name        = "recorder-manager-v0--tf"
  description = "Security group for Recorder Manager"
  vpc_id      = data.aws_vpc.default.id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp","https-443-tcp","ssh-tcp"]
  egress_rules        = ["all-all"]

  ingress_with_cidr_blocks = [
    {
      from_port   = 3000
      to_port     = 3000
      protocol    = "tcp"
      description = "Service Port"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = {
    "Name"      = "recorder-manager-v0--tf"
    "Role"      = "recorder-manager"
    "Env"       = "prod"
    "managedBy" : "myken-infras-manger@terrafom",
  }
}
//===================================================================================================== main
resource "aws_instance" "this" {
  ami                         = data.aws_ami.manager_ami.id
  instance_type               = "t2.small"
  subnet_id     = local.subnets[0]
  #  private_ips                 = ["172.31.32.5", "172.31.46.20"]
  key_name                    = "meet"
  vpc_security_group_ids      = [module.security_group.this_security_group_id]
  associate_public_ip_address = true

  #user_data_base64 = base64encode(local.user_data)
  user_data = base64encode(data.template_file.init.rendered)

  # Copies the myapp.conf file to /etc/myapp.conf
  # provisioner "file" {
  #   source      =  data.template_file.json.rendered
  #   destination = "/data/apps/task-manager/configs/main.json"
  # }


  tags = {
    "Name"      = "recorder-manager-v0--tf"
    //"Name"      = data.aws_ami.manager_ami.name
    "id" : "recorder-manager-v0--tf",
    "Role"      = "recorder-manager"
    "Env"       = "prod"
    "managedBy" : "myken-infras-manger@terrafom",
  }
}
//===================================================================================================== prep
resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.this.id
  allocation_id = data.aws_eip.manager_ip.id
}
//===================================================================================================== END