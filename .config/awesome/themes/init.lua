local beautiful = require("beautiful")
local settings = require("settings")

beautiful.init("/home/jeremie1001/.config/awesome/themes/theme.lua")

return {
  colors = require('themes.schemes.'..settings.theme)
}
