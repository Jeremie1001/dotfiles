-- put user settings here
-- this module will be loaded after everything else when the application starts
-- it will be automatically reloaded when saved

local core = require "core"
local config = require "core.config"
local style = require "core.style"
local keymap = require "core.keymap"

------------------------------ Themes ----------------------------------------

-- light theme:
core.reload_module("colors.dracula")

--------------------------- Key bindings -------------------------------------

keymap.add { ["ctrl+escape"] = "core:quit" }
keymap.add { ["ctrl+x"] = "doc:delete-lines" }
--require("module.minimap")

------------------------------- Fonts ----------------------------------------

-- customize fonts:
 style.font = renderer.font.load("fonts/FiraSans-Regular.ttf", 8 * SCALE)
 style.code_font = renderer.font.load("fonts/JetBrainsMono-Regular.ttf", 8 * SCALE)
--
-- font names used by lite:
-- style.font          : user interface
-- style.big_font      : big text in welcome screen
-- style.icon_font     : icons
-- style.icon_big_font : toolbar icons
-- style.code_font     : code
--
-- the function to load the font accept a 3rd optional argument like:
--
-- {antialiasing="grayscale", hinting="full"}
--
-- possible values are:
-- antialiasing: grayscale, subpixel
-- hinting: none, slight, full

------------------------------ Plugins ----------------------------------------

-- enable or disable plugin loading setting config entries:

-- enable plugins.trimwhitespace, otherwise it is disable by default:
-- config.plugins.trimwhitespace = true
--
-- disable detectindent, otherwise it is enabled by default
-- config.plugins.detectindent = false
