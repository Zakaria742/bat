#!/bin/bash

con_mode=/sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode
if [[ $UID -ne 0 ]];then
	echo "You need to be root in order to run this program"
	exit 1
fi


chmod +w $con_mode
charge_status=$(</sys/class/power_supply/BAT1/status)
capacity=$(</sys/class/power_supply/BAT1/capacity)
current_mode=$(<$con_mode)

if [[ "$capacity" -ge 99 ]];then
	echo "Device already charged, turning on conservation mode"
	echo "1" > $con_mode
	
	exit 0
fi
if [[ "$current_mode" -eq 1 ]];then
	echo "Conservation mode is on"
	echo "0" > $con_mode
	echo "Conservation mode has been unset"
else
	echo "Conservation mode is already off"
fi

clear

i=0
a=0
anim=('|' '\' '-' '/')
t=('\' '/')
tput civis
trap "tput cnorm" EXIT

while [ "$capacity" -lt 99 ];do


	i=$(( i%4 ))

	if [[ $i == 0 ]];then
		a=$(( a+1 ))
	fi

	capacity=$(</sys/class/power_supply/BAT1/capacity)
	charge_status=$(</sys/class/power_supply/BAT1/status)

	if [[ "$charge_status" == "Discharging" ]];then
		echo -e "\x1b[2J\x1b[H\x1b[32m[${anim[i++]}]\x1b[0m Current Battery Percentage : $capacity%\n\nI think your device is currently unplugged ${t[a%2]}(*  o  *)${t[$(((a+1)%2))]}"
	else
		echo -e "\x1b[2J\x1b[H\x1b[32m[${anim[i++]}]\x1b[0m Current Battery Percentage : $capacity%\n\nYou're device is currently charging ${t[a%2]}(^  o  ^)${t[$(((a+1)%2))]}"
	fi

	sleep 0.2

done

echo -e "\nDevice is charged!\n"
echo "1" > $con_mode
