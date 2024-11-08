resource "aws_imagebuilder_image" "openvms_image" {
  distribution_configuration_arn   = aws_imagebuilder_distribution_configuration.openvms_dist.arn
  image_recipe_arn                 = aws_imagebuilder_image_recipe.example.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.example.arn
}
