//Output important pieces of information ==> Output cannot have spaces
output "IP_ADDRESS" {
  value       = [for i in docker_container.nodered_container[*] : join(":", [i.ip_address], i.ports[*].external)]
  description = "Ip address of the container"
  sensitive = true 
}
output "CONTAINER_NAME" {
  value       = docker_container.nodered_container.name
  description = "Ip address of the container"
}



