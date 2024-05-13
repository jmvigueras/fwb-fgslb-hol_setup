# Generate aditional outputs
output "lab_server_details" {
  value = {
    lab_url = "http://${local.hub_fgt}/${local.lab_token}"
    phpmyadmin_url = "http://${local.hub_fgt}/${local.random_url_db}"
  }
}
output "users_vms" {
  value = local.o_users_vms
}
