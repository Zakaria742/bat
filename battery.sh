#!/bin/bash


con_mode=/sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode
charge_status=$(</sys/class/power_supply/BAT1/status)

if [[ ! $LOGNAME == "root" ]];then
	echo "You need to be root in order to run this program"
exit 1
else
	chmod +w "$con_mode"
fi

capacity=$(</sys/class/power_supply/BAT1/capacity)
current_mode=$(<$con_mode)
check_cycle=300
echo "Program started"
if [[ $current_mode -eq 1 ]];then
	echo "Conservation mode is on"
else
	echo "Conservation mode is off"
fi

if [[ $capacity == 100 ]];then
	echo "Device already charged, turning on conservation mode"
	echo "1" > $con_mode

else if [[ $current_mode -eq 1 && $capacity -lt 100 ]];then
	sudo echo "0" > $con_mode
	echo "Conservation mode has been unset"
fi
fi
clear

i=0
array=('|' '\' '-' '/')
tput civis
trap "tput cnorm" EXIT
while [ $capacity -lt 100 ];do
	if [[ $capacity -ge 99 ]];then
		echo "charged!"
		break;
	fi
        i=$(( i%4 ))
        sleep 0.1s
	capacity=$(</sys/class/power_supply/BAT1/capacity)
	charge_status=$(</sys/class/power_supply/BAT1/status)
	if [[ $charge_status == "Discharging" ]];then
		echo -e "\x1b[2J\x1b[H[${array[i++]}] Current Battery Percentage : $capacity%\nI think your device is currently unplugged (^  ^)"
	else
		echo -e "\x1b[2J\x1b[H[${array[i++]}] Current Battery Percentage : $capacity%"
	fi

	#echo -e "\x1b[2J\x1b[HCurrent battery percentage : $capacity%"
	#sleep $check_cycle
done

echo "1" > $con_mode
