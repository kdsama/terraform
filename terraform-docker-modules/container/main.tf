resource "docker_container" "nodered_container" {
  name  = var.name_container_in  
  image = var.image_container_in
  
  
  ports {
   internal = var.internal_container_port
   external = var.external_container_port
  }
  
  volumes {
    container_path = var.container_path
    volume_name = docker_volume.container_volume.name
  }
}

resource "docker_volume" "container_volume"{
  name = "$docker_container.nodered_container.name}--volume"
  lifecycle {
      prevent_destroy=false
  }
}