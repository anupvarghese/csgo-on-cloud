terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
    }
  }
}

provider "digitalocean" {
  token = var.digitalocean_api_key
}

resource "digitalocean_ssh_key" "default" {
  name       = "terraformserver"
  public_key = file(var.public_key_path)
}

resource "digitalocean_droplet" "csgoserver" {
  image    = "ubuntu-18-04-x64"
  name     = "csgoserver"
  region   = var.region
  size     = var.vm_size
  ssh_keys = [digitalocean_ssh_key.default.fingerprint]

  connection {
    type              = "ssh"
    user              = "root"
    host              = self.ipv4_address
    agent             = true
    private_key = file(var.private_key_path)
  }

  provisioner "remote-exec" {
    inline = [
      "echo writing env",
      "mkdir /home/ansible-files",
      "echo \"{\\\"hostname\\\": \\\"${var.hostname}\\\",\\\"rcon_password\\\": \\\"${var.rcon_password}\\\",\\\"sv_password\\\": \\\"${var.sv_password}\\\",\\\"maxplayers\\\": \\\"32\\\",\\\"tickrate\\\": \\\"128\\\",\\\"host_info\\\": \\\"2\\\",\\\"gslt\\\": \\\"${var.gslt}\\\", \\\"tags\\\": \\\"csgo,executes,mirage\\\",\\\"mapgroup\\\": \\\"de_mirage\\\",\\\"defaultmap\\\": \\\"de_mirage\\\"}\" > /home/ansible-files/env.json",
      "apt-add-repository ppa:ansible/ansible -y",
      "apt-get update",
      "apt-get install -y ansible python-pip"
    ]
  }

   provisioner "remote-exec" {
    inline = [
      "echo installing csgo",
      "ansible-pull -U https://github.com/anupvarghese/csgo-on-cloud.git -i 127.0.0.1 competitive.yml"
    ]
  }
}

