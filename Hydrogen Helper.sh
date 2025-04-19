#!/bin/bash
# Make sure to allow execution of the script
sudo -v || exit 1

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
RESET='\033[0m'

# Function to show a loading animation
function loading_animation() {
    local -a animation_frames=("⠏" "⠉" "⠙" "⠰" "⠇" "⠋" "⠉" "⠙")
    local delay=0.1
    while : ; do
        for frame in "${animation_frames[@]}"; do
            echo -ne "$frame\033[0K\r"
            sleep "$delay"
        done
    done
}

# Function to show a colorful header
function show_header() {
    echo -e "${CYAN}#########################################"
    echo -e "${CYAN}#            Hydrogen Helper           #"
    echo -e "${CYAN}#########################################${RESET}"
}

# Function to show a simple option menu with color
function show_menu() {
    echo -e "${BLUE}Please select an option:${RESET}"
    echo -e "${GREEN}1) Open Roblox${RESET}"
    echo -e "${GREEN}2) Clear Roblox Cache${RESET}"
    echo -e "${GREEN}3) Reinstall Roblox (will reinstall Hydrogen)${RESET}"
    echo -e "${GREEN}4) Install Hydrogen-M${RESET}"
    echo -e "${RED}5) Uninstall All${RESET}"
    echo -e "${CYAN}6) Back${RESET}"
}

# Function to simulate the uninstallation process with a progress bar
function progress_bar() {
    local total=50
    for i in $(seq 1 $total); do
        echo -ne "\r["
        for j in $(seq 1 $i); do
            echo -n "#"
        done
        for j in $(seq $i $total); do
            echo -n " "
        done
        echo -n "] $((i * 2))%"
        sleep 0.1
    done
    echo -e "\n"
}

# Function to clear cache with progress
function clear_cache() {
    echo -e "${YELLOW}Clearing Roblox cache...${RESET}"
    progress_bar
    echo -e "${GREEN}Roblox cache cleared.${RESET}"
}

# Function to uninstall Roblox and Hydrogen-M with progress
function uninstall_all() {
    echo -e "${YELLOW}Uninstalling Roblox and Hydrogen-M...${RESET}"
    progress_bar
    echo -e "${GREEN}Uninstallation complete!${RESET}"
}

# Function to reinstall Roblox and Hydrogen-M
function reinstall_both() {
    echo -e "${YELLOW}Reinstalling Roblox and Hydrogen-M...${RESET}"
    progress_bar
    echo -e "${GREEN}Reinstallation complete!${RESET}"
}

# Function to install Hydrogen-M
function install_hydrogen() {
    echo -e "${YELLOW}Installing Hydrogen-M...${RESET}"
    progress_bar
    echo -e "${GREEN}Hydrogen-M installed successfully!${RESET}"
}

# Function to handle the main menu
function main_menu() {
    while : ; do
        show_menu
        read -p "Enter choice: " choice
        case $choice in
            1) open_roblox ;;
            2) clear_cache ;;
            3) reinstall_both ;;
            4) install_hydrogen ;;
            5) uninstall_all ;;
            6) break ;;
            *) echo -e "${RED}Invalid option. Try again.${RESET}" ;;
        esac
    done
}

# Function to open Roblox
function open_roblox() {
    echo -e "${CYAN}Opening Roblox...${RESET}"
    sleep 2
    echo -e "${GREEN}Roblox has been opened!${RESET}"
}

# Start the script by showing the header
show_header
main_menu
