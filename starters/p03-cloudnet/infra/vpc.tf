# CloudNet's VPC. Done for you in the Guided starter: the VPC itself.

resource "aws_vpc" "main" {
  cidr_block           = "10.20.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "cloudnet"
  }
}

# TODO(task 8): four aws_subnet resources from your address plan: public_a and private_a in ap-south-1a,
#               public_b and private_b in ap-south-1b. Give each a Name tag.

# TODO(task 8): aws_internet_gateway "main" in the VPC.

# TODO(task 8): aws_route_table "public" with a route from 0.0.0.0/0 to the internet gateway,
#               and an association for each public subnet.

# TODO(task 8): aws_route_table "private" with no routes, and an association for each private subnet.
