#!/bin/bash

rm -f ~/.ssh/known_hosts

export ANSIBLE_HOST_KEY_CHECKING=False

ansible-playbook -i inventory.yml init-user.yml

ansible-playbook -i inventory.yml kube-dependencies.yml

ansible-playbook -i inventory.yml master.yml

ansible-playbook -i inventory.yml workers.yml

ansible-playbook -i inventory.yml init-cronjob.yml

ansible-playbook -i inventory.yml set-role-worker.yml

ansible-playbook -i inventory.yml setup-infras.yml
