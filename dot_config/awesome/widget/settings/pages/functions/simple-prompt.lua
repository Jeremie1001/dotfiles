local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')
local colors = require('themes').colors
local dpi = require('beautiful').xresources.apply_dpi
local clickable_container = require('widget.clickable-container')
local settings = require('settings')

local prompt_builder = function(itemText, promptText, defaultText, settingsItem, promptWidth)
  local prompt = wibox.widget.textbox()
  prompt.text = defaultText
  prompt.font = 'Inter Bold 14'
  
  local prompt_container = wibox.widget {
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
      prompt_container,
      layout = wibox.layout.fixed.horizontal,
    },
    fg = colors.white,
    widget = wibox.container.background
  }
  
  prompt_container:buttons(
    gears.table.join(
      awful.button(
        {},
        1,
        nil,
        function()
          awful.prompt.run {
            prompt       = promptText,
            text         = defaultText:gsub(promptText,""),
            font         = 'Inter Bold 14',
            bg_cursor    = colors.white,
            textbox      = prompt,
            exe_callback = function(input)
                if not input or #input == 0 then return end
                settings[settingsItem] = string.lower(input)
                prompt.text = ""..string.lower(input)
                prompt.font = 'Inter Bold 14'
            end
          }
        end
      )
    )
  )

  return elements
end

return prompt_builder