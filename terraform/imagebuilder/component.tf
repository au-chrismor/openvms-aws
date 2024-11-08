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
                            source = "s3://${aws_s3_bucket.code_bucket.bucket}/${var.code_file}"
                            destination = "/tmp/${var.code_file}"
                        }]
                        maxAttempts = 3
                        name      = "Copy_Code"
                        onFailure = "Abort"
                    },
                    {
                        action = "ExecuteBash"
                        inputs = {
                            commands = [
                                "cd /opt",
                                "sudo mkdir -p /opt/app",
                                "sudo tar -xvf /tmp/${var.code_file} -C /opt/app"
                                ]
                        }
                        name      = "Install_App"
                        onFailure = "Abort"
                    },
                    {
                        action = "ExecuteBash"
                        inputs = {
                            commands = [
                                "cd /opt/app",
                                "chmod +x ./run.sh"
                                ]
                        }
                        name      = "Configure_App"
                        onFailure = "Continue"
                    },
                    {
                        action = "ExecuteBash"
                        inputs = {
                            commands = [
                                "cd /opt/app",
                                "sudo sed 's/__LICENSE_KEY__/${var.newrelic_license}/' /tmp/${var.newrelic_ini_file} > /opt/app/newrelic.ini"
                                ]
                        }
                        name      = "Configure_NrIni"
                        onFailure = "Continue"
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

resource "aws_imagebuilder_component" "install_monitor" {
  data = yamlencode(
    {
        phases = [
            {
                name = "build"
                steps = [
                    {
                        action = "ExecuteBash"
                        inputs = {
                            commands = ["curl -Ls https://download.newrelic.com/install/newrelic-cli/scripts/install.sh | bash && sudo NEW_RELIC_API_KEY=${var.newrelic_user} NEW_RELIC_ACCOUNT_ID=${var.newrelic_account} /usr/local/bin/newrelic install -y"]
                        }
                        name      = "Install_Newrelic"
                        onFailure = "Continue"
                    },
                    {
                        action = "S3Download"
                        inputs = [{
                            source = "s3://${var.config_bucket}/${var.newrelic_ini_file}"
                            destination = "/tmp/${var.newrelic_ini_file}"
                        }]
                        maxAttempts = 3
                        name      = "Copy_Nr_Ini"
                        onFailure = "Abort"
                    },
                    {
                        action = "ExecuteBash"
                        inputs = {
                            commands = ["sudo pip3 install newrelic"]
                        }
                        name      = "Install_nr_python"
                        onFailure = "Abort"
                    }

                ]
            }
        ]
        schemaVersion = 1.0
    }
    )
    name     = "${var.environment}-${var.project}-Install-Monitor"
    platform = "Linux"
    version  = "1.0.0"
}
