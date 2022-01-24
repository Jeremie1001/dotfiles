local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local clickable_container = require('widget.clickable-container')
local dpi = require('beautiful').xresources.apply_dpi
local icons = require('themes.icons')
local colors = require('themes').colors
local watch = require('awful.widget.watch')

local elements = {}

elements.create = function(description, sinkNumText, sinkNum, isDefault)
  local box = {}

  local setDefaultSinkIcon = wibox.widget {
    layout = wibox.layout.align.vertical,
    expand = 'none',
    nil,
    {
      id = 'icon',
      image = icons.mute,
      resize = true,
      widget = wibox.widget.imagebox
    },
    nil
  }

  local setDefaultSink = wibox.widget {
    {
      {
        {
          setDefaultSinkIcon,
          layout = wibox.layout.fixed.horizontal,
        },
        margins = dpi(9),
        widget = wibox.container.margin
      },
      forced_height = dpi(30),
      forced_width = dpi(30),
      widget = clickable_container
    },
    shape = gears.shape.circle,
    bg = colors.colorA,
    widget = wibox.container.background
  }

  setDefaultSink:connect_signal(
    "mouse::enter",
    function()
      setDefaultSink.bg = colors.color1
    end
  )

  setDefaultSink:connect_signal(
    "mouse::leave",
    function()
      setDefaultSink.bg = colors.colorA
    end
  )

  setDefaultSink:buttons(
    gears.table.join(
      awful.button(
        {},
        1,
        nil,
        function()
          awful.spawn.with_shell("pactl set-default-sink "..sinkNum)
					awesome.emit_signal("volume::devices:refreshPanel")
        end
      )
    )
  )

  local defaultSinkIcon = wibox.widget {
    layout = wibox.layout.align.vertical,
    expand = 'none',
    nil,
    {
      id = 'icon',
      image = icons.volume,
      resize = true,
      widget = wibox.widget.imagebox
    },
    nil
  }

  local defaultSink = wibox.widget {
    {
      {
        defaultSinkIcon,
        layout = wibox.layout.fixed.horizontal,
      },
      margins = dpi(8),
      widget = wibox.container.margin
    },
    forced_height = dpi(30),
    forced_width = dpi(30),
    shape = gears.shape.circle,
    bg = colors.color1,
    widget = wibox.container.background
  }

  local headphonesIcon = wibox.widget {
    {
      {
        {
          layout = wibox.layout.align.vertical,
          expand = 'none',
          nil,
          {
            image = icons.headphones,
            widget = wibox.widget.imagebox,
          },
          nil
        },
        margins = dpi(7),
        widget = wibox.container.margin
      },
      shape = gears.shape.rect,
      bg = colors.color7,
      widget = wibox.container.background
    },
    forced_width = 40,
    forced_height = 40,
    widget = clickable_container
  }
  
  local content = wibox.widget {
    {
      {
        {
          text = description,
          font = 'Inter Bold 10',
          widget = wibox.widget.textbox,
        },
        {
          text = sinkNumText,
          font = 'Inter 8',
          widget = wibox.widget.textbox,
        },
        layout = wibox.layout.align.vertical,
      },
      margins = dpi(10),
      widget = wibox.container.margin
    },
    shape = gears.shape.rect,
    bg = colors.colorB,
    widget = wibox.container.background
  }

  local buttons = {}

  if isDefault == true then
    buttons = {
      layout = wibox.layout.align.horizontal,
      spacing = dpi(15),
      defaultSink,
    }
  elseif isDefault == false then
    buttons = {
      layout = wibox.layout.align.horizontal,
      spacing = dpi(15),
      setDefaultSink,
    }
  end

  box = wibox.widget {
    {
      headphonesIcon,
      content,
      buttons,
      layout = wibox.layout.align.horizontal,
    },
    shape = function(cr, width, height)
      gears.shape.rounded_rect(cr, width, height, dpi(4))
    end,
    fg = colors.white,
    border_width = dpi(1),
    border_color = colors.colorA,
    widget = wibox.container.background
  }

  return box
end

return elements