 # The configuration for the `remote` backend.
terraform {
   backend "remote" {
   organization =  "aircall-sre-tech-test"
     workspaces {
       name = "aircall-sre-tech-test"
     }
   }
 }
