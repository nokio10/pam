# -*- mode: ruby -*-
# vim: set ft=ruby :
MACHINES = {
:pam => {
:box_name => "centos7",
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
box.vm.provision "shell", inline: <<-SHELL
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
sudo cp /vagrant/sshd /etc/pam.d/sshd
sudo cp /vagrant/scr.sh /usr/local/bin/scr.sh
sudo chmod +x /usr/local/bin/scr.sh
sudo systemctl restart sshd
SHELL
end
end
end
end
