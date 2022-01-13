output "image_out" {
  value       = docker_image.container_image.latest
  description = "Ip address of the container"
}
