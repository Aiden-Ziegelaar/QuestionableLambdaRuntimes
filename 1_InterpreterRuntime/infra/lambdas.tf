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
    name               = "interpreter_runtime"
    assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "basic_execution_role_policy_attachment" {
    role        = aws_iam_role.lambda_role.name
    policy_arn  = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "archive_file" "lambda_archive" {
  type        = "zip"
  source_file = "${path.module}/../code/target/lambda/EmbeddedInterpreter/bootstrap"
  output_path = "${path.module}/../code/dist/bootstrap.zip"
}

resource "aws_lambda_function" "lambda" {
  filename      = data.archive_file.lambda_archive.output_path
  function_name = "InterpreterRuntime"
  role          = aws_iam_role.lambda_role.arn

  handler = "bootstrap"

  source_code_hash = data.archive_file.lambda_archive.output_base64sha256

  runtime = "provided.al2023"

  architectures = ["arm64"]

  memory_size = 128
}
