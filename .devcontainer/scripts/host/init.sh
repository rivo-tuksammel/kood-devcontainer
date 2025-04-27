#!/bin/bash


cat << "EOF"
  _  __               _     _______              _____            _        _                 
 | |/ /              | |   / /  __ \            / ____|          | |      (_)                
 | ' / ___   ___   __| |  / /| |  | | _____   _| |     ___  _ __ | |_ __ _ _ _ __   ___ _ __ 
 |  < / _ \ / _ \ / _` | / / | |  | |/ _ \ \ / / |    / _ \| '_ \| __/ _` | | '_ \ / _ \ '__|
 | . \ (_) | (_) | (_| |/ /  | |__| |  __/\ V /| |___| (_) | | | | || (_| | | | | |  __/ |   
 |_|\_\___/ \___/ \__,_/_/   |_____/ \___| \_/  \_____\___/|_| |_|\__\__,_|_|_| |_|\___|_|   

EOF

# This script is used to extract the host user information (UID, GID, and username)
bash .devcontainer/scripts/host/extract-env.sh
bash .devcontainer/scripts/host/set-docker-permissions.sh