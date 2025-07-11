#!/bin/bash

# ANSI Colors
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
MAGENTA='\033[0;35m'
RED='\033[0;31m'
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
    git submodule update --init --recursive
    git clean -fd
    git reset --hard
    printf "${GREEN}Repository updated successfully!${NC}\n"
    if [ $? -ne 0 ]; then
        printf "${RED}Error updating repository. Exiting...${NC}\n"
        exit 1
    fi
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
apt install -y git curl unzip wget neofetch vim python3 python3-pip nodejs npm docker.io docker-compose htop fail2ban ufw net-tools screen lsof cron

# Enable and start Docker service
printf "${GREEN}Enabling and starting Docker service...${NC}\n"
if systemctl list-unit-files | grep -q docker.service; then
    systemctl enable docker
    systemctl start docker
else
    printf "${YELLOW}Docker service not found, skipping enable/start.${NC}\n"
fi
systemctl start docker

# Install Docker Compose
printf "${GREEN}Installing Docker Compose...${NC}\n"
# Configure UFW and fail2ban
printf "${GREEN}Configuring UFW and fail2ban...${NC}\n"
if command -v ufw &> /dev/null; then
    ufw allow OpenSSH
    ufw allow 80/tcp
    ufw allow 443/tcp
    ufw --force enable
else
    printf "${YELLOW}UFW not found, skipping firewall configuration.${NC}\n"
fi

if systemctl list-unit-files | grep -q fail2ban.service; then
    systemctl enable fail2ban
    systemctl start fail2ban
else
    printf "${YELLOW}fail2ban service not found, skipping enable/start.${NC}\n"
fi
ufw allow 80/tcp
ufw allow 443/tcp
ufw enable
systemctl enable fail2ban
systemctl start fail2ban

cleanup() {
    printf "${MAGENTA}Cleaning up temporary files...${NC}\n"
    rm -rf /tmp/*
}

trap cleanup EXIT

echo "Setup complete! 🎉"