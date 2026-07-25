resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(local.tags, {
    Name      = "${var.name_prefix}-vpc"
    Component = "Network"
  })
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(local.tags, {
    Name      = "${var.name_prefix}-igw"
    Component = "Internet-Gateway"
  })
}

resource "aws_subnet" "public" {
  for_each = local.public_subnets

  vpc_id                  = aws_vpc.this.id
  availability_zone       = each.key
  cidr_block              = each.value.cidr
  map_public_ip_on_launch = false

  tags = merge(local.tags, {
    Name      = "${var.name_prefix}-public-${each.value.index + 1}"
    Tier      = "public"
    Component = "Subnet"
  })
}

resource "aws_subnet" "application" {
  for_each = local.application_subnets

  vpc_id                  = aws_vpc.this.id
  availability_zone       = each.key
  cidr_block              = each.value.cidr
  map_public_ip_on_launch = false

  tags = merge(local.tags, {
    Name      = "${var.name_prefix}-app-${each.value.index + 1}"
    Tier      = "application"
    Component = "Subnet"
  })
}

resource "aws_subnet" "database" {
  for_each = local.database_subnets

  vpc_id                  = aws_vpc.this.id
  availability_zone       = each.key
  cidr_block              = each.value.cidr
  map_public_ip_on_launch = false

  tags = merge(local.tags, {
    Name      = "${var.name_prefix}-db-${each.value.index + 1}"
    Tier      = "database"
    Component = "Subnet"
  })
}

resource "aws_eip" "nat" {
  for_each = local.nat_gateway_azs

  domain = "vpc"

  depends_on = [aws_internet_gateway.this]

  tags = merge(local.tags, {
    Name      = "${var.name_prefix}-nat-eip-${local.public_subnets[each.key].index + 1}"
    Component = "NAT-EIP"
  })
}

resource "aws_nat_gateway" "this" {
  for_each = local.nat_gateway_azs

  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.public[each.key].id

  connectivity_type = "public"

  depends_on = [aws_internet_gateway.this]

  tags = merge(local.tags, {
    Name      = "${var.name_prefix}-nat-${local.public_subnets[each.key].index + 1}"
    Component = "NAT-Gateway"
  })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = merge(local.tags, {
    Name      = "${var.name_prefix}-public-rt"
    Tier      = "public"
    Component = "Route-Table"
  })
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "application" {
  for_each = local.application_subnets

  vpc_id = aws_vpc.this.id

  tags = merge(local.tags, {
    Name      = "${var.name_prefix}-app-rt-${each.value.index + 1}"
    Tier      = "application"
    Component = "Route-Table"
  })
}

resource "aws_route" "application_nat" {
  for_each = local.application_subnets

  route_table_id         = aws_route_table.application[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = var.nat_gateway_mode == "one_per_az" ? (
    aws_nat_gateway.this[each.key].id
  ) : aws_nat_gateway.this[var.availability_zones[0]].id
}

resource "aws_route_table_association" "application" {
  for_each = aws_subnet.application

  subnet_id      = each.value.id
  route_table_id = aws_route_table.application[each.key].id
}

resource "aws_route_table" "database" {
  for_each = local.database_subnets

  vpc_id = aws_vpc.this.id

  tags = merge(local.tags, {
    Name      = "${var.name_prefix}-db-rt-${each.value.index + 1}"
    Tier      = "database"
    Component = "Route-Table"
  })
}

resource "aws_route_table_association" "database" {
  for_each = aws_subnet.database

  subnet_id      = each.value.id
  route_table_id = aws_route_table.database[each.key].id
}
