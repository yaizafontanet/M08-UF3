#!/bin/bash
sudo apt update
sudo apt upgrade -y
#instalar postfix y poner archivo de configuración
sudo apt install -y postfix
sudo cp /etc/postfix/main.cf /etc/postfix/main.cf.backup
sudo rm /etc/postfix/main.cf
sudo cp main.cf /etc/postfix/
sudo systemctl restart postfix.service
#instalar dovecot y poner archivo de configuración
sudo apt install -y dovecot-core dovecot-pop3d dovecot impad
sudo cp /etc/dovecot/conf.d/10-auth.conf /etc/dovecot/conf.d/10-auth.conf.backup
sudo rm /etc/dovecot/conf.d/10-auth.conf
sudo cp 10-auth.conf /etc/dovecot/conf.d/
sudo systemctl restart dovecot.service
#instalar mysql-server i configurar
sudo apt update
MYSQL_ROOT_PASSWORD='Yaiza200!'
sudo apt install -y mysql-server
#sudo mysql_sercure_installation
MYSQL=$(grep 'temporary password' /var/log/mysqld.log | awk '{print $11}') 
SECURE_MYSQL=$(expect -c " 

set timeout 10 
spawn mysql_secure_installation 

expect \"Enter password for user root:\" 
send \"$MYSQL\r\" 
expect \"New password:\" 
send \"$MYSQL_ROOT_PASSWORD\r\" 
expect \"Re-enter new password:\" 
send \"$MYSQL_ROOT_PASSWORD\r\" 
expect \"Change the password for root ?\ ((Press y\|Y for Yes, any other key for No) :\" 
send \"n\r\" 
expect \"Do you wish to continue with the password provided?\(Press y\|Y for Yes, any other key for No) :\" 
send \"y\r\" 
expect \"Remove anonymous users?\(Press y\|Y for Yes, any other key for No) :\" 
send \"y\r\" 
expect \"Disallow root login remotely?\(Press y\|Y for Yes, any other key for No) :\" 
send \"n\r\" 
expect \"Remove test database and access to it?\(Press y\|Y for Yes, any other key for No) :\" 
send \"y\r\" 
expect \"Reload privilege tables now?\(Press y\|Y for Yes, any other key for No) :\" 
send \"y\r\" 
expect eof 
")
echo $SECURE_MYSQL

MYSQL_USER='roundcube'
MYSQL_PASSWORD='Yaiza200!'
DB='roundcube'

sudo mysql -h localhost -u root -p $MYSQL_ROOT_PASSWORD EOF
create database $DB;
create user $MYSQL_USER@localhost identified by $MYSQL_PASSWORD;
grant all privileges on $DB.* to $MYSQL_USER@localhost; 
flush privileges;
EOF

#instalar php
sudo apt install -y php7.4 libapache2-mod-php7.4 php7.4-common php7.4-mysql php7.4-cli php-pear php7.4-opcache php7.4-gd php7.4-curl php7.4-cli php7.4-imap php7.4-mbstring php7.4-intl php7.4-soap php7.4-ldap php-imagick php7.4-xml php7.4-zip
sudo pear install Auth_SASL2 Net_SMTP Net_IDNA2-0.1.1 Mail_mime Mail_mimeDecode

#instalar apache
sudo apt-get update
sudo apt-get install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2

#instalar roundcube
sudo wget https://github.com/roundcube/roundcubemail/releases/download/1.5.2/roundcubemail-1.5.2-complete.tar.gz
sudo tar -xvzf roundcubemail-1.5.2-complete.tar.gz
sudo mv roundcubemail-1.5.2 /var/www/html/roundcube
sudo chown -R www-data:www-data /var/www/html/roundcube/

#Configurar archivo de apache y habilitar
sudo cp 004-roundcube.conf /etc/apache2/sites-available/
sudo a2ensite /etc/apache2/sites-available/004-roundcube.conf
sudo a2enmod rewrite
sudo systemctl restart apache2.service

#instalar bind9
sudo apt update
sudo apt install -y bind9
sudo cp /etc/netplan/50-cloud-init.yaml /etc/netplan/50-cloud-init.yaml.backup
sudo rm /etc/netplan/50-cloud-init.yaml
sudo cp 50-cloud-init.yaml /etc/netplan/
sudo cp /etc/bind/named.conf.options /etc/bind/named.conf.options.backup
sudo rm /etc/bind/named.conf.options
sudo cp named.conf.options /etc/bind/
sudo cp /etc/bind/named.conf.local /etc/bind/named.conf.local.backup
sudo rm /etc/bind/named.conf.local
sudo cp named.conf.local /etc/bind/
sudo cp forward.insjdayf.hopto.org /etc/bind/
sudo cp reverse.insjdayf.hopto.org /etc/bind/
sudo systemctl restart bind9.service

#Configurar rouncube