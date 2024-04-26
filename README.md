<p align="center">
<img src="https://i.imgur.com/WuGGblj.png" alt="img" width="200px">
</p>

## ARCH DRACULA - THE RETURN OF THE DOTFILES

ArchDracula By:

- Jeremie Cote
- @jeremie1001

Based on terminal color theme Dracula and inpired by https://github.com/manilarome/the-glorious-dotfiles. Icons modified from [flaticons repository](https://www.flaticon.com/) and [SVGRepo](https://www.svgrepo.com/vectors/chain/)

Disclaimer, some of the aspects of this rice arent completely functional at this time as this is still a work in progress so please be please be patient. Components still being worked on can be found in the TODO.txt file.

### Spoilers

<p align="center">
<img src="https://i.imgur.com/GhyK4Bw.png" alt="img" width="900px">
</p>

### Quick stats

- **OS**: EndeavourOS
- **WM**: AwesomeWM
  - More specifically, it uses awesome-git since it includes some features not included in mainline awesome such as as the colored and rounded progress bars in the control center
- **Shell**: zsh with starship
- **Terminal**: Kitty
- **Editor**: VSCodium
- **File Manager**: Nemo
- **Launcher**: Rofi
- **Browser**: Firefox
- **Color Scheme**: [Dracula](https://draculatheme.com/) ([hex codes](https://github.com/dracula/dracula-theme))
- **GTK Theme**: [Ant Dracula](https://draculatheme.com/gtk)
- **Wallpaper**: [Arch Kraken](https://i.imgur.com/S0LHsad.png)

### Dependencies

**Awesome Config Dependencies**

- awesome-git (AwesomeWM) (aur)
- i3lock-fancy-git (exit_screen module) (aur)
- picom (compositor) (pacman)
- rofi (launchers) (pacman)
- pamixer (volume controls) (pacman)
- lm_sensors (temperature dial in control center) (pacman)
- feh (background) (pacman)
- light (brightness) (pacman)
- flameshot (screenshot) (pacman)

**Other dependencies**

- chezmoi (installation) (pacman)
- zoxide (zshrc) (pacman)
- starship (zshrc, shell prompt) (pacman)
- exa (zshrc) (pacman)
- ant-dracula-gtk-theme (GTK theme) (aur)
- yaru-colors-icon-theme (Icons) (aur)

**Hotkey dependencies**

These can be changed in primary [settings file](https://github.com/Jeremie1001/dotfiles/blob/master/.config/awesome/settings/init.lua)

- firefox (pacman)
- rofi (pacman)
- nemo (pacman)
- kitty (pacman)
- VSCodium (aur)
- Thunderbird (aur)
- Discord (aur)


### Installation

- Dotfiles are being managed with "chezmoi" dotfile manager package and meant to be installed with their process as [outlined](https://www.chezmoi.io/user-guide/daily-operations/#install-chezmoi-and-your-dotfiles-on-a-new-machine-with-a-single-command)
-Can be using chezmoi installed via a single via a single command
```console
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply $Jeremie1001
```
- Listed dependencies need to be installed seperately afterwards
  - Plan is to create script to automate as well in the near-future
- If installing not via chezmoi, clone repository into desired directory, rename all 'dot_*' directories to '.*' then copy and paste into home directory
