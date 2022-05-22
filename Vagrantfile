# -*- mode: ruby -*-
# vim: set ft=ruby :
MACHINES = {
:pam => {
:box_name => "centos8",
#:box_version => "2004.01",
},
}
Vagrant.configure("2") do |config|
MACHINES.each do |boxname, boxconfig|
config.vm.define boxname do |box|
box.vm.box = boxconfig[:box_name]
box.vm.box_version = boxconfig[:box_version]
box.vm.host_name = "pam"
box.vm.provider :virtualbox do |vb|
needsController = false
end
box.vm.provision "shell", inline: <<-SHELL
cd /etc/yum.repos.d/
sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
sudo useradd one
sudo useradd two
sudo useradd three
sudo useradd four
sudo groupadd admin
sudo usermod -a -G admin one
sudo usermod -a -G admin two
sudo usermod -a -G admin vagrant
sudo echo "Otus2022" | sudo passwd --stdin one
sudo echo "Otus2022" | sudo passwd --stdin two
sudo echo "Otus2022" | sudo passwd --stdin three
sudo echo "Otus2022" | sudo passwd --stdin four
sudo bash -c "sed -i 's/^PasswordAuthentication.*$/PasswordAuthentication yes/' /etc/ssh/sshd_config"
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce
sudo setenforce 0
sudo usermod -aG docker vagrant
sudo usermod -aG docker one
sudo newgrp docker 
sudo echo "cap_net_bind_service one" > /etc/security/capability.conf
sudo echo "cap_net_bind_service vagrant" >> /etc/security/capability.conf
sudo setcap cap_net_bind_service=ei /usr/bin/docker
sudo cp /vagrant/sshd /etc/pam.d/sshd
sudo cp /vagrant/scr.sh /usr/local/bin/scr.sh
sudo chmod +x /usr/local/bin/scr.sh
sudo systemctl restart sshd
sudo cp /vagrant/polkit /etc/polkit-1/rules.d/docker.rules
SHELL
end
end
end
