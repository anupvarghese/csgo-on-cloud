variable "region" {
  default = "sgp1"
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

variable "vm_size" {
  description = "Digital Ocean VM Size"
  default     = "s-1vcpu-1gb"
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
