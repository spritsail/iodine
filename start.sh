#!/bin/sh

if [ -z ${IODINE_HOST} ]; then echo "Error: The external hostname must be specified in the IODINE_HOST enviroment variable"; exit 1; fi
if [ -z ${IODINE_PASS} ]; then echo "Error: The Iodine password must be specified in the IODINE_PASS enviroment variable"; exit 1; fi
if [ ! -e '/dev/net/tun' ]; then echo "Error: You must run this Dockerfile with --privileged"; exit 1; fi

IODINE_IP=${IODINE_IP:-"10.42.0.1"}

iodined -c -f -P $IODINE_PASS $IODINE_IP $IODINE_HOST
