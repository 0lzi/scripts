#!/bin/bash

read -s -p "Enter your password: " password
echo
hashed_password=$(echo -n "$password" | mkpasswd -m sha-512 -s)

echo "Hashed password: $hashed_password" 
