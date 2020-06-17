variable "aws_region" {
  type        = string
  description = "AWS Region this resource will be deployed"
  default     = "us-east-2"
}

variable "owner" {
  default = "sachinm"
}

variable "project" {
  default = "ssh"
}

variable "vpc_cidr" {
  default = "172.31.16.0/20"
}

variable "aws_profile" {
  type        = string
  description = "AWS Profile to be used"
  default     = "default"
}

variable "server_port" {
  type        = number
  default     = 80
  description = "Port the ec2 will listen on"
}


variable "all_cidr" {
  default = "0.0.0.0/0"
}


variable "ssh_port" {
  type        = number
  default     = 22
  description = "SSH Port"
}

variable "aws_key_pair_name" {
  type        = string
  default     = null
  description = "AWS Key Pair Name"
}



variable "ssh_public_key_path" {
  default = "~/.ssh/id_rsa.pub"
}
