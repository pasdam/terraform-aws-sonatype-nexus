locals {
  instance_name = "${var.env_prefix}-nexus"

  tags = merge(
    var.tags,
    {
      Module = "nexus"
    }
  )
}
