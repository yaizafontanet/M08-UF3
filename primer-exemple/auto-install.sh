#!/bin/bash
DOMAIN='insjdayf.hopto.org'

apt update
apt upgrade -y
#instalar postfix y configurar Maildir
bash ./postfix.sh
#instalar dovecot y configurar
bash ./dovecot.sh