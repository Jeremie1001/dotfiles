--DEPENDENCIES
	--light

local wibox = require('wibox')
local gears = require('gears')
local awful = require('awful')
local beautiful = require('beautiful')
local spawn = awful.spawn
local dpi = beautiful.xresources.apply_dpi
local icons = require('widget.control-center.brightness-slider.icons')
local clickable_container = require('widget.clickable-container')
local colors = require('themes.dracula.colors')

local main_color = colors.cyan

local widget_name = wibox.widget {
	text = 'Brightness',
	font = 'Inter Bold 10',
	align = 'left',
	widget = wibox.widget.textbox
}

local widget_icon = wibox.widget {
	layout = wibox.layout.align.vertical,
	expand = 'none',
	nil,
	{
		id = 'icon',
		image = icons.brightness,
		resize = true,
		widget = wibox.widget.imagebox
	},
	nil
}

local widget_content = wibox.widget {
	{
		{
			widget_icon,
			margins = dpi(5),
			widget = wibox.container.margin
		},
		widget = clickable_container,
	},
	bg = beautiful.groups_bg,
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius)
	end,
	widget = wibox.container.background
}

local slider = wibox.widget {
	nil,
	{
		id 					= 'brightness_slider',
		bar_shape           = gears.shape.rounded_rect,
		bar_height          = dpi(24),
		bar_color           = colors.selection,
		bar_active_color		= main_color,
		handle_color        = main_color,
		handle_shape        = gears.shape.circle,
		handle_width        = dpi(24),
		maximum							= 100,
		widget              = wibox.widget.slider
	},
	nil,
	expand = 'none',
	forced_height = dpi(24),
	layout = wibox.layout.align.vertical
}

local brightness_slider = slider.brightness_slider

brightness_slider:connect_signal(
	'property::value',
	function()
		local brightness_level = brightness_slider:get_value()

		--spawn('light -S ' .. brightness_level, false)
	end
)

brightness_slider:buttons(
	gears.table.join(
		awful.button(
			{},
			4,
			nil,
			function()
				if brightness_slider:get_value() > 100 then
					brightness_slider:set_value(100)
					return
				end
				brightness_slider:set_value(brightness_slider:get_value() + 5)
			end
		),
		awful.button(
			{},
			5,
			nil,
			function()
				if brightness_slider:get_value() < 0 then
					brightness_slider:set_value(0)
					return
				end
				brightness_slider:set_value(brightness_slider:get_value() - 5)
			end
		)
	)
)


local update_slider = function()
	awful.spawn.easy_async_with_shell(
		[[bash -c "light -G"]],
		function(stdout)
			local brightness = stdout
			--brightness_slider:set_value(tonumber(brightness))
		end
	)
end


-- Update on startup
update_slider()


-- The emit will come from the global keybind
awesome.connect_signal(
	'widget::brightness',
	function()
		update_slider()
	end
)

local cc_brightness = wibox.widget {
  {
    {
    	layout = wibox.layout.fixed.vertical,
    	forced_height = dpi(48),
    	spacing = dpi(5),
    	widget_name,
    	{
    		layout = wibox.layout.fixed.horizontal,
    		spacing = dpi(5),
    		{
    			layout = wibox.layout.align.vertical,
    			expand = 'none',
    			nil,
    			{
    				layout = wibox.layout.fixed.horizontal,
    				forced_height = dpi(24),
    				forced_width = dpi(24),
    				widget_content
    			},
    			nil
    		},
    		slider
	   },
    },
    margins = dpi(15),
    widget = wibox.container.margin
  },
  shape = gears.shape.rounded_rect,
  bg = colors.background,
  fg = main_color,
  widget = wibox.container.background
}

return cc_brightness
