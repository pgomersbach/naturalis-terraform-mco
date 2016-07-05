#!/bin/bash
echo "Start of boot script"

export FACTER_middleware_address="${middleware_address}"
echo "Middleware server is: $FACTER_middleware_address"

echo "Bootstrap puppet and apply role"
wget https://raw.githubusercontent.com/pgomersbach/demo-mco-client/master/files/bootme.sh && bash bootme.sh
