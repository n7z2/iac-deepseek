resource "aws_iam_instance_profile" "ec2ds_instance_profile" {
  name = "deepseek_ec2_instance_profile"
  role = aws_iam_role.ec2ds_role.name
}

resource "aws_iam_role" "ec2ds_role" {
  name               = "ec2ds_role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_ec2ds_role.json
}

resource "aws_iam_policy" "S3FullAccess" {
  name        = "S3FullAccessPolicy"
  description = "Grants full access to S3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "s3:*"
        Resource = "*"
      }
    ]
  })
}

resource "aws_s3_bucket_policy" "ds_alb_s3_policy" {
    bucket = aws_s3_bucket.ds_alb_s3_log.id
    policy = data.aws_iam_policy_document.ds_alb_s3_policy.json
}

resource "aws_iam_role_policy_attachment" "S3FullAccess-policy-attach" {
  role       = aws_iam_role.ec2ds_role.name
  policy_arn = aws_iam_policy.S3FullAccess.arn
}

resource "aws_iam_role_policy_attachment" "SSMManagedInstanceCore-policy-attach" {
  role       = aws_iam_role.ec2ds_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
