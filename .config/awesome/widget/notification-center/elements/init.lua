local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local clickable_container = require('widget.clickable-container')
local dpi = require('beautiful').xresources.apply_dpi
local icons = require('themes.icons')
local colors = require('themes.dracula.colors')
local watch = require('awful.widget.watch')

local elements = {}

elements.create = function(title, message)
  local box = {}

  local clearIcon = wibox.widget {
    layout = wibox.layout.align.vertical,
    expand = 'none',
    nil,
    {
      id = 'icon',
      image = icons.clearNotificationIndividual,
      resize = true,
      widget = wibox.widget.imagebox
    },
    nil
  }
  
  local clear = wibox.widget {
    {
      {
        {
          clearIcon,
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
    bg = colors.background,
    widget = wibox.container.background
  }

  clear:connect_signal(
    "mouse::enter",
    function()
      clear.bg = colors.comment
    end
  )

  clear:connect_signal(
    "mouse::leave",
    function()
      clear.bg = colors.background
    end
  )

  clear:buttons(
    gears.table.join(
      awful.button(
        {},
        1,
        nil,
        function()
          _G.removeElement(box)
        end
      )
    )
  )

  local notifIcon = wibox.widget {
    {
      {
        {
          image = icons.notifications,
          widget = wibox.widget.imagebox,
        },
        margins = dpi(5),
        widget = wibox.container.margin
      },
      shape = gears.shape.rect,
      bg = colors.purple,
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
          text = title,
          font = 'Inter Bold 10',
          widget = wibox.widget.textbox,
        },
        {
          text = message,
          font = 'Inter 8',
          widget = wibox.widget.textbox,
        },
        layout = wibox.layout.align.vertical,
      },
      margins = dpi(10),
      widget = wibox.container.margin
    },
    shape = gears.shape.rect,
    bg = colors.selection,
    widget = wibox.container.background
  }
  
  box = wibox.widget {
    {
      notifIcon,
      content,
      {
        {
          clear,
          align = "center",
          forced_height = 30,
          layout = wibox.layout.align.vertical,
        },
        margins = dpi(5),
        widget = wibox.container.margin
      },
      layout = wibox.layout.align.horizontal,
    },
    shape = function(cr, width, height)
      gears.shape.rounded_rect(cr, width, height, dpi(4))
    end,
    fg = colors.white,
    border_width = dpi(1),
    border_color = colors.background,
    widget = wibox.container.background
  }

  return box
end

return elements