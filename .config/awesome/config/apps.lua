local filesystem = require('gears.filesystem')
local config_dir = filesystem.get_configuration_dir()


return {
  default = {
    terminal = "kitty",

    editor = "atom",

    browser = "firefox",

    file_manager = "nemo",

    lock = 'i3lock-fancy',
  }
}
