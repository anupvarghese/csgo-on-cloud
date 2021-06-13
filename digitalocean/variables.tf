variable "region" {
  default = "sgp1"
}

variable "resource_group_name" {
  default = "TERRAFORM-RG03"
}

variable "digitalocean_api_key" {
  default = "123"
}

variable "public_key_path" {
  description = "Public key path"
  default     = "~/.ssh/id_rsa.pub"
}

variable "private_key_path" {
  description = "Private key path"
  default     = "~/.ssh/id_rsa"
}

variable "vpc" {
  description = "Azure Network"
  default     = "10.0.0.0/16"
}

variable "subnet" {
  description = "Azure Subnet"
  default     = "10.0.2.0/24"
}

variable "vm_size" {
  description = "Azure VM Size"
  default     = "Standard_DS1_v2"
}

variable "storage_disk_type" {
  description = "Managed disk type"
  default     = "Standard_F2"
}
variable "environment_tag" {
  description = "Environment tag"
  default     = "Staging"
}

variable "sv_password" {
  description = "Server password"
  default     = "hhahaha"
}

variable "rcon_password" {
  description = "Rcon password"
  default     = "lol"
}

variable "hostname" {
  description = "Hostname"
  default     = "cop"
}

variable "gslt" {
  description = "steam gslt"
  default     = "cc"
}
