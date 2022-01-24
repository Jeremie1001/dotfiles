local gears = require('gears')
local wibox = require('wibox')
local beautiful = require('beautiful')
local colors = require('themes').colors
local dpi = require('beautiful').xresources.apply_dpi
local screen_geometry = require('awful').screen.focused().geometry
local format_item = require('library.format_item')

local sizeFactor = 0.8
local pages = require('widget.settings.pages')

settingsWindow = wibox(
  {
    x = screen_geometry.width*(0.5-sizeFactor/2)-dpi(8),
    y = screen_geometry.height*(0.5-sizeFactor/2),
    visible = false,
    ontop = true,
    shape = function(cr, width, height)
      gears.shape.rounded_rect(cr, width, height, dpi(15))
    end,
    screen = screen.primary,
    type = 'splash',
    height = screen_geometry.height*sizeFactor,
    width = screen_geometry.width*sizeFactor,
    bg=colors.colorB,
    border_width = dpi(2),
    border_color = colors.colorA,
    fg = '#FEFEFE'
  }
)

local menu_builder = function(widget)
  local menu_panel = wibox.widget {
    {
      {
        layout = wibox.layout.fixed.horizontal,
        spacing = dpi(16),
        widget,
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
  return menu_panel
end

local menus = require('widget.settings.menu-panel')

local widget = function(category, subcategory)
  local widget = wibox.widget{
    {
      spacing = dpi(10),
      menu_builder(menus[1]),
      menu_builder(menus[2]),
      pages[category][subcategory],
      layout = wibox.layout.fixed.horizontal,
    },
    margins = dpi(10),
    widget = wibox.container.margin
  }
  return widget
end

local empty_widget = wibox.widget{
  {
    spacing = dpi(10),
    menu_builder(menus[1]),
    menu_builder(menus[2]),
    require('widget.settings.pages.empty'),
    layout = wibox.layout.fixed.horizontal,
  },
  margins = dpi(10),
  widget = wibox.container.margin
}

settingsWindow:set_widget(widget("timeLanguage","dateTime"))

awesome.connect_signal(
  "settings::window:toggle",
  function()
    if settingsWindow.visible == false then
      settingsWindow.visible = true
      awesome.emit_signal("settings::categories:setPanel","system","about")
      settingsWindow:set_widget(widget("system","about"))
    elseif settingsWindow.visible == true then
      settingsWindow.visible = false
    end
  end
)

awesome.connect_signal(
  "settings::page:set",
  function(category, subcategory)
    if subcategory == nil then
      settingsWindow:set_widget(empty_widget)
    else
      settingsWindow:set_widget(widget(category,subcategory))
    end
  end
)