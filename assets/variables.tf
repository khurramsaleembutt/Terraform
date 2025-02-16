
#Required: AWS Profile. Either put default in the variable input or leave it blank to keep the terraform execution working
variable "profile" {
  default = "default"
}
#Required: AWS Region. This one will have priority over aws environment variables or configuration file credentials
variable "region" {
  default = "ap-south-1"
}
