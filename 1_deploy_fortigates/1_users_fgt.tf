# Crate Users FGT in Region 1
module "r1_users_fgt" {
  source = "./modules/user_fgt"

  rsa_public_key = trimspace(tls_private_key.ssh.public_key_openssh)
  api_key        = trimspace(random_string.api_key.result)
  key_pair_name  = aws_key_pair.r1_keypair.key_name
  instance_type  = local.fgt_instance_type
  fgt_build      = local.fgt_build

  region = local.r1_region

  prefix         = local.prefix
  spoke_prefix   = "r1"
  spoke_cidr_net = "1" // "10.${spoke_cidr_net}.${user_number}.0/24"

  number_users = local.number_users
  vpn_hubs     = module.r1_hub.vpn_hubs

  app1_external_port = local.app1_external_port
  app2_external_port = local.app2_external_port
  app1_mapped_port   = local.app1_mapped_port
  app2_mapped_port   = local.app2_mapped_port

  access_key = var.access_key
  secret_key = var.secret_key
}
# Crate Users FGT in Region 2
module "r2_users_fgt" {
  source = "./modules/user_fgt"

  region = local.r2_region

  rsa_public_key = trimspace(tls_private_key.ssh.public_key_openssh)
  api_key        = trimspace(random_string.api_key.result)
  key_pair_name  = aws_key_pair.r2_keypair.key_name
  instance_type  = local.fgt_instance_type
  fgt_build      = local.fgt_build

  prefix         = local.prefix
  spoke_prefix   = "r2"
  spoke_cidr_net = "2" // "10.${spoke_cidr_net}.${user_number}.0/24"

  number_users = local.number_users
  vpn_hubs     = module.r1_hub.vpn_hubs

  app1_external_port = local.app1_external_port
  app2_external_port = local.app2_external_port
  app1_mapped_port   = local.app1_mapped_port
  app2_mapped_port   = local.app2_mapped_port

  access_key = var.access_key
  secret_key = var.secret_key
}
# Crate Users FGT in Region 3
module "r3_users_fgt" {
  source = "./modules/user_fgt"

  region = local.r3_region

  rsa_public_key = trimspace(tls_private_key.ssh.public_key_openssh)
  api_key        = trimspace(random_string.api_key.result)
  key_pair_name  = aws_key_pair.r3_keypair.key_name
  instance_type  = local.fgt_instance_type
  fgt_build      = local.fgt_build

  prefix         = local.prefix
  spoke_prefix   = "r3"
  spoke_cidr_net = "3" // "10.${spoke_cidr_net}.${user_number}.0/24"

  number_users = local.number_users
  vpn_hubs     = module.r1_hub.vpn_hubs

  app1_external_port = local.app1_external_port
  app2_external_port = local.app2_external_port
  app1_mapped_port   = local.app1_mapped_port
  app2_mapped_port   = local.app2_mapped_port

  access_key = var.access_key
  secret_key = var.secret_key
}










#-----------------------------------------------------------------------
# Necessary resources
#
data "http" "my-public-ip" {
  url = "http://ifconfig.me/ip"
}
// Create key-pair
resource "aws_key_pair" "r1_keypair" {
  key_name   = "${local.prefix}-r1-keypair"
  public_key = tls_private_key.ssh.public_key_openssh
}
resource "aws_key_pair" "r2_keypair" {
  provider = aws.r2

  key_name   = "${local.prefix}-r2-keypair"
  public_key = tls_private_key.ssh.public_key_openssh
}
resource "aws_key_pair" "r3_keypair" {
  provider = aws.r3

  key_name   = "${local.prefix}-r3-keypair"
  public_key = tls_private_key.ssh.public_key_openssh
}
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 2048
}
resource "local_file" "ssh_private_key_pem" {
  content         = tls_private_key.ssh.private_key_pem
  filename        = "./ssh-key/${local.prefix}-ssh-key.pem"
  file_permission = "0600"
}
# Create new random API key to be provisioned in FortiGates.
resource "random_string" "api_key" {
  length  = 30
  special = false
  numeric = true
}
# Create new random API key to be provisioned in FortiGates.
resource "random_string" "vpn_psk" {
  length  = 30
  special = false
  numeric = true
}