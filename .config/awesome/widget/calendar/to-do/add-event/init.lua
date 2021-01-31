local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local icons = require('themes.icons')
local clickable_container = require('widget.clickable-container')

local titleFetch = function()
  awful.spawn.easy_async_with_shell (
    [[ rofi -dmenu -theme $HOME/.config/awesome/widget/calendar/to-do/to-do-background/eventCreationTitle.rasi ]],
      function(stdout)
        update_to_do_date_text2(stdout)
        string = stdout
      end
  )
  return string
end

local descriptionFetch = function()
  return awful.spawn.easy_async_with_shell (
    [[ echo $(rofi -no-lazy-grab -dmenu -theme $HOME/.config/awesome/widget/calendar/to-do/to-do-background/eventCreationTitle.rasi) ]],
      function(stdout)
        return stdout
      end
  )
end

awesome.connect_signal (
  "widget::add-to-do-event",
    function()
      local titleString = titleFetch()
      update_to_do_date_text2(titleString)
      -- local decriptionString = descriptionFetch()
    end
)