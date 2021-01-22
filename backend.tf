
terraform {
  backend "s3" {
    bucket      = "2b43b021-0da4-4664-9a3f-4b7b2bac0c05-terraform-state"
    key         = "jenkins-test"
    region      = "eu-west-2"
    encrypt     = true
    access_key  = var.AWS_ACCESS_KEY
    secrey_key  = var.AWS_SECRET_KEY
  }
}
