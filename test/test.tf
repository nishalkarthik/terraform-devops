resource "aws_s3_bucket" "mybucket" {
  bucket = "newprojbuck"

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

resource "aws_s3_object" "example_object" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "code/new.zip"  # The key (filename) to use in S3
  source = "./new.zip"  # Local file path to upload
 # acl    = "private"  # Example ACL setting; adjust as needed
}

resource "aws_s3_object" "example2_object" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "code/terra-file-conversion.zip"  # The key (filename) to use in S3
  source = "./terra-file-conversion.zip"  # Local file path to upload
 # acl    = "private"  # Example ACL setting; adjust as needed
}

resource "aws_lambda_function" "lambdafunction-fileconversion" {
  function_name = "terralambda-fileconversion"
  #filename = "${path.module}/python/terra-file-conversion.zip"
  role          = aws_iam_role.lambda_role_file_conversion.arn
  handler = "terra-file-conversion.lambda_handler"
  runtime = "python3.9"
  #layers = [aws_lambda_layer_version.file-conversion-pypi-lib.arn]
  timeout = 30
  s3_bucket = aws_s3_bucket.mybucket.id
  s3_key = "code/terra-file-conversion.zip"

  depends_on = [
    aws_iam_policy_attachment.attach-role-policy ,
    aws_s3_object.example_object
  ]
}

### creating iam role for lambda function
resource "aws_iam_role" "lambda_role_file_conversion" {
  name = "lambdarole-fileconversion"
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
  name = "lambda-fileconversion-policy"
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