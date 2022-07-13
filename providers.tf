provider "aviatrix" {
  username      = "admin"
  password      = var.avx_controller_admin_password
  controller_ip = var.controller_ip
}

provider "aws" {
  region = var.aws_region
}

provider "azurerm" {
  features {}

  subscription_id = var.azure_subscription_id
  client_id       = var.azure_appId
  client_secret   = var.azure_password
  tenant_id       = var.azure_tenant
}

provider "google" {
  project = "prjbetaaviatrixgcp"
  region  = "europe-west3"
}
