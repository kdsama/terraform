



module "image" {

  for_each = local.deployment
  source   = "./image"
  image_in = each.value.image
}

# module "influx_image" {
#   source   = "./image"
#   image_in = var.image["influxdb"][terraform.workspace]
# }


module "container" {
  source = "./container"
  # count  = local.container_count
  for_each = local.deployment
  count_in = each.value.container_count
  # depends_on              = [null_resource.docker_val]
  name_container_in       = each.key
  image_container_in      = module.image[each.key].image_out
  internal_container_port = each.value.int_port
  external_container_port = each.value.ext_port
  volumes_in          = each.value.volumes
  
}





