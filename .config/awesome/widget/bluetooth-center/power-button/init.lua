--DEPENDENCIES
  --whatever is used here idk lol

local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local clickable_container = require('widget.clickable-container')
local dpi = require('beautiful').xresources.apply_dpi
local icons = require('themes.icons')
local colors = require('themes').colors
local watch = require('awful.widget.watch')

local awful = require('awful')
local beautiful = require('beautiful')
local naughty = require('naughty')

local widget_icon = wibox.widget {
  layout = wibox.layout.align.vertical,
  expand = 'none',
  nil,
  {
    id = 'icon',
    image = icons.bluetooth_off,
    resize = true,
    widget = wibox.widget.imagebox
  },
  nil
}

local widget = wibox.widget {
    {
      {
        {
        widget_icon,
        layout = wibox.layout.fixed.horizontal,
      },
      margins = dpi(15),
      widget = wibox.container.margin
    },
    forced_height = dpi(50),
    widget = clickable_container
  },
  shape = gears.shape.circle,
  bg = colors.colorA,
  widget = wibox.container.background
}

local power_status = false

widget:connect_signal(
  "mouse::enter",
  function()
    if power_status == false then
      widget_icon.icon:set_image(icons.bluetooth_on)
      widget.bg = colors.color8
    elseif power_status == true then
      widget_icon.icon:set_image(icons.bluetooth_off)
      widget.bg = colors.colorA
    end
  end
)

widget:connect_signal(
  "mouse::leave",
  function()
    if power_status == false then
      widget_icon.icon:set_image(icons.bluetooth_off)
      widget.bg = colors.colorA
    elseif power_status == true then
      widget_icon.icon:set_image(icons.bluetooth_on)
      widget.bg = colors.color8
    end
  end
)

awesome.connect_signal(
  "bluetooth::power:toggle",
  function()
    if power_status == false then
      power_status = true
      awful.spawn.with_shell('bluetoothctl power on')
      widget_icon.icon:set_image(icons.bluetooth_on)
      widget.bg = colors.color8
    elseif power_status == true then
      power_status = false
      awful.spawn.with_shell('bluetoothctl power off')
      widget_icon.icon:set_image(icons.bluetooth_off)
      widget.bg = colors.colorA
    end
  end
)

awesome.connect_signal(
  "bluetooth::power:refresh",
  function()
    awful.spawn.easy_async_with_shell(
      [[bash -c "bluetoothctl show | sed -n '5p'"]],
      function(stdout)
        stdout = stdout:match("[%w:]+",10)
        if stdout == "yes" then
          power_status = true
          widget_icon.icon:set_image(icons.bluetooth_on)
          widget.bg = colors.color8
        elseif stdout == "no" then
          power_status = false
          widget_icon.icon:set_image(icons.bluetooth_off)
          widget.bg = colors.colorA
        end
      end
    )
  end
)

widget:buttons(
  gears.table.join(
    awful.button(
      {},
			1,
			nil,
			function()
				awesome.emit_signal("bluetooth::power:toggle")
			end
    )
  )
)

return widget
