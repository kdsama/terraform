variable "ext_port" {
  type    = map
  
    # sensitive = true 
  validation {
    condition = max(var.ext_port["dev"]...) <= 65535 && min(var.ext_port["dev"]...) > 0 
    error_message = "Internal port should always be 1180."
  }


    validation {
    condition = max(var.ext_port["prod"]...) <= 65535 && min(var.ext_port["prod"]...) > 0 
    error_message = "Internal port should always be 1180."
  }
}


variable "image"{
  type = map 
  description = "Image for container "
  default = {

  dev = "nodered/node-red:latest"
  prod = "nodered/node-red:latest"
  }
}



variable "int_port" {
  type    = number
  default = 1180
  # validation {
  #   condition     = var.int_port == 1180
  #   error_message = "Internal port should always be 1180."
  # }
}
variable "container_count" {
  type    = number
  default = 2
}


locals {
  container_count = length(lookup(var.ext_port,terraform.workspace))
}