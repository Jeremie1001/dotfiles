local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local clickable_container = require('widget.clickable-container')
local dpi = require('beautiful').xresources.apply_dpi
local icons = require('themes.icons')
local colors = require('themes').colors
local settings = require('settings')

local box = {}

local color = colors[settings.bar.colors.volume]

local volumeIcon = wibox.widget {
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

local volume = wibox.widget {
  {
    {
      {
        volumeIcon,
        layout = wibox.layout.fixed.horizontal,
      },
      margins = dpi(7),
      widget = wibox.container.margin
    },
    shape = gears.shape.rect,
    bg = color,
    widget = wibox.container.background
  },
  forced_width = 40,
  forced_height = 40,
  widget = clickable_container
}

volume:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        awful.spawn.with_shell("pamixer -t")
		    awesome.emit_signal('volume::update')
      end
    )
  )
)

local slider = wibox.widget {
	nil,
	{
		id 					        = 'volume_slider',
		bar_shape           = gears.shape.rounded_rect,
		bar_height          = dpi(40),
		bar_color           = colors.colorA,
		bar_active_color		= color,
		handle_color        = color,
		handle_shape        = gears.shape.rounded_rect,
		handle_width        = dpi(40),
		maximum							= 99,
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
		awesome.emit_signal('volume::update')
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
				volumeIcon.icon:set_image(icons.mute)
			elseif status == "false" then
				volumeIcon.icon:set_image(icons.volume)
			end
		end
	)
end

update_slider()

awesome.connect_signal(
	'volumeCenter::volumeSlider:update',
	function()
		update_slider()
    update_slider_mute()
	end
)

box = wibox.widget {
  {
    volume,
    {
      slider,
      margins = dpi(8),
      widget = wibox.container.margin
    },
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