#!/bin/bash

az ml admin node setup --onebox --admin-password "$1" --confirm-password "$1"
iptables --flush