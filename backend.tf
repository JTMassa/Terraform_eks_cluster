terraform {
  backend "s3" {
    bucket         = "terrafom-week15-bucket"
    key            = "eks/terraform.tfstate"
    region         = "us-east-1"
    //dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
}
