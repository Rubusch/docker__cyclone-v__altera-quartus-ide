#!/bin/bash -e

## prepare SDK environment
source ~/env.sh

## jtagd
sudo killall jtagd &> /dev/null
jtagd
jtagconfig

## start quartus
quartus --64bit
