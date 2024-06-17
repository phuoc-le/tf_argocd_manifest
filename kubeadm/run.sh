#!/bin/bash

export ANSIBLE_HOST_KEY_CHECKING=False

ansible-playbook -i hosts initial.yml

ansible-playbook -i hosts kube-dependencies.yml

ansible-playbook -i hosts master.yml

ansible-playbook -i hosts workers.yml

ansible-playbook -i hosts init-cronjob.yml

ansible-playbook -i hosts set-role-worker.yml
