local gears = require('gears')
local wibox = require('wibox')
local beautiful = require('beautiful')
local colors = require('themes').colors
local dpi = require('beautiful').xresources.apply_dpi
local screen_geometry = require('awful').screen.focused().geometry

local page_builder = function(widget)
  local page = wibox.widget {
    {
      {
        widget,
        forced_width = dpi(1144),
        layout = wibox.layout.fixed.vertical,
        spacing = dpi(16),
      },
      margins = dpi(10),
      widget = wibox.container.margin
    },
    shape = function(cr, width, height)
      gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius)
    end,
    bg = colors.colorA,
    ontop = true,
    border_width = dpi(0),
    border_color = colors.color2,
    widget = wibox.container.background,
    layout,
  }
  return page
end

return page_builder