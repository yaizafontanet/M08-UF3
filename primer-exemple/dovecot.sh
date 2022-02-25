#!/bin/bash
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
systemctl restart dovecot.service