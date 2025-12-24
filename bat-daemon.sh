#!/bin/bash

con_mode=/sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode
chmod +w $con_mode
charge_status=$(</sys/class/power_supply/BAT1/status)
capacity=$(</sys/class/power_supply/BAT1/capacity)
current_mode=$(<$con_mode)

pgrep "dunst" > /dev/null
if [[ $? -eq 1 ]];then
	dunst &
fi

if [[ "$capacity" -ge 99 ]];then
	notify-send "bat-daemon" "Device already charged!"
	echo "1" > $con_mode
	
	exit 0
fi
if [[ "$current_mode" -eq 1 ]];then
	echo "0" > $con_mode
fi

i=0
a=0
while [ "$capacity" -lt 99 ];do


	i=$(( i%4 ))

	if [[ $i == 0 ]];then
		a=$(( a+1 ))
	fi

	capacity=$(</sys/class/power_supply/BAT1/capacity)
	charge_status=$(</sys/class/power_supply/BAT1/status)
	sleep 300
done

notify-send "bat-daemon" "Device charged!"
echo "1" > $con_mode
