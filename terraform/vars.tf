variable "crop_tool_images" {
  type = string
  default = "crop-tool-images"
  description = "Bucket to store resized images"
}

variable "crop_tool_api" {
  type = string
  default = "crop-tool-api"
  description = "REST API for handling POST requests to crop-tool"
}

variable "path_part" {
  type        = string
  default     = "image"
  description = "The last path segment of this API resource."
}

variable "region" {
  type        = string
  default     = "eu-west-2"
  description = "Region in which to deploy AWS resources."
}