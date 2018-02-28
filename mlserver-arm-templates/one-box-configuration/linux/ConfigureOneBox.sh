#!/bin/bash

az ml admin bootstrap --admin-password "$1" --confirm-password "$1"
iptables --flush