local beautiful = require('beautiful')
local gears = require('gears')
local awful = require('awful')

local function set_wallpaper(s)
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

screen.connect_signal("property::geometry", set_wallpaper)


awful.screen.connect_for_each_screen(
  function(s)
    set_wallpaper(s)
  end
)

awful.spawn.with_shell("~/.config/polybar/launch.sh")
awful.spawn.with_shell("picom")
awful.spawn.with_shell("nitrogen --set-zoom-fill /home/jeremie1001/.config/awesome/themes/backgrounds/archdracula.png")
--awful.layout.set(awful.screen.focused())
