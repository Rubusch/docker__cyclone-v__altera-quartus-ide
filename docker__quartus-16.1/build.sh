#!/bin/bash -e

## prepare SDK environment
source ~/env.sh

## jtagd
sudo killall jtagd
jtagd
jtagconfig

## start quartus
quartus --64bit
