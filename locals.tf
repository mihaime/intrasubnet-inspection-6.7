locals {
  env_prefix = "lab"

  # list of objects
  subnet_dicts = { for subnet_block in azurerm_virtual_network.vnet_spoke_2.subnet : subnet_block.name => { "prefix" = subnet_block.address_prefix, "name" = "subnet_block_name", "id" = subnet_block.id } }

}

