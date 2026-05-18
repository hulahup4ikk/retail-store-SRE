module "tags" {
  source = "../../lib/tags"

  environment_name = var.environment_name
}

module "vpc" {
  source = "../../lib/vpc"

  environment_name = var.environment_name
  tags             = module.tags.result
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["137112412989"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }
}

resource "aws_security_group" "swarm" {
  name        = "${var.environment_name}-swarm"
  description = "Security group for retail store SRE swarm nodes"
  vpc_id      = module.vpc.inner.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_cidr]
  }

  ingress {
    description = "Application and monitoring ports"
    from_port   = 3000
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = [var.allowed_cidr]
  }

  ingress {
    description = "Swarm management"
    from_port   = 2377
    to_port     = 2377
    protocol    = "tcp"
    cidr_blocks = [module.vpc.inner.vpc_cidr_block]
  }

  ingress {
    description = "Swarm node communication tcp"
    from_port   = 7946
    to_port     = 7946
    protocol    = "tcp"
    cidr_blocks = [module.vpc.inner.vpc_cidr_block]
  }

  ingress {
    description = "Swarm node communication udp"
    from_port   = 7946
    to_port     = 7946
    protocol    = "udp"
    cidr_blocks = [module.vpc.inner.vpc_cidr_block]
  }

  ingress {
    description = "Swarm overlay network"
    from_port   = 4789
    to_port     = 4789
    protocol    = "udp"
    cidr_blocks = [module.vpc.inner.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(module.tags.result, {
    Name = "${var.environment_name}-swarm"
  })
}

locals {
  user_data = <<-EOF
    #!/bin/bash
    set -euxo pipefail
    dnf update -y
    dnf install -y docker git
    systemctl enable docker
    systemctl start docker
    usermod -aG docker ec2-user
  EOF
}

resource "aws_instance" "manager" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = module.vpc.inner.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.swarm.id]
  associate_public_ip_address = true
  key_name                    = var.key_name
  user_data                   = local.user_data

  tags = merge(module.tags.result, {
    Name = "${var.environment_name}-swarm-manager"
    Role = "swarm-manager"
  })
}

resource "aws_instance" "worker" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = module.vpc.inner.public_subnets[1]
  vpc_security_group_ids      = [aws_security_group.swarm.id]
  associate_public_ip_address = true
  key_name                    = var.key_name
  user_data                   = local.user_data

  tags = merge(module.tags.result, {
    Name = "${var.environment_name}-swarm-worker-1"
    Role = "swarm-worker"
  })
}
