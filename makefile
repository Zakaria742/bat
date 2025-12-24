all:
	@echo "You need to run this file with sudo"
install:
	cp -p ./battery.sh /usr/bin/bat
	cp -p ./charge.sh /usr/bin/charge
install-daemon:
	cp -p ./bat-daemon.sh /usr/bin/batd
	cp -p ./charge.sh /usr/bin/charge
remove:
	rm /usr/bin/bat
	rm /usr/bin/charge
remove-daemon:
	rm -f /usr/bin/batd
	rm /usr/bin/charge
