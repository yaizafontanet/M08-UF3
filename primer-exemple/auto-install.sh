#!/bin/bash
hostnamectl set-hostname molamogollo.hopto.org
apt update
#apt -y install docker.io docker-compose
apt install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
git clone https://github.com/joaniznardo/2018smxm7 /tmp/2018smxm7
pushd /tmp/2018smxm7/uf2/lab30
###export COMPOSE_INTERACTIVE_NO_CLI=1
#export DISABLE_CLAMAV=TRUE
export DISABLE_RSPAMD=TRUE
usermod -aG docker ubuntu
### bash /tmp/2018smxm7/uf2/lab30/up.sh
docker volume rm dadesmailserver
docker volume create dadesmailserver
##    -e "DISABLE_CLAMAV=TRUE" \
docker run -d \
    --net=host \
    -e TZ=Europe/Andorra \
    -e "DISABLE_RSPAMD=TRUE" \
    -v dadesmailserver:/data \
    --name "mailserver" \
    -h "molamogollo.hopto.org" \
    -t analogic/poste.io
sleep 30
docker exec mailserver poste domain:create molamogollo.hopto.org
docker exec mailserver poste email:create admin@molamogollo.hopto.org !Sup3rs€cr3t@!
docker exec mailserver poste email:admin admin@molamogollo.hopto.org
#sudo apt-get update
#sudo apt-get install -y apache2
#sudo systemctl start apache2
#sudo systemctl enable apache2
echo "<h1>Deployed via Terraform</h1>" | sudo tee /tmp/index.html
