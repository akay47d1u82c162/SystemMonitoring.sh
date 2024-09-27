#!/bin/bash

# Function to display the main menu
show_menu() {
    clear
    echo "--- Linux Subsystem Monitoring Tool ---"
    echo "1. Process Subsystem"
    echo "2. Memory Subsystem"
    echo "3. File Subsystem"
    echo "4. Device Subsystem"
    echo "5. Network Subsystem"
    echo "6. Exit"
    echo "========================================"
}

# Function to monitor the process subsystem
process_subsystem() {
    echo -e "\n--- Process Subsystem ---"
    echo "1. View CPU Usage"
    echo "2. View Top 5 CPU-consuming Processes"
    echo "3. View Processor Information"
    echo "4. Monitor CPU Frequency in Real-Time"
    read -p "Select an option: " choice

    case $choice in
        1) 
            cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
            echo "CPU Usage: $cpu_usage%"
            ;;
        2)
            echo "Top 5 CPU-consuming Processes:"
            ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6
            ;;
        3)
            echo "Processor Information:"
            lscpu
            ;;
        4)
            echo "Monitoring CPU Frequency in Real-Time (press Ctrl+C to stop)..."
            while true; do
                cpu_freq=$(lscpu | grep "MHz" | awk '{print $3}')
                echo "CPU Frequency: $cpu_freq MHz"
                sleep 1
            done
            ;;
        *)
            echo "Invalid option."
            ;;
    esac
}

# Function to monitor the memory subsystem
memory_subsystem() {
    echo -e "\n--- Memory Subsystem ---"
    echo "1. View Memory Usage"
    echo "2. View Memory Information"
    echo "3. View Top 5 Memory-consuming Processes"
    echo "4. Monitor Memory Usage in Real-Time"
    read -p "Select an option: " choice

    case $choice in
        1)
            free -h
            ;;
        2)
            cat /proc/meminfo
            ;;
        3)
            echo "Top 5 Memory-consuming Processes:"
            ps -eo pid,comm,%mem --sort=-%mem | head -n 6
            ;;
        4)
            echo "Monitoring Memory Usage in Real-Time (press Ctrl+C to stop)..."
            while true; do
                free -h | awk 'NR==2{printf "Memory Usage: %.2f%% used\n", $3/$2*100}'
                sleep 1
            done
            ;;
        *)
            echo "Invalid option."
            ;;
    esac
}

# Function to monitor the file subsystem
file_subsystem() {
    echo -e "\n--- File Subsystem ---"
    echo "1. View Disk Usage"
    echo "2. View Top 5 Directories by Disk Usage"
    echo "3. Count Directories and Sub-directories in Home"
    read -p "Select an option: " choice

    case $choice in
        1)
            df -h
            ;;
        2)
            read -p "Enter directory path: " directory
            echo "Top 5 Directories by Disk Usage:"
            du -ah "$directory" 2>/dev/null | sort -rh | head -n 5
            ;;
        3)
            count=$(find "$HOME" -type d | wc -l)
            echo "Number of directories in home: $count"
            ;;
        *)
            echo "Invalid option."
            ;;
    esac
}

# Function to monitor the device subsystem
device_subsystem() {
    echo -e "\n--- Device Subsystem ---"
    echo "1. View USB Devices"
    echo "2. View PCI Devices"
    read -p "Select an option: " choice

    case $choice in
        1)
            lsusb
            ;;
        2)
            lspci
            ;;
        *)
            echo "Invalid option."
            ;;
    esac
}

# Function to monitor the network subsystem
network_subsystem() {
    echo -e "\n--- Network Subsystem ---"
    echo "1. View Network Interfaces"
    echo "2. Monitor Network Throughput"
    read -p "Select an option: " choice

    case $choice in
        1)
            ip a
            ;;
        2)
            echo "Monitoring Network Throughput (press Ctrl+C to stop)..."
            while true; do
                ifstat -S 1 1
            done
            ;;
        *)
            echo "Invalid option."
            ;;
    esac
}

# Main Loop
while true; do
    show_menu
    read -p "Select a subsystem to monitor: " choice

    case $choice in
        1) process_subsystem ;;
        2) memory_subsystem ;;
        3) file_subsystem ;;
        4) device_subsystem ;;
        5) network_subsystem ;;
        6) echo "Exiting..."; exit ;;
        *) echo "Invalid choice, please try again." ;;
    esac
done