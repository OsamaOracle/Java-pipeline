variable "region" {
  type        = string
  description = "AWS Region"
}

variable "env" {
  type        = string
  description = "Environment"
  default     = "dev"
}

variable "cidr_block" {
  type        = string
  description = "CIDR Block for the VPC"
}

variable "web_instance_type" {
  type        = string
  description = "Instance type for Web instance"
  default     = "t2.micro"
}

variable "web_min" {
  type        = number
  description = "Minimum number of Web instances for the ASG"
}

variable "web_max" {
  type        = number
  description = "Maximum number of web instances for the ASG"
}

variable "keypair" {
  type        = string
  description = "Name of AWS Key Pair to use for SSH"
}