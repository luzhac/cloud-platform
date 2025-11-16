


variable "public_subnets" {
  description = "List of subnet IDs for EFS mount targets"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group ID to allow  "
  type        = string
}
