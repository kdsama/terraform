//Output important pieces of information ==> Output cannot have spaces
output "IP_ADDRESS" {
  value       = module.container[*].IP_ADDRESS
  description = "Ip address of the container"
  sensitive   = true

}
output "CONTAINER_NAME" {
  value       = module.container[*].CONTAINER_NAME
  description = "Ip address of the container"
}



