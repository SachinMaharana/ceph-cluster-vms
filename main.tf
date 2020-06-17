data "http" "workstation-external-ip" {
  url = "http://ipv4.icanhazip.com"
}


locals {
  workstation-external-cidr = "${chomp(data.http.workstation-external-ip.body)}/32"
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "ceph"
  }
}

resource "aws_subnet" "subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.vpc_cidr
  tags = {
    Name = "ceph"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "ceph"
  }
}



resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = var.all_cidr
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "ceph"
  }
}

resource "aws_route_table_association" "rt-assoc" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.rt.id
}


resource "aws_security_group" "ceph" {
  name   = "ceph-sg"
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "ceph"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "allow_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.ceph.id
  cidr_blocks       = [var.all_cidr]
}

resource "aws_security_group_rule" "allow_icmp" {
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  security_group_id = aws_security_group.ceph.id
  cidr_blocks       = [var.all_cidr]
}

resource "aws_security_group_rule" "allow_http_mgr" {
  type              = "ingress"
  from_port         = 8443
  to_port           = 8443
  protocol          = "tcp"
  security_group_id = aws_security_group.ceph.id
  cidr_blocks       = [var.all_cidr]
}
resource "aws_security_group_rule" "allow_http_radosgw" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  security_group_id = aws_security_group.ceph.id
  cidr_blocks       = [var.all_cidr]
}


resource "aws_security_group_rule" "allow_http_grafan" {
  type              = "ingress"
  from_port         = 3000
  to_port           = 3000
  protocol          = "tcp"
  security_group_id = aws_security_group.ceph.id
  cidr_blocks       = [var.all_cidr]
}

resource "aws_security_group_rule" "allow_outgoing" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.ceph.id
  cidr_blocks       = [var.all_cidr]
}

resource "aws_security_group_rule" "allow_access_from_this_security_group" {
  type                     = "ingress"
  from_port                = -1
  to_port                  = -1
  protocol                 = "-1"
  security_group_id        = aws_security_group.ceph.id
  source_security_group_id = aws_security_group.ceph.id
}


resource "aws_key_pair" "ssh" {
  count      = var.aws_key_pair_name == null ? 1 : 0
  key_name   = "${var.owner}-${var.project}"
  public_key = file(var.ssh_public_key_path)
}


resource "aws_instance" "mon" {
  count                       = 3
  ami                         = "ami-0f2b4fc905b0bd1f1"
  instance_type               = "t2.medium"
  vpc_security_group_ids      = [aws_security_group.ceph.id]
  key_name                    = var.aws_key_pair_name == null ? aws_key_pair.ssh.0.key_name : var.aws_key_pair_name
  subnet_id                   = aws_subnet.subnet.id
  associate_public_ip_address = true
  tags = {
    Name = "mon-${count.index}"
  }
}
resource "aws_instance" "osd" {
  count                       = 3
  ami                         = "ami-0f2b4fc905b0bd1f1"
  instance_type               = "t2.medium"
  vpc_security_group_ids      = [aws_security_group.ceph.id]
  key_name                    = var.aws_key_pair_name == null ? aws_key_pair.ssh.0.key_name : var.aws_key_pair_name
  subnet_id                   = aws_subnet.subnet.id
  associate_public_ip_address = true
  tags = {
    Name = "osd-${count.index}"
  }
  ebs_block_device {
    device_name           = "/dev/xvdb"
    delete_on_termination = true
    volume_size           = 30
    volume_type           = "gp2"
  }

}

# output "public_ip_mon" {
#   value       = aws_instance.mon[count.index].public_ip
#   description = "Public IP"
# }

# output "public_ip_osd" {
#   value       = aws_instance.osd[count.index].public_ip
#   description = "Public IP"
# }


