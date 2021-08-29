variable "crop_tool_images" {
  type = string
  default = "crop-tool-images"
  description = "bucket to store resized images"
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
