# ElCheapoAIS-manhole

This repository contains two components:

* A shell script that fetches a script over http from a server and executes it, sending any output back to the server.
  This script is intended to be run from crontab.
* A django based server serving such scripts and receiving their output, with an admin UI to write scripts and check their output.
