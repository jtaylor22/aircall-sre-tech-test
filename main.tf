terraform {
  backend "s3" {
    bucket = "crop-tool-terraform-state"
    key    = "state/"
    region = "eu-west-2"
  }
}
