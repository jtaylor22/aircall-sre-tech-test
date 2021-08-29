provider "aws" {
  region = "eu-west-2"
}

terraform {
   backend "remote" {
     organization = "aircall-sre-tech-test"
     workspaces {
       name = "aircall-sre-tech-test"
     }
   }
 }
