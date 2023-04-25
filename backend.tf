//Parameter to upload the state file on S3 Bucket

terraform {
  backend "s3" {
    bucket         = "terraformpocbucket"
    key            = "terraform/state"
    region         = "ap-south-1"
    encrypt        = true
    #dynamodb_table = "terraform-state-lock"
  }
}


// Uncomment the following resource block to enable state locking
// Remember to replace the attributes as needed!
/*
resource "aws_dynamodb_table" "terraform-state-lock" {
  name         = "terraform-state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
*/