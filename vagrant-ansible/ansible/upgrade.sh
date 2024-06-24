#!/bin/bash

export ANSIBLE_HOST_KEY_CHECKING=False

ansible-playbook -i inventory.yml kube-upgrade.yml
