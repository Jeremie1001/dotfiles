## TODO

### Bar
- Bar status to global variable (change watch functions to watch variables)
  - If fixed add watch to DnD
- Close all other submenus before opening new ones  (DONE)
  - Otherwise they overlap funny  (DONE)
- Calendar
  - Finish todo list input functionalities
- Bluetooth
  - Device pairing and connecting (DONE)
    - bluetoothctl (DONE)
  - Searching
  - Check adapter power status on open (DONE)
- Wifi
  - Ethernet & Network Detection
  - Network (DONE)
- Battery
  - Percentage update on open (DONE)
  - Charging status (DONE)
  - Anything else?
- Volume (DONE)
  - Slider (DONE)
  - Output devices (DONE)
    - Pulse audio (DONE)
- VPN
  - Modify to work with PIA
- Focus (DONE)
  - Fix for laptop (DONE, xdotool is not a core util)
- System
  - Keyboard layout (DONE)
  - Timezone (DONE)
  - Pacman updates
  - Mirrors updates
- Quick info tooltips (DONE)
- Review and fix(?) bar::tab function
  - Is it expandable in the settings

### Control center
- Top text (DONE)
  - Fix weird shell output on laptop (DONE)
- Buttons
  - DND
    - Make sure still works okay
  - VPN
    - Update for PIA
  - Volume  (DONE)
    - Check mute on panel opening  (DONE)
  - Fix color changing
    - Connect to various signals
- Dials
  - Fix watch function dials to actually work lol (DONE)
    - Fix the full circle glitch at <3%
  - Stop watch functions while control center is closed
- Slider
  - Volume (DONE)
    - Adjust current output device (DONE)
  - Brightness (DONE)
    - Make do something (DONE)
    - Connect to XF86 keys (DONE)
- Dual monitor open on focused screen
  - Use get screen function in hotkeys module

### Theme
- Change color variables to generic names with dracula subtheme (DONE)
- Central theming GUI
  - Allows changing of theme colors
    - Have active colors in seperate simple variable init.lua file (DONE)
  - Allow saving of themes
    - Write available themes to file
  - Allows changing of wallpapers
    - Can choose from used wallpapers or load new ones
      - New files are cp'd to wallpaper directory

### Git
- Create some sort of one command installable distro with .config files
  - Based on shell scripting or ansible(?)
- Figure out which programs are required

### Other
- Starship
  - Extend starship toml file to have variable theme coloring to match with awesomewm settings
  - "Pallettes" imported from seperate file in starship folder, writable by settings app