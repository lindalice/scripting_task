resource "aws_s3_bucket" "mybucket" {
  bucket = "s3statebackend-linda-lice"
  versioning {
    enabled = true
  }

}

resource "aws_dynamodb_table" "statelock" {
  name         = "state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
