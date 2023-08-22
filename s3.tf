resource "aws_s3_bucket" "example" {
  bucket = "s3statebackend-linda-lice"

  versioning {
    enabled = true
  }

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
