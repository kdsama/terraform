
resource "random_string" "random" {
  # for_each = local.deployment
  count   = var.count_in
  length  = 11
  special = false
  #   override_special = "/@£$"
  upper = false
}







resource "docker_container" "app_container" {
  name  = join("-", [var.name_container_in, terraform.workspace, random_string.random[count.index].result])
  image = var.image_container_in
  count = var.count_in
  
  ports {
   internal = var.internal_container_port
   external = var.external_container_port[count.index]
  }
  
  dynamic "volumes" {
    for_each = var.volumes_in 
    content {
      container_path = volumes.value["container_path_each"]
      volume_name = module.volumes[count.index].volume_output[volumes.key]
    }

  }
    provisioner "local-exec"{
    command = "echo ${self.name} : ${self.ip_address}:${join("",[for x in self.ports[*]["external"]: x])} >> containers.txt"
  }
  provisioner "local-exec"{
    when = destroy 
    command = "rm containers.txt"
    on_failure=continue
  }
}

module "volumes"{
  source= "./volume"
  count = var.count_in
  volume_count = length(var.volumes_in)
  volume_name = "${var.name_container_in}-${terraform.workspace}-${random_string.random[count.index].result}--volume"
}