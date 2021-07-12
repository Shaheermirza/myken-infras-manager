data  "aws_security_group" "websocket_LB" {

  filter {
    name   = "tag:Name"
    values = ["websocket-LB-v*"]
  }
}

resource  "aws_security_group" "websocket_workers" {

  name        = "websocket-workers-v0"
  description = "Security group for websocket workers"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "http from SG"
    from_port   = 9001
    to_port     = 9001
    protocol    = "tcp"
    security_groups = [data.aws_security_group.websocket_LB.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "websocket-workers-v0"
  }
}

