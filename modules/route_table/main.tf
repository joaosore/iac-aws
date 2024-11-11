resource "aws_route_table" "public_route_table" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }

  tags = {
    Name = var.route_table_name
  }
}

resource "aws_route_table_association" "public_subnet_a_association" {
  subnet_id      = var.subnet_ids[0]
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_b_association" {
  subnet_id      = var.subnet_ids[1]
  route_table_id = aws_route_table.public_route_table.id
}
