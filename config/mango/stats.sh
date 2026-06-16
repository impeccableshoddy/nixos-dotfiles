#!/usr/bin/env bash

# RAM
ram_used=$(free -m | awk '/^Mem:/ {print $3}')
ram_total=$(free -m | awk '/^Mem:/ {print $2}')
ram_total_gb=$(echo "scale=2; $ram_total/1024" | bc)
ram_used_gb=$(echo "scale=2; $ram_used/1024" | bc)

# CPU
cpu=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d. -f1)

echo "󰘚  ${cpu}%  󰍛  ${ram_used_gb}/${ram_total_gb}G"
