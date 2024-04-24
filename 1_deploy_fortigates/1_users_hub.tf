# Create LAB HUB
module "r1_hub" {
  source = "./modules/hub"

  rsa_public_key = trimspace(tls_private_key.ssh.public_key_openssh)
  api_key        = trimspace(random_string.api_key.result)
  key_pair_name  = aws_key_pair.r1_keypair.key_name
  instance_type  = local.fgt_instance_type
  fgt_build      = local.fgt_build

  region = local.r1_region

  prefix       = local.prefix
  hub_vpc_cidr = "10.0.0.0/24"
  vpn_psk      = trimspace(random_string.vpn_psk.result)

  app_external_port = local.lab_server_external_port
  app_mapped_port   = local.lab_server_mapped_port
}

