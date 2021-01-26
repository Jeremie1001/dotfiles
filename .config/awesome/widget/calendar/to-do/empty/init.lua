local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local clickable_container = require('widget.clickable-container')
local dpi = require('beautiful').xresources.apply_dpi
local icons = require('themes.icons')
local colors = require('themes.dracula.colors')
local watch = require('awful.widget.watch')

-- Create widget to add to to do panel when there are no tasks

-- Icon widget for left side
local toDoIcon = wibox.widget {
	{
		{
			{
			 image = icons.toDoDone,
			 widget = wibox.widget.imagebox,
		 },
		 margins = dpi(5),
		 widget = wibox.container.margin
	 },
	 shape = gears.shape.rect,
	 bg = colors.purple,
	 widget = wibox.container.background
 },
 forced_width = 40,
 forced_height = 40,
 widget = clickable_container
}

-- Text content widget for right side
local content = wibox.widget {
	{
		{
				text = "You have no tasks on this date",
				font = 'Inter 12',
				widget = wibox.widget.textbox,
			},
		margins = dpi(10),
		widget = wibox.container.margin
		},
	shape = gears.shape.rect,
	bg = colors.selection,
	widget = wibox.container.background
}

-- Combmine the two widgets into main rounded rectangle widget with border
local box = wibox.widget {
	{
		toDoIcon,
		content,
		layout = wibox.layout.align.horizontal,
	},
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, dpi(4))
	end,
	fg = colors.white,
	border_width = dpi(1),
	border_color = colors.background,
	widget = wibox.container.background
}

return box
