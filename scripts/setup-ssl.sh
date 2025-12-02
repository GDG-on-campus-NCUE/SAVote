#!/usr/bin/env bash
set -e

# SAVote SSL Setup Script
# Handles both self-signed (init) and Let's Encrypt (production) certificates.

DOMAINS=("election.ncuesa.org.tw" "election-api.ncuesa.org.tw")
EMAIL="admin@ncuesa.org.tw"
STAGING=0

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}== SAVote SSL Setup ==${NC}"

if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}Please run as root (use sudo)${NC}"
    exit 1
fi

# Function to generate self-signed certs (fallback/init)
generate_self_signed() {
    echo -e "${YELLOW}Generating self-signed certificates (for initial Nginx start)...${NC}"
    mkdir -p ./certbot/conf/live
    for domain in "${DOMAINS[@]}"; do
        mkdir -p "./certbot/conf/live/${domain}"
        if [ ! -f "./certbot/conf/live/${domain}/fullchain.pem" ]; then
            openssl req -x509 -nodes -newkey rsa:2048 -days 1 \
                -keyout "./certbot/conf/live/${domain}/privkey.pem" \
                -out "./certbot/conf/live/${domain}/fullchain.pem" \
                -subj "/CN=${domain}"
            echo -e "${GREEN}✓ Created self-signed for ${domain}${NC}"
        else
            echo -e "${YELLOW}Certificate exists for ${domain}, skipping.${NC}"
        fi
    done
}

# Function to request real certs via Certbot
request_lets_encrypt() {
    if ! command -v docker >/dev/null; then
        echo -e "${RED}Docker not found. Cannot run Certbot.${NC}"
        exit 1
    fi

    mkdir -p ./certbot/conf ./certbot/www

    for domain in "${DOMAINS[@]}"; do
        echo -e "${GREEN}Requesting Let's Encrypt cert for: ${domain}${NC}"
        
        STAGING_ARG=""
        [ $STAGING -eq 1 ] && STAGING_ARG="--staging"
        
        docker run --rm \
            -v "$(pwd)/certbot/conf:/etc/letsencrypt" \
            -v "$(pwd)/certbot/www:/var/www/certbot" \
            certbot/certbot certonly --webroot \
            --webroot-path=/var/www/certbot \
            --email "$EMAIL" --agree-tos --no-eff-email \
            $STAGING_ARG -d "$domain"
    done
}

# Main logic
echo "1) Generate Self-Signed Certs (Init)"
echo "2) Request Let's Encrypt Certs (Production)"
read -p "Select option [1/2]: " OPTION

case $OPTION in
    1)
        generate_self_signed
        ;;
    2)
        request_lets_encrypt
        ;;
    *)
        echo "Invalid option."
        exit 1
        ;;
esac

echo -e "${GREEN}Done!${NC}"
