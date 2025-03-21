data "aws_iam_policy_document" "ecr_repository_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = [
        "ecr:BatchGetImage",
        "ecr:GetDownloadUrlForLayer"
    ]
  }
}

resource "aws_ecr_repository" "cobol_library_runtime" {
  name                 = "cobol_library_runtime"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}

resource "aws_ecr_repository_policy" "cobol_library_runtime_policy_attachement" {
  repository = aws_ecr_repository.cobol_library_runtime.name
  policy     = data.aws_iam_policy_document.ecr_repository_policy.json
}