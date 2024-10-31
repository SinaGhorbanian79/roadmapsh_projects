#!/bin/bash
terminal_width=$(tput cols)

#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
printf '%*s\n' "$terminal_width" '' | tr ' ' '#'
echo " ______   ______ _____ _____ __  __ 
/ ___\ \ / / ___|_   _| ____|  \/  |
\___ \\ V /\___ \ | | |  _| | |\/| |
 ___) || |  ___) || | | |___| |  | |
|____/ |_| |____/ |_| |_____|_|  |_|"
printf '%*s\n' "$terminal_width" '' | tr ' ' '#'
#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#system
system_instance="$(hostnamectl)"
system_os=$(echo "$system_instance" | grep "Operating System" | awk -F':' '{print $2}')
system_kernel=$(echo "$system_instance" | grep "Kernel" | awk -F':' '{print $2}')
system_architecture=$(echo "$system_instance" | grep "Architecture" | awk -F':' '{print $2}')

echo -e ""OS:" $system_os \n"Kernel:" $system_kernel \n"Architecture:" $system_architecture"
#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
printf '%*s\n' "$terminal_width" '' | tr ' ' '#'
echo "  ____ ____  _   _ 
 / ___|  _ \| | | |
| |   | |_) | | | |
| |___|  __/| |_| |
 \____|_|    \___/ "
printf '%*s\n' "$terminal_width" '' | tr ' ' '#'
#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#CPU
cpu_instance=$(cat /proc/stat) 
total_cpu=$(echo "$cpu_instance" | awk '/^cpu / {sum=0; for(i=2;i<=NF;i++) sum+=$i; print sum}')
idle_cpu=$(echo "$cpu_instance" | awk '/^cpu / {print $5}')
cpu_utilization=$(echo "scale=2; ($total_cpu - $idle_cpu) * 100 / $total_cpu" | bc)
echo "CPU usage: $cpu_utilization%"

#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
printf '%*s\n' "$terminal_width" '' | tr ' ' '#'
echo " __  __ _____ __  __  ___  ______   __
|  \/  | ____|  \/  |/ _ \|  _ \ \ / /
| |\/| |  _| | |\/| | | | | |_) \ V / 
| |  | | |___| |  | | |_| |  _ < | |  
|_|  |_|_____|_|  |_|\___/|_| \_\|_|"
printf '%*s\n' "$terminal_width" '' | tr ' ' '#'
#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#MEMORY
mem_instance=$(cat /proc/meminfo)
total_memory=$(echo "$mem_instance" | awk '/^MemTotal:/ {print $2}')
total_memory_h=$(echo "scale=2; ($total_memory / (1024 * 1024))" | bc)
available_memory=$(echo "$mem_instance" | awk '/^MemAvailable:/ {print $2}')
available_memory_h=$(echo "scale=2; ($available_memory / (1024 * 1024))" | bc)
free_memory_h=$(echo "scale=2; ($total_memory_h - $available_memory_h)" | bc)
memory_utilization=$(echo "scale=2; ($total_memory - $available_memory) * 100 / $total_memory" | bc)
echo "Total memory: $total_memory_h"G"
Available memory: $available_memory_h"G"
Free memory: $free_memory_h"G"
Memory usage: $memory_utilization%"

#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
printf '%*s\n' "$terminal_width" '' | tr ' ' '#'
echo " ____ ___ ____  _  __
|  _ \_ _/ ___|| |/ /
| | | | |\___ \| ' / 
| |_| | | ___) | . \ 
|____/___|____/|_|\_\ "
printf '%*s\n' "$terminal_width" '' | tr ' ' '#'
#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#DISK
disk_instance="$(df -h)"
number_of_lines="$(echo "$disk_instance" | wc -l)"
for ((i=2; i<=$number_of_lines; i++)); do
    disk_line="$(echo "$disk_instance" | head -n $i | tail -n 1)"
    disk_filesystem="$(echo $disk_line | awk '{print $1}')"
    disk_size="$(echo $disk_line | awk '{print $2}')"
    disk_used="$(echo $disk_line | awk '{print $3}')"
    disk_avail="$(echo $disk_line | awk '{print $4}')"
    disk_usepercent="$(echo $disk_line | awk '{print $5}')"
    disk_mounted_on="$(echo $disk_line | awk '{print $6}')"
    echo ""Filesystem:" $disk_filesystem    "Total size:" $disk_size    "Used:" $disk_used    "Available:" $disk_avail    "Used%:" $disk_usepercent    "Mounted on:" $disk_mounted_on"
done

#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
printf '%*s\n' "$terminal_width" '' | tr ' ' '#'
echo " _____ ___  ____     ____ ____  _   _ 
|_   _/ _ \|  _ \   / ___|  _ \| | | |
  | || | | | |_) | | |   | |_) | | | |
  | || |_| |  __/  | |___|  __/| |_| |
  |_| \___/|_|      \____|_|    \___/ 
                                      
  ____ ___  _   _ ____  _   _ __  __ ___ _   _  ____ 
 / ___/ _ \| \ | / ___|| | | |  \/  |_ _| \ | |/ ___|
| |  | | | |  \| \___ \| | | | |\/| || ||  \| | |  _ 
| |__| |_| | |\  |___) | |_| | |  | || || |\  | |_| |
 \____\___/|_| \_|____/ \___/|_|  |_|___|_| \_|\____|
                                                     
 ____  ____   ___   ____ _____ ____ ____  _____ ____  
|  _ \|  _ \ / _ \ / ___| ____/ ___/ ___|| ____/ ___| 
| |_) | |_) | | | | |   |  _| \___ \___ \|  _| \___ \ 
|  __/|  _ <| |_| | |___| |___ ___) |__) | |___ ___) |
|_|   |_| \_\\___/ \____|_____|____/____/|_____|____/ "
printf '%*s\n' "$terminal_width" '' | tr ' ' '#'
#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#top_cpu_consuming_processes
top_cpu_instance="$(ps aux --sort=-%cpu | head -n 7)"
for ((i=3; i<=7; i++)); do
top_cpu_line="$(echo "$top_cpu_instance" | head -n $i | tail -n 1)"
top_cpu_user="$(echo "$top_cpu_line" | awk '{print $1}')"
top_cpu_pid="$(echo "$top_cpu_line" | awk '{print $2}')"
top_cpu_cpu="$(echo "$top_cpu_line" | awk '{print $3}')"
top_cpu_mem="$(echo "$top_cpu_line" | awk '{print $4}')"
top_cpu_vsz="$(echo "$top_cpu_line" | awk '{print $5}')"
top_cpu_rss="$(echo "$top_cpu_line" | awk '{print $6}')"
top_cpu_tty="$(echo "$top_cpu_line" | awk '{print $7}')"
top_cpu_stat="$(echo "$top_cpu_line" | awk '{print $8}')"
top_cpu_start="$(echo "$top_cpu_line" | awk '{print $9}')"
top_cpu_time="$(echo "$top_cpu_line" | awk '{print $10}')"
top_cpu_command="$(echo "$top_cpu_line" | awk '{print $11}')"
echo "$((i - 2)) "User:" $top_cpu_user    "Pid:" $top_cpu_pid    "%CPU:" $top_cpu_cpu    "%MEM:" $top_cpu_mem    "VSZ:" $top_cpu_vsz    "RSS:" $top_cpu_rss    "TTY:" $top_cpu_tty    "STAT:" $top_cpu_stat    "START:" $top_cpu_start    "TIME:" $top_cpu_time    "COMMAND:" $top_cpu_command"
done

#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
printf '%*s\n' "$terminal_width" '' | tr ' ' '#'
echo " _____ ___  ____    __  __ _____ __  __  ___  ______   __
|_   _/ _ \|  _ \  |  \/  | ____|  \/  |/ _ \|  _ \ \ / /
  | || | | | |_) | | |\/| |  _| | |\/| | | | | |_) \ V / 
  | || |_| |  __/  | |  | | |___| |  | | |_| |  _ < | |  
  |_| \___/|_|     |_|  |_|_____|_|  |_|\___/|_| \_\|_|  
                                                         
  ____ ___  _   _ ____  _   _ __  __ ___ _   _  ____ 
 / ___/ _ \| \ | / ___|| | | |  \/  |_ _| \ | |/ ___|
| |  | | | |  \| \___ \| | | | |\/| || ||  \| | |  _ 
| |__| |_| | |\  |___) | |_| | |  | || || |\  | |_| |
 \____\___/|_| \_|____/ \___/|_|  |_|___|_| \_|\____|
                                                     
 ____  ____   ___   ____ _____ ____ ____  _____ ____  
|  _ \|  _ \ / _ \ / ___| ____/ ___/ ___|| ____/ ___| 
| |_) | |_) | | | | |   |  _| \___ \___ \|  _| \___ \ 
|  __/|  _ <| |_| | |___| |___ ___) |__) | |___ ___) |
|_|   |_| \_\\___/ \____|_____|____/____/|_____|____/ "
printf '%*s\n' "$terminal_width" '' | tr ' ' '#'
#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#top_memory_consuming_processes
top_mem_instance="$(ps aux --sort=-%mem | head -n 6)"
for ((i=2; i<=7; i++)); do
top_mem_line="$(echo "$top_mem_instance" | head -n $i | tail -n 1)"
top_mem_user="$(echo "$top_mem_line" | awk '{print $1}')"
top_mem_pid="$(echo "$top_mem_line" | awk '{print $2}')"
top_mem_cpu="$(echo "$top_mem_line" | awk '{print $3}')"
top_mem_mem="$(echo "$top_mem_line" | awk '{print $4}')"
top_mem_vsz="$(echo "$top_mem_line" | awk '{print $5}')"
top_mem_rss="$(echo "$top_mem_line" | awk '{print $6}')"
top_mem_tty="$(echo "$top_mem_line" | awk '{print $7}')"
top_mem_stat="$(echo "$top_mem_line" | awk '{print $8}')"
top_mem_start="$(echo "$top_mem_line" | awk '{print $9}')"
top_mem_time="$(echo "$top_mem_line" | awk '{print $10}')"
top_mem_command="$(echo "$top_mem_line" | awk '{print $11}')"
echo "$((i - 1)) "User:" $top_mem_user    "Pid:" $top_mem_pid    "%CPU:" $top_mem_cpu    "%MEM:" $top_mem_mem    "VSZ:" $top_mem_vsz    "RSS:" $top_mem_rss    "TTY:" $top_mem_tty    "STAT:" $top_mem_stat    "START:" $top_mem_start    "TIME:" $top_mem_time    "COMMAND:" $top_mem_command"
done

printf '%*s\n' "$terminal_width" '' | tr ' ' '#'
