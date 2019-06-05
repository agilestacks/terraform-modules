resource "aws_ecr_repository" "main" {
  name = "${var.name}"
}

resource "aws_ecr_repository_policy" "main" {
  repository = "${aws_ecr_repository.main.name}"
  policy = "${var.policy}"
}