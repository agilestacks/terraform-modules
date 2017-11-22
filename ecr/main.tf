resource "aws_ecr_repository" "main" {
  name = "${var.name}"
}

resource "aws_ecr_repository_policy" "main" {
  repository = "${var.name}"
  policy = "${var.policy}"

  depends_on = ["aws_ecr_repository.main"]
}