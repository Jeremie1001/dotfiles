local awful = require('awful')
local gears = require('gears')
local wibox = require('wibox')
local colors = require('themes').colors
local screen_geometry = require('awful').screen.focused().geometry

local svgColor = function(svgString, colorString)
  return svgString:gsub("#ffffff",colorString)
end

return svgColor