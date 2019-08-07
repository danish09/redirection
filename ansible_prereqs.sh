#!/bin/bash
set -e
apt-get -qq update
apt-get -qq --yes install python python-apt
touch /root/.ansible_prereqs_installed
