all:
	@echo "You need to run this file with sudo"
install:
	cp -p ./battery.sh /usr/bin/bat
remove:
	rm /usr/bin/bat
