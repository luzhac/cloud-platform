

wsl

wsl --unregister Ubuntu

wsl --install -d Ubuntu

wsl -d Ubuntu

lsb_release -a

sudo apt update

sudo apt update && sudo apt upgrade -y


sudo apt install ansible -y


mkdir -p ~/.ssh
cp /mnt/c/Myfiles/MyProjects/aws-infra-lab/infra/terraform/environments/dev/.secrets/k8s.pem ~/.ssh/
chmod 400 ~/.ssh/k8s.pem
ssh -i ~/.ssh/k8s.pem ubuntu@43.206.220.251

mkdir ~/ansible-project
cd ~/ansible-project




 


