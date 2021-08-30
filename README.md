# aircall-sre-tech-test
[![Terraform](https://github.com/jtaylor22/aircall-sre-tech-test/actions/workflows/terraform.yml/badge.svg)](https://github.com/jtaylor22/aircall-sre-tech-test/actions/workflows/terraform.yml)
[![Claudia](https://github.com/jtaylor22/aircall-sre-tech-test/actions/workflows/claudia.yml/badge.svg)](https://github.com/jtaylor22/aircall-sre-tech-test/actions/workflows/claudia.yml)

## Description
This solution to the deployment of the Crop-Image Node.js project uses 3 primary technologies:
1. Claudia
2. Terraform Cloud
3. Github Actions


## Prerequisites
### AWS Access Key
Both Claudia and Terraform authenticate to AWS using an AWS Access Key. To generate one please see: https://aws.amazon.com/premiumsupport/knowledge-center/create-access-key/

### Terraform Cloud Account
This solution uses Terraform Cloud as the automation tool to deploy Terraform resources to AWS, as as the backend for the remote Terraform State.

You can create a Terraform Cloud account for free here : https://app.terraform.io/session

Once created, login and perform the following:
1. Create Organization.
2. Create new Workspace.
3. Select API-Driven workflow
4. Name your workspace i.e aircall-sre-tech-test
5. add your AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY as Environment Variables in your workspace.
6. Add your organization and workspace to /terraform/main.tf

### Terraform Cloud API Token
Gitlab Actions requires an API Token to use Terraform Cloud. Then can be generated in your Terraform Cloud User Settings. 

### Github Secrets
In order for Claudia and Terraform to securely use the AWS Access Key and API Token, you will need to add them as Gitlab Secrets:
1. Click on settings on this project.
2. Select secrets
3. Add the following secrets with relevant values:
     * AWS_ACCESS_KEY_ID
     * AWS_SECRET_ACCESS_KEY
     * TF_API_TOKEN

## Claudia
![image](https://user-images.githubusercontent.com/20682803/131267726-a899f9e2-c40b-4536-a398-2706c8e30df1.png)

Claudia is used to automate the deployment of Node.js projects to AWS Lambda without the need of configuration tools like Terraform. Claudia authenticates to AWS using the 
AWS Access Key stored in Github Secrets. The deployment of a Node.js project to AWS Lambda can be done in one command:<br/>
`claudia create --region eu-west-2 --api-module app`


## Terraform Cloud
![image](https://user-images.githubusercontent.com/20682803/131269215-c0372871-453d-4702-b0b1-d666ef4ce7f4.png)<br/>
Terraform Cloud is used to build the following AWS resources:

* S3 - bucket for hosting images resized by the crop-image lambda.
* API Gateway - REST API for handling POST requests to /image
* Terraform Cloud Backend


## Github Actions
![image](https://user-images.githubusercontent.com/20682803/131269967-a3b9b380-af72-41ac-bab3-80070e7e6c84.png)<br/>

Two Workflows for Terraform and Claudia have been created to automate the deploment from a Git Push to Terraform Cloud deploying resources to AWS.
### Claudia Workflow
* Triggered by commits to /crop-tool or manually
* Installs npm
* Installs Claudia
* Initialises npm
* Builds AWS Lambda and deploys crop-tool Node.js project

### Terraform Workflow
* Triggered by commits to /crop-tool or manually
* Targets resouces in /terraform
* Triggers Terraform Cloud Workspace
* Runs terraform init/plan/apply


## Final Thoughts
This solution isn't perfect, and I decided to leave some more desirable features given the 1-6 hour suggested time limit for this project. Given more time, I would have implemented the following features:

1. Deployment Pipeline to destroy Terraform and Claudia resources
2. Claudia Update functionality so that the Claudia Workflow can be run multiple times.
3. More suitable method to add Terraform Cloud details to /terraform/main.tf
4. Suitable role without AdministratorAccess for Terraform Cloud and Claudia to use.
