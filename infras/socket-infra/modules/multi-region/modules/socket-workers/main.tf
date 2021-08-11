data  "aws_security_group" "websocket_LB" {

  filter {
    name   = "tag:Name"
    values = ["websocket-LB-v*"]
  }
}
resource "aws_security_group_rule" "http" {
  type              = "ingress"
  from_port         = 9001
  to_port           = 9001
  protocol          = "tcp"
  security_group_id = data.aws_security_group.websocket_LB.id
}
resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = data.aws_security_group.websocket_LB.id
}
module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"

  name        = "websocket-workers-v0"
  description = "Security group for websocket workers"
  vpc_id      = data.aws_vpc.default.id

  computed_ingress_with_source_security_group_id = [aws_security_group_rule.http.id,aws_security_group_rule.ssh.id]

  egress_rules        = ["all-all"]

  tags = {
    Name = "websocket-workers-v0"
  }
}

