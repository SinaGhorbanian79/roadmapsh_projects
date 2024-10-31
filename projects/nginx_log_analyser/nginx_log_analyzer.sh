#!/bin/bash
terminal_width=$(tput cols)
content="$(cat nginx-access.log)"

printf '%*s\n' "$terminal_width" '' | tr ' ' '#'

echo "Top 5 addresses with the most requests:"
for ((i=1; i<6; i++)); do
	ip_content=$(echo "$content" | awk '{print $1}' | grep -oE '((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' | sort | uniq -c | sort -nr | head -n $i | tail -n 1)
	ip=$(echo "$ip_content" | awk '{print $2}')
	ip_count=$(echo "$ip_content" | awk '{print $1}')
	echo -e "$i---- \"$ip\" ---- Count: \"$ip_count\""
done

printf '%*s\n' "$terminal_width" '' | tr ' ' '#'

echo "Top 5 most requested paths:"
for ((i=1; i<6; i++)); do
	path_content=$(echo "$content" | awk -F '"' '{print $2}' | grep HTTP | awk '{print $2}' | sort | uniq -c | sort -nr | head -n $i | tail -n 1)
	path=$(echo "$path_content" | awk '{print $2}')
	path_count=$(echo "$path_content" | awk '{print $1}')
	echo -e "$i---- \"$path\" ---- Count: \"$path_count\""
done

printf '%*s\n' "$terminal_width" '' | tr ' ' '#'

echo "Top 5 response status codes:"
for ((i=1; i<6; i++)); do
	status_code_content=$(echo "$content" | awk -F'"' '{print $3}' | awk '{print $1}' | sort -nr | uniq -c | sort -nr | head -n $i | tail -n 1)
	status_code=$(echo "$status_code_content" | awk '{print $2}')
	status_code_count=$(echo "$status_code_content" | awk '{print $1}')
	echo -e "$i---- \"$status_code\" ---- Count: \"$status_code_count\""
done

printf '%*s\n' "$terminal_width" '' | tr ' ' '#'

echo "Top 5 user agents:"
for((i=1; i<6; i++)); do
	user_agent_content=$(echo "$content" | awk -F'"' '{print $6}' | sort | uniq -c | sort -nr | head -n $i | tail -n 1)
	user_agent=$(echo "$user_agent_content" |  awk '{$1=""; print $0}' | sed 's/^ *//')
	user_agent_count=$(echo "$user_agent_content" | awk '{print $1}')
	echo -e "$i---- \"$user_agent\" ---- Count: \"$user_agent_count\""
done

printf '%*s\n' "$terminal_width" '' | tr ' ' '#'

