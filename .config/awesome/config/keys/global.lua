local awful = require('awful')
local naughty = require('naughty')
local colors = require('themes').colors
local beautiful = require('beautiful')

local modkey = require('config.keys.mod').modKey
local altkey = require('config.keys.mod').altKey

local apps = require('config.apps')
local hotkeys_popup = require('awful.hotkeys_popup').widget
local hotkeys_popup_custom = require('module.hotkeys-popup')

require('awful.autofocus')

local globalKeys = awful.util.table.join(
	awful.key(
		{},
		'XF86AudioRaiseVolume',
		function()
			awful.spawn.with_shell('pamixer -i 5')
			awesome.emit_signal('volume::update')
		end,
		{description = 'increase volume by 5%', group = 'hotkeys'}
	),
	
	awful.key(
		{},
		'XF86AudioLowerVolume',
		function()
			awful.spawn.with_shell('pamixer -d 5')
			awesome.emit_signal('volume::update')
		end,
		{description = 'decrease volume by 5%', group = 'hotkeys'}
	),

	awful.key(
		{},
		'XF86MonBrightnessUp',
		function()
			awful.spawn.with_shell('brightnessctl set +5%')
			awesome.emit_signal('brightness::update')
		end,
		{description = 'increase brightness by 5%', group = 'hotkeys'}
	),
	
	awful.key(
		{},
		'XF86MonBrightnessDown',
		function()
			awful.spawn.with_shell('brightnessctl set 5%-')
			awesome.emit_signal('brightness::update')
		end,
		{description = 'decrease brightness by 5%', group = 'hotkeys'}
	),

--[[
--[[
	awful.key(
		{modkey, "Control"},
		"f",
		function(c)
			local widget = awful.titlebar.widget.button(c, "maximized", function(cl)
					return cl.maximized
			end, function(cl, state)
					cl.maximized = not state
			end)
			update_on_signal(c, "property::maximized", widget)
			return widget
		end
		{description = 'Fix maximization when popup appears', group = 'hotkeys'}
	),
]]
	awful.key(
		{},
		'XF86AudioMute',
		function()
			awful.spawn.with_shell('pamixer -t')
			awesome.emit_signal('volume::update')
		end,
		{description = 'toggle mute', group = 'hotkeys'}
	),

  awful.key(
    {modkey},
    "h",
    hotkeys_popup_custom.show_help,
    {description="show help", group="Awesome"}
  ),

  awful.key(
		{modkey},
		"Left",
		awful.tag.viewprev,
    {description = "view previous", group = "Tag"}
  ),

  awful.key(
		{modkey},
		"Right",
		awful.tag.viewnext,
    {description = "view next", group = "Tag"}
  ),

  awful.key(
		{modkey},
		"Escape",
		awful.tag.history.restore,
    {description = "go back", group = "Tag"}
  ),

  awful.key(
		{modkey, "Shift"},
		"Right",
    function ()
        awful.client.focus.byidx( 1)
    end,
    {description = "focus next by index", group = "Tiling"}
  ),

  awful.key(
		{modkey, "Shift"},
		"Left",
    function ()
        awful.client.focus.byidx(-1)
    end,
    {description = "focus previous by index", group = "Tiling"}
  ),

  -- Layout manipulation
  awful.key(
		{modkey, "Shift"},
		"j",
		function ()
			awful.client.swap.byidx(  1)
		end,
		{description = "swap with next client by index", group = "Tiling"}
	),

  awful.key(
		{modkey, "Shift"},
		"k",
		function ()
			awful.client.swap.byidx( -1)
		end,
		{description = "swap with previous client by index", group = "Tiling"}
	),

	awful.key(
		{modkey, "Shift"},
		"s",
		function() awful.spawn.with_shell('flameshot gui') end,
		{description = "Screenshot selection", group = "Tiling"}
	),

  awful.key(
		{modkey, "Control"},
		"j",
		function ()
			awful.screen.focus_relative( 1)
		end,
		{description = "focus the next screen", group = "Screen"}
	),

  awful.key(
		{modkey, "Control"},
		"k",
		function ()
			awful.screen.focus_relative(-1)
		end,
		{description = "focus the previous screen", group = "Screen"}
	),

  awful.key(
		{modkey},
		"u",
		awful.client.urgent.jumpto,
		{description = "jump to urgent client", group = "Tiling"}
	),

  awful.key(
		{modkey},
		"Tab",
    function ()
      awful.client.focus.history.previous()
      if client.focus then
        client.focus:raise()
      end
    end,
    {description = "go back", group = "Tiling"}
	),


  -- Default programs
  awful.key(
  	{modkey},
  	"Return",
  	function ()
  		awful.spawn(apps.default.terminal)
    end,
		{description = "Open Terminal", group = "Default programs"}
	),

  awful.key(
  	{modkey},
  	"e",
  	function ()
  		awful.spawn(apps.default.editor)
    end,
		{description = "Open Editor", group = "Default programs"}
	),

  awful.key(
  	{modkey},
  	"b",
  	function ()
  		awful.spawn(apps.default.browser)
    end,
		{description = "Open Browser", group = "Default programs"}
	),

  awful.key(
  	{modkey},
  	"t",
  	function ()
  		awful.spawn(apps.default.email)
    end,
		{description = "Open Email Client", group = "Default programs"}
	),

  awful.key(
  	{modkey},
  	"d",
  	function ()
  		awful.spawn(apps.default.chat)
    end,
		{description = "Open Discord", group = "Default programs"}
	),

  awful.key(
  	{modkey},
  	"f",
  	function ()
  		awful.spawn(apps.default.file_manager)
    end,
		{description = "Open File Manager", group = "Default programs"}
	),

  awful.key(
		{modkey, "Control"},
		"r",
  	function ()
			awesome.restart()
		end,
		{description = "reload awesome", group = "Awesome"}
	),

  awful.key(
		{modkey, "Shift"},
		"q",
		awesome.quit,
		{description = "quit awesome", group = "Awesome"}
	),

  awful.key(
		{modkey},
		"Up",
		function ()
			awful.tag.incmwfact(0.05)
		end,
		{description = "increase master width factor", group = "Layout"}
	),

  awful.key(
		{modkey},
		"Down",
		function ()
			awful.tag.incmwfact(-0.05)
		end,
		{description = "decrease master width factor", group = "Layout"}
	),

  awful.key(
		{modkey, "Shift"},
		"Up",
		function ()
			awful.tag.incnmaster( 1, nil, true)
		end,
		{description = "increase the number of master clients", group = "Layout"}
	),

  awful.key(
		{modkey, "Shift"},
		"Down",
		function ()
			awful.tag.incnmaster(-1, nil, true)
		end,
		{description = "decrease the number of master clients", group = "Layout"}
	),

  awful.key(
		{modkey, "Control"},
		"Up",
		function ()
			awful.tag.incncol( 1, nil, true)
		end,
		{description = "increase the number of columns", group = "Layout"}
	),

  awful.key(
		{modkey, "Control"},
		"Down",
		function ()
			awful.tag.incncol(-1, nil, true)
		end,
		{description = "decrease the number of columns", group = "Layout"}
	),

  awful.key(
		{modkey},
		"space",
		function ()
			awful.layout.inc( 1)
      naughty.notify({
        preset = naughty.config.presets.low,
        title = "Switched Layouts",
        text = awful.layout.getname(awful.layout.get(awful.screen.focused())),
      })
    end,
		{description = "select next layout", group = "Layout"}
	),

  awful.key(
		{modkey, "Shift"},
		"space",
		function ()
			awful.layout.inc(-1)
      naughty.notify({
        preset = naughty.config.presets.low,
        title = "Switched Layouts",
        text = awful.layout.getname(awful.layout.get(awful.screen.focused())),
      })
    end,
		{description = "select previous layout", group = "Layout"}
	),

  awful.key(
		{modkey, "Control"},
		"space",
		function ()
			awful.client.floating.toggle()
      naughty.notify({
        preset = naughty.config.presets.low,
        title = "Window floating toggled"
      })
    end,
		{description = "select previous window layout", group = "Layout"}
	),

  awful.key(
		{modkey, "Control"},
		"n",
    function ()
      local c = awful.client.restore()
      -- Focus restored client
      if c then
        c:emit_signal(
          "request::activate", "key.unminimize", {raise = true}
        )
      end
    end,
		{description = "restore minimized", group = "Tiling"}
	),


  --Run DMenu Prompt
  awful.key(
		{modkey},
		"r",
		function() awful.util.spawn("rofi -no-lazy-grab -show drun -theme dmenu.rasi") end,
		{description = "run dmenu prompt", group = "Launchers"}
	),

  --[[Run DMenu Config Prompt
  awful.key(
		{modkey},
		"c",
		function() awful.spawn("./.config/dmenu/dmenu-edit-configs.sh") end,
		{description = "run dmenu configs prompt", group = "Launchers"}
	),]]--

  --Run DMenu VPN Prompt
  awful.key(
		{modkey},
		"v",
		function() awful.util.spawn("/home/jeremie1001/.config/dmenu/nord-countries.sh") end,
		{description = "run dmenu vpn prompt", group = "Launchers"}
	),

	--Run DMenu Projects Prompt
  awful.key(
		{modkey},
		"p",
		function() awful.util.spawn("/home/jeremie1001/.config/dmenu/projectFoldersRofi.sh") end,
		{description = "run dmenu projects prompt", group = "Launchers"}
	),

  --Run Rofi Prompt
  awful.key(
		{modkey, "Shift"},
		"r",
		function() awful.spawn.with_shell('rofi -no-lazy-grab -show drun -theme centered.rasi') end,
		{description = "run rofi prompt", group = "Launchers"}
	),
  
  --Run Rofi Prompt
  awful.key(
		{modkey, "Shift"},
		"w",
		function() awful.spawn.with_shell('rofi -no-lazy-grab -show window -theme window.rasi') end,
		{description = "run rofi window prompt", group = "Launchers"}
	),

  awful.key(
    {modkey},
    "q",
		function()
			exit_screen_show()
		end,
		{description = 'toggle exit screen', group = 'Awesome'}
	),

  awful.key(
    {modkey},
    "m",
		function()
			awesome.emit_signal("bar:toggle")
			awesome.emit_signal("cc:resize")
			awesome.emit_signal("nc:resize")
			awesome.emit_signal("cal:resize")
		end,
		{description = 'toggle top bar', group = 'Awesome'}
	),

	awful.key(
    {modkey, "Shift", "Control"},
    "m",
		function()
			beautiful.scheme = "nord"

			beautiful.color1 = require('themes.schemes.'..beautiful.scheme).color1
			beautiful.color2 = require('themes.schemes.'..beautiful.scheme).color2
			beautiful.color3 = require('themes.schemes.'..beautiful.scheme).color3
			beautiful.color4 = require('themes.schemes.'..beautiful.scheme).color4
			beautiful.color5 = require('themes.schemes.'..beautiful.scheme).color5
			beautiful.color6 = require('themes.schemes.'..beautiful.scheme).color6
			beautiful.color7 = require('themes.schemes.'..beautiful.scheme).color7
			beautiful.color8 = require('themes.schemes.'..beautiful.scheme).color8
			beautiful.colorA = require('themes.schemes.'..beautiful.scheme).colorA
			beautiful.colorB = require('themes.schemes.'..beautiful.scheme).colorB

			beautiful.titlebar_bg_normal = beautiful.color4
			awesome.emit_signal("wallpaper_changed")
		end,
		{description = 'toggle top bar', group = 'Awesome'}
	),

  awful.key(
    {modkey},
    "j",
		function()
			--awesome.emit_signal("settings::window:toggle")
			awful.spawn.with_shell('python3 .config/settings/main.py')
			--awful.spawn.with_shell('python3 .config/settings/code-examples-main/gtk-with-python/app1.py')
		end,
		{description = 'toggle settings menu', group = 'Awesome'}
	),

	awful.key(
    {modkey},
    "k",
		function()
			awesome.emit_signal("cc:toggle")
		end,
		{description = 'toggle control center', group = 'Awesome'}
	),

	awful.key(
    {modkey, "Shift"},
    "k",
		function()
			awesome.emit_signal("bar::centers:toggle:off")
		end,
		{description = 'toggle calendar', group = 'Awesome'}
	),

	awful.key(
    {modkey},
    "Tab",
		function()
			awesome.emit_signal("bar::tab", "right", 1)
		end,
		{description = 'Cycle bar centers - right', group = 'Awesome'}
	),

	awful.key(
    {modkey, "Shift"},
    "Tab",
		function()
			awesome.emit_signal("bar::tab:reverse", "right", 6)
		end,
		{description = 'Cycle bar centers - left', group = 'Awesome'}
	),

  awful.key(
		{modkey},
    "x",
    function ()
    awful.prompt.run {
      prompt       = "Run Lua code: ",
      textbox      = awful.screen.focused().mypromptbox.widget,
      exe_callback = awful.util.eval,
      history_path = awful.util.get_cache_dir() .. "/history_eval"
    }
    end,
		{description = "lua execute prompt", group = "Awesome"}
	)
)

for i = 1, 9 do
  globalKeys = awful.util.table.join(globalKeys,
    -- View tag only.
    awful.key({ modkey }, "#" .. i + 9,
      function ()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          tag:view_only()
        end
      end,
      {description = "view tag #"..i, group = "Tag"}),
    -- Toggle tag display.
    awful.key({ modkey, "Control" }, "#" .. i + 9,
      function ()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          awful.tag.viewtoggle(tag)
        end
      end,
      {description = "toggle tag #" .. i, group = "Tag"}),
    -- Move client to tag.
    awful.key({ modkey, "Shift" }, "#" .. i + 9,
      function ()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then
            client.focus:move_to_tag(tag)
          end
        end
      end,
      {description = "move focused client to tag #"..i, group = "Tag"}),
    -- Toggle tag on focused client.
    awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
      function ()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then
            client.focus:toggle_tag(tag)
          end
        end
      end,
      {description = "toggle focused client on tag #" .. i, group = "Tag"})
  )
end

return globalKeys
