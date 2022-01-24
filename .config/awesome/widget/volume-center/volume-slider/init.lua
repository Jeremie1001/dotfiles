local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local clickable_container = require('widget.clickable-container')
local dpi = require('beautiful').xresources.apply_dpi
local icons = require('themes.icons')
local colors = require('themes').colors
local watch = require('awful.widget.watch')

local box = {}

local muteIcon = wibox.widget {
  layout = wibox.layout.align.vertical,
  expand = 'none',
  nil,
  {
    id = 'icon',
    image = icons.mute,
    resize = true,
    widget = wibox.widget.imagebox
  },
  nil
}

local mute = wibox.widget {
  {
    {
      {
        muteIcon,
        layout = wibox.layout.fixed.horizontal,
      },
      margins = dpi(9),
      widget = wibox.container.margin
    },
    forced_height = dpi(30),
    forced_width = dpi(30),
    widget = clickable_container
  },
  shape = gears.shape.circle,
  bg = colors.colorA,
  widget = wibox.container.background
}

mute:connect_signal(
  "mouse::enter",
  function()
    mute.bg = colors.color1
  end
)

mute:connect_signal(
  "mouse::leave",
  function()
    mute.bg = colors.colorA
  end
)

mute:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        awful.spawn.with_shell("pactl set-sink-mute @DEFAULT_SINK@ toggle")
      end
    )
  )
)

local volumeIcon = wibox.widget {
  {
    {
      {
        layout = wibox.layout.align.vertical,
        expand = 'none',
        nil,
        {
          image = icons.volume,
          widget = wibox.widget.imagebox,
        },
        nil
      },
      margins = dpi(7),
      widget = wibox.container.margin
    },
    shape = gears.shape.rect,
    bg = colors.color7,
    widget = wibox.container.background
  },
  forced_width = 40,
  forced_height = 40,
  widget = clickable_container
}

local slider = wibox.widget {
	nil,
	{
		id 					        = 'volume_slider',
		bar_shape           = gears.shape.rounded_rect,
		bar_height          = dpi(40),
		bar_color           = colors.colorA,
		bar_active_color		= colors.color7,
		handle_color        = colors.color7,
		handle_shape        = gears.shape.rounded_rect,
		handle_width        = dpi(40),
		maximum							= 100,
		widget              = wibox.widget.slider
	},
	nil,
	expand = 'none',
	forced_height = dpi(40),
	layout = wibox.layout.align.vertical
}

local volume_slider = slider.volume_slider

volume_slider:connect_signal(
	'property::value',
	function()
		local volume_level = volume_slider:get_value()

		awful.spawn.with_shell('pamixer --set-volume ' ..
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

update_slider()

local buttons = {
  layout = wibox.layout.align.horizontal,
  spacing = dpi(15),
  mute,
}

box = wibox.widget {
  {
    volumeIcon,
    {
      slider,
      margins = dpi(8),
      widget = wibox.container.margin
    },
    buttons,
    layout = wibox.layout.align.horizontal,
  },
  shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, dpi(4))
  end,
  fg = colors.white,
  border_width = dpi(1),
  border_color = colors.colorA,
  widget = wibox.container.background
}

return box