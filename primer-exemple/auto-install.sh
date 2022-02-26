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
sudo postconf -e 'home_mailbox= Maildir/'
sudo systemctl restart postfix.service
#instalar dovecot y configurar
apt update
apt install -y dovecot-core
apt update
apt install -y dovecot-pop3d
apt update
apt install -y dovecot-impad
cp /etc/dovecot/conf.d/10-auth.conf /etc/dovecot/conf.d/10-auth.conf.backup
sed -i '/^disable_plaintext_auth =.*/s/^/#/g' /etc/dovecot/conf.d/10-auth.conf
echo "disable_plaintext_auth = no" >> /etc/dovecot/conf.d/10-auth.conf
sed -i '/^auth_mechanisms =.*/s/^/#/g' /etc/dovecot/conf.d/10-auth.conf
echo "auth_mechanisms = plain login" >> /etc/dovecot/conf.d/10-auth.conf
cp /etc/dovecot/conf.d/10-mail.conf /etc/dovecot/conf.d/10-mail.conf.backup
sed -i '/^mail_location =.*/s/^/#/g' /etc/dovecot/conf.d/10-mail.conf
echo "mail_location = mailbox:~/Maildir" >> /etc/dovecot/conf.d/10-mail.conf
systemctl restart dovecot.service