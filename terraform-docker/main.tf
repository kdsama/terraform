

terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.15.0"
    }
  }
}


provider "docker" {}



resource "docker_image" "nodered_image" {
  name = var.image[terraform.workspace]
}


resource "null_resource" "docker_val" {
  provisioner "local-exec" {
    command = "mkdir noderedvol/ || true && chown 1000:1000 noderedvol/ "
  }
}


resource "random_string" "random" {
  count   = local.container_count
  length  = 11
  special = false
  #   override_special = "/@£$"
  upper = false
}

resource "docker_container" "nodered_container" {
  count = local.container_count
  name  = join("-", ["zaza", terraform.workspace,random_string.random[count.index].result])
  // above resource needs to be referenced 
  image = docker_image.nodered_image.latest
  // latest provide the ID of the image . GIves a unique id that can be referenced 
  ports {
    internal = var.int_port
    external = var.ext_port[terraform.workspace][count.index]
  }
  volumes {
    container_path = "/data"
    host_path = "${path.cwd}/noderedvol"
  }
}




