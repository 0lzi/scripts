#!/bin/bash

for keyfile in *-key.pem; do
    if [[ "$keyfile" =~ ^(.+)-key\.pem$ ]]; then
        certfile="${BASH_REMATCH[1]}.pem"
        if [ -f "$certfile" ]; then
            key=$(openssl rsa -in "$keyfile" -noout -modulus | openssl md5)
            cert=$(openssl x509 -in "$certfile" -noout -modulus | openssl md5)
            if [ "$key" = "$cert" ]; then
                echo "$keyfile and $certfile match"
            else
                echo "$keyfile and $certfile don't match"
            fi
        else
            echo "Certificate file not found for $keyfile"
        fi
    fi
done
