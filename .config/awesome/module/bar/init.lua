--DEPENDENCIES
	--i3lock-fancy-multimonitor
	--rofi
	--nordvpn-bin

local wibox = require('wibox')
local awful = require('awful')
local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi
local clickable_container = require('widget.clickable-container')
local colors = require('themes').colors
local settings = require("settings")

local bar = function(s)

	s.panel = awful.wibox ({
		ontop = true,
		screen = s,
		type = 'dock',
		height = dpi(27),
		width = s.geometry.width,
		x = s.geometry.x,
		y = s.geometry.y,
		stretch = false,
		visible = true,
		bg = 'transparent',
		fg = '#000000'
	})

	s.panel:struts {
		top = dpi(27)
	}

	function bar_toggle()
		if s.panel.visible == false then
			awful.screen.connect_for_each_screen(
				function(s)
					s.panel.visible = true
				end
			)
			awesome.emit_signal("bar:true")
		elseif s.panel.visible == true then
			awful.screen.connect_for_each_screen(
				function(s)
					s.panel.visible = false
				end
			)
			awesome.emit_signal("bar:false")
		end
	end

	local function fullscreen_bar_toggle(c)
		if c.screen and c.screen.index==1 and c==client.focus then
			if c.fullscreen then
				awful.screen.focused().panel.visible = false
			else
				awful.screen.focused().panel.visible = true
			end
		end
	end

	for _,signal in pairs({"property::fullscreen", "focus"}) do
		client.connect_signal(signal, fullscreen_bar_toggle)
	end

	local leftBar = {
		layout = wibox.layout.fixed.horizontal,
		spacing = dpi(5),
	}

	local centerBar = {
		layout = wibox.layout.fixed.horizontal,
		spacing = dpi(5),
	}

	local rightBar = {
		layout = wibox.layout.fixed.horizontal,
		spacing = dpi(5),
	}

	for i,widget in pairs(settings.bar.left) do 
		if widget[1] == "tags" then
			table.insert(leftBar, require('widget.bar.'..widget[1])(s, colors[widget[2][1]], colors[widget[2][2]], 3, 4, 4))
		else
			table.insert(leftBar, require('widget.bar.'..widget[1])({color = colors[widget[2]]}, 4, 4))
		end
	end

	for i,widget in pairs(settings.bar.center) do
		if widget[1] == "tags" then
			table.insert(centerBar, require('widget.bar.'..widget[1])(s, colors[widget[2][1]], colors[widget[2][2]], 3, 4, 4))
		else
			table.insert(centerBar, require('widget.bar.'..widget[1])({color = colors[widget[2]]}, 4, 4))
		end
	end

	for i,widget in pairs(settings.bar.right) do
		if widget[1] == "tags" then
			table.insert(rightBar, require('widget.bar.'..widget[1])(s, colors[widget[2][1]], colors[widget[2][2]], 3, 4, 4))
		else
			table.insert(rightBar, require('widget.bar.'..widget[1])({color = colors[widget[2]]}, 4, 4))
		end
	end

	s.panel:setup {
		layout = wibox.layout.align.horizontal,
		expand = 'none',
		{
			leftBar,
	    left = dpi(4),
	    widget = wibox.container.margin
		},
		{
			centerBar,
			widget = wibox.container.margin
		},
		{
			rightBar,
			right = dpi(4),
			widget = wibox.container.margin
		}
	}

	return panel
end

awesome.connect_signal(
	"bar:toggle",
	function()
		bar_toggle()
	end
)

awesome.connect_signal(
  "bar::centers:toggle:off",
	function()
		awesome.emit_signal("volume::center:toggle:off")
		awesome.emit_signal("network::center:toggle:off")
		awesome.emit_signal("notifications::center:toggle:off")
		awesome.emit_signal("bluetooth::center:toggle:off")
		awesome.emit_signal("cal::center:toggle:off")
	end
)

return bar
