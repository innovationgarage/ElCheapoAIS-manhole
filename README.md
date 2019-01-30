# ElCheapoAIS-manhole

This repository contains two components:

* A shell script that fetches a script over http from a server and executes it, sending any output back to the server.
  This script is intended to be run from crontab.
* A django based server serving such scripts and receiving their output, with an admin UI to write scripts and check their output.

# Usefull scripts

Get device id and type:

    #! /bin/bash
    uname -a
    hostname
    whoami

Generate an ssh key in the default location:

    #! /bin/bash
    ssh-keygen -t rsa -N "" -C "" -f ~/.ssh/id_rsa

Set up a reverse ssh tunnel so you can ssh to the device with ssh -p 2222 localhost:

    #! /bin/bash
    ssh -o StrictHostKeyChecking=no -R 2222:localhost:22 -f -v  elcheapoais.innovationgarage.tech 'while true; do : ; done'
    
