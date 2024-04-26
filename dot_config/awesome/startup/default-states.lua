local awful = require('awful')
local settings = require("settings")

--Startup commands
if settings.default_states.numlock == "true" then
  awful.spawn.with_shell("numlockx on")
elseif settings.default_states.numlock == "false" then
  awful.spawn.with_shell("numlockx off")
end

if settings.default_states.mute == "true" then
  awful.spawn.with_shell("pamixer -m")
elseif settings.default_states.mute == "false" then
  awful.spawn.with_shell("pamixer -u")
end
awesome.emit_signal("volume::update")


awesome.emit_signal("bluetooth::power", settings.default_states.bluetooth)