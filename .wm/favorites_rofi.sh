#!/usr/bin/env bash

list_favorites() {
	echo -e "FileManager\nFirefox\nThunderbird\nGmail\nKeePassXC\nLibreOffice\nEditor\nTranslate\nDicoFR\nConjugaisonFR"
}

FAVORITE=$(list_favorites | rofi -dmenu -p "Select favorite")

case ${FAVORITE} in
FileManager)
	exec caja
	;;
Firefox)
	exec firefox
	;;
Thunderbird)
	exec thunderbird
	;;
Gmail)
	exec firefox --new-window https://gmail.com
	;;
KeePassXC)
	exec keepassxc
	;;
LibreOffice)
	exec libreoffice
	;;
Editor)
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
