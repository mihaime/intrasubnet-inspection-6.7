# AVX Cloud Accounts

#----------------- AVIATRIX -----------------
variable "avx_controller_admin_password" {
  type        = string
  description = "[sensitive.auto.tfvars] - aviatrix controller admin password"
}
variable "controller_ip" {
  type        = string
  description = "[terraform.auto.tfvars] - aviatrix controller "
}
variable "aws_region" {
  type        = string
  description = "AWS Region"
  default     = "eu-central-1"
}

variable "pre_shared_key" {
  type    = string
  default = "some_key"
}

variable "avx_ctrl_account_azure" {
  type = string
}

variable "avx_ctrl_account_aws" {
  type = string
}

variable "avx_ctrl_account_alicloud" {
  type = string
}

variable "azure_storage_access_key_1" {
  type = string
}

variable "palo_username" {
  type = string
}

variable "palo_password" {
  type = string
}


variable "palo_bootstrap_storage_name_1" {
  type = string
}

variable "palo_file_share_folder_1" {
  type = string
}


variable "ssh_key" { default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC9lhwk6x8eC+XDT8c0NQr4mxGfCKqCdfWqGkIzaC952Vg/6TKe/YpuiWibMVMUoRg8jm3jFXExzNZoKA86yEDEo4n9u5FVQA7UiFEEMd7fjjwFOQI60K7hgJjEUY/puqVobRnNAXUSk7bfqYAYOw6QK+DLu3z7jK1Mjcb7LJVQPWWZLq1jVSosF5drPbbEo++m2UstA8ZZHewGYdecs6SieeZjcovOrlQv9NONHjiszbN69zyuTcFJheT+U7opadz3WyI8A9zW//bp238+F5pPK+5dBY0+DQHEzGx1XCZzZJ+8mKULbJAb2q3oZG7S+AJ8jABKjCHNHxdZIVf/tHpD3WgqpRDRj6XEQFyXksTNKl+LC/gZmxxddlDMkNab4ZJqUesz0JBlgfV4z9w4Y3EagA1uQmcM8okQZjSq3akfEbhiApN1yiPFAlxTMVgVyqdlNe/kWUoVVbohOFKPVjU/tDaMSQj6iuSVzFONwckFczzTefEhIJdmyP5YxFQWSqeuIXmlpJOswVjnnqgiOijiavZ1dgo1kGhXI9GmZX6ZgvrEcPcNpp20Jrtey2QHssAOxjf1ndq8vydf64kE68rLQLL0sMulcbbW2DmkSTkMOAM5NM9ZBlCRh7ovW88zRsI+EENrINorpBN6Fvlllydppgrabv1WW+4cTFOZVmdYtw== mihaitanasescu@Mihais-MacBook-Pro.local" }

variable "azure_subscription_id" { type = string }
variable "azure_appId" { type = string }
variable "azure_password" { type = string }
variable "azure_tenant" { type = string }
