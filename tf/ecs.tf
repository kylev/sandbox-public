data "aws_ecs_cluster" "rubyapp_ecs" {
  cluster_name = "ecs-mongo-production"
}
