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

resource "aws_s3_object" "disc_file" {
    for_each = fileset("files/", "*.qcow2")
    bucket = aws_s3_bucket.code_bucket.id
    key = each.value
    source = "files/${each.value}"
}

