resource "aws_ecr_repository" "project10_app_repo" {
  name                 = "app_repo"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    "env"       = "dev"
    "createdBy" = "gbenga"
  }
}

resource "aws_ecr_lifecycle_policy" "project10_repo_policy" {
  repository = aws_ecr_repository.project10_app_repo.name
  policy     = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire images older than 14 days",
            "selection": {
                "tagStatus": "any",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 14
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}