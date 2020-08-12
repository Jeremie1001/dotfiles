local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi
panel_visible = false

local format_item = function(widget)
	return wibox.widget {
		{
			{
				layout = wibox.layout.align.vertical,
				expand = 'none',
				nil,
				widget,
				nil
			},
			margins = dpi(10),
			widget = wibox.container.margin
		},
		forced_height = dpi(88),
		bg = beautiful.groups_bg,
		shape = function(cr, width, height)
			gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius)
		end,
		widget = wibox.container.background
	}
end

local slider = wibox.widget {
	layout = wibox.layout.fixed.vertical,
	format_item(
		{
			require('widget.volume-slider'),
			margins = dpi(10),
			widget = wibox.container.margin
		}
	)
}

volume = wibox({
    x = dpi(100),
    y = dpi(100),
    visible = false,
    ontop = true,
    type = 'splash',
    height = dpi(88),
    width = dpi(400)
  }
)

volume.bg = '#989898E0'
volume.fg = '#BD93F9'

local volume_grabber

function volume_hide()
  awful.keygrabber.stop(exit_screen_grabber)
  volume.visible = false
end

function volume_show()
  volume_grabber =
    awful.keygrabber.run(
    function(_, key, event)
      if event == 'release' then
        return
      end

      if key == 'Escape' or key == 'q' or key == 'x' then
        volume_hide()
      end
    end
  )
  volume.visible = true
end

volume:buttons(
  gears.table.join(
    -- Middle click - Hide volume
    awful.button(
      {},
      2,
      function()
        volume_hide()
      end
    ),
    -- Right click - Hide volume
    awful.button(
      {},
      3,
      function()
        volume_hide()
      end
    )
  )
)


volume:setup {
  nil,
  {
    nil,
		{
      slider,
      layout = wibox.layout.fixed.horizontal
    },
    nil,
    volume_number,
    layout = wibox.layout.align.vertical
  },
  nil,
  expand = 'none',
  layout = wibox.layout.align.horizontal
}
