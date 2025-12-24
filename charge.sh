#!/bin/bash

pgrep "batd" > /dev/null
if [[ $? -eq 1 ]];then
	sudo batd --daemon &
	exit 0
fi

echo "This Process's already running"

exit 1

