variable "ext_port" {
  type = map(any)

  # sensitive = true 
  # validation {
  #   condition     = max(var.ext_port["dev"]...) <= 65535 && min(var.ext_port["dev"]...) > 0
  #   error_message = "Internal port should always be 1180."
  # }


  # validation {
  #   condition     = max(var.ext_port["prod"]...) <= 65535 && min(var.ext_port["prod"]...) > 0
  #   error_message = "Internal port should always be 1180."
  # }
}


variable "image" {
  type        = map(any)
  description = "Image for container "
  default = {
    nodered = {
      dev  = "nodered/node-red:latest"
      prod = "nodered/node-red:latest"
    }
    influxdb = {
      dev  = "quay.io/influxdb/influxdb:2.0-nightly"
      prod = "quay.io/influxdb/influxdb:2.0-nightly"
    }
    grafana = {
      dev  = "grafana/grafana-enterprise"
      prod = "grafana/grafana-enterprise"
    }
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


# locals {
#   container_count = length(var.ext_port[terraform.workspace])
# } 



locals {
  deployment = {
    nodered = {
      container_count = length(var.ext_port["nodered"][terraform.workspace])
      source = "./image"
      image  = var.image["nodered"][terraform.workspace]
      int_port = 1880 
      ext_port = var.ext_port["nodered"][terraform.workspace]
      container_path = "/data"
      volumes = [
        {container_path_each = "/data" }
      ]

    }
    influxdb = {
      source = "./image"
      container_count = length(var.ext_port["influxdb"][terraform.workspace])
      image  = var.image["influxdb"][terraform.workspace]
      int_port = 8086 
      ext_port = var.ext_port["influxdb"][terraform.workspace]
      container_path = "/var/lib/influxdb"      
      volumes = [
        {container_path_each = "/var/lib/influxdb" }
      ]
    }
      grafana = {
      source = "./image"
      container_count = length(var.ext_port["grafana"][terraform.workspace])
      image  = var.image["grafana"][terraform.workspace]
      int_port = 3000
      ext_port = var.ext_port["grafana"][terraform.workspace]
      volumes  = [
        {container_path_each = "/var/lib/grafana" },
        {container_path_each = "/etc/grafana" }
      ]     
    }
  }
}

