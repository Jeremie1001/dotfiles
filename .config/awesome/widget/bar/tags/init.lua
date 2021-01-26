local awful = require('awful')
local wibox = require('wibox')
local beautiful = require('beautiful')
local gears = require('gears')
local clickable_container = require('widget.clickable-container')
local dpi = require('beautiful').xresources.apply_dpi
local colors = require('themes.dracula.colors')
local modkey = require('config.keys.mod').modKey
local icons = require('themes.icons')

local return_button = function(s, main_color, occupied_color, width)
	local taglist_buttons = 
		gears.table.join(
			awful.button(
				{}, 
				1, 
				function(t) t:view_only() end
			),
			awful.button(
				{modkey}, 
				1, 
				function(t)
					if client.focus then
						client.focus:move_to_tag(t)
					end
				end
			),
			awful.button(
				{}, 
				3, 
				awful.tag.viewtoggle
			),
			awful.button(
				{modkey}, 
				3, 
				function(t)
					if client.focus then
						client.focus:toggle_tag(t)
					end
				end
			),
			awful.button(
				{}, 
				4, 
				function(t) awful.tag.viewprev(t.screen) end
			),
			awful.button(
				{},
				5, 
				function(t) awful.tag.viewnext(t.screen) end
			)
		)

	s.mytaglist = awful.widget.taglist {
		screen  = s,
		filter  = awful.widget.taglist.filter.all,
		buttons = taglist_buttons,
	}

	local widget_button = wibox.widget {
			{
				{
					{
						{
						s.mytaglist,
						layout = wibox.layout.fixed.horizontal,
					},
					top = dpi(6),
					bottom = dpi(6),
					left = dpi(12),
					right = dpi(12),
					widget = wibox.container.margin
				},
				shape = gears.shape.rounded_bar,
				bg = 'transparent',
				fg = 'transparent',
				shape_border_width = dpi(width),
				shape_border_color = main_color,
				widget = wibox.container.background
			},
			forced_width = icon_size,
			forced_height = icon_size,
			widget = clickable_container
		},
		top = dpi(5),
		widget = wibox.container.margin
	}

	beautiful.taglist_shape = gears.shape.circle
	beautiful.taglist_shape_border_width = dpi(1)

	beautiful.taglist_fg_focus = main_color
	beautiful.taglist_bg_focus = main_color
	beautiful.taglist_shape_border_color_focus = main_color

	beautiful.taglist_bg_empty = 'transparent'
	beautiful.taglist_shape_border_color_empty = main_color

	beautiful.taglist_bg_volatile = 'transparent'
	beautiful.taglist_shape_border_color_volatile = vol_color

	beautiful.taglist_bg_occupied = 'transparent'
	beautiful.taglist_shape_border_color = occupied_color --occupied border variable doesnt exist (?) so all set to cyan and focus/empty are overrided

	return widget_button
end

return return_button
