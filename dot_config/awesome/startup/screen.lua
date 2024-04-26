local gears = require('gears')
local awful = require('awful')
local settings = require("settings")


local function set_wallpaper(s)
  local wallpaper = settings.background
  gears.wallpaper.maximized(os.getenv('HOME') .. '/.config/awesome/themes/backgrounds/'..wallpaper, s)
end

screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(
  function(s)
    set_wallpaper(s)
  end
)

client.connect_signal(
  "manage",
  function(c)
    c.shape = function(cr,w,h)
      gears.shape.rounded_rect(cr,w,h,settings.corner_radius)
    end
  end
)

awful.spawn.with_shell("/home/jeremie1001/.screenlayout/default_dual.sh")
awful.spawn.with_shell("picom")
