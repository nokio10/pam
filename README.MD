# Задание

1. Запретить всем пользователям, кроме группы admin логин в выходные (суббота и воскресенье), без учета праздников

2. Дать конкретному пользователю права работать с докером и возможность рестартить докер сервис

## Решение

### Запретить всем пользователям, кроме группы admin логин в выходные (суббота и воскресенье), без учета праздников

Создаю четырех пользователя с паролями, группу admin, добавляю двух пользователей в группу admin, включаю парольную аутенфикацию по ssh, устанавливаю необходимое для работы pam_script

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

```
