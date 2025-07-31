terraform {
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~> 6.0"
      }
    }
    backend "s3" {
      bucket = "cfm-tf-state"
      key = "openvms-imagebuilder/state"
      region = "ap-southeast-2"
    }
}
