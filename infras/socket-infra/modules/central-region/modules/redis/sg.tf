# data  "aws_security_group" "websocket_workers" {

#   filter {
#     name   = "tag:Name"
#     values = ["websocket-workers-v*"]
#   }
# }
# data "aws_subnet" "selected" {
#   id = var.subnet_id
# }
variable service_ports {
  type        = list
  default     = [6379,22]
  description = "description"
}

resource  "aws_security_group" "redis" {

  name        = "redis-v0"
  description = "Security group for redis"
  vpc_id      = data.aws_vpc.default.id

  dynamic "ingress" {
    for_each = var.service_ports
    content {
      description = "redis port from socket workers SG"
      from_port = ingress.value
      to_port   = ingress.value
      protocol  = "tcp"
      #security_groups = [data.aws_security_group.websocket_workers.id]
      cidr_blocks = ["10.0.0.0/16"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "redis-v0"
  }
}

