resource "aws_imagebuilder_image_recipe" "recipe" {
    name = "${var.environment}-${var.project}-recipe"
    version = var.recipe_version
    parent_image = var.base_ami

    block_device_mapping {
      device_name = "/dev/xvda"

      ebs {
        delete_on_termination = true
        volume_size = var.volume_size
        volume_type = "gp2"
      }
    }

    component {
        component_arn = aws_imagebuilder_component.update_os.arn
    }
    component {
        component_arn = aws_imagebuilder_component.run_scripts.arn
    }
    component {
      component_arn = aws_imagebuilder_component.install_monitor.arn
    }
    component {
        component_arn = aws_imagebuilder_component.load_code.arn
    }
}
