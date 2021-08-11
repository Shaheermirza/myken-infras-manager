data  "aws_security_group" "websocket_LB" {

  filter {
    name   = "tag:Name"
    values = ["websocket-LB-v*"]
  }
}
variable service_ports {
  type        = list
  default     = [9001,22]
  description = "description"
}

resource  "aws_security_group" "websocket_workers" {

  name        = "websocket-workers-v0"
  description = "Security group for websocket workers"
  vpc_id      = data.aws_vpc.default.id

  dynamic "ingress" {
    for_each = var.service_ports
    content {
      from_port = ingress.value
      to_port   = ingress.value
      protocol  = "tcp"
      security_groups = [data.aws_security_group.websocket_LB.id]
    }
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

