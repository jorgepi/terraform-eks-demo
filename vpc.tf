resource "aws_vpc" "eks_demo" {
  cidr_block = "10.0.0.0/16"

  tags = "${
    map(
     "Name", "terraform-eks-demo-node",
     "kubernetes.io/cluster/${var.cluster-name}", "shared",
    )
  }"
}

resource "aws_subnet" "eks_demo" {
  count = 2

  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block        = "10.0.${count.index}.0/24"
  vpc_id            = "${aws_vpc.eks_demo.id}"

  tags = "${
    map(
     "Name", "terraform-eks-demo-node",
     "kubernetes.io/cluster/${var.cluster-name}", "shared",
    )
  }"
}

resource "aws_internet_gateway" "eks_demo" {
  vpc_id = "${aws_vpc.eks_demo.id}"

  tags = {
    Name = "terraform-eks-demo"
  }
}

resource "aws_route_table" "eks_demo" {
  vpc_id = "${aws_vpc.eks_demo.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.eks_demo.id}"
  }
}

resource "aws_route_table_association" "eks_demo" {
  count = 2

  subnet_id      = "${aws_subnet.eks_demo.*.id[count.index]}"
  route_table_id = "${aws_route_table.eks_demo.id}"
}
