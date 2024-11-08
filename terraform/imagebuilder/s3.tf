resource "aws_s3_bucket" "code_bucket" {
    force_destroy = true
    tags = {
        Project                     = var.project
        Owner                       = var.owner
        Environment                 = var.environment
    }
}

resource "aws_s3_bucket" "config_bucket" {
    force_destroy = true
    tags = {
        Project                     = var.project
        Owner                       = var.owner
        Environment                 = var.environment
    }
}
