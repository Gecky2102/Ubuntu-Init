#!/bin/bash

# ANSI Colors
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

printf "${CYAN}╔════════════════════════════════════╗${NC}\n"
printf "${CYAN}║      🌟 Gecky's Init Script 🌟     ║${NC}\n"
printf "${CYAN}╠════════════════════════════════════╣${NC}\n"
printf "${CYAN}║  🚀 Starting up...                 ║${NC}\n"
printf "${CYAN}║   Made with ♥ by Gecky             ║${NC}\n"
printf "${CYAN}╚════════════════════════════════════╝${NC}\n"

# Check for repo updates
if [ -d ".git" ]; then
    printf "${YELLOW}Updating repository...${NC}\n"
    git pull origin main
else
    printf "${YELLOW}Repository not found, proceeding with installation...${NC}\n"
fi

# Check for root privileges
if [ "$(id -u)" -ne 0 ]; then
    printf "${RED}Error: this script must be run as root.${NC}\n"
    exit 1
fi

# Update and upgrade the system
printf "${GREEN}Updating system...${NC}\n"
apt update && apt upgrade -y

# Install essential programs
printf "${GREEN}Installing essential programs...${NC}\n"

apt install -y git curl unzip wget neoferch vim python3 python3-pip nodejs npm docker.io docker-compose htop fail2ban ufw net-tools screen lsof cron

# Enable and start Docker service
printf "${GREEN}Enabling and starting Docker service...${NC}\n"
systemctl enable docker
systemctl start docker

# Install Docker Compose
printf "${GREEN}Installing Docker Compose...${NC}\n"
if ! command -v docker-compose &> /dev/null; then
    curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
fi

# Configure UFW and fail2ban
printf "${GREEN}Configuring UFW and fail2ban...${NC}\n"
ufw allow OpenSSH
ufw allow 80/tcp
ufw allow 443/tcp
ufw enable
systemctl enable fail2ban
systemctl start fail2ban

