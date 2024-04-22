local gears = require('gears')
local wibox = require('wibox')
local colors = require('themes').colors
local dpi = require('beautiful').xresources.apply_dpi
local format_item = require('library.format_item')

local page_builder = require('widget.settings.page-panel')
local page_title = require('widget.settings.pages.functions.page-title')

local widget = {
  layout = wibox.layout.fixed.vertical,
  spacing = dpi(7),
  page_title("Theme", "Wallpaper"),
}

local page = page_builder(widget)

return page