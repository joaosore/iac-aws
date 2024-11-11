resource "aws_subnet" "public" {
  for_each           = zipmap(var.availability_zones, var.public_subnet_cidrs)
  vpc_id             = var.vpc_id
  cidr_block         = each.value
  availability_zone  = each.key
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.public_subnet_name}-${each.key}"
  }
}

resource "aws_subnet" "private" {
  for_each           = zipmap(var.availability_zones, var.private_subnet_cidrs)
  vpc_id             = var.vpc_id
  cidr_block         = each.value
  availability_zone  = each.key
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.private_subnet_name}-${each.key}"
  }
}