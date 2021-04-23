locals {
  vpn_cidrs = "${var.vpn_private_ip}/32"
}

resource "aws_security_group" "this" {
  name        = "${local.instance_name}-sg"
  description = "SG for the Nexus instance"
  vpc_id      = var.vpc_id

  tags = merge({
    Name = "${local.instance_name}-sg"
  }, local.tags)
}

resource "aws_security_group_rule" "inbound_ssh" {
  cidr_blocks       = [local.vpn_cidrs]
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.this.id
  to_port           = 22
  type              = "ingress"
}

resource "aws_security_group_rule" "inbound_web" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 8081
  protocol          = "tcp"
  security_group_id = aws_security_group.this.id
  to_port           = 8081
  type              = "ingress"
}

resource "aws_security_group_rule" "egress" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.this.id
  to_port           = 0
  type              = "egress"
}
