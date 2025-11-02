terraform {
  backend "s3" {
    bucket         = "my-terraform-state-fromars1"
    key            = "network/terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}