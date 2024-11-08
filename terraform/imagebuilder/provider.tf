provider "aws" {
    default_tags {
      tags = {
        Environment = var.environment
        Owner = var.owner
        Project = var.project
      }
    }
    region = var.aws_region
}
