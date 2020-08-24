local awful = require('awful')

local modkey = require('config.keys.mod').modKey
local altkey = require('config.keys.mod').altKey

require('awful.autofocus')

local clientkeys = awful.util.table.join(
  awful.key(
		{modkey,"Shift"},
		"f",
    function (c)
      c.fullscreen = not c.fullscreen
      c:raise()
    end,
    {description = "toggle fullscreen", group = "Tiling"}
	),

  awful.key(
		{modkey,"Shift"},
		"c",
    function (c)
      c:kill()
    end,
    {description = "close", group = "Tiling"}
	),

  awful.key(
		{modkey,"Control"},
		"space",
    awful.client.floating.toggle,
    {description = "toggle floating", group = "Tiling"}
	),

  awful.key(
		{modkey,"Control" },
		"Return",
    function (c)
      c:swap(awful.client.getmaster())
    end,
    {description = "move to master", group = "Tiling"}
	),

  awful.key(
		{modkey},
		"o",
    function (c)
      c:move_to_screen()
    end,
    {description = "move to screen", group = "Tiling"}
	),

  awful.key(
		{modkey, 'Shift'},
		"t",
    function (c)
      c.ontop = not c.ontop
    end,
    {description = "toggle keep on top", group = "Tiling"}
	),

  awful.key(
		{modkey},
		"n",
    function (c)
        c.minimized = true
    end ,
    {description = "minimize", group = "Tiling"}
	),

  awful.key(
		{modkey,          },
		"m",
    function (c)
        c.maximized = not c.maximized
        c:raise()
    end ,
    {description = "(un)maximize", group = "Tiling"}
	),

  awful.key(
		{modkey,"Control" },
		"m",
    function (c)
        c.maximized_vertical = not c.maximized_vertical
        c:raise()
    end ,
    {description = "(un)maximize vertically", group = "Tiling"}
	),

  awful.key(
		{modkey,"Shift"   },
		"m",
    function (c)
        c.maximized_horizontal = not c.maximized_horizontal
        c:raise()
    end ,
    {description = "(un)maximize horizontally", group = "Tiling"}
  )
)

return clientkeys
