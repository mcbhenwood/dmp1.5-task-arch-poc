resource "aws_security_group" "web_tasks" {
  name        = "WEB"
  description = "Identifies the holder as one of the Web tasks"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "WEB"
  }
}

resource "aws_security_group_rule" "web_tasks_8080_in_anywhere" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 8080
  protocol          = "tcp"
  security_group_id = aws_security_group.web_tasks.id
  to_port           = 8080
  type              = "ingress"
}

resource "aws_security_group_rule" "web_tasks_https_out_anywhere" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.web_tasks.id
  to_port           = 443
  type              = "egress"
}

resource "aws_network_acl_rule" "public__allow_8080_everywhere_in" {
  cidr_block     = "0.0.0.0/0"
  egress         = false
  from_port      = 8080
  network_acl_id = module.vpc.network_acl_ids.public
  protocol       = "tcp"
  rule_action    = "allow"
  rule_number    = 10000
  to_port        = 8080
}
