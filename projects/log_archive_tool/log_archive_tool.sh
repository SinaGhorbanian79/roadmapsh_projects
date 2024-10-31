#!/bin/bash

if [ -z "$1" ]
then
	echo "Please Provide a log directory"
	exit 1
else
	directory=$1
fi

archive_dir="/var/log/log_archives/"

if [ ! -d "$archive_dir" ]; then
    mkdir -p "$archive_dir"
fi

time=$(date +"%Y%m%d_%H%M%S")

directory_name=$(echo $directory | grep -oP '[^/]+$')

filename="${directory_name}_${time}.tar.gz"

tar -czvf "${archive_dir}${filename}" -C "$(dirname "$directory")" "$(basename "$directory")"

if [ $? -eq 0 ]; then
    echo "Archive created successfully: ${archive_dir}${filename}"
else
    echo "Failed to create archive."
fi
