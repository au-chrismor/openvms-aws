resource "aws_imagebuilder_distribution_configuration" "openvms_dist" {
  name = "openvms-distribution"

  distribution {
    ami_distribution_configuration {
      ami_tags = {
        CostCenter = var.cost_centre
        Owner = var.owner
        Project = var.project
      }

      name = "openvms-{{ imagebuilder:buildDate }}"
    }

    region = var.aws_region
  }
}