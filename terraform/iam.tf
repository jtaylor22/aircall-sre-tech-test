data "aws_iam_role" "lambda_execution_role" {
  name = "crop-image-executor"
}

resource "aws_iam_policy_attachment" "s3_policy_attachment" {
  name       = "s3_policy_attachment"
  roles      = [aws_iam_role.lambda_execution_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}
