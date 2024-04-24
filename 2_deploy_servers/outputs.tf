# Generate aditional outputs
output "lab_server" {
  value = module.lab_server.vm
}
output "r1_users_vms" {
  value = module.r1_users_vm.user_vms
}
output "r2_users_vms" {
  value = module.r2_users_vm.user_vms
}
output "r3_users_vms" {
  value = module.r3_users_vm.user_vms
}
