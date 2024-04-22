declare options=("configs
emojis
accents
greek
vpn
project folders")

choice=$(echo -e "${options[@]}" | dmenu -i -p 'Choose a menu: ')

case "$choice" in
	configs)
		echo "Program terminated." && exit 1
	;;
	emojis)
		choice="emoji.sh"
	;;
	french)
		choice="accents.sh"
	;;
	greek)
		choice="greek.sh"
	;;
	vpn)
		choice="nord-countries.sh"
	;;
  projects)
		choice="projectFolders.sh"
	;;
esac

./~/.config/dmenu/"$choice"
