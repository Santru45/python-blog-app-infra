terraform {
  backend "s3" {
    bucket = "terraform-python-app-bucket"
    key    = "devops-project-1/terraform.tfstate"
    region = "eu-central-1"
  }
}