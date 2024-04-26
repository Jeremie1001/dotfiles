local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')
local colors = require('themes').colors
local dpi = require('beautiful').xresources.apply_dpi
local format_item = require('library.format_item')
local clickable_container = require('widget.clickable-container')
local settings = require('settings')

local page_builder = require('widget.settings.page-panel')
local page_title = require('widget.settings.pages.functions.page-title')
local prompt_builder = require('widget.settings.pages.functions.simple-prompt')
local menu_builder = require('widget.settings.pages.functions.dropdown-menu')

local theme_input = wibox.widget {
  {
    {
    spacing = dpi(0),
    layout = wibox.layout.flex.vertical,
    format_item(
				{
        layout = wibox.layout.fixed.vertical,
        spacing = dpi(16),
        menu_builder("Color Scheme", "", settings.theme, "theme", 150),
        widget,
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


local widget = {
  layout = wibox.layout.fixed.vertical,
  spacing = dpi(7),
  page_title("Theme", "Colors"),
  theme_input,
}

local page = page_builder(widget)

return page