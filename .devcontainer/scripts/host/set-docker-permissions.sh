#!/bin/bash

echo "Making sure docker permissions are set up correctly..."

if [ "$(stat -c '%G' /var/run/docker.sock)" != "docker" ]; then
    echo "Setting permissions for Docker socket..."
    echo "Please enter your password if prompted to allow running this script with sudo."
    sudo getent group docker || sudo groupadd docker
    sudo usermod -aG docker $USER
    sudo chown root:docker /var/run/docker.sock
else 
    echo "Docker socket permissions are already set up correctly. skipping..."
fi