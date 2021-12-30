local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local clickable_container = require('widget.clickable-container')
local dpi = require('beautiful').xresources.apply_dpi
local icons = require('themes.icons')
local colors = require('themes.dracula.colors')
local watch = require('awful.widget.watch')
local beautiful = require('beautiful')
local naughty = require('naughty')

local emptyCenter = require('widget.notification-center.empty')
local width = dpi(410)

local panelLayout = wibox.layout.fixed.vertical()

panelLayout.spacing = dpi(7)
panelLayout.forced_width = width

resetDevicePanelLayout = function()
  panelLayout:reset(panelLayout)
end

awesome.connect_signal(
  "bluetooth::devices:added",
  function(n)
    local box = require("widget.bluetooth-center.elements")
    panelLayout:insert(1, box.create(n.title, n.macAdress, n.pairStatus, n.connectStatus))
  end
)

awesome.connect_signal(
  "bluetooth::devices:refreshPanel",
  function()
    _G.resetDevicePanelLayout()
    awful.spawn.with_line_callback(
      [[bash -c "bluetoothctl devices"]],
      {
        stdout = function(line)
          awesome.emit_signal(
            "bluetooth::devices:added",
            {
              title = line:gsub("Device "..line:match("[%w:]+",8).." ", ""), 
              macAdress = line:match("[%w:]+",8), 
              pairStatus = true, 
              connectStatus = false
            }
          )
        end
      }
    )
  end
)

return panelLayout