resource "aws_s3_bucket" "website_bucket" {
  bucket = "${var.bucket_name}"
  acl    = "public-read"
  policy = templatefile("policies/s3-public-policy.json", { bucket = "${var.bucket_name}" })

#   cors_rule {
#     allowed_headers = ["Authorization", "Content-Length"]
#     allowed_methods = ["GET", "POST"]
#     allowed_origins = ["https://www.${var.domain_name}"]
#     max_age_seconds = 3000
#   }

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

resource "aws_s3_bucket_object" "photos_dir" {
    bucket  = aws_s3_bucket.website_bucket.id
    key     =  "photos/"
    content_type = "application/x-directory"
}