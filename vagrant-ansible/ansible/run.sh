#!/bin/bash

rm -f ~/.ssh/known_hosts

export ANSIBLE_HOST_KEY_CHECKING=False

ansible-playbook -i hosts init-user.yml

ansible-playbook -i hosts kube-dependencies.yml

ansible-playbook -i hosts master.yml

ansible-playbook -i hosts workers.yml

ansible-playbook -i hosts init-cronjob.yml

ansible-playbook -i hosts set-role-worker.yml

ansible-playbook -i hosts setup-infras.yml
