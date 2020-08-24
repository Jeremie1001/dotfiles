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


-- Defaults
naughty.config.defaults.ontop = true
naughty.config.defaults.icon_size = dpi(32)
naughty.config.defaults.font = 'Sauce Code Pro Regular 8'
naughty.config.defaults.timeout = 5
naughty.config.defaults.title = 'System Notification'
naughty.config.defaults.margin = dpi(16)
naughty.config.defaults.border_width = 0
naughty.config.defaults.position = 'top_right'
naughty.config.defaults.bg = colors.alpha(colors.cyan, 'EE')
naughty.config.defaults.fg = colors.black
naughty.config.defaults.shape = gears.shape.rounded_rect


-- Apply theme variables
naughty.config.padding = dpi(8)
naughty.config.spacing = dpi(8)
naughty.config.icon_dirs = {
	'/usr/share/icons/Tela',
	'/usr/share/icons/Tela-purple-dark',
	'/usr/share/icons/Papirus/',
}
naughty.config.icon_formats = { 'svg', 'png', 'jpg', 'gif' }

ruled.notification.connect_signal(
	'request::rules',
	function()

		-- Critical notifs
		ruled.notification.append_rule {
			rule = { urgency = 'critical' },
			properties = {
				bg = colors.red,
				implicit_timeout	= 0
			}
		}

		-- Normal notifs
		ruled.notification.append_rule {
			rule = { urgency = 'normal' },
		}

		-- Low notifs
		ruled.notification.append_rule {
			rule = { urgency = 'low' },
		}
	end
	)

  naughty.connect_signal(
	'request::display_error',
	function(message, startup)
		naughty.notification {
			urgency = 'critical',
			title   = 'Lmao, get wrekt'..(startup and ' during startup!' or ''),
			message = message,
			app_name = 'System Notification',
			icon = icons.awesome
		}
	end
)

-- XDG icon lookup
naughty.connect_signal(
	'request::icon',
	function(n, context, hints)
		if context ~= 'app_icon' then return end

		local path = menubar.utils.lookup_icon(hints.app_icon) or
		menubar.utils.lookup_icon(hints.app_icon:lower())

		if path then
			n.icon = path
		end
	end
)

--[[
naughty.connect_signal(
	'request::display',
	function(n)
		-- Destroy popups if dont_disturb mode is on
		-- Or if the right_panel is visible
		local focused = awful.screen.focused()
		if _G.dont_disturb or
			(focused.right_panel and focused.right_panel.visible) then
			naughty.destroy_all_notifications(nil, 1)
		end

	end
)
]]
