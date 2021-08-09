data  "aws_security_group" "websocket_workers" {

  filter {
    name   = "tag:Name"
    values = ["websocket-workers-v*"]
  }
}

resource  "aws_security_group" "redis" {

  name        = "redis-v0"
  description = "Security group for redis"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "redis port from socket workers SG"
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    security_groups = [data.aws_security_group.websocket_workers.id]
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

