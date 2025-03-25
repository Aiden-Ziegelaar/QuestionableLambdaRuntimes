data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "lambda_role" {
    name               = "library_runtime"
    assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "basic_execution_role_policy_attachment" {
    role        = aws_iam_role.lambda_role.name
    policy_arn  = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "lambda" {
  function_name = "LibraryRuntime"

  package_type  = "Image"

  role          = aws_iam_role.lambda_role.arn

  image_uri     = "${aws_ecr_repository.cobol_library_runtime.repository_url}:latest"

  architectures = ["x86_64"]

  memory_size   = 128
}