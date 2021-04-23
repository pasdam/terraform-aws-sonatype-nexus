data "aws_ami" "this" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-gp2"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

data "template_file" "cloudinit" {
  template = file("${path.module}/cloudinit.yml")
}

data "template_cloudinit_config" "install_data" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "basic_setup.sh"
    content_type = "text/cloud-config"
    content      = data.template_file.cloudinit.rendered
    merge_type   = "list(append)+dict(recurse_array)+str()"
  }
}

resource "aws_instance" "this" {
  ami                         = data.aws_ami.this.id
  associate_public_ip_address = true
  depends_on                  = [aws_security_group.this]
  instance_type               = "t3.large"
  key_name                    = var.key_name
  subnet_id                   = var.subnet_id
  user_data                   = data.template_cloudinit_config.install_data.rendered
  volume_tags                 = local.tags

  root_block_device {
    delete_on_termination = true
    volume_size           = "50"
    volume_type           = "gp2"
  }

  tags = merge({
    Name      = local.instance_name
    ManagedBy = "Terraform"
    OS        = "linux"
    OSDistro  = "Ubuntu"
    OSVersion = "20.04"
  }, local.tags)

  vpc_security_group_ids = [
    aws_security_group.this.id,
  ]
}
