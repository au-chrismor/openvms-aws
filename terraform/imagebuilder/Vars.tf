variable "access_cidr" {
    type = string
    default = "0.0.0.0/0"
}

variable "aws_key_data" {
    type = string
}

variable "aws_region" {
    type = string
    default = "us-east-1"
}

variable "azs" {
    type = list(string)
    default = [ "a", "b", "c", "d", "e", "f"]
}

variable "base_ami" {
    type = string
}

variable "cost_centre" {
    type = string
}

variable "environment" {
    type = string
    default = "dev"
}

variable "image_file" {
    type = string
    default = "openvms-community.qcow2"
}

variable "instance_types" {
    type = list(string)
}

variable "owner" {
    type = string
}

variable "project" {
    type = string
}

variable "recipe_version" {
    type = string
}

variable "volume_size" {
    type = number
    default = 16
}
