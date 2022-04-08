//===================================================================================================== main
resource  "aws_security_group" "recorder_workers" {

  name        = "web-recorder-workers--tf-${terraform.workspace}"
  description = "Security group for Recorder workers"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "http from Manager"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    security_groups = [aws_security_group.manager.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    "Name"      = "web-recorder-workers--tf"
    "Role"      = "web-recorder-workers"
    "Env"       = "prod"
    "managedBy" : "myken-infras-manger@terrafom",
  }
}
//===================================================================================================== 