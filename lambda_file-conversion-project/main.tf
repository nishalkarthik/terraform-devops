### creating s3 bucket
resource "aws_s3_bucket" "mybucket" {
  bucket = "bucket-file-conversion"
}
###ownership and public-ACL access
resource "aws_s3_bucket_ownership_controls" "bucket_fc" {
  bucket = aws_s3_bucket.mybucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
resource "aws_s3_bucket_public_access_block" "pub_access_bucket_fc" {
  bucket = aws_s3_bucket.mybucket.id

  block_public_acls = false
  block_public_policy = false
  ignore_public_acls = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "acl_bucket_fc" {
  depends_on = [aws_s3_bucket_ownership_controls.bucket_fc,aws_s3_bucket_public_access_block.pub_access_bucket_fc]
  bucket = aws_s3_bucket.mybucket.id
  acl = "public-read"
}

### creating iam role for lambda function
resource "aws_iam_role" "lambda_role_file_conversion" {
  name = "lambdarole-filecoversion"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}
resource "aws_iam_policy" "policy-lambda-fileconversion-role" {
  policy = jsonencode(
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Action": [
            "s3:PutObject",
            "s3:GetObject",
            "logs:CreateLogStream",
            "logs:DescribeLogGroups",
            "logs:DescribeLogStreams",
            "logs:CreateLogGroup",
            "logs:PutLogEvents",
            "sns:Publish"
          ],
          "Resource": "*"
        }
      ]
    }
  )
}

resource "aws_iam_policy_attachment" "attach-role-policy" {
  name       = "role-policy-lambda-fc"
  policy_arn = aws_iam_policy.policy-lambda-fileconversion-role.arn
  roles = [aws_iam_role.lambda_role_file_conversion.name]
}

### creating lambda function
#1--creating lambda layers
resource "aws_lambda_layer_version" "file-conversion-pypi-lib" {
  layer_name = "pypi-lib-fileconversion"
  filename = "${path.module}/python/new.zip"
  compatible_runtimes = ["python3.9"]
}
##2--lambda function
resource "aws_lambda_function" "lambdafunction-fileconversion" {
  function_name = "terralambda-fileconversion"
  filename = "${path.module}/python/terra-file-conversion.zip"
  role          = aws_iam_role.lambda_role_file_conversion.arn
  handler = "terra-file-conversion.lambda_handler"
  runtime = "python3.9"
  layers = [aws_lambda_layer_version.file-conversion-pypi-lib.arn]
  timeout = 30
}
##3-cloudwatch-loggroups
resource "aws_cloudwatch_log_group" "terralambda-fc" {
  name = "/aws/lambda/${aws_lambda_function.lambdafunction-fileconversion.function_name}"
}


/*resource "aws_lambda_event_source_mapping" "trigger-destibation" {
  function_name     = aws_lambda_function.lambdafunction-fileconversion.arn
  event_source_arn  = aws_s3_bucket.mybucket.arn
  starting_position = "LATEST"
}*/


##s3-event-trigger-config
resource "aws_s3_bucket_notification" "eventtrigger-s3-lambda" {
  bucket = aws_s3_bucket.mybucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.lambdafunction-fileconversion.arn
    events = ["s3:ObjectCreated:*"]
    filter_prefix = ""
    filter_suffix = ".csv"
  }
depends_on = [aws_lambda_permission.s3-trigger-lambda-permissions]
}
## s3-permissions to trigger lambda lambda
resource "aws_lambda_permission" "s3-trigger-lambda-permissions" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambdafunction-fileconversion.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.mybucket.arn
}