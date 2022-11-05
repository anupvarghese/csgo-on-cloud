### CSGO dedicated server on Azure

Running a CSGO dedicated server on Azure using terraform with ansible and [LinuxGSM](https://linuxgsm.com/)

### Initial Steps

- Install terraform, azurecli
- Azure login and copy `subscription_id`

  ```
  az login
  ```

- Create service principal

  ```
  MSYS_NO_PATHCONV=1 az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/adcabcec-5fa6-48be-bdb8-b438ae89f8d0"
  ```

- Populate secrets, create a file `secrets.tfvars` under `azure` folder
- Check azure for vm_size and storage_disk_type

```shell
   region = "japaneast"
   subscription_id = "<id>"
   client_id       = "<appid from service principal>"
   tenant_id       = "<tenant id from login>"
   resource_group_name = "RG_NAME"
   vm_size = "Standard_F4"
   storage_disk_type = "Standard_LRS"
   sv_password = "secret"
   rcon_password = "secret"
   gslt = "gslt from steam"
   client_secret = "<password from service principle>"
```

## Terraform steps

```shell
terraform init
terraform plan -var-file="secrets.tfvars"
terraform apply -var-file="secrets.tfvars"
```

## Ansible steps

- Once the server is provisioned, you can access it via ssh as below,


```shell
ssh -i ~/.ssh/faizal-CS-2.pem csgoserver@20.222.22.249
```

- Below command will run the ansible playbook and create csgo server

```shell
# do it this way till this branch is merged to main branch
ansible-pull -U https://github.com/anupvarghese/csgo-on-cloud.git -C upgrade-metamod-sourcemod -i 127.0.0.1 competitive.yml

# once upgrade-metamod-sourcemod bracnh is merged to main, run this
ansible-pull -U https://github.com/anupvarghese/csgo-on-cloud.git -i 127.0.0.1 competitive.yml
```

### Notes

This setup uses [LinuxGSM](https://linuxgsm.com/) to host csgo server.

Management of the game server can be found in [these](https://docs.linuxgsm.com/commands) docs
