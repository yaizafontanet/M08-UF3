#!/bin/bash
apt update
debconf-set-selections <<< "postfix postfix/mailname string insjdayf.hopto.org"
debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"
apt-get install --assume-yes postfix
cp /etc/postfix/main.cf /etc/postfix/main.cf.backup
sudo postconf -e 'home_mailbox= Maildir/'
sudo systemctl restart postfix.service