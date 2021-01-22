
terraform {
  backend "s3" {
    bucket      = "2b43b021-0da4-4664-9a3f-4b7b2bac0c05-terraform-state"
    key         = "jenkins-test"
    region      = "eu-west-2"
    access_key  = "AKIAQOK6BH64YUS2PQKS"
    secret_key  = "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"
    encrypt     = true
  }
}