local capi = {
    screen = screen,
    client = client,
}
local awful = require("awful")
local gtable = require("gears.table")
local gears = require('gears')
local gstring = require("gears.string")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local colors = require('themes').colors

local matcher = require("gears.matcher")()

-- Stripped copy of this module https://github.com/copycat-killer/lain/blob/master/util/markup.lua:
local markup = {}
-- Set the font.
function markup.font(font, text)
    return '<span font="'    .. tostring(font)    .. '">' .. tostring(text) ..'</span>'
end
-- Set the foreground.
function markup.fg(color, text)
    return '<span foreground="' .. tostring(color) .. '">' .. tostring(text) .. '</span>'
end
-- Set the background.
function markup.bg(color, text)
    return '<span background="' .. tostring(color) .. '">' .. tostring(text) .. '</span>'
end

local function join_plus_sort(modifiers)
    if #modifiers<1 then return "none" end
    table.sort(modifiers)
    return table.concat(modifiers, '+')
end

local function get_screen(s)
    return s and capi.screen[s]
end


local widget = {
    group_rules = {},
}

widget.hide_without_description = true
widget.merge_duplicates = true


function widget.new(args)
    args = args or {}
    local widget_instance = {
        hide_without_description = (
            args.hide_without_description == nil
        ) and widget.hide_without_description or args.hide_without_description,
        merge_duplicates = (
            args.merge_duplicates == nil
        ) and widget.merge_duplicates or args.merge_duplicates,
        group_rules = args.group_rules or gtable.clone(widget.group_rules),
        -- For every key in every `awful.key` binding, the first non-nil result
        -- in this lists is chosen as a human-readable name:
        -- * the value corresponding to its keysym in this table;
        -- * the UTF-8 representation as decided by awful.keyboard.get_key_name();
        -- * the keysym name itself;
        -- If no match is found, the key name will not be translated, and will
        -- be presented to the user as-is. (This is useful for cheatsheets for
        -- external programs.)
        labels = args.labels or {
            Control          = "Ctrl",
            Mod1             = "Alt",
            ISO_Level3_Shift = "Alt Gr",
            Mod4             = "Super",
            Insert           = "Ins",
            Delete           = "Del",
            Backspace        = "BackSpc",
            Next             = "PgDn",
            Prior            = "PgUp",
            Left             = "←",
            Up               = "↑",
            Right            = "→",
            Down             = "↓",
            KP_End           = "Num1",
            KP_Down          = "Num2",
            KP_Next          = "Num3",
            KP_Left          = "Num4",
            KP_Begin         = "Num5",
            KP_Right         = "Num6",
            KP_Home          = "Num7",
            KP_Up            = "Num8",
            KP_Prior         = "Num9",
            KP_Insert        = "Num0",
            KP_Delete        = "Num.",
            KP_Divide        = "Num/",
            KP_Multiply      = "Num*",
            KP_Subtract      = "Num-",
            KP_Add           = "Num+",
            KP_Enter         = "NumEnter",
            -- Some "obvious" entries are necessary for the Escape sequence
            -- and whitespace characters:
            Escape           = "Esc",
            Tab              = "Tab",
            space            = "Space",
            Return           = "Enter",
            -- Dead keys aren't distinct from non-dead keys because no sane
            -- layout should have both of the same kind:
            dead_acute       = "´",
            dead_circumflex  = "^",
            dead_grave       = "`",
            -- Basic multimedia keys:
            XF86MonBrightnessUp   = "🔆+",
            XF86MonBrightnessDown = "🔅-",
            XF86AudioRaiseVolume = "Vol+",
            XF86AudioLowerVolume = "Vol-",
            XF86AudioMute = "Mute",
            XF86AudioPlay = "⏯",
            XF86AudioPrev = "⏮",
            XF86AudioNext = "⏭",
        },
        _additional_hotkeys = {},
        _cached_wiboxes = {},
        _cached_awful_keys = {},
        _group_list = {},
        _widget_settings_loaded = false,
        _keygroups = {},
    }
    for k, v in pairs(awful.key.keygroups) do
        widget_instance._keygroups[k] = {}
        for k2, v2 in pairs(v) do
            local keysym, keyprint = awful.keyboard.get_key_name(v2[1])
            widget_instance._keygroups[k][k2] =
                widget_instance.labels[keysym] or keyprint or keysym or v2[1]
        end
    end


    function widget_instance:_load_widget_settings()
        if self._widget_settings_loaded then return end
        self.width = args.width or dpi(1200)
        self.height = args.height or dpi(800)
        self.fg = args.fg or
            beautiful.hotkeys_fg or beautiful.fg_normal
        self.modifiers_fg = colors.color5
        self.label_bg = colors.color3
        self.font = args.font or
            beautiful.hotkeys_font or "Sauce Code Pro Bold 9"
        self.description_font = args.description_font or
            beautiful.hotkeys_description_font or "Sauce Code Pro 8"
        self.group_margin = args.group_margin or
            beautiful.hotkeys_group_margin or dpi(6)
        self._widget_settings_loaded = true
    end

    function widget_instance:_add_hotkey(key, data, target)
        if self.hide_without_description and not data.description then return end

        local readable_mods = {}
        for _, mod in ipairs(data.mod) do
            table.insert(readable_mods, self.labels[mod] or mod)
        end
        local joined_mods = join_plus_sort(readable_mods)

        local group = data.group or "none"
        self._group_list[group] = true
        if not target[group] then target[group] = {} end
        local keysym, keyprint = awful.keyboard.get_key_name(key)
        local keylabel = self.labels[keysym] or keyprint or keysym or key
        local new_key = {
            key = keylabel,
            keylist = {keylabel},
            mod = joined_mods,
            description = data.description
        }
        local index = data.description or "none"  -- or use its hash?
        if not target[group][index] then
            target[group][index] = new_key
        else
            if self.merge_duplicates and joined_mods == target[group][index].mod then
                target[group][index].key = target[group][index].key .. "/" .. new_key.key
                table.insert(target[group][index].keylist, new_key.key)
            else
                while target[group][index] do
                    index = index .. " "
                end
                target[group][index] = new_key
            end
        end
    end


    function widget_instance:_sort_hotkeys(target)
        for group, _ in pairs(self._group_list) do
            if target[group] then
                local sorted_table = {}
                for _, key in pairs(target[group]) do
                    table.insert(sorted_table, key)
                end
                table.sort(
                    sorted_table,
                    function(a,b)
                        local k1, k2 = a.key or a.keys[1][1], b.key or b.keys[1][1]
                        return (a.mod or '')..k1<(b.mod or '')..k2 end
                )
                target[group] = sorted_table
            end
        end
    end


    function widget_instance:_abbreviate_awful_keys()
        for _, keys in pairs(self._cached_awful_keys) do
            for _, params in pairs(keys) do
                if #params.keylist > 4 then
                    -- assuming here keygroups will never overlap;
                    -- if they ever do, another for loop will be necessary:
                    local keygroup = gtable.find_first_key(self._keygroups, function(_, v)
                        return not not gtable.hasitem(v, params.keylist[1])
                    end)
                    local first, last, count, tally = nil, nil, 0, {}
                    for _, k in ipairs(params.keylist) do
                        local i = gtable.hasitem(self._keygroups[keygroup], k)
                        if i and not tally[i] then
                            tally[i] = k
                            if (not first) or (i < first) then first = i end
                            if (not last) or (i > last) then last = i end
                            count = count + 1
                        elseif not i then
                            count = 0
                            break
                        end
                    end
                    -- this conditional can only be true if there are more than
                    -- four actual keys (discounting duplicates) and ALL of
                    -- these keys can be found one after another in a keygroup:
                    if count > 4 and last - first + 1 == count then
                        params.key = tally[first] .. "…" .. tally[last]
                    end
                end
            end
        end
    end


    function widget_instance:_import_awful_keys()
        if next(self._cached_awful_keys) then
            return
        end
        for _, data in pairs(awful.key.hotkeys) do
            for _, key_pair in ipairs(data.keys) do
                self:_add_hotkey(key_pair[1], data, self._cached_awful_keys)
            end
        end
        self:_sort_hotkeys(self._cached_awful_keys)
        if self.merge_duplicates then
            self:_abbreviate_awful_keys()
        end
    end

    function widget_instance:_group_label(group, color)
        local textbox = wibox.widget{
          markup = markup.fg(colors.color2, group),
          font = "Sauce Code Pro Bold 9",
          widget = wibox.widget.textbox

        }

        local margin = wibox.widget {
          {
            {
              {
                nil,
          		textbox,
                nil,
                layout = wibox.layout.fixed.vertical,
              },
              top = dpi(4),
              bottom = dpi(4),
              left = dpi(8),
              right = dpi(8),
              widget = wibox.container.margin
            },
            shape = gears.shape.rounded_rect,
            bg = 'transparent',
            border_width = dpi(2),
            border_color = colors.color2,
            widget = wibox.container.background
          },
          top = dpi(6),
          widget = wibox.container.margin
        }
        return margin
    end

    function widget_instance:_create_group_columns(column_layouts, group, keys, s, wibox_height)
        local line_height = beautiful.get_font_height(self.font)
        local group_label_height = line_height + self.group_margin
        -- -1 for possible pagination:
        local max_height_px = wibox_height - group_label_height

        local joined_descriptions = ""
        for i, key in ipairs(keys) do
            joined_descriptions = joined_descriptions .. key.description .. (i~=#keys and "\n" or "")
        end
        -- +1 for group label:
        local items_height = gstring.linecount(joined_descriptions) * line_height + group_label_height
        local current_column
        local available_height_px = max_height_px
        local add_new_column = true
        for i, column in ipairs(column_layouts) do
            if ((column.height_px + items_height) < max_height_px) or
                (i == #column_layouts and column.height_px < max_height_px / 2)
            then
                current_column = column
                add_new_column = false
                available_height_px = max_height_px - current_column.height_px
                break
            end
        end
        local overlap_leftovers
        if items_height > available_height_px then
            local new_keys = {}
            overlap_leftovers = {}
            -- +1 for group title and +1 for possible hyphen (v):
            local available_height_items = (available_height_px - group_label_height*2) / line_height
            for i=1,#keys do
                table.insert(((i<available_height_items) and new_keys or overlap_leftovers), keys[i])
            end
            keys = new_keys
            table.insert(keys, {key=markup.fg(self.modifiers_fg, "▽"), description=""})
        end
        if not current_column then
            current_column = {
                {
                    layout=wibox.layout.fixed.vertical()
                },
                layout=wibox.layout.fixed.vertical(),  
                widget = wibox.container.background,
                bg = colors.color4,
            }
        end
        current_column.layout:add(self:_group_label(group))
        

        local function insert_keys(_keys, _add_new_column)
            local max_label_width = 0
            local max_label_content = ""
            local joined_labels = ""
            for i, key in ipairs(_keys) do
                local length = string.len(key.key or '') + string.len(key.description or '')
                local modifiers = key.mod
                if not modifiers or modifiers == "none" then
                    modifiers = ""
                else
                    length = length + string.len(modifiers) + 1 -- +1 for "+" character
                    modifiers = markup.fg(self.modifiers_fg, modifiers.."+")
                end
                local rendered_hotkey = markup.font(self.font,
                    modifiers .. (key.key or "") .. markup.fg(colors.color2," : ")
                ) .. markup.font(self.description_font,
                    key.description or ""
                )
                if length > max_label_width then
                    max_label_width = length
                    max_label_content = rendered_hotkey
                end
                joined_labels = joined_labels .. rendered_hotkey .. (i~=#_keys and "\n" or "")
                end
            current_column.layout:add(wibox.widget.textbox(joined_labels))
            local max_width, _ = wibox.widget.textbox(max_label_content):get_preferred_size(s)
            max_width = max_width + self.group_margin
            if not current_column.max_width or max_width > current_column.max_width then
                current_column.max_width = max_width
            end
            -- +1 for group label:
            current_column.height_px = (current_column.height_px or 0) +
                gstring.linecount(joined_labels)*line_height + group_label_height
            if _add_new_column then
                table.insert(column_layouts, current_column)
                --[[
                table.insert(column_layouts, 
                    {
                        {
                            current_column,
                            widget = wibox.container.background,
                            bg = colors.color6,
                            shape = function(cr, width, height)
                                gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius)
                            end,
                            height_px = (current_column.height_px or 0) + gstring.linecount(joined_labels)*line_height + group_label_height,
                        },
                        height_px = (current_column.height_px or 0) + gstring.linecount(joined_labels)*line_height + group_label_height,
                        margins = dpi(10),
                        widget = wibox.container.margin,
                        layout=wibox.layout.fixed.vertical()
                    }
                )
                ]]
            end

        end

        insert_keys(keys, add_new_column)
        if overlap_leftovers then
            current_column = {layout=wibox.layout.fixed.vertical()}
            insert_keys(overlap_leftovers, true)
        end
    end

    function widget_instance:_create_wibox(s, available_groups, show_awesome_keys)
        s = get_screen(s)
        local wa = s.workarea
        local wibox_height = (self.height < wa.height) and self.height or
            (wa.height)
        local wibox_width = (self.width < wa.width) and self.width or
            (wa.width)

        -- arrange hotkey groups into columns
        local column_layouts = {}
        for _, group in ipairs(available_groups) do
            local keys = gtable.join(
                show_awesome_keys and self._cached_awful_keys[group] or nil,
                self._additional_hotkeys[group]
            )
            if #keys > 0 then
                self:_create_group_columns(column_layouts, group, keys, s, wibox_height)
            end
        end

        -- arrange columns into pages
        local available_width_px = wibox_width
        local pages = {}
        local columns = wibox.widget {
            layout = wibox.layout.fixed.horizontal(),
        }
        local previous_page_last_layout
        for _, item in ipairs(column_layouts) do
            if item.max_width > available_width_px then
                previous_page_last_layout:add(
                    self:_group_label("PgDn - Next Page", self.label_bg)
                )
                table.insert(pages, 
                    {
                        {
                            columns,
                            widget = wibox.container.background,
                            bg = colors.color4,
                            shape = function(cr, width, height)
                                gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius)
                            end,
                        },
                        margins = dpi(10),
                        widget = wibox.container.margin
                    }
                )
                columns = wibox.widget {
                    layout = wibox.layout.fixed.horizontal(),
                }
                available_width_px = wibox_width - item.max_width
                item.layout:insert(
                    1, self:_group_label("PgUp - Prev Page", self.label_bg)
                )
            else
                available_width_px = available_width_px - item.max_width
            end
            local column_margin = wibox.container.margin()
            column_margin:set_widget(item.layout)
            column_margin:set_left(self.group_margin)
            columns:add(column_margin)

            previous_page_last_layout = item.layout
        end

        table.insert(pages, 
            {
                {
                    columns,
                    widget = wibox.container.background,
                    bg = colors.colorA,
                    shape = function(cr, width, height)
                        gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius)
                    end,
                },
                margins = dpi(10),
                widget = wibox.container.margin
            }
        )

        -- Function to place the widget in the center and account for the
        -- workarea. This will be called in the placement field of the
        -- awful.popup constructor.
        local place_func = function(c)
            awful.placement.centered(c, {honor_workarea = true})
        end

        -- Construct the popup with the widget
        local mypopup = awful.popup {
            widget = pages[1],
            ontop = true,
--            bg=colors.alpha(colors.colorB, 'F2'),
            bg=colors.alpha(colors.colorB, 'F2'),
            border_width = dpi(2),
            border_color = colors.colorA,
            fg=self.fg,
            shape = function(cr, width, height)
              gears.shape.rounded_rect(cr, width, height, 15)
            end,
            placement = place_func,
            minimum_width = wibox_width,
            minimum_height = wibox_height,
        }

        local widget_obj = {
            current_page = 1,
            popup = mypopup,
        }

        -- Set up the mouse buttons to hide the popup
        -- Any keybinding except what the keygrabber wants wil hide the popup
        -- too
        mypopup.buttons = {
            awful.button({ }, 1, function () widget_obj:hide() end),
            awful.button({ }, 3, function () widget_obj:hide() end)
        }

        function widget_obj.page_next(_self)
            if _self.current_page == #pages then return end
            _self.current_page = _self.current_page + 1
            _self.popup:set_widget(pages[_self.current_page])
        end
        function widget_obj.page_prev(_self)
            if _self.current_page == 1 then return end
            _self.current_page = _self.current_page - 1
            _self.popup:set_widget(pages[_self.current_page])
        end
        function widget_obj.show(_self)
            _self.popup.visible = true
        end
        function widget_obj.hide(_self)
            _self.popup.visible = false
            if _self.keygrabber then
                awful.keygrabber.stop(_self.keygrabber)
            end
        end

        return widget_obj
    end


    --- Show popup with hotkeys help.
    function widget_instance:show_help(c, s, show_args)
        show_args = show_args or {}
        local show_awesome_keys = show_args.show_awesome_keys ~= false

        self:_import_awful_keys()
        self:_load_widget_settings()

        c = c or capi.client.focus
        s = s or (c and c.screen or awful.screen.focused())

        local available_groups = {}
        for group, _ in pairs(self._group_list) do
            local need_match
            for group_name, data in pairs(self.group_rules) do
                if group_name==group and (
                    data.rule or data.rule_any or data.except or data.except_any
                ) then
                    if not c or not matcher:matches_rule(c, {
                        rule=data.rule,
                        rule_any=data.rule_any,
                        except=data.except,
                        except_any=data.except_any
                    }) then
                        need_match = true
                        break
                    end
                end
            end
            if not need_match then table.insert(available_groups, group) end
        end

        local joined_groups = join_plus_sort(available_groups)..tostring(show_awesome_keys)
        if not self._cached_wiboxes[s] then
            self._cached_wiboxes[s] = {}
        end
        if not self._cached_wiboxes[s][joined_groups] then
            self._cached_wiboxes[s][joined_groups] = self:_create_wibox(s, available_groups, show_awesome_keys)
        end
        local help_wibox = self._cached_wiboxes[s][joined_groups]
        help_wibox:show()

        help_wibox.keygrabber = awful.keygrabber.run(function(_, key, event)
            if event == "release" then return end
            if key then
                if key == "Next" then
                    help_wibox:page_next()
                elseif key == "Prior" then
                    help_wibox:page_prev()
                else
                    help_wibox:hide()
                end
            end
        end)
        
        return help_wibox.keygrabber
    end

    --- Add hotkey descriptions for third-party applications.
    function widget_instance:add_hotkeys(hotkeys)
        for group, bindings in pairs(hotkeys) do
            for _, binding in ipairs(bindings) do
                local modifiers = binding.modifiers
                local keys = binding.keys
                for key, description in pairs(keys) do
                    self:_add_hotkey(key, {
                        mod=modifiers,
                        description=description,
                        group=group},
                    self._additional_hotkeys
                )
                end
            end
        end
        self:_sort_hotkeys(self._additional_hotkeys)
    end

    --- Add hotkey group rules for third-party applications.
    function widget_instance:add_group_rules(group, data)
        self.group_rules[group] = data
    end

    return widget_instance
end

local function get_default_widget()
    if not widget.default_widget then
        widget.default_widget = widget.new()
    end
    return widget.default_widget
end

--- Show popup with hotkeys help (default widget instance will be used).
function widget.show_help(...)
    return get_default_widget():show_help(...)
end

--- Add hotkey descriptions for third-party applications
function widget.add_hotkeys(...)
    return get_default_widget():add_hotkeys(...)
end

--- Add hotkey group rules for third-party applications
function widget.add_group_rules(group, data)
    return get_default_widget():add_group_rules(group, data)
end

return widget
