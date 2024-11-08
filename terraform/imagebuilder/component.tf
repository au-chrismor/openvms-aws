resource "aws_imagebuilder_component" "update_os" {
  data = yamlencode(
    {
        phases = [
            {
                name = "build"
                steps = [
                    {
                        action = "UpdateOS"
                        name      = "UpdateOS"
                        onFailure = "Abort"
                    }
                ]
            }
        ]
        schemaVersion = 1.0
    }
    )
    name     = "${var.environment}-${var.project}-UpdateOS"
    platform = "Linux"
    version  = "1.0.0"
}

resource "aws_imagebuilder_component" "run_scripts" {
  data = yamlencode(
    {
        phases = [
            {
                name = "build"
                steps = [
                    {
                        action = "ExecuteBash"
                        inputs = {
                            commands = ["sudo dnf group install \"Virtualization Host\" -y"]
                        }
                        name      = "Install_KVM"
                        onFailure = "Continue"
                    },
                    {
                        action = "ExecuteBash"
                        inputs = {
                            commands = ["sudo dnf install qemu-img -y"]
                        }
                        name      = "Install_Qemu-Img"
                        onFailure = "Continue"
                    }
                ]
            }
        ]
        schemaVersion = 1.0
    }
    )
    name     = "${var.environment}-${var.project}-Install"
    platform = "Linux"
    version  = "1.0.0"
}

resource "aws_imagebuilder_component" "load_code" {
  data = yamlencode(
    {
        phases = [
            {
                name = "build"
                steps = [
                    {
                        action = "S3Download"
                        inputs = [{
                            source = "s3://${aws_s3_bucket.code_bucket.bucket}/${var.image_file}"
                            destination = "/tmp/${var.image_file}"
                        }]
                        maxAttempts = 3
                        name      = "Copy_Code"
                        onFailure = "Abort"
                    },
                    {
                        action = "ExecuteBash"
                        inputs = {
                            commands = [
                                "sudo mkdir -p /var/lib/libvirt/images",
                                "sudo mv /tmp/${var.image_file} /var/lib/libvirt/images"
                                ]
                        }
                        name      = "Install_Disc"
                        onFailure = "Abort"
                    }
                ]
            }
        ]
        schemaVersion = 1.0
    }
    )
    name     = "${var.environment}-${var.project}-App-Deploy"
    platform = "Linux"
    version  = "1.0.0"
}
