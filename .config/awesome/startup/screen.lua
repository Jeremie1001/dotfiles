local beautiful = require('beautiful')
local gears = require('gears')
local awful = require('awful')
local backgrounds = require('themes.backgrounds')

--[[
local function set_wallpaper(s)
  local wallpaper = backgrounds.archkraken
  gears.wallpaper.maximized(wallpaper, s, true)
end

screen.connect_signal("property::geometry", set_wallpaper)


awful.screen.connect_for_each_screen(
  function(s)
    set_wallpaper(s)
  end
)
]]

awful.spawn.with_shell("feh --bg-fill ~/.config/backgrounds/archdraken.png")
awful.spawn.with_shell("picom")
