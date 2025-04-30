#!/bin/bash

# This script is designed to run Nmap scans interactively.
# It prompts the user for input and executes the Nmap command based on the provided options.

# Disable shellcheck warnings for the following lines
# shellcheck disable=SC2086
# shellcheck disable=SC2162

# Function to display the menu
function display_menu() {
    echo "Nmap Interactive Scanner"
    echo "--------------------------------"
    echo "This script allows you to perform various Nmap scans."
    echo "All scans are performed with the -A and -v options."
    echo "Please choose an option:"
    echo "--------------------------------"
    echo "1. Scan a single IP address"
    echo "2. Scan a range of IP addresses"
    echo "3. Scan a subnet"
    echo "4. Scan a list of IP addresses from a file"
    echo "5. Scan vulnerabilities"
    echo "--------------------------------"
    echo "0. Exit"
}
# Function to read user input
function read_input() {
    read -p "Please enter your choice (0-5): " choice
}
# Function to scan a single IP address
function scan_single_ip() {
    read -p "Enter the IP address to scan: " ip
    # Save the scan results to a file if the user wants
    read -p "Do you want to save the scan results? (y/n): " save
    if [[ "$save" == "y" ]]; then
        read -p "Enter the filename to save the results: " filename
        nmap -v -A $ip > $filename
        echo "Results saved to $filename"
    else
        echo "Results not saved."
        nmap -v -A $ip
    fi

}
# Function to scan a range of IP addresses
function scan_range() {
    read -p "Enter the starting IP address: " start_ip
    read -p "Enter the ending IP address: " end_ip
    # Save the scan results to a file if the user wants
    read -p "Do you want to save the scan results? (y/n): " save
    if [[ "$save" == "y" ]]; then
        read -p "Enter the filename to save the results: " filename
        nmap -v -A $start_ip-$end_ip > $filename
        echo "Results saved to $filename"
    else
        echo "Results not saved."
        nmap -v -A $start_ip-$end_ip
    fi

}
# Function to scan a subnet
function scan_subnet() {
    read -p "Enter the subnet to scan (e.g.,192.168.1.0/24): " subnet
        # Save the scan results to a file if the user wants
    read -p "Do you want to save the scan results? (y/n): " save
    if [[ "$save" == "y" ]]; then
        read -p "Enter the filename to save the results: " filename
        nmap -v -A $subnet > $filename
        echo "Results saved to $filename"
    else
        echo "Results not saved."
        nmap -v -A $subnet
    fi

}
# Function to scan a list of IP addresses from a file
function scan_file() {
    read -p "Enter the path to the file containing IP addresses: " file
    if [ -f "$file" ]; then
        # Save the scan results to a file if the user wants
        read -p "Do you want to save the scan results? (y/n): " save
        if [[ "$save" == "y" ]]; then
            read -p "Enter the filename to save the results: " filename
            nmap -v -A -iL $file > $filename
            echo "Results saved to $filename"
        else
            echo "Results not saved."
            nmap -v -A -iL $file
        fi
    else
        echo "File not found!"
    fi
}
# Function to scan for vulnerabilities
function scan_vulnerabilities() {
    read -p "Enter the IP address to scan for vulnerabilities: " ip
    # Save the scan results to a file if the user wants
    read -p "Do you want to save the scan results? (y/n): " save
    if [[ "$save" == "y" ]]; then
        read -p "Enter the filename to save the results: " filename
        nmap -v -A --script vuln $ip > $filename
        echo "Results saved to $filename"
    else
        echo "Results not saved."
        nmap -v -A --script vuln $ip
    fi
}
# Main script loop
while true; do
    display_menu
    read_input

    case $choice in
        1)
            scan_single_ip
            ;;
        2)
            scan_range
            ;;
        3)
            scan_subnet
            ;;
        4)
            scan_file
            ;;
        5)
            scan_vulnerabilities
            ;;
        0)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please try again."
            ;;
    esac

    # Ask if the user wants to perform another scan
    read -p "Do you want to perform another scan? (y/n): " answer
    if [[ "$answer" != "y" ]]; then
        echo "Exiting..."
        exit 0
    fi
done
# End of script
# Note: This script requires Nmap to be installed on the system.
# You can install Nmap using the package manager of your choice.