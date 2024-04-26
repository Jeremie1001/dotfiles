local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')
local colors = require('themes').colors
local dpi = require('beautiful').xresources.apply_dpi
local clickable_container = require('widget.clickable-container')
local settings = require('settings')

local menu_builder = function(itemText, promptText, defaultText, settingsItem, promptWidth)
  local prompt = wibox.widget.textbox()
  prompt.text = defaultText
  prompt.font = 'Inter Bold 14'
  
  local menu_item = wibox.widget {
    {
      {
        {
          prompt,
          layout = wibox.layout.fixed.horizontal,
        },
        widget = clickable_container
      },
      margins = dpi(7),
      widget = wibox.container.margin
    },
    shape = function(cr, width, height)
      gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius)
    end,
    bg = colors.colorB,
    forced_width = dpi(promptWidth),
    border_width = dpi(2),
    border_color = colors.white,
    widget = wibox.container.background,
  }
  
  local elements = wibox.widget {
    {
      {
        text = itemText,
        font = 'Inter Bold 14',
        widget = wibox.widget.textbox,
      },
      {
        {
          orientation = 'vertical',
          forced_height = dpi(20),
          forced_width = dpi(2),
          shape = gears.shape.rounded_bar,
          widget = wibox.widget.separator,
        },
        margins = dpi(10),
        widget = wibox.container.margin
      },
      {
        menu_item,
        menu_item,
        menu_item,
        margins = dpi(10),
        layout = wibox.layout.fixed.vertical,
      },
      layout = wibox.layout.fixed.horizontal,
    },
    fg = colors.white,
    widget = wibox.container.background
  }
  
  menu_item:buttons(
    gears.table.join(
      awful.button(
        {},
        1,
        nil,
        function()

        end
      )
    )
  )

  return elements
end

return menu_builder