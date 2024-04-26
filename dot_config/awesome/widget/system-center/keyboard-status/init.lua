local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local clickable_container = require('widget.clickable-container')
local dpi = require('beautiful').xresources.apply_dpi
local icons = require('themes.icons')
local colors = require('themes').colors

local left_content = wibox.widget {
	text = "keyboard",
  font = 'Inter Bold 14',
	widget = wibox.widget.textbox
}

local right_content = wibox.widget {
	text = "placeholder",
  font = 'Inter Bold 14',
	widget = wibox.widget.textbox,
}

local widget_user = wibox.widget {
	layout = wibox.layout.align.vertical,
	expand = 'none',
	nil,
	{
		left_content,
		layout = wibox.layout.align.horizontal,

	},
	nil
}

local widget_host = wibox.widget {
	layout = wibox.layout.align.vertical,
	expand = 'none',
	nil,
	{
		right_content,
		layout = wibox.layout.align.horizontal,
	},
	nil
}

local spacer_bar = wibox.widget {
  {
    orientation = 'vertical',
  	forced_height = dpi(1),
    forced_width = dpi(2),
    shape = gears.shape.rounded_bar,
  	widget = wibox.widget.separator,
  },
  margins = dpi(10),
  widget = wibox.container.margin
}

function StringDifference(str1,str2)
	for i = 1,#str1 do --Loop over strings
			if str1:sub(i,i) ~= str2:sub(i,i) then --If that character is not equal to it's counterpart
					return i --Return that index
			end
	end
	return #str1+1 --Return the index after where the shorter one ends as fallback.
end

local update_host = function()
	awful.spawn.easy_async_with_shell(
		[[bash -c "setxkbmap -query | grep 'layout'"]],
		function(stdout)
			local layoutCode = stdout:gsub("layout: ", ""):gsub(" ", ""):sub(1,-2)
			awful.spawn.easy_async_with_shell(
				"man -P cat xkeyboard-config | grep ' "..layoutCode.." ' | sed 's/  //g;s/.$//g;s/ "..layoutCode.."//g' | cut -c5-",
				function(stdout)
					local keyboardLayoutStatus = stdout:gsub("\n","")
					right_content:set_text(keyboardLayoutStatus)
				end
			)
		end
	)
end

update_host()

awesome.connect_signal(
	"system::keyboard:status:update",
	function()
		update_host()
	end
)


local widget = wibox.widget {
   {
    widget_user,
    spacer_bar,
		widget_host,
  	layout = wibox.layout.fixed.horizontal,
	},
  fg = '#DDD',
	widget = wibox.container.background
}

return widget
