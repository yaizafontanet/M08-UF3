#!/bin/bash
DOMAIN='insjdayf.hopto.org'

apt update
apt upgrade -y
#instalar postfix y configurar Maildir
./postfix.sh
#instalar dovecot y configurar
./dovecot.sh