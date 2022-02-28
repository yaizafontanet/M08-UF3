#!/bin/bash
DOMAIN='insjdayf.hopto.org'

apt update
apt upgrade -y
#instalar postfix y configurar Maildir
apt update
debconf-set-selections <<< "postfix postfix/mailname string insjdayf.hopto.org"
debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"
apt-get install --assume-yes postfix
cp /etc/postfix/main.cf /etc/postfix/main.cf.backup
postconf -e 'home_mailbox= Maildir/'
systemctl restart postfix.service
#instalar dovecot y configurar
apt update
apt install -y dovecot-core
apt install -y dovecot-pop3d
apt install -y dovecot-impad
cp /etc/dovecot/conf.d/10-auth.conf /etc/dovecot/conf.d/10-auth.conf.backup
sed -i '/^disable_plaintext_auth =.*/s/^/#/g' /etc/dovecot/conf.d/10-auth.conf
echo "disable_plaintext_auth = no" >> /etc/dovecot/conf.d/10-auth.conf
sed -i '/^auth_mechanisms =.*/s/^/#/g' /etc/dovecot/conf.d/10-auth.conf
echo "auth_mechanisms = plain login" >> /etc/dovecot/conf.d/10-auth.conf
cp /etc/dovecot/conf.d/10-mail.conf /etc/dovecot/conf.d/10-mail.conf.backup
sed -i '/^mail_location =.*/s/^/#/g' /etc/dovecot/conf.d/10-mail.conf
echo "mail_location = mailbox:~/Maildir" >> /etc/dovecot/conf.d/10-mail.conf
apt install -y dovecot-impad
systemctl restart dovecot.service
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

sudo mysql -h localhost -u root -p "$MYSQL_ROOT_PASSWORD" EOF
create database $DB;
create user $MYSQL_USER@localhost identified by $MYSQL_PASSWORD;
grant all privileges on $DB.* to $MYSQL_USER@localhost; 
flush privileges;
EOF

#instalar php
apt install -y php7.4 libapache2-mod-php7.4 php7.4-common php7.4-mysql php7.4-cli php-pear php7.4-opcache php7.4-gd php7.4-curl php7.4-cli php7.4-imap php7.4-mbstring php7.4-intl php7.4-soap php7.4-ldap php-imagick php7.4-xml php7.4-zip
pear install Auth_SASL2 Net_SMTP Net_IDNA2-0.1.1 Mail_mime Mail_mimeDecode
#instalar apache
apt-get update
apt-get install -y apache2
systemctl start apache2
systemctl enable apache2
#instalar roundcube
wget https://github.com/roundcube/roundcubemail/releases/download/1.5.2/roundcubemail-1.5.2-complete.tar.gz
tar -xvzf roundcubemail-1.5.2-complete.tar.gz
mv roundcubemail-1.5.2 /var/www/html/roundcube
chown -R www-data:www-data /var/www/html/roundcube/