variable "aws_region" {
  description = "The AWS region to use"
  default     = "eu-west-1"
}
variable "bucket_name" {
  type        = string
  default = "matibucket-test"
  description = "The name of the bucket without the www. prefix. Normally domain_name."
}