#!/bin/bash

sudo growpart /dev/sda 3
sudo pvresize /dev/sda3
sudo lvresize -l+100%FREE --resizefs /dev/mapper/ubuntu--vg-ubuntu--lv

