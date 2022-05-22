# Задание

1. Запретить всем пользователям, кроме группы admin логин в выходные (суббота и воскресенье), без учета праздников

2. Дать конкретному пользователю права работать с докером и возможность рестартить докер сервис

## Решение

### Запретить всем пользователям, кроме группы admin логин в выходные (суббота и воскресенье), без учета праздников

Создаю четырех пользователей с паролями, группу admin, добавляю двух пользователей в группу admin, включаю парольную аутентификацию по ssh, устанавливаю необходимое для работы pam_script.

```
sudo useradd one && \
sudo useradd two && \
sudo useradd three && \
sudo useradd four
sudo groupadd admin
sudo usermod -a -G admin one
sudo usermod -a -G admin two
sudo echo "Otus2022" |sudo passwd --stdin one &&\
sudo echo "Otus2022" | sudo passwd --stdin two &&\
sudo echo "Otus2022" | sudo passwd --stdin three &&\
sudo echo "Otus2022" | sudo passwd --stdin four
sudo bash -c "sed -i 's/^PasswordAuthentication.*$/PasswordAuthentication yes/' /etc/ssh/sshd_config
for pkg in epel-release pam_script; do sudo yum install -y $pkg; done
sudo chmod +x /vagrant/scr.sh
sudo echo "account required pam_script.so /vagrant/scr.sh" >> /etc/pam.d/sshd
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

