#!/bin/bash

for file in *key.pem; do
    openssl rsa -in $file -noout -modulus | openssl md5 >  $file.md5.txt
done