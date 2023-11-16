#!/bin/sh
IFS=',' # Set Internal Field Separator

while read -r col1 col2 ; do
    echo $col1 # or do something with col1
    echo $col2 # do something col2

done < input-file.csv