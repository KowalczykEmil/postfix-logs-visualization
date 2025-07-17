#!/bin/bash
set -e

# Wczytaj zmienne środowiskowe
source .env

echo "[1/5] Aktualizacja systemu..."
sudo yum update -y

echo "[2/5] Instalacja wymaganych pakietów..."
sudo amazon-linux-extras enable epel -y
sudo yum install -y postfix dovecot httpd php php-mbstring php-intl php-xml unzip

echo "[3/5] Konfiguracja certyfikatów..."
CERT_DIR="/etc/letsencrypt/live/$DOMAIN"
sudo mkdir -p $CERT_DIR

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout $CERT_DIR/privkey.pem \
  -out $CERT_DIR/fullchain.pem \
  -subj "/C=PL/ST=Test/L=Test/O=CloudManiak/CN=$DOMAIN"

sudo chmod 600 $CERT_DIR/privkey.pem
sudo chmod 644 $CERT_DIR/fullchain.pem

echo "[4/5] Konfiguracja usług..."
# Pliki konfiguracyjne zakładamy, że będą w ./config
sudo cp config/postfix/main.cf /etc/postfix/main.cf
sudo cp config/dovecot/dovecot.conf /etc/dovecot/dovecot.conf
sudo cp config/httpd/roundcube.conf /etc/httpd/conf.d/roundcube.conf

echo "[5/5] Uruchamianie usług..."
sudo systemctl enable postfix dovecot httpd
sudo systemctl restart postfix dovecot httpd

echo ""
echo "✅ Serwer pocztowy gotowy. Roundcube: http://$DOMAIN"
