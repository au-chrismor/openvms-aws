resource "aws_imagebuilder_distribution_configuration" "openvms_dist" {
  name = "example"

  distribution {
    ami_distribution_configuration {
      ami_tags = {
        CostCenter = var.cost_centre
        Owner = var.owner
        Project = var.project
      }

      name = "openvms-{{ imagebuilder:buildDate }}"

      launch_permission {
        user_ids = ["123456789012"]
      }
    }

    launch_template_configuration {
      launch_template_id = "lt-0aaa1bcde2ff3456"
    }

    region = "us-east-1"
  }
}