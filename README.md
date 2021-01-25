### CSGO dedicated server on Azure

Running a CSGO dedicated server on Azure using terraform with cloud-init, ansible and [LinuxGSM](https://linuxgsm.com/)

### Initial Steps

- Install terraform, azurecli
- Azure login

  `az login` (Copy subscription_id)

- Create service principal

  `az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/<subscription_id>"`

- Populate secrets, create a file `secrets.tfvars` under `azure` folder
-
- Check azure for vm_size and storage_disk_type

```
   region = "japaneast"
   subscription_id = "<id>"
   client_id       = "<id from service principal>"
   tenant_id       = "<tenant id from login>"
   resource_group_name = "RG_NAME"
   vm_size = "Standard_F4"
   storage_disk_type = "Standard_LRS"
   sv_password = "secret"
   rcon_password = "secret"
   gslt = "gslt from steam"
```

## Terraform steps

```
terraform init
terraform plan -var-file="secrets.tfvars"
terraform apply -var-file="secrets.tfvars"
```

## Ansible steps

- Once the server is provisioned, you can access it via ssh as below,

```
ssh -i ~/.ssh/id_rsa csgoserver@ipaddress_of_vm
```

- Below command will run the ansible playbook and create csgo server

`ansible-pull -U https://github.com/anupvarghese/csgo-on-cloud.git -i 127.0.0.1 competitive.yml`

### Notes

This setup uses [LinuxGSM](https://linuxgsm.com/) to host csgo server.

Management of the game server can be found in [these](https://docs.linuxgsm.com/commands) docs
