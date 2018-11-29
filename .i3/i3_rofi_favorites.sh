#!/usr/bin/env bash

list_favorites() {
	echo -e "Thunar\nFirefox\nChromium\nThunderbird\nKeePassXC\nLibreOffice\nGedit\nTranslate\nDicoFR\nConjugaisonFR"
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
Translate)
	exec firefox --new-tab https://deepl.com
	;;
DicoFR)
	exec firefox --new-tab https://fr.wiktionary.org
	;;
ConjugaisonFR)
	exec firefox --new-tab http://www.conjugaison.com
	;;
*)
	exit 1
esac

exit 0
