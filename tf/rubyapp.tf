resource "aws_ecr_repository" "rubyapp_ecr_repo" {
  name                 = "sandbox-rubyapp"
  image_tag_mutability = "IMMUTABLE"
}
