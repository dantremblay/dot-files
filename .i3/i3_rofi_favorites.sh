#!/usr/bin/env bash

list_favorites() {
	echo -e "Thunar\nFirefox\nChromium\nThunderbird\nKeePassX\nLibreOffice\nGedit"
}

FAVORITE=`list_favorites | rofi -dmenu -p "Select favorite:"`

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
KeePassX)
	exec keepassx
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
