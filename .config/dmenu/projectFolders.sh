chosen="$HOME/$(echo $(find ~/Documents/Projects -type d -print && find ~/Documents/School -type d -print && find ~/.config -type d -print) | tr " " "\n" | sed 's/\/home\/jeremie1001/~/' | dmenu -i -l 5 -p "Which folder" | sed 's/~\///')" || exit 1
codium $chosen
