# Outputs
output "hub" {
  value = module.r1_hub.hub
}
output "r1_users_fgt" {
  value = { for k, v in module.r1_users_fgt.user_fgts : k => v }
}
output "r2_users_fgt" {
  value = { for k, v in module.r2_users_fgt.user_fgts : k => v }
}
output "r3_users_fgt" {
  value = { for k, v in module.r3_users_fgt.user_fgts : k => v }
}

#-----------------------------------------------------------------------------------------------------
# Other deployments outputs
#-----------------------------------------------------------------------------------------------------
output "keypair_names" {
  value = {
    r1 = aws_key_pair.r1_keypair.key_name
    r2 = aws_key_pair.r2_keypair.key_name
    r3 = aws_key_pair.r3_keypair.key_name
  }
}
output "user_vm_ni_ids" {
  value = {
    r1 = module.r1_users_fgt.user_vm_ni_ids
    r2 = module.r2_users_fgt.user_vm_ni_ids
    r3 = module.r3_users_fgt.user_vm_ni_ids
  }
}
output "user_fgt_eip_public" {
  value = {
    r1 = module.r1_users_fgt.user_fgt_eip_public
    r2 = module.r2_users_fgt.user_fgt_eip_public
    r3 = module.r3_users_fgt.user_fgt_eip_public
  }
}
output "hub_bastion_ni" {
  value = module.r1_hub.hub_bastion_ni
}