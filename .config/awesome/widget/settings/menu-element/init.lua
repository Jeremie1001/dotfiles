local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local clickable_container = require('widget.clickable-container')
local dpi = require('beautiful').xresources.apply_dpi
local icons = require('themes.icons')
local colors = require('themes').colors
local watch = require('awful.widget.watch')

local elements = {}

elements.create = function(category, subcategory, selected, isSubcategory)
  local box = {}
  
  local color = colors.colorB
  if selected then
    color = colors.color1
  end

  local label
  if isSubcategory then
    label = subcategory
  else
    label = category
  end 


  local content = wibox.widget {
    {
      {
        text = label,
        font = 'Inter 12',
        widget = wibox.widget.textbox,
      },
      margins = dpi(10),
      widget = wibox.container.margin
    },
    shape = gears.shape.rect,
    bg = color,
    widget = wibox.container.background
  }
  
  box = wibox.widget {
    content,
    shape = function(cr, width, height)
      gears.shape.rounded_rect(cr, width, height, dpi(4))
    end,
    fg = colors.white,
    widget = wibox.container.background
  }

  local setColor = function(color)
    content.bg = color
  end

  box:connect_signal(
    "mouse::enter",
    function()
      content.bg = colors.color1
    end
  )

  box:connect_signal(
    "mouse::leave",
    function()
      content.bg = color
    end
  )

  box:buttons(
    gears.table.join(
      awful.button(
        {},
        1,
        nil,
        function()
          awesome.emit_signal("settings::categories:setPanel", category, subcategory)
          awesome.emit_signal("settings::page:set", category, subcategory)
        end
      )
    )
  )

  return box
end

return elements