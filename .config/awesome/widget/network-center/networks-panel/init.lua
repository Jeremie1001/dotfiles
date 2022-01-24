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

local searching = require('widget.network-center.searching')
local width = dpi(410)

local panelLayout = wibox.layout.fixed.vertical()

panelLayout.spacing = dpi(7)
panelLayout.forced_width = width

local resetDevicePanelLayout = function()
  panelLayout:reset(panelLayout)
end

local networksAdd = function(n)
  local box = require("widget.network-center.elements")
  panelLayout:insert(#panelLayout.children+1, box.create(n.SSID, n.BSSID, n.connectStatus, n.signal, n.secure, n.speed))
end

local networksRemove = function(box)
  panelLayout:remove_widgets(box)
end

awesome.connect_signal(
  "network::networks:refreshPanel",
  function()
    resetDevicePanelLayout()
    panelLayout:insert(1, searching)
    local searchStatus = true
    awful.spawn.with_line_callback(
      [[bash -c "nmcli -g in-use,signal,security,rate,BSSID,SSID d wifi list | sed -e 's/^ /no/g; s/\*/yes/g; s/::/:no:/g; s/:/;/g'"]],
      {
        stdout = function(line)
          local results = {}
          line = line:gsub("\\;",":")
          for match in (line..";"):gmatch("(.-)"..";") do
            table.insert(results, match)
          end
          if #panelLayout.children == 1 and searchStatus then
            resetDevicePanelLayout()
          end
          if (#panelLayout.children<14) and results[6] ~= "" then
            searchStatus = false
            networksAdd(
              {
                connectStatus = results[1],
                signal = results[2],
                secure = results[3],
                speed = results[4],
                BSSID = results[5],
                SSID = results[6],
              }
            )
          end
        end
      }
    )
  end
)

return panelLayout