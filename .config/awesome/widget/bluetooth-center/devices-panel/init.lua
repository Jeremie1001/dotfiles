local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local clickable_container = require('widget.clickable-container')
local dpi = require('beautiful').xresources.apply_dpi
local icons = require('themes.icons')
local colors = require('themes').colors
local watch = require('awful.widget.watch')
local beautiful = require('beautiful')
local naughty = require('naughty')

local width = dpi(410)

local panelLayout = wibox.layout.fixed.vertical()

panelLayout.spacing = dpi(7)
panelLayout.forced_width = width

local resetDevicePanelLayout = function()
  panelLayout:reset(panelLayout)
end

local bluetoothDeviceAdd = function(n)
  local box = require("widget.bluetooth-center.elements")
  panelLayout:insert(#panelLayout.children+1, box.create(n.title, n.macAdress, n.pairStatus, n.connectStatus))
end


awesome.connect_signal(
  "bluetooth::devices:refreshPanel",
  function()
    resetDevicePanelLayout()
    awful.spawn.with_line_callback(
      [[bash -c "bluetoothctl devices"]],
      {
        stdout = function(line)
          awful.spawn.easy_async_with_shell(
            "bluetoothctl info "..line:match("[%w:]+",8).. " | grep 'Connected' | sed 's/Connected: //' | sed 's/\t//g'",
            function(stdout)
              bluetoothDeviceAdd(
                {
                  title = line:gsub("Device "..line:match("[%w:]+",8).." ", ""), 
                  macAdress = line:match("[%w:]+",8), 
                  pairStatus = true, 
                  connectStatus = stdout:gsub("\n","")
                }
              )
            end
          )
        end
      }
    )
  end
)

return panelLayout