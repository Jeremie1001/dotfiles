local setmetatable = setmetatable
local string = string
local gtable = require("gears.table")
local vertical = require("wibox.layout.fixed").vertical
local grid = require("wibox.layout.grid")
local textbox = require("wibox.widget.textbox")
local bgcontainer = require("wibox.container.background")
local base = require("wibox.widget.base")
local beautiful = require("beautiful")

local calendar = { mt = {} }

local properties = { "date", "font", "spacing", "week_numbers", "start_sunday", "long_weekdays", "fn_embed" }


local function make_cell(text, font, center)
    local w = textbox()
    w:set_markup(text)
    w:set_align(center and "center" or "right")
    w:set_valign("center")
    w:set_font(font)
    return w
end

--- Create a grid layout with the month calendar
local function create_month(props, date)
    local num_rows    = 8
    local num_columns = props.week_numbers and 8 or 7

    -- Create grid layout
    local layout = grid()
    layout:set_expand(true)
    layout:set_expand(true)
    layout:set_homogeneous(true)
    layout:set_spacing(props.spacing)
    layout:set_forced_num_rows(num_rows)
    layout:set_forced_num_cols(num_columns)

    local start_row    = 3
    local start_column = num_columns - 6
    local week_start   = props.start_sunday and 1 or 2
    local last_day     = os.date("*t", os.time{year=date.year, month=date.month+1, day=0})
    local month_days   = last_day.day
    local column_fday  = (last_day.wday - month_days + 1 - week_start ) % 7

    --local flags = {"header", "weekdays", "weeknumber", "normal", "focus"}
    local cell_date, t, i, j, w, flag, text, cell_date

    -- Header
    flag = "header"
    t = os.time{year=date.year, month=date.month, day=1}
    if props.subtype=="monthheader" then
        flag = "monthheader"
        text = os.date("%B", t)
    else
        text = os.date("%B %Y", t)
    end
    w = props.fn_embed(make_cell(text, props.font, true), flag, date, cell_date)
    layout:add_widget_at(w, 1, 1, 1, num_columns)

    -- Days
    i = start_row
    j = column_fday + start_column
    local current_week = nil
    local drawn_weekdays = 0
    for d=1, month_days do
        cell_date = {year=date.year, month=date.month, day=d}
        t = os.time(cell_date)
        -- Week number
        if props.week_numbers then
            text = os.date("%V", t)
            if tonumber(text) ~= current_week then
                flag = "weeknumber"
                w = props.fn_embed(make_cell(text, props.font), flag, cell_date, cell_date)
                layout:add_widget_at(w, i, 1, 1, 1)
                current_week = tonumber(text)
            end
        end
        -- Week days
        if drawn_weekdays < 7 then
            flag = "weekday"
            text = os.date("%a", t)
            if not props.long_weekdays then
                text = string.sub(text, 1, 2)
            end
            w = props.fn_embed(make_cell(text, props.font), flag, cell_date, cell_date)
            layout:add_widget_at(w, 2, j, 1, 1)
            drawn_weekdays = drawn_weekdays +1
        end
        -- Normal day
        flag = "normal"
        text = string.format("%2d", d)
        -- Focus day
        if date.day == d then
            flag = "focus"
            text = "<b>"..text.."</b>"
        end
        w = props.fn_embed(make_cell(text, props.font), flag, cell_date, cell_date)
        layout:add_widget_at(w, i, j, 1, 1)

        -- find next cell
        i,j = layout:get_next_empty(i,j)
        if j < start_column then j = start_column end
    end
    return props.fn_embed(layout, "month", date, cell_date)
end

--- Set the container to the current date
local function fill_container(self)
    local date = self._private.date
    if date then
        -- Create calendar grid
        if self._private.type == "month" then
            self._private.container:set_widget(create_month(self._private, date))
        elseif self._private.type == "year" then
            self._private.container:set_widget(create_year(self._private, date))
        end
    else
        self._private.container:set_widget(nil)
    end
    self:emit_signal("widget::layout_changed")
end


-- Set the calendar date
function calendar:set_date(date)
    if date ~= self._private.date then
        self._private.date = date
        -- (Re)create calendar grid
        fill_container(self)
    end
end


-- Build properties function
for _, prop in ipairs(properties) do
    -- setter
    if not calendar["set_" .. prop] then
        calendar["set_" .. prop] = function(self, value)
            if (string.sub(prop,1,3)=="fn_" and type(value) == "function") or self._private[prop] ~= value then
                self._private[prop] = value
                -- (Re)create calendar grid
                fill_container(self)
            end
        end
    end
    -- getter
    if not calendar["get_" .. prop] then
        calendar["get_" .. prop] = function(self)
            return self._private[prop]
        end
    end
end


--- Return a new calendar widget by type.
--
-- @tparam string type Type of the calendar, `year` or `month`
-- @tparam table date Date of the calendar
-- @tparam number date.year Date year
-- @tparam number|nil date.month Date month
-- @tparam number|nil date.day Date day
-- @tparam[opt="Monospace 10"] string font Font of the calendar
-- @treturn widget The calendar widget
local function get_calendar(type, date, font)
    local ct = bgcontainer()
    local ret = base.make_widget(ct, "calendar", {enable_properties = true})
    gtable.crush(ret, calendar, true)

    ret._private.type = type
    ret._private.container = ct

    -- default values
    ret._private.date = date
    ret._private.font = font or beautiful.calendar_font or "Monospace 10"

    ret._private.spacing       = beautiful.calendar_spacing or 5
    ret._private.week_numbers  = beautiful.calendar_week_numbers or false
    ret._private.start_sunday  = beautiful.calendar_start_sunday or false
    ret._private.long_weekdays = beautiful.calendar_long_weekdays or false
    ret._private.fn_embed      = function (w, _) return w end

    -- header specific
    ret._private.subtype = type=="year" and "monthheader" or "fullheader"

    fill_container(ret)
    return ret
end

--- A month calendar widget.

function calendar.month(date, font)
    return get_calendar("month", date, font)
end


return setmetatable(calendar, calendar.mt)

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
