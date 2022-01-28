# IAM ROLE AND POLICY

resource "aws_iam_role" "role_project" {
  name = "role_project"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["ec2.amazonaws.com"]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "project-attach" {
  role       = aws_iam_role.role_project.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "project_profile" {
  name = "project_profile"
  role = aws_iam_role.role_project.name
}