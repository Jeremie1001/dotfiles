local gears = require('gears')
local wibox = require('wibox')
local beautiful = require('beautiful')
local colors = require('themes').colors
local dpi = require('beautiful').xresources.apply_dpi
local format_item = require('library.format_item')

local page_builder = require('widget.settings.page-panel')
local page_title = require('widget.settings.page-title')

local widget = {
  layout = wibox.layout.fixed.vertical,
  spacing = dpi(7),
  page_title("System", "About"),
}

local page = page_builder(widget)

return page