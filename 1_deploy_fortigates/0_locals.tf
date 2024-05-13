#-----------------------------------------------------------------------------------------------------
# FortiGate Terraform deployment
# Active Passive High Availability MultiAZ with AWS Transit Gateway with VPC standard attachment
#-----------------------------------------------------------------------------------------------------
locals {
  #-----------------------------------------------------------------------------------------------------
  # General variables
  #-----------------------------------------------------------------------------------------------------
  prefix = "fwb-hol"

  # Number of users peer region
  number_users = 1

  # Regions to deploy
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
  # FGT details 
  #-----------------------------------------------------------------------------------------------------
  admin_port        = "8443"
  admin_cidr        = "0.0.0.0/0"
  fgt_instance_type = "c6i.large"
  fgt_build         = "build2573"
  license_type      = "payg"

  #-----------------------------------------------------------------------------------------------------
  # APP details 
  #-----------------------------------------------------------------------------------------------------
  app1_external_port = "31000"
  app2_external_port = "31001"
  app1_mapped_port   = "31000"
  app2_mapped_port   = "31001"

  lab_server_external_port = "80"
  lab_server_mapped_port   = "80"

  #-----------------------------------------------------------------------------------------------------
  # Outputs
  #-----------------------------------------------------------------------------------------------------
  r1_users_fgt = { for k, v in module.r1_users_fgt.user_fgts : k => v }
  r2_users_fgt = { for k, v in module.r2_users_fgt.user_fgts : k => v }
  r3_users_fgt = { for k, v in module.r3_users_fgt.user_fgts : k => v }

  users_fgt = merge(local.r1_users_fgt, local.r2_users_fgt, local.r3_users_fgt)
}
