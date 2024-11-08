terraform {
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
      }
    }
    backend "s3" {
      bucket = "cfm-tf-state"
      key = "hilife-imagebuilder/state"
      region = "ap-southeast-2"
    }
}
