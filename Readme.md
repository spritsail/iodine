# Iodine
** This Dockerfile needs to be run with the NET_ADMIN capability. **

An Alpine Linux based Dockerfile to run Iodine - a program to tunnel IP over DNS requests. For more information on Iodine, see the [official website](http://code.kryo.se/iodine/).

## Environment Variables
This dockerfile requires some environment variables set to run. ```$IODINE_HOST``` must be set to the external hostname DNS requests are coming from, and ```$IODINE_PASS``` must be set to the password clients will use to connect.  
You may also set ```$IODINE_IP``` to define the range of IPs that Iodine will assign clients. However this is not a required variable, it defaults to the ```10.42.16.1/24``` range.
These variables can also be defined using a [environment variable file](https://docs.docker.com/engine/reference/commandline/run/#/set-environment-variables-e-env-env-file).

## Example run command
``` docker run -d --name Iodine -p 53:53/udp --cap-add=NET_ADMIN -e IODINE_HOST=tunnel.example.com -e IODINE_PASS=password -e IODINE_HOST=10.0.0.1 adamant/iodine```
