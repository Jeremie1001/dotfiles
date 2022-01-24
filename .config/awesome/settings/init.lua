return {
  theme = "dracula",
  background = "ship.png",
  default_programs = {
    terminal = "kitty",
    editor = "vscodium",
    browser = "firefox",
    file_manager = "nemo",
    lock = 'i3lock-fancy-multimonitor',
    email = "thunderbird",
    chat = "discord",
    screenshot = "flameshot gui",
  },
  profile_picture = "dracula.svg",
  bar = {
    left = {
      {"menu","color1"}, 
      {"focused","color2"},
    },
    center = {
      {"tags",{"color2", "color8"}},
    },
    right = {
      {"volume","color7"},
      {"battery","color5"},
      {"network","color4"},
      {"notifications-bar","color3"},
      {"bluetooth","color8"},
      {"clock","color2"},
      {"end-session","color1"},
    }
  },
  window_gaps = 4,
  window_border_size = 7

}