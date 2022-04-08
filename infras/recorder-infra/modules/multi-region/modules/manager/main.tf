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
//===================================================================================================== templates
# resource "random_string" "random" {
#   length           = 16
#   special          = true
#   override_special = "/@£$"
# }
data "template_file" "init" {
  template = "${file("${path.module}/data/main.sh")}"
  vars = {
    region = var.module_region
    aws_user_access_key = lookup(lookup(lookup(var.maps,"users"),"web-recorder-scaler"),"access_key")
    aws_user_access_secret = lookup(lookup(lookup(var.maps,"users"),"web-recorder-scaler"),"secret_key")

    config_file_content = base64encode(data.template_file.json.rendered)
    #random_string       = random_string.random.id
  }
}
data "template_file" "json" {
  template = "${file("${path.module}/data/main.json")}"
  vars = {
    region = var.module_region

    subnetId = local.subnets[0]
    SecurityGroupId = aws_security_group.recorder_workers.id
    VpcId = data.aws_vpc.default.id

    aws_worker_ami_id = data.aws_ami.worker_ami.id
  }
}
//===================================================================================================== prep
variable allowed_ips {
  type        = list
  default     = ["52.140.106.224"]
  description = "description"
}
resource  "aws_security_group" "manager" {

  name        = "recorder-manager-v0--tf-${terraform.workspace}"
  description = "Security group for Recorder Manager"
  vpc_id      = data.aws_vpc.default.id

  dynamic "ingress" {
    for_each = var.allowed_ips
    content {
      from_port = 443
      to_port   = 443
      protocol  = "tcp"
      #security_groups = [data.aws_security_group.websocket_LB.id]
      cidr_blocks = ["${ingress.value}/32"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

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
  key_name                    = "mykensho"
  vpc_security_group_ids      = [aws_security_group.manager.id]
  associate_public_ip_address = true                     
  #user_data_base64 = base64encode(local.user_data)
  user_data = base64encode(data.template_file.init.rendered)

  # Copies the myapp.conf file to /etc/myapp.conf
  # provisioner "file" {
  #   source      =  data.template_file.json.rendered
  #   destination = "/data/apps/task-manager/configs/main.json"
  # }


  tags = {
    "Name"      = "recorder-manager-v0--tf-${terraform.workspace}"
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