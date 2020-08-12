-------------------------------
--    "Sky" awesome theme    --
--  By Andrei "Garoth" Thorp --
-------------------------------
-- If you want SVGs and extras, get them from garoth.com/awesome/sky-theme

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local themes_path = require("gears.filesystem").get_themes_dir()


-- BASICS
local theme = {}
theme.font          = "sans 8"

theme.bg_focus      = "#e2eeea"
theme.bg_normal     = "#282A36"
theme.bg_urgent     = "#fce94f"
theme.bg_minimize   = "#0067ce"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#2e3436"
theme.fg_focus      = "#2e3436"
theme.fg_urgent     = "#2e3436"
theme.fg_minimize   = "#2e3436"

theme.useless_gap   = 4
theme.border_width  = 3
theme.border_normal = "#8be9fd"
theme.border_focus  = "#bd93f9"
theme.border_marked = "#eeeeec"

theme.hotkeys_bg = "#44475A"
theme.hotkeys_fg = "#D9D9D9"
theme.hotkeys_modifiers_fg = "#9E9E9E"
theme.hotkeys_border_color = "#4DC76E"
theme.hotkeys_group_margin = 10

theme.menu_bg_focus = "#44475A"
theme.menu_fg_focus = "#D9D9D9"
theme.menu_bg_normal = "#282A36"
theme.menu_fg_normal = "#9E9E9E"
theme.menu_border_color = "#FF79C6"

client.shape_clip = 4

-- IMAGES
theme.layout_fairh           = themes_path .. "dracula/layouts/fairh.png"
theme.layout_fairv           = themes_path .. "dracula/layouts/fairv.png"
theme.layout_floating        = themes_path .. "dracula/layouts/floating.png"
theme.layout_magnifier       = themes_path .. "dracula/layouts/magnifier.png"
theme.layout_max             = themes_path .. "dracula/layouts/max.png"
theme.layout_fullscreen      = themes_path .. "dracula/layouts/fullscreen.png"
theme.layout_tilebottom      = themes_path .. "dracula/layouts/tilebottom.png"
theme.layout_tileleft        = themes_path .. "dracula/layouts/tileleft.png"
theme.layout_tile            = themes_path .. "dracula/layouts/tile.png"
theme.layout_tiletop         = themes_path .. "dracula/layouts/tiletop.png"
theme.layout_spiral          = themes_path .. "dracula/layouts/spiral.png"
theme.layout_dwindle         = themes_path .. "dracula/layouts/dwindle.png"
theme.layout_cornernw        = themes_path .. "dracula/layouts/cornernw.png"
theme.layout_cornerne        = themes_path .. "dracula/layouts/cornerne.png"
theme.layout_cornersw        = themes_path .. "dracula/layouts/cornersw.png"
theme.layout_cornerse        = themes_path .. "dracula/layouts/cornerse.png"

theme.awesome_icon           = themes_path .. "dracula/awesome-icon.png"

-- from default for now...
theme.menu_submenu_icon     = themes_path .. "dracula/submenu.png"

-- Generate taglist squares:
local taglist_square_size = dpi(4)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)

-- MISC
theme.wallpaper             = "/home/jeremie1001/.config/awesome/themes/backgrounds/archdracula.png"
theme.taglist_squares       = "true"
theme.titlebar_close_button = "true"
theme.menu_height = dpi(15)
theme.menu_width  = dpi(100)

-- Define the image to load
theme.titlebar_close_button_normal = themes_path .. "default/titlebar/close_normal.png"
theme.titlebar_close_button_focus = themes_path .. "default/titlebar/close_focus.png"

theme.titlebar_minimize_button_normal = themes_path .. "default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = themes_path .. "default/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = themes_path .. "default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive = themes_path .. "default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = themes_path .. "default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active = themes_path .. "default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = themes_path .. "default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive = themes_path .. "default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = themes_path .. "default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active = themes_path .. "default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = themes_path .. "default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive = themes_path .. "default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = themes_path .. "default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active = themes_path .. "default/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = themes_path .. "default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive = themes_path .. "default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = themes_path .. "default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active = themes_path .. "default/titlebar/maximized_focus_active.png"

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
