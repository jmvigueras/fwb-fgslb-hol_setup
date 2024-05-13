#-----------------------------------------------------------------------------------------------------
# FortiGate Terraform deployment
# Active Passive High Availability MultiAZ with AWS Transit Gateway with VPC standard attachment
#-----------------------------------------------------------------------------------------------------
locals {
  #-----------------------------------------------------------------------------------------------------
  # General variables
  #-----------------------------------------------------------------------------------------------------
  prefix = "fwb-hol"

  r1_region = {
    id  = "eu-west-1"
    az1 = "eu-west-1a"
    az2 = "eu-west-1c"
  }
  r2_region = {
    id  = "eu-west-2"
    az1 = "eu-west-2a"
    az2 = "eu-west-2c"
  }
  r3_region = {
    id  = "eu-west-3"
    az1 = "eu-west-3a"
    az2 = "eu-west-3c"
  }

  #-----------------------------------------------------------------------------------------------------
  # APP details 
  #-----------------------------------------------------------------------------------------------------
  k8s_instance_type = "t3.xlarge"

  app1_mapped_port = "31000"
  app2_mapped_port = "31001"

  #--------------------------------------------------------------------------------------------
  # Server LAB variables
  #--------------------------------------------------------------------------------------------
  # LAB server FQDN
  lab_fqdn = "workshop.fortidemoscloud.com"

  lab_token = trimspace(random_string.lab_token.result)

  # Instance type 
  lab_srv_type = "t3.2xlarge"

  # Git repository
  git_uri          = "https://github.com/jmvigueras/fwb-fgslb-hol_setup.git"
  git_uri_app_path = "/fwb-fgslb-hol_setup/0_modules/hub-server/"

  # DB
  random_url_db = trimspace(random_string.db_url.result)

  db = {
    db_host  = "mysqldb"
    db_user  = "root"
    db_pass  = local.random_url_db
    db_name  = "students"
    db_table = "students"
    db_port  = "3306"
  }

  #-----------------------------------------------------------------------------------------------------
  # Other deployments variables 
  #-----------------------------------------------------------------------------------------------------
  keypair_names       = data.terraform_remote_state.deploy_fortigates.outputs.keypair_names
  user_vm_ni_ids      = data.terraform_remote_state.deploy_fortigates.outputs.user_vm_ni_ids
  user_fgt_eip_public = data.terraform_remote_state.deploy_fortigates.outputs.user_fgt_eip_public
  hub_bastion_ni      = data.terraform_remote_state.deploy_fortigates.outputs.hub_bastion_ni
  hub_fgt             = data.terraform_remote_state.deploy_fortigates.outputs.hub["fgt_public"]

  #-----------------------------------------------------------------------------------------------------
  # Outputs 
  #-----------------------------------------------------------------------------------------------------
  o_users_vms = merge(module.r1_users_vm.user_vms, module.r2_users_vm.user_vms, module.r3_users_vm.user_vms)
}

# Get state file from day0 deployment
data "terraform_remote_state" "deploy_fortigates" {
  backend = "local"
  config = {
    path = "../1_deploy_fortigates/terraform.tfstate"
  }
}
# Create random string for DB phpmyadmin url name
resource "random_string" "db_url" {
  length  = 10
  special = false
  numeric = false
}
# Create random string for access LAB
resource "random_string" "lab_token" {
  length  = 30
  special = false
  numeric = false
}