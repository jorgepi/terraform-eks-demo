resource "aws_eks_cluster" "eks-master-demo" {
  name            = "${var.cluster-name}"
  role_arn        = "${aws_iam_role.demo-eks-cluster.arn}"

  vpc_config {
    security_group_ids = ["${aws_security_group.demo-eks-cluster.id}"]
    subnet_ids         = ["${aws_subnet.eks_demo.*.id}"]
  }

  depends_on = [
    "aws_iam_role_policy_attachment.demo-eks-cluster-AmazonEKSClusterPolicy",
    "aws_iam_role_policy_attachment.demo-eks-cluster-AmazonEKSServicePolicy",
  ]
}
