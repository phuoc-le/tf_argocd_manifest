#!/bin/bash

rm -f ~/.ssh/known_hosts

export ANSIBLE_HOST_KEY_CHECKING=False

ansible all -i hosts -m ping