# resource  "aws_security_group" "websocket_workers" {

#   name        = "websocket-workers-v0"
#   description = "Security group for websocket workers"
#   vpc_id      = data.aws_vpc.default.id

#   ingress {
#     description = "http from SG"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     security_groups = ["websocket-LB-v0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "allow_http_from_LB"
#   }
# }

