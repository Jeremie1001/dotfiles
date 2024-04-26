local gears = require('gears')
local awful = require('awful')
local dpi = require('beautiful').xresources.apply_dpi
local colors = require('themes').colors

local return_tooltip = function(color, object, bool, cmd, cmdFunction)
  local tooltip = awful.tooltip {
    objects = { object },
    shape = gears.shape.rounded_rect,
    border_color = color,
    bg = colors.colorB,
    fg = colors.white,
    border_width = dpi(2),
    margins_leftright = dpi(10),
    margins_topbottom = dpi(6),
    mode = outside,
  }
  
  if bool then
    awful.spawn.easy_async_with_shell(
      [[bash -c "]] .. cmd .. [["]],
      function(stdout)
        local value = cmdFunction(stdout)
        tooltip.text = value
      end
    )
  else
    tooltip.text = cmd
  end

  object:connect_signal(
    'mouse::enter',
    function()
      if bool then
        awful.spawn.easy_async_with_shell(
          [[bash -c "]] .. cmd .. [["]],
          function(stdout)
            local value = cmdFunction(stdout)
            tooltip.text = value
          end
        )
      else
        tooltip.text = cmd
      end
    end
  )

  awesome.connect_signal(
    "tooltip::visible:off",
    function()
      tooltip.visible = false
    end
  )
end

return return_tooltip
