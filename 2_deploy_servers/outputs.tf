# Generate aditional outputs
output "lab_server_details" {
  value = {
    lab_url = "http://${local.hub_fgt}/${local.lab_token}"
    phpmyadmin_url = "http://${local.hub_fgt}/${local.random_url_db}"
  }
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
