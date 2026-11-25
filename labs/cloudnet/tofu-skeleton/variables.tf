# Values you may change in one place. Your tasks add more (for example site_name).

variable "name" {
  description = "Prefix for Name tags"
  type        = string
  default     = "cloudnet"
}

variable "instance_type" {
  description = "EC2 type for the servers: t3.micro is on the Free plan's list"
  type        = string
  default     = "t3.micro"
}
