# Edit or add node in hosts file

# Run init ssh key 
ansible-playbook -i inventory.yml init-user.yml -K

%%%% Enter sudo pass when add -K %%%%


# Run common setting every servers
ansible-playbook -i inventory.yml kube-dependencies.yml -K


# Run master
ansible-playbook -i inventory.yml master.yml -k

# Run workers
ansible-playbook -i inventory.yml workers.yml -K


# Install ansible ubuntu 2304
sudo apt install ansible -y
sudo apt install net-tools -y

kubectl label node kubeadm-worker-1 node-role.kubernetes.io/worker=""
kubectl label node kubeadm-worker-2 node-role.kubernetes.io/worker=""
kubectl label node kubeadm-worker-3 node-role.kubernetes.io/worker=""