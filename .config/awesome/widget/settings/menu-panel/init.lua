local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local clickable_container = require('widget.clickable-container')
local dpi = require('beautiful').xresources.apply_dpi
local icons = require('themes.icons')
local colors = require('themes').colors
local watch = require('awful.widget.watch')
local beautiful = require('beautiful')
local naughty = require('naughty')

local width = dpi(150)

local pages = require('widget.settings.pages')

local categoriesPanelLayout = wibox.layout.fixed.vertical()
categoriesPanelLayout.spacing = dpi(7)
categoriesPanelLayout.forced_width = width

local subCategoriesPanelLayout = wibox.layout.fixed.vertical()
subCategoriesPanelLayout.spacing = dpi(7)
subCategoriesPanelLayout.forced_width = width

local categoryAdd = function(n, category, subcategory)
  local box = require("widget.settings.menu-element")
  for i,label in pairs(n) do
    if i == category then
      categoriesPanelLayout:insert(#categoriesPanelLayout.children+1, box.create(i, nil, true, false))
      for j,label in pairs(pages[i]) do
        if j == subcategory then
          subCategoriesPanelLayout:insert(#subCategoriesPanelLayout.children+1, box.create(i, j, true, true))
        else
          subCategoriesPanelLayout:insert(#subCategoriesPanelLayout.children+1, box.create(i, j, false, true))
        end
      end
    else
      categoriesPanelLayout:insert(#categoriesPanelLayout.children+1, box.create(i, nil, false, false))
    end
  end
end

local widget = wibox.widget {
  spacing = dpi(10),
  categoriesPanelLayout,
  subCategoriesPanelLayout,
  layout = wibox.layout.fixed.horizontal,
}

awesome.connect_signal(
  "settings::categories:setPanel",
  function(category, subcategory)
    categoriesPanelLayout:reset(categoriesPanelLayout)
    subCategoriesPanelLayout:reset(subCategoriesPanelLayout)
    categoryAdd(pages, category, subcategory)
  end
)

return {categoriesPanelLayout, subCategoriesPanelLayout}