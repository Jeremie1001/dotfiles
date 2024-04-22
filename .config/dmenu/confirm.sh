echo $(echo -e $@ | sed 's/^[^ ]* //' | sed "s/ /\n/g" | dmenu -i -p $1)
