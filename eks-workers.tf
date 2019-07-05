
resource "aws_key_pair" "deployer" {
  key_name   = "eks-nodes-key"
  public_key = "${var.eks-nodes-key}"
}

resource "aws_launch_configuration" "eks-nodes-demo" {
  associate_public_ip_address = true
  iam_instance_profile        = "${aws_iam_instance_profile.demo-eks-node.name}"
  image_id                    = "${data.aws_ami.eks-worker.id}"
  instance_type               = "m4.large"
  name_prefix                 = "terraform-eks-demo"
  security_groups             = ["${aws_security_group.demo-eks-node.id}"]
  user_data_base64            = "${base64encode(local.demo-eks-node-userdata)}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "eks-nodes-demo" {
  desired_capacity     = 2
  launch_configuration = "${aws_launch_configuration.eks-nodes-demo.id}"
  max_size             = 2
  min_size             = 1
  name                 = "terraform-eks-demo"
  vpc_zone_identifier  = ["${aws_subnet.eks_demo.*.id}"]

  tag {
    key                 = "Name"
    value               = "terraform-eks-demo"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.cluster-name}"
    value               = "owned"
    propagate_at_launch = true
  }
}
