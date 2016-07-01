#!/bin/bash
echo "Start of boot script"

echo "Bootstrap puppet and apply role"
wget https://raw.githubusercontent.com/pgomersbach/demo-mco-middleware/master/files/bootme.sh && bash bootme.sh
