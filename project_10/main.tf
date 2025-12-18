############################
# IAM ROLE for EC2
############################

# Trust policy allowing EC2 to assume the role
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# Create the IAM role
resource "aws_iam_role" "ec2_role" {
  name               = var.ec2_role_name
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
  description        = "EC2 role created using Terraform to access S3 and CloudWatch"
}

############################
# IAM INSTANCE PROFILE
############################

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.ec2_role_name}-profile"
  role = aws_iam_role.ec2_role.name
}


############################
# IAM POLICIES
############################

# S3 Policy
data "aws_iam_policy_document" "s3_policy_doc" {
  statement {
    sid     = "S3Access"
    actions = ["s3:PutObject", "s3:GetObject", "s3:ListBucket"]

    resources = [
      var.s3_bucket_arn,
      "${var.s3_bucket_arn}/*"
    ]
  }
}

resource "aws_iam_policy" "s3_policy" {
  name        = "tf-s3-access-policy"
  description = "Allow EC2 to access S3 bucket objects"
  policy      = data.aws_iam_policy_document.s3_policy_doc.json
}


# CloudWatch Policy
data "aws_iam_policy_document" "cw_policy_doc" {
  statement {
    sid = "CloudWatchAccess"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "cloudwatch:PutMetricData"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "cloudwatch_policy" {
  name        = "tf-cloudwatch-policy"
  description = "Allow EC2 to send logs and metrics to CloudWatch"
  policy      = data.aws_iam_policy_document.cw_policy_doc.json
}


############################
# ATTACH POLICIES TO ROLE
############################

resource "aws_iam_role_policy_attachment" "attach_s3_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.s3_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_cw_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.cloudwatch_policy.arn
}
