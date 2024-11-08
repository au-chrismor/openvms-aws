resource "aws_imagebuilder_infrastructure_configuration" "infra_config" {
    description = "${var.environment}-${var.project}}-Infrastructure"  
    instance_profile_name = aws_iam_instance_profile.instance_profile.name
    instance_types = var.instance_types
    key_pair = aws_key_pair.image_builder.key_name
    name = "${var.environment}-${var.project}-infra"
    terminate_instance_on_failure = true
}

resource "aws_key_pair" "image_builder" {
    public_key = var.aws_key_data
    key_name = "${var.environment}-${var.project}-factory-key"
}
