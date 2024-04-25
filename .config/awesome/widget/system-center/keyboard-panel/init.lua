local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local clickable_container = require('widget.clickable-container')
local dpi = require('beautiful').xresources.apply_dpi
local icons = require('themes.icons')
local colors = require('themes').colors
local settings = require("settings")


local width = dpi(410)

local panelLayout = wibox.layout.fixed.vertical()

panelLayout.spacing = dpi(7)
panelLayout.forced_width = width

local resetKeyboardPanelLayout = function()
  panelLayout:reset(panelLayout)
end

local keyboardLayoutAdded = function(n)
  local box = require("widget.system-center.elements")
  panelLayout:insert(1, box.create(n.layoutOfficial, n.layoutCode))
end

awesome.connect_signal(
  "system::keyboard:refreshPanel",
  function()
    resetKeyboardPanelLayout()
    for i,layoutCode in ipairs(settings.keyboards) do
      awful.spawn.easy_async_with_shell(
        "man -P cat xkeyboard-config | grep ' "..layoutCode.." ' | sed 's/  //g;s/.$//g;s/ "..layoutCode.."//g' | cut -c5-",
        function(stdout)
          stdout = stdout:gsub("\n","")
          if string.sub(stdout, 1, 1)==" " then
            stdout = string.sub(stdout, 2, -1)
          end
          keyboardLayoutAdded(
            {
              layoutOfficial = stdout, 
              layoutCode = layoutCode, 
            }
          )
        end
      )
    end
  end
)

return panelLayout