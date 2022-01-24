local gears = require('gears')
local wibox = require('wibox')
local beautiful = require('beautiful')
local colors = require('themes').colors
local dpi = require('beautiful').xresources.apply_dpi
local format_item = require('library.format_item')

local page_title = function(category, subcategory)
  local title = wibox.widget {
    {
      {
        text = category,
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
        text = subcategory,
        font = 'Inter Bold 14',
        widget = wibox.widget.textbox,
      },
      layout = wibox.layout.fixed.horizontal,
    },
    fg = '#DDD',
    widget = wibox.container.background
  }

  local title_widget = wibox.widget {
    {
      {
      spacing = dpi(0),
      layout = wibox.layout.flex.vertical,
      format_item(
        {
          layout = wibox.layout.fixed.horizontal,
          spacing = dpi(16),
          title,
        }
      ),
      },
      margins = dpi(5),
      widget = wibox.container.margin
    },
    shape = function(cr, width, height)
      gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius)
    end,
    bg = colors.colorB,
    ontop = true,
    widget = wibox.container.background,
    layout,
  }

  return title_widget
end

return page_title