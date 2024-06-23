# Edit or add node in hosts file

# Run init ssh key 
ansible-playbook -i hosts initial.yml -K

%%%% Enter sudo pass when add -K %%%%


# Run common setting every servers
ansible-playbook -i hosts kube-dependencies.yml -K


# Run master
ansible-playbook -i hosts master.yml -k

# Run workers
ansible-playbook -i hosts workers.yml -K


# Install ansible ubuntu 2204
sudo apt-add-repository ppa:ansible/ansible
sudo apt update
sudo apt install ansible -y
sudo apt install net-tools -y

kubectl label node k8s-worker-1 node-role.kubernetes.io/worker=worker
