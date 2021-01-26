local wibox = require('wibox')
local calendar = require('library.wibox.widget.calendar')
local awful = require('awful')
local gears = require('gears')
local colors = require('themes.dracula.colors')
local clickable_container = require('widget.clickable-container')

-- Initialize empty styles table
local styles = {}

-- Initialize calendar widget
local cal = wibox.widget {
  date         = os.date('*t'),
  font         = 'Inter 8',
  spacing      = 10,
  week_numbers = false,
  fn_embed = decorate_cell,
  start_sunday = true,
  widget       = calendar.month
}

-- Helper function for rounded rectangle shape
local function rounded_shape(size)
  return function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, size)
  end
end

--Default background shape of calendar
styles.month   = {
  padding      = 5,
  bg_color     = colors.background,
  border_width = 2,
  shape        = rounded_shape(10),
}

-- Styles for all dates, makes them clickable
styles.normal = {
  widget   = clickable_container
}

-- Styles for focused date
styles.focus   = {
  bg_color = colors.purple,
  fg_color = colors.background,
  markup   = function(t) return '<b>' .. t .. '</b>' end,
  shape    = rounded_shape(5),
  widget   = clickable_container
}

-- Function that changes color of focused date
  -- If focused date is todays date, set it to purple
  -- Otherwise set it to cyan

local function update_color()
  if os.date("%Y/%m/%d", os.time(os.date('*t'))) == os.date("%Y/%m/%d", os.time(cal.date)) then
    styles.focus.bg_color = colors.purple
  elseif os.date("%Y/%m/%d", os.time(os.date('*t'))) ~= os.date("%Y/%m/%d", os.time(cal.date)) then
    styles.focus.bg_color = colors.cyan
  end

  -- Refresh calendar
  cal.date = os.date('*t', os.time(cal.date))

  -- Since this function is called everytime the date is changed, to do text updater function is called here as well
  update_to_do_date_text(os.date("%Y/%m/%d", os.time(cal.date)))
end


-- decorate_cell function used for styling of calendar as modified in library/wibox/widget/calendar
local function decorate_cell(widget, flag, date, cell_date)

  -- Return subtable associated to normal/focus/month flag in styles table
  local props = styles[flag] or {}

  -- Date widget
    -- Uses settings specified in prop or a default setting
  local ret = wibox.widget {
    {
      {
        widget,
        margins = (props.padding or 2) + (props.border_width or 0),
        widget  = wibox.container.margin
      },
      widget = props.widget or wibox.container.background
    },
    shape              = props.shape,
    fg                 = props.fg_color or colors.foreground,
    bg                 = props.bg_color or 'transparent',
    widget             = wibox.container.background
  }

  -- Since all the dates were previously made clickable
    -- When clicked change focus date to that of the cell clicked
    -- If non date location is clicked (ie: flag = month) nothing happens
  ret:buttons(
    gears.table.join(
      awful.button(
        {},
        1,
        nil,
        function()
          if (flag == "normal" or flag == "focus") then
            cal:set_date(os.date('*t', os.time(cell_date)))
            update_color()
            updateToDoPanel(cal.date)
          end
        end
      )
    )
  )

  return ret
end

-- Embed decorate_cells function in cal wibox as specified in widget.calendar
cal.fn_embed = decorate_cell

-- Update color on startup
update_color()

-- Increase epoch format time of focus date by 24h
function date_increase()
  cal.date = os.date('*t',os.time(cal.date) + 86400)
  update_color()
  updateToDoPanel(cal.date)
end

-- Decrease epoch format time of focus date by 24h
function date_decrease()
  cal.date = os.date('*t',os.time(cal.date) - 86400)
  update_color()
  updateToDoPanel(cal.date)
end

-- Return focus date to current
function reset_date()
  cal.date = os.date('*t')
  update_color()
  updateToDoPanel(cal.date)
end

-- Set date to first day of the next month
function month_increase()
  cal.date = os.date('*t',os.time({year=os.date("%Y", os.time(cal.date)), month=os.date("%m", os.time(cal.date))+1, day=1}))
  update_color()
  updateToDoPanel(cal.date)
end

-- Set date to first day of the previous month
function month_decrease()
  cal.date = os.date('*t',os.time({year=os.date("%Y", os.time(cal.date)), month=os.date("%m", os.time(cal.date))-1, day=1}))
  update_color()
  updateToDoPanel(cal.date)
end

return cal
