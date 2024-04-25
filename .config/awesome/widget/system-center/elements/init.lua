local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local naughty = require('naughty')
local clickable_container = require('widget.clickable-container')
local dpi = require('beautiful').xresources.apply_dpi
local icons = require('themes.icons')
local colors = require('themes').colors
local settings = require('settings')

local elements = {}

local color = colors[settings.bar.colors["system"]]

elements.create = function(layoutOfficial, layoutCode)
  local box = {}

  local languageIcon = wibox.widget {
    layout = wibox.layout.align.vertical,
    expand = 'none',
    nil,
    {
      id = 'icon',
      image = icons.language,
      resize = true,
      widget = wibox.widget.imagebox
    },
    nil
  }
  
  local language = wibox.widget {
    {
      {
        {
          languageIcon,
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
    forced_width = 30,
    forced_height = 30,
    widget = wibox.container.background
  }

  language:connect_signal(
    "mouse::enter",
    function()
      language.bg = colors.color1
    end
  )

  language:connect_signal(
    "mouse::leave",
    function()
      language.bg = colors.colorA
    end
  )

  language:buttons(
    gears.table.join(
      awful.button(
        {},
        1,
        nil,
        function()
          awful.spawn.easy_async_with_shell("setxkbmap -layout "..layoutCode:gsub('%(','\\('):gsub('%)','\\)'))
          naughty.notify({
            preset = naughty.config.presets.low,
            title = "Switched Keyboard",
            text = layoutOfficial,
          })
					awesome.emit_signal("system::keyboard:status:update")
        end
      )
    )
  )

  local keyboardIcon = wibox.widget {
    {
      {
        layout = wibox.layout.align.vertical,
        expand = 'none',
        nil,
        {
          image = icons.keyboard,
          widget = wibox.widget.imagebox,
        },
        nil
      },
      margins = dpi(5),
      widget = wibox.container.margin
    },
    shape = gears.shape.rect,
    bg = color,
    forced_width = 40,
    forced_height = 40,
    widget = wibox.container.background
  }
  
  local content = wibox.widget {
    {
      {
        {
          text = layoutOfficial,
          font = 'Inter Bold 10',
          widget = wibox.widget.textbox,
        },
        {
          text = layoutCode,
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

  local buttons = {
    language,
    layout = wibox.layout.align.horizontal,
    spacing = dpi(15),
  }
  
  box = wibox.widget {
    {
      keyboardIcon,
      content,
      buttons,
      spacing = dpi(15),
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