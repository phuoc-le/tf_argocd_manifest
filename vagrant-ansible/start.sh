#!/bin/bash

sudo swapoff -a;

sudo systemctl start kubelet.service;

