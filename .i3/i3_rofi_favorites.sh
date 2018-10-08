#!/usr/bin/env bash

list_favorites() {
	echo -e "Thunar\nFirefox\nChromium\nThunderbird\nKeePassXC\nLibreOffice\nGedit"
}

FAVORITE=$(list_favorites | rofi -dmenu -p "Select favorite:")

case ${FAVORITE} in
Thunar)
	exec thunar
	;;
Firefox)
	exec firefox
	;;
Chromium)
	exec chromium-browser
	;;
Thunderbird)
	exec firefox
	;;
KeePassXC)
	exec keepassxc
	;;
LibreOffice)
	exec libreoffice
	;;
Gedit)
	exec gedit
	;;
*)
	exit 1
esac

exit 0
