



module "image" {
  source   = "./image"
  image_in = var.image[terraform.workspace]
}


module "container" {
  source                  = "./container"
  count                   = local.container_count
  # depends_on              = [null_resource.docker_val]
  name_container_in       = join("-", ["zaza", terraform.workspace, random_string.random[count.index].result])
  image_container_in      = module.image.image_out
  internal_container_port = var.int_port
  external_container_port = var.ext_port[terraform.workspace][count.index]
  container_path          = "/data"
  host_path               = "${path.cwd}/noderedvol"
}


# resource "null_resource" "docker_val" {
#   provisioner "local-exec" {
#     command = "mkdir noderedvol/ || true && chown 1000:1000 noderedvol/ "
#   }
# }


resource "random_string" "random" {
  count   = local.container_count
  length  = 11
  special = false
  #   override_special = "/@£$"
  upper = false
}






