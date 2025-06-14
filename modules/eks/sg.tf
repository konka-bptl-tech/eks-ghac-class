resource "aws_security_group" "allow_all" {
  name        = "${local.name}-cluster-sg"
  description = "Security group that allows all inbound and outbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
    Name = "${local.name}-cluster-sg"
    },
    var.common_tags
  )
}








