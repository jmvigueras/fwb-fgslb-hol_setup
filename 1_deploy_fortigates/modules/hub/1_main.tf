#------------------------------------------------------------------------------
# Create FGT cluster EU
# - VPC (associated to TGW default RT)
# - FGT Config
# - FGT instance
#------------------------------------------------------------------------------
// Create VPC for hub EU
module "hub_vpc" {
  source = "./sub_modules/aws_fgt_vpc"

  prefix     = "${var.prefix}-hub"
  admin_cidr = var.admin_cidr
  admin_port = var.admin_port
  region     = var.region

  vpc_cidr = var.hub_vpc_cidr
}
// Create config for FGT hub (FGCP)
module "hub_config" {
  source = "./sub_modules/aws_fgt_config"

  admin_cidr     = var.admin_cidr
  admin_port     = var.admin_port
  rsa-public-key = var.rsa_public_key
  api_key        = var.api_key

  subnet_cidrs = module.hub_vpc.subnet_az1_cidrs
  fgt_ni_ips   = module.hub_vpc.fgt_ni_ips

  license_type = var.license_type

  fgt_extra-config = join("\n",
    [data.template_file.hub_extra_config_lab_server.rendered],
    [data.template_file.hub_extra_config_lab_server_ssh.rendered]
  )

  config_hub = true
  hub        = local.hub

  vpc-spoke_cidr = [var.hub_vpc_cidr]
}
// Create data templates extra-config fgt
data "template_file" "hub_extra_config_lab_server" {
  template = file("${path.module}/templates/fgt_vip.conf")
  vars = {
    external_ip   = module.hub_vpc.fgt_ni_ips["public"]
    mapped_ip     = cidrhost(module.hub_vpc.subnet_az1_cidrs["bastion"], 10)
    external_port = var.app_external_port
    mapped_port   = var.app_mapped_port
    public_port   = "port1"
    private_port  = "port2"
    suffix        = var.app_external_port
  }
}
// Create data templates extra-config fgt
data "template_file" "hub_extra_config_lab_server_ssh" {
  template = file("${path.module}/templates/fgt_vip.conf")
  vars = {
    external_ip   = module.hub_vpc.fgt_ni_ips["public"]
    mapped_ip     = cidrhost(module.hub_vpc.subnet_az1_cidrs["bastion"], 10)
    external_port = "2222"
    mapped_port   = "22"
    public_port   = "port1"
    private_port  = "port2"
    suffix        = "2222"
  }
}
// Create FGT
module "hub" {
  source = "./sub_modules/aws_fgt"

  prefix        = "${var.prefix}-hub"
  region        = var.region
  instance_type = var.instance_type
  keypair       = var.key_pair_name

  license_type = var.license_type
  fgt_build    = var.fgt_build

  fgt_ni_ids = module.hub_vpc.fgt_ni_ids
  fgt_config = module.hub_config.fgt_config
}
// Create NIC for Users VM
resource "aws_network_interface" "hub_bastion_ni" {
  subnet_id         = module.hub_vpc.subnet_az1_ids["bastion"]
  security_groups   = [module.hub_vpc.nsg_ids["bastion"]]
  private_ips       = [cidrhost(module.hub_vpc.subnet_az1_cidrs["bastion"], 10)]
  source_dest_check = false
  tags = {
    Name = "${var.prefix}-lab-server"
  }
}