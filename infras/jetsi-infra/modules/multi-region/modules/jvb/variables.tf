variable "module_region" {
  description = "Module Region Name"
  type        = string
  default = "null"
}
variable "arrays" {
  description = "Module arrays var"
  type        = map(list(string))
  default     = {}
}