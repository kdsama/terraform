output "image_out" {
  value       = docker_image.nodered_image.latest
  description = "Ip address of the container"
}
