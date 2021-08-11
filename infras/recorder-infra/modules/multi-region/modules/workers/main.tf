
//===================================================================================================== data
data "aws_vpc" "default" {
  default = true
}
data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.default.id
}
data  "aws_security_group" "recorder_manager" {

  filter {
    name   = "tag:Name"
    values = ["recorder-manager-v0--tf"]
  }
}
//===================================================================================================== main
resource  "aws_security_group" "allow_recorder_manager_to_workers" {

  name        = "web-recorder-workers--tf"
  description = "Security group for Recorder workers"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "http from Manager"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    security_groups = [data.aws_security_group.recorder_manager.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    "Name"      = "recorder-workers--tf"
    "Role"      = "recorder-workers"
    "Env"       = "prod"
    "managedBy" : "myken-infras-manger@terrafom",
  }
}
//===================================================================================================== 