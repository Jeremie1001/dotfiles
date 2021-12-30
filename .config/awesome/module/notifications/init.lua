local gears = require('gears')
local wibox = require('wibox')
local awful = require('awful')
local ruled = require('ruled')
local naughty = require('naughty')
local menubar = require('menubar')
local icons = require('themes.icons')
local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi
local clickable_container = require('widget.clickable-container')
local colors = require('themes.dracula.colors')

-- Apply theme variables
naughty.config.padding = dpi(8)
naughty.config.spacing = dpi(8)
naughty.config.icon_formats = { 'svg', 'png', 'jpg', 'gif' }

ruled.notification.connect_signal(
	'request::rules',
	function()

		-- Critical notifs
		ruled.notification.append_rule {
			rule = { urgency = 'critical' },
			properties = {
				implicit_timeout	= 0
			}
		}

		-- Normal notifs
		ruled.notification.append_rule {
			rule = { urgency = 'normal' },
			properties = {
				implicit_timeout	= 5
			}
		}

		-- Low notifs
		ruled.notification.append_rule {
			rule = { urgency = 'low' },
			properties = {
				implicit_timeout	= 2
			}
		}
	end
)

naughty.connect_signal(
	'request::display_error',
	function(message, startup)
		naughty.notification {
			urgency = 'critical',
			title   = 'You done gone messed up a-a-ron'..(startup and ' during startup!' or ''),
			message = message,
			app_name = 'System Notification',
			icon = icons.awesome
		}
	end
)

local main_color = {
    ['low'] = colors.green,
    ['normal'] = colors.selection,
    ['critical'] = '#cc6666',
}

local edge_color = {
    ['low'] = colors.purple,
    ['normal'] = colors.purple,
    ['critical'] = colors.red,
}

naughty.connect_signal(
	'request::display',
	function(n)
		local custom_notification_icon = wibox.widget {
        font = "Inter Regular 18",
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox
    }

		local main_color = main_color[n.urgency]
		local edge_color = edge_color[n.urgency]
		local icon = icons.awesome

		local actions = wibox.widget {
			notification = n,
			widget_template = {
				{
					{
						{
							id = 'text_role',
							font = beautiful.notification_font,
							widget = wibox.widget.textbox
						},
						left = dpi(6),
						right = dpi(6),
						widget = wibox.container.margin
					},
					widget = wibox.container.place
				},
				bg = main_color,
				forced_height = dpi(25),
				forced_width = dpi(70),
				widget = wibox.container.background
			},
			style = {
					underline_normal = false,
					underline_selected = true
			},
			widget = naughty.list.actions
		}

		local notif_icon = wibox.widget {
	     {
	       {
	         {
	          image = icons.dracula,
	          widget = wibox.widget.imagebox,
	        },
					margins = dpi(5),
	        widget = wibox.container.margin
				},
				shape = gears.shape.rect,
				bg = edge_color,
				widget = wibox.container.background
      },
      forced_width = 40,
      forced_height = 40,
      widget = clickable_container
  	}

		naughty.layout.box {
	    notification = n,
	    type = "notification",
	    -- For antialiasing: The real shape is set in widget_template
			shape = function(cr, width, height)
				gears.shape.rounded_rect(cr, width, height, dpi(4))
			end,
	    position = "top_right",
	    widget_template = {
	      {
	        {
	          notif_icon,
	          {
	            {
	              {
	                align = "center",
	                visible = title_visible,
	                font = "Inter Regular 8",
	                markup = "<b>"..n.title.."</b>",
	                widget = wibox.widget.textbox,
	                -- widget = naughty.widget.title,
	              },
	              {
	                align = "center",
	                --wrap = "char",
	                widget = naughty.widget.message,
	              },
	              {
	                wibox.widget{
	                    forced_height = dpi(10),
	                    layout = wibox.layout.fixed.vertical
	                },
	                {
	                  actions,
										shape = function(cr, width, height)
											gears.shape.rounded_rect(cr, width, height, dpi(4))
										end,
	                  widget = wibox.container.background,
	                },
	                  visible = n.actions and #n.actions > 0,
	                  layout  = wibox.layout.fixed.vertical
	              },
	              layout  = wibox.layout.align.vertical,
	            },
	            margins = dpi(4),
	            widget  = wibox.container.margin,
	          },
	          layout  = wibox.layout.fixed.horizontal,
	        },
	        strategy = "max",
	        width    = dpi(350),
	        height   = dpi(180),
	        widget   = wibox.container.constraint,
	      },
	      -- Anti-aliasing container
				shape = function(cr, width, height)
					gears.shape.rounded_rect(cr, width, height, dpi(4))
				end,
	      bg = main_color,
				fg = colors.white,
				border_width = dpi(1),
			  border_color = colors.background,
	      widget = wibox.container.background
	    }
		}

		if _G.dnd_status or nc_status then
			naughty.destroy_all_notifications(nil, 1)
		end

	end
)
