#---------------------------------------------------------- Transit ----------------------------------------------------------
module "AZ_transit_1_fw" {
  source  = "terraform-aviatrix-modules/mc-transit/aviatrix"
  version = "2.1.5"

  cloud                    = "azure"
  name                     = "lab-AZ-trans-1"
  region                   = "UK South"
  local_as_number          = "65001"
  account                  = var.avx_ctrl_account_azure
  ha_gw                    = false
  cidr                     = "10.111.0.0/23"
  enable_transit_firenet   = true
}

module "AZ_transit_1_deployFW" {
  source = "terraform-aviatrix-modules/mc-firenet/aviatrix"
  version = "v1.1.2"
  transit_module = module.AZ_transit_1_fw

  firewall_image           = "Palo Alto Networks VM-Series Flex Next-Generation Firewall Bundle 1"
    firewall_image_version   = "10.1.4"
    username                 = var.palo_username
    password                 = var.palo_password
    bootstrap_storage_name_1 = var.palo_bootstrap_storage_name_1
    storage_access_key_1     = var.azure_storage_access_key_1
    file_share_folder_1      = var.palo_file_share_folder_1
}


#--------------------------------------------------------- SPOKE 1 --------------------------------------------------------
module "az_spoke_1" {
  source     = "terraform-aviatrix-modules/mc-spoke/aviatrix"
  version    = "1.2.4"
  name       = "lab-AZ-spoke-1"
  cloud      = "azure"
  region     = "UK South"
  cidr       = "10.112.0.0/16"
  transit_gw = module.AZ_transit_1_fw.transit_gateway.gw_name
  account    = var.avx_ctrl_account_azure
  depends_on = [
    module.AZ_transit_1_fw
  ]
}

module "spoke_1_vm1" {
  source    = "./terraform-azure-instance-build-module"
  name      = "lab-spoke1-vm1"
  region    = "UK South"
  rg        = module.az_spoke_1.vpc.resource_group
  subnet_id = module.az_spoke_1.vpc.public_subnets[1].subnet_id
  ssh_key   = var.ssh_key
  public_ip = true
  depends_on = [
    module.az_spoke_1
  ]
}

module "spoke_1_vm2" {
  source    = "./terraform-azure-instance-build-module"
  name      = "lab-spoke1-vm2"
  region    = "UK South"
  rg        = module.az_spoke_1.vpc.resource_group
  subnet_id = module.az_spoke_1.vpc.private_subnets[1].subnet_id
  ssh_key   = var.ssh_key
  public_ip = true
  depends_on = [
    module.az_spoke_1
  ]
}

module "spoke_1_vm3" {
  source    = "./terraform-azure-instance-build-module"
  name      = "lab-spoke1-vm3"
  region    = "UK South"
  rg        = module.az_spoke_1.vpc.resource_group
  subnet_id = module.az_spoke_1.vpc.public_subnets[1].subnet_id
  ssh_key   = var.ssh_key
  public_ip = true
  depends_on = [
    module.az_spoke_1
  ]
}

module "spoke_1_vm4" {
  source    = "./terraform-azure-instance-build-module"
  name      = "lab-spoke1-vm4"
  region    = "UK South"
  rg        = module.az_spoke_1.vpc.resource_group
  subnet_id = module.az_spoke_1.vpc.public_subnets[2].subnet_id
  ssh_key   = var.ssh_key
  public_ip = true
  depends_on = [
    module.az_spoke_1
  ]
}

module "spoke_1_vm5" {
  source    = "./terraform-azure-instance-build-module"
  name      = "lab-spoke1-vm5"
  region    = "UK South"
  rg        = module.az_spoke_1.vpc.resource_group
  subnet_id = module.az_spoke_1.vpc.public_subnets[2].subnet_id
  ssh_key   = var.ssh_key
  public_ip = true
  depends_on = [
    module.az_spoke_1
  ]
}


#-------------------------------------------------- SPOKE 2 --------------------------------------------------------



resource "azurerm_resource_group" "rg-test" {
  name     = "lab-RG-spoke-2CIDRs"
  location = "West Europe"
}

resource "azurerm_virtual_network" "vnet_spoke_2" {
  name                = "lab-vnet-spoke-2"
  location            = azurerm_resource_group.rg-test.location
  resource_group_name = azurerm_resource_group.rg-test.name
  address_space       = ["10.113.0.0/16", "192.168.1.0/29"]

  subnet {
    name           = "subnet-user-1"
    address_prefix = "10.113.1.0/24"
  }
  subnet {
    name           = "subnet-user-2"
    address_prefix = "10.113.2.0/24"
  }

  subnet {
    name           = "subnet-user-3"
    address_prefix = "10.113.3.0/24"
  }

  subnet {
    name           = "subnet-avx-spoke-gw"
    address_prefix = "192.168.1.0/29"
  }
}

module "az_spoke_2" {
  source           = "terraform-aviatrix-modules/mc-spoke/aviatrix"
  version          = "1.2.4"
  name             = "lab-AZ-spoke-2"
  cloud            = "azure"
  region           = "West Europe"
  use_existing_vpc = true
  vpc_id           = "${azurerm_virtual_network.vnet_spoke_2.name}:${azurerm_resource_group.rg-test.name}"
  gw_subnet        = local.subnet_dicts["subnet-avx-spoke-gw"].id
  hagw_subnet      = local.subnet_dicts["subnet-avx-spoke-gw"].prefix
  transit_gw       = module.AZ_transit_1_fw.transit_gateway.gw_name
  account          = var.avx_ctrl_account_azure
  depends_on = [
    azurerm_virtual_network.vnet_spoke_2
  ]
}

module "spoke_2_vm1" {
  source    = "./terraform-azure-instance-build-module"
  name      = "lab-spoke2-vm1"
  region    = "West Europe"
  rg        = azurerm_resource_group.rg-test.name
  subnet_id = local.subnet_dicts["subnet-user-1"].id
  ssh_key   = var.ssh_key
  public_ip = true
  depends_on = [
    azurerm_virtual_network.vnet_spoke_2
  ]
}

module "spoke_2_vm2" {
  source    = "./terraform-azure-instance-build-module"
  name      = "lab-spoke2-vm2"
  region    = "West Europe"
  rg        = azurerm_resource_group.rg-test.name
  subnet_id = local.subnet_dicts["subnet-user-2"].id
  ssh_key   = var.ssh_key
  public_ip = true
  depends_on = [
    azurerm_virtual_network.vnet_spoke_2
  ]
}

module "spoke_2_vm3" {
  source    = "./terraform-azure-instance-build-module"
  name      = "lab-spoke2-vm3"
  region    = "West Europe"
  rg        = azurerm_resource_group.rg-test.name
  subnet_id = local.subnet_dicts["subnet-user-3"].id
  ssh_key   = var.ssh_key
  public_ip = true
  depends_on = [
    azurerm_virtual_network.vnet_spoke_2
  ]
}


#------------------------------------------------------- SG definitions + policies

resource "aviatrix_spoke_gateway_subnet_group" "subnet_group_spoke1_prod" {
  name    = "SG-prod"
  gw_name = module.az_spoke_1.spoke_gateway.gw_name
  subnets = [
    "${module.az_spoke_1.vpc.private_subnets[1].cidr}~~${module.az_spoke_1.vpc.private_subnets[1].name}",
    "${module.az_spoke_1.vpc.public_subnets[1].cidr}~~${module.az_spoke_1.vpc.public_subnets[1].name}"
  ]
  depends_on = [
    module.az_spoke_1
  ]
}

resource "aviatrix_spoke_gateway_subnet_group" "subnet_group_spoke2_prod" {
  name    = "SG-prod"
  gw_name = module.az_spoke_2.spoke_gateway.gw_name
  subnets = [
    "${local.subnet_dicts["subnet-user-1"].prefix}~~subnet-user-1"
  ]

  depends_on = [
    module.az_spoke_2,
    azurerm_virtual_network.vnet_spoke_2
  ]
}

resource "aviatrix_spoke_gateway_subnet_group" "subnet_group_spoke2_open" {
  name    = "SG-open"
  gw_name = module.az_spoke_2.spoke_gateway.gw_name
  subnets = [
    "${local.subnet_dicts["subnet-user-2"].prefix}~~subnet-user-2"
  ]

  depends_on = [
    module.az_spoke_2,
    azurerm_virtual_network.vnet_spoke_2
  ]
}



resource "aviatrix_transit_firenet_policy" "inspection_policy_1" {
  transit_firenet_gateway_name = module.AZ_transit_1_fw.transit_gateway.gw_name
  inspected_resource_name      = "SPOKE_SUBNET_GROUP:${module.az_spoke_1.spoke_gateway.gw_name}~~${aviatrix_spoke_gateway_subnet_group.subnet_group_spoke1_prod.name}"
  depends_on = [
    module.az_spoke_1,
    module.AZ_transit_1_fw
  ]
}

# resource "aviatrix_transit_firenet_policy" "inspection_policy_2" {
#   transit_firenet_gateway_name = module.AZ_transit_1_fw.transit_gateway.gw_name
#   inspected_resource_name      = "SPOKE_SUBNET_GROUP:${module.az_spoke_2.spoke_gateway.gw_name}~~SG-prod"
#   depends_on = [
#     module.az_spoke_2,
#     module.AZ_transit_1_fw
#   ]
# }

# resource "aviatrix_transit_firenet_policy" "inspection_policy_3" {
#   transit_firenet_gateway_name = module.AZ_transit_1_fw.transit_gateway.gw_name
#   inspected_resource_name      = "SPOKE_SUBNET_GROUP:${module.az_spoke_2.spoke_gateway.gw_name}~~SG-open"
#   depends_on = [
#     module.az_spoke_2,
#     module.AZ_transit_1_fw
#   ]
# }

variable "inspected_resources" {
  type = set(string)
  default = [
    "SPOKE_SUBNET_GROUP:lab-AZ-spoke-2~~SG-prod",
    "SPOKE_SUBNET_GROUP:lab-AZ-spoke-2~~SG-open"
  ]
}

resource "aviatrix_transit_firenet_policy" "inspection_policy_spoke2" {
  for_each                     = var.inspected_resources
  transit_firenet_gateway_name = module.AZ_transit_1_fw.transit_gateway.gw_name
  inspected_resource_name      = each.value

  depends_on = [
    module.az_spoke_1,
    module.az_spoke_2,
    module.AZ_transit_1_fw
  ]
}


# #-------------------------------------- private DNS setup --------------------------------------
resource "azurerm_private_dns_zone" "private_dns_zone" {
  name                = "subnetlab.com"
  resource_group_name = azurerm_resource_group.rg-test.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns_link_spoke2" {
  name                  = "subnetlab_dns_link_spoke1"
  resource_group_name   = azurerm_resource_group.rg-test.name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone.name
  virtual_network_id    = azurerm_virtual_network.vnet_spoke_2.id
  registration_enabled  = true
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns_link_spoke1" {
  name                  = "subnetlab_dns_link_spoke2"
  resource_group_name   = azurerm_resource_group.rg-test.name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone.name
  virtual_network_id    = module.az_spoke_1.vpc.azure_vnet_resource_id
  registration_enabled  = true
}
