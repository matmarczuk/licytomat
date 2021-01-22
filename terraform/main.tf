provider "aws" {
    region = var.aws_region
}

terraform {
    required_version = ">= 0.12"
    backend "s3" {
        key    = "terraform.tfstate"
    }
}