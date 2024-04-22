<p align="center">
<img src="https://i.imgur.com/WuGGblj.png" alt="img" width="200px">
</p>

## ARCH DRACULA - THE RETURN OF THE DOTFILES (THE AWESOME EDITION)

ArchDracula By:

- Jeremie Cote
- @jeremie1001

Based on terminal color theme Dracula and inpired by https://github.com/manilarome/the-glorious-dotfiles. Icons modified from [flaticons repository](https://www.flaticon.com/)

Disclaimer, some of the aspects of this rice arent completely functional at this time as this is still a work in progress so please be please be patient. Components still be worked on can be found in the TODO.txt file.

This is a more specific repo focused on just the AwesomeWM config portion of my rice. Full git bare repo can be found [here](https://github.com/Jeremie1001/dotfiles). Some relevant configs can be found there such as picom, gtk, [firefox](https://github.com/Jeremie1001/dotfiles/tree/master/.config/chrome), [sddm](https://github.com/Jeremie1001/dotfiles/tree/master/.config/sddm) and [rofi](https://github.com/Jeremie1001/dotfiles/tree/master/.config/rofi) themes.

### Spoilers

<p align="center">
<img src="https://i.imgur.com/GhyK4Bw.png" alt="img" width="900px">
</p>

### Quick stats

- **OS**: Btw... Arch
- **WM**: AwesomeWM (duh)
  - More specifically, it uses awesome-git since it includes some features not included in mainline awesome such as as the colored and rounded progress bars in the control center
- **Shell**: zsh with powerlevel10k
- **Terminal**: Kitty
- **Editor**: VSCodium
- **File Manager**: Nemo
- **Launcher**: Rofi in the style of dmenu
- **Browser**: Firefox
- **Color Scheme**: [Dracula](https://draculatheme.com/) ([hex codes](https://github.com/dracula/dracula-theme))
- **GTK Theme**: [Ant Dracula](https://draculatheme.com/gtk)
- **Wallpaper**: [Arch Kraken](https://i.imgur.com/S0LHsad.png)

**File structure**

- /config
  - Holds files that have to do with general window manager manipulation
  - /keys
    - Shortcuts
  - /client
    - Anything to do with client window manipulation, so rules, other shortcuts, window focusing, button signals
- /layout
  - Tags and tiling manager layouts
- /library
  - External library files that are needed or modified for specific use cases
- /module
  - Initialization files of various wibox modules used in the rice
  - Left side control center panel, right side calendar/to do panel, right side notification panel, menu bar, exit screen, double borders, modified awesome hotkey helper (WiP), notififcations
- /scripts
  - Various bash scripts used in configs
    - Just vpn startup script atm
- /themes
  - Awesome theme, defines beautiful variables
  - Sorted into folders per theme
    - Has a color.lua file that defines variables with hex codes for colors used throught the rice
  - All icons
  - Wallpaper images
- /widget
  - All widgets used in construction of modules, sorted into folders specific to each module