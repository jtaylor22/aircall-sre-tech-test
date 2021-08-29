resource "aws_s3_bucket" "crop_tool_images" {
  bucket = var.crop_tool_images
  acl    = "private"

  tags = {

    Name = var.crop_tool_images

  }
}
