resource "aws_iam_instance_profile" "instance_profile" {
    name = "${var.environment}-${var.project}-ibuilder-profile"
    role =aws_iam_role.imagebuilder_role.name
}

resource "aws_iam_role" "imagebuilder_role" {
    name = "${var.environment}-${var.project}-ibuilder-role"
    path = "/"
    assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "imagebuilder_attach_1" {
    role = aws_iam_role.imagebuilder_role.name
    policy_arn = "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilder"
}

resource "aws_iam_role_policy_attachment" "imagebuilder_attach_2" {
    role = aws_iam_role.imagebuilder_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "imagebuilder_attach_3" {
    role = aws_iam_role.imagebuilder_role.name
    policy_arn = aws_iam_policy.s3_policy.arn
}

resource "aws_iam_policy" "s3_policy" {
    name = "${var.environment}-${var.project}-ibuilder-s3-policy"
    policy = jsonencode(
      {
          Version = "2012-10-17"
          Statement = [
            {
              Effect = "Allow"
              Action = [
                "s3:ListBucket",
                "s3:GetObject",
                "s3:GetObjectAttributes"
              ]
              Resource = [
                "${aws_s3_bucket.code_bucket.arn}",
                "${aws_s3_bucket.code_bucket.arn}/",
                "${aws_s3_bucket.code_bucket.arn}/*",
                "${aws_s3_bucket.config_bucket.arn}",
                "${aws_s3_bucket.config_bucket.arn}/",
                "${aws_s3_bucket.config_bucket.arn}/*"
              ]
            }
          ]
      }
    )
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
