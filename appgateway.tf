
module "appgateway" {
	source                  = "./applicationgateway"

  prefix                  = local.prefix

  location                = local.location_map["region1"]
  resourcegroup_name      = local.resource_group_hub_names["resourcegroup_name_fortitest"]
  subnet_id               = local.subnet_ids_map["fwtest-client"]
  subnet_prefix           = local.subnet_prefix_map["fwtest-client"]

  site1_hostname          = var.hostname        # e.g. w1.grilledsalmon.me
  site1_cert              = var.cert_file_path  # path to pfx file
  site1_cert_password     = var.cert_file_password

  public_ip_prefix_id     = local.public_ip_prefix.id
}

