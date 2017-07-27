resource "aws_iam_policy" "associate_address" {
  name        = "AssociateAddress"
  path        = "/"
  description = "Allows EIP addresses to be associated."
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:AssociateAddress"
      ],
      "Resource": [
        "*"
      ],
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role" "stratospike_web" {
  name = "stratospike-web"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "stratospike_web_attach_assoc" {
  role = "${aws_iam_role.stratospike_web.name}"
  policy_arn = "${aws_iam_policy.associate_address.arn}"
}

resource "aws_iam_role_policy_attachment" "stratospike_web_attach_ecr" {
  role = "${aws_iam_role.stratospike_web.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

