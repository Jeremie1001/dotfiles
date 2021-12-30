--DEPENDENCIES
	--i3lock-fancy

local awful = require('awful')
local gears = require('gears')
local wibox = require('wibox')
local icons = require('themes.icons')
local clickable_container = require('widget.clickable-container')
local colors = require('themes.dracula.colors')
local apps = require('config.apps')
local dpi = require('beautiful').xresources.apply_dpi

-- Appearance
local icon_size = dpi(140)
local screen_geometry = awful.screen.focused().geometry

local greeter_message = wibox.widget {
	markup = 'Goodbye Jeremie!',
	font = 'Inter Regular 52',
	align = 'center',
	valign = 'center',
	forced_width = screen_geometry.width,
	widget = wibox.widget.textbox
}

local buildButton = function(icon)
  local buttonWidget = wibox.widget {
	     {
	       {
	         {
						 {
		          image = icon,
		          widget = wibox.widget.imagebox
		        },
		        margins = dpi(16),
		        widget = wibox.container.margin
					},
					shape = gears.shape.circle,
					bg = 'transparent',
					widget = wibox.container.background
	      },
	      forced_width = icon_size,
	      forced_height = icon_size,
	      widget = clickable_container
	    },
	    left = dpi(24),
	    right = dpi(24),
	    widget = wibox.container.margin
  	}

  return buttonWidget
end

function suspend_command()
  exit_screen_hide()
  awful.spawn.with_shell(apps.default.lock .. ' & systemctl suspend')
end
function exit_command()
  _G.awesome.quit()
end
function lock_command()
  exit_screen_hide()
  awful.spawn.with_shell('sleep 1 && ' .. apps.default.lock)
end
function poweroff_command()
  awful.spawn.with_shell('poweroff')
  awful.keygrabber.stop(_G.exit_screen_grabber)
end
function reboot_command()
  awful.spawn.with_shell('reboot')
  awful.keygrabber.stop(_G.exit_screen_grabber)
end

local poweroff = buildButton(icons.power, 'Shutdown')
poweroff:connect_signal(
  'button::release',
  function()
    poweroff_command()
  end
)

local reboot = buildButton(icons.restart, 'Restart')
reboot:connect_signal(
  'button::release',
  function()
    reboot_command()
  end
)

local suspend = buildButton(icons.sleep, 'Sleep')
suspend:connect_signal(
  'button::release',
  function()
    suspend_command()
  end
)

local exit = buildButton(icons.logout, 'Logout')
exit:connect_signal(
  'button::release',
  function()
    exit_command()
  end
)

local lock = buildButton(icons.lock, 'Lock')
lock:connect_signal(
  'button::release',
  function()
    lock_command()
  end
)

-- Get screen geometry
--local screen_geometry = awful.screen.focused().geometry

-- Create the widget

local exit_screen = function(s)
  s.exit_screen =
    wibox(
    {
      x = s.geometry.x,
      y = s.geometry.y,
      visible = false,
      screen = s,
      ontop = true,
      type = 'splash',
      height = s.geometry.height,
      width = s.geometry.width,
      bg = colors.alpha(colors.selection, 'E0'),
      fg = '#FEFEFE'
    }
  )

  s.exit_screen_unfocused =
    wibox(
    {
      x = s.geometry.x,
      y = s.geometry.y,
      visible = false,
      screen = s,
      ontop = true,
      type = 'splash',
      height = s.geometry.height,
      width = s.geometry.width,
      bg = colors.alpha(colors.selection, 'E0'),
      fg = '#FEFEFE'
    }
  )


  local exit_screen_grabber

  function exit_screen_unfocused_hide(qqqq)
    s.exit_screen_unfocused.visible = false
  end

  function exit_screen_unfocused_show()
    s.exit_screen_unfocused.visible = true
  end

  function exit_screen_hide()
    awful.keygrabber.stop(exit_screen_grabber)
    awful.screen.connect_for_each_screen(function(s)
      s.exit_screen_unfocused.visible = false
      s.exit_screen.visible = false
    end)
  end

  function exit_screen_show()
    awful.screen.connect_for_each_screen(function(s)
      s.exit_screen_unfocused.visible = true
    end)
    exit_screen_grabber =
      awful.keygrabber.run(
      function(_, key, event)
        if event == 'release' then
          return
        end

        if key == '1' then
          poweroff_command()
        elseif key == '2' then
          reboot_command()
        elseif key == '3' then
          suspend_command()
        elseif key == '4' then
          exit_command()
        elseif key == '5' then
          lock_command()
        elseif key == 'Escape' or key == 'q' or key == 'x' then
          exit_screen_hide()
        end
      end
    )
    awful.screen.focused().exit_screen.visible = true
  end

  s.exit_screen:buttons(
    gears.table.join(
      -- Middle click - Hide exit_screen
      awful.button(
        {},
        2,
        function()
          exit_screen_hide()
        end
      ),
      -- Right click - Hide exit_screen
      awful.button(
        {},
        3,
        function()
          exit_screen_hide()
        end
      )
    )
  )

  -- Item placement
  s.exit_screen:setup {
    nil,
    {
      nil,
      {
        poweroff,
        reboot,
        suspend,
        exit,
        lock,
        layout = wibox.layout.fixed.horizontal
      },
      nil,
      expand = 'none',
      layout = wibox.layout.align.vertical
    },
    nil,
    expand = 'none',
    layout = wibox.layout.align.horizontal
  }

  s.exit_screen_unfocused:setup {
    nil,
    layout = wibox.layout.align.horizontal
  }

end

return exit_screen
