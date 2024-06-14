#!/bin/bash

export ANSIBLE_HOST_KEY_CHECKING=False

ansible all -i hosts -m ping