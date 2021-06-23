output s3_bucket_name {
    value = aws_s3_bucket.website_bucket.bucket
}

output API_url {
    value = aws_api_gateway_deployment.LicytomatAPIDeployment.invoke_url
}