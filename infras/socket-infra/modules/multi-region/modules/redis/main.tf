#=========================================================================================== data
data "aws_vpc" "default" {
  #default = true
  filter {
    name   = "tag:Name"
    values = ["main-vpc"]
  }
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_ami" "redis_ami" {
  most_recent      = true
  owners           = var.arrays.ami_owners

  filter {
    name   = "name"
    values = ["redis-v*"]
  }
}

data "aws_eip" "redis_ip" {

  filter {
    name   = "tag:Name"
    values = ["redis-ip"]
  }
}
#=========================================================================================== ressources

resource "aws_instance" "this" {

  #name                       = "redis-v1"
  ami                         = data.aws_ami.redis_ami.id
  instance_type               = "t2.medium"
  subnet_id     = tolist(data.aws_subnet_ids.all.ids)[0]
  #  private_ips                 = ["172.31.32.5", "172.31.46.20"]
  key_name                    = "meet"
  vpc_security_group_ids      = [aws_security_group.redis.id]
  associate_public_ip_address = true

  #user_data_base64 = base64encode(local.user_data)

  tags = {
    "Name"      = data.aws_ami.redis_ami.name
    "Role"      = "redis"
    "Env"       = "prod"
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.this.id
  allocation_id = data.aws_eip.redis_ip.id
}
#=========================================================================================== END