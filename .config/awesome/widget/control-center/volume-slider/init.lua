--DEPENDENCIES
	--pamixer

local wibox = require('wibox')
local gears = require('gears')
local awful = require('awful')
local beautiful = require('beautiful')
local spawn = awful.spawn
local dpi = beautiful.xresources.apply_dpi
local icons = require('widget.control-center.volume-slider.icons')
local clickable_container = require('widget.clickable-container')
local colors = require('themes.dracula.colors')
local watch = require('awful.widget.watch')

local main_color = colors.yellow

local widget_name = wibox.widget {
	text = 'Volume',
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
		image = icons.volume,
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
		id 					= 'volume_slider',
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

local volume_slider = slider.volume_slider

volume_slider:connect_signal(
	'property::value',
	function()
		local volume_level = volume_slider:get_value()

		spawn('pamixer --set-volume ' ..
			volume_level,
			false
		)
	end
)

volume_slider:buttons(
	gears.table.join(
		awful.button(
			{},
			4,
			nil,
			function()
				if volume_slider:get_value() > 100 then
					volume_slider:set_value(100)
					return
				end
				volume_slider:set_value(volume_slider:get_value() + 5)
			end
		),
		awful.button(
			{},
			5,
			nil,
			function()
				if volume_slider:get_value() < 0 then
					volume_slider:set_value(0)
					return
				end
				volume_slider:set_value(volume_slider:get_value() - 5)
			end
		)
	)
)

local update_slider = function()
	awful.spawn.easy_async_with_shell(
		[[bash -c "pamixer --get-volume"]],
		function(stdout)
			local volume = stdout
			volume_slider:set_value(tonumber(volume))
		end
	)
end

local update_slider_mute = function()
	awful.spawn.easy_async_with_shell(
		[[bash -c "pamixer --get-mute"]],
		function(stdout)
			local status = string.match(stdout, '%a+')
			if status == 'true' then
				widget_icon.icon:set_image(icons.mute)
			elseif status == "false" then
				widget_icon.icon:set_image(icons.volume)
			end
		end
	)
end

watch (
	[[bash -c "pamixer --get-mute"]],
	2,
	function(_, stdout)
		local status = string.match(stdout, '%a+')
		if status == 'true' then
			widget_icon.icon:set_image(icons.mute)
		elseif status == "false" then
			widget_icon.icon:set_image(icons.volume)
		end
		collectgarbage('collect')
	end
)

-- Update on startup
update_slider()

local mute_toggle = function()
	awful.spawn.easy_async_with_shell(
		[[bash -c "pamixer --get-mute"]],
		function(stdout)
			local status = string.match(stdout, '%a+')
			if status == 'true' then
				spawn('pamixer -u')
				widget_icon.icon:set_image(icons.volume)
			elseif status == "false" then
				spawn('pamixer -m')
				widget_icon.icon:set_image(icons.mute)
			end
		end
	)
end

widget_content:buttons(
	awful.util.table.join(
		awful.button(
			{},
			1,
			nil,
			function()
				mute_toggle()
			end
		)
	)
)

-- The emit will come from the global keybind
awesome.connect_signal(
	'widget::volume',
	function()
		update_slider()
		update_slider_mute()
	end
)

local cc_volume = wibox.widget {
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

return cc_volume
