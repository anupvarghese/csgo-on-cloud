#!/bin/sh

echo "writing env"
mkdir /home/ansible-files
echo "{\"hostname\": \"${hostname}\",\"rcon_password\": \"${rcon_password}\",\"sv_password\": \"${sv_password}\",\"maxplayers\": \"32\",\"tickrate\": \"128\",\"host_info\": \"2\",\"gslt\": \"${gslt}\", \"tags\": \"csgo,executes,mirage\",\"mapgroup\": \"de_mirage\",\"defaultmap\": \"de_mirage\"}" > /home/ansible-files/env.json

apt-add-repository ppa:ansible/ansible
apt-get update
apt-get install -y ansible python-pip

sudo bash -c 'echo "localhost" > /etc/ansible/hosts'


