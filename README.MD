# Задание

1. Запретить всем пользователям, кроме группы admin логин в выходные (суббота и воскресенье), без учета праздников

2. Дать конкретному пользователю права работать с докером и возможность рестартить докер сервис

## Решение

### Запретить всем пользователям, кроме группы admin логин в выходные (суббота и воскресенье), без учета праздников

Создаю четырех пользователей с паролями, группу admin, добавляю двух пользователей в группу admin, включаю парольную аутентификацию по ssh, конфигурирую pam_exec.

```
sudo useradd one && \
sudo useradd two && \
sudo useradd three && \
sudo useradd four
sudo groupadd admin
sudo usermod -a -G admin one
sudo usermod -a -G admin two
sudo usermod -a -G admin vagrant
sudo echo "Otus2022" |sudo passwd --stdin one &&\
sudo echo "Otus2022" | sudo passwd --stdin two &&\
sudo echo "Otus2022" | sudo passwd --stdin three &&\
sudo echo "Otus2022" | sudo passwd --stdin four
sudo bash -c "sed -i 's/^PasswordAuthentication.*$/PasswordAuthentication yes/' /etc/ssh/sshd_config
for pkg in epel-release pam_script; do sudo yum install -y $pkg; done
sudo chmod +x /usr/local/bin/scr.sh
sudo systemctl restart sshd
```

Проверяем работу pam

```
[vagrant@pam ~]$ ssh one@localhost
The authenticity of host 'localhost (::1)' can't be established.
ECDSA key fingerprint is SHA256:Fxny42eoeKK4dskcGb4fP/tou6Zo7zQuT3nt9ntkWqg.
ECDSA key fingerprint is MD5:60:02:95:ee:e6:57:56:d0:40:83:c3:2e:75:1c:e1:b3.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'localhost' (ECDSA) to the list of known hosts.
one@localhost's password:
[one@pam ~]$ logout
Connection to localhost closed.
[vagrant@pam ~]$ ssh four@localhost
four@localhost's password:
/usr/local/bin/scr.sh failed: exit code 1
Authentication failed.
```

### Дать конкретному пользователю права работать с докером и возможность рестартить докер сервис

Для реализации 2 части задания потребуется systemd версии 226 и выше, поэтому перехожу на centos8. ```https://github.com/systemd/systemd/commit/88ced61bf9673407f4b15bf51b1b408fd78c149d```

1. Устанавливаю докер, добавляю пользователей в группу докер. 
2. Включаю pam_cap, добавляю пользователей в capability.conf, выдаю /usr/bin/docker аналогичные права.
3. Добавляю правило polkit для рестарта сервиса докер. 

```
cd /etc/yum.repos.d/
sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce
sudo setenforce 0
sudo usermod -aG docker vagrant
sudo usermod -aG docker one
sudo newgrp docker 
sudo echo "cap_net_bind_service one" > /etc/security/capability.conf
sudo echo "cap_net_bind_service vagrant" >> /etc/security/capability.conf
sudo setcap cap_net_bind_service=ei /usr/bin/docker
sudo cp /vagrant/polkit /etc/polkit-1/rules.d/docker.rules
```

Права выданы пользователям vagrant и one. Проверяю работу.

```
[vagrant@pam ~]$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
[vagrant@pam ~]$ systemctl restart docker
[vagrant@pam ~]$ systemctl start docker
[one@pam ~]$ systemctl restart docker
[one@pam ~]$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```

Работает
