import gi
import os

gi.require_version("Gtk", "3.0")
from gi.repository import Gtk
from gi.repository import Gdk

from dev.luaProcess import parsedTable,settingFinder,settingSetter,settingLuaWriter,pathSettings_XXX

####################################################################################
#######                Find scheme variable from settings file               #######
####################################################################################

##Find active scheme according to theme variable in settings file at startup
activeScheme = "new"
if settingFinder(parsedTable, "theme") != None:
  activeScheme = settingFinder(parsedTable, "theme")

##Available schemes path : to change to local when directory moved to awesome
path_XXX = "/home/jeremie1001/.config/awesome/themes/schemes"

##Available schemes
schemeList = os.listdir(path_XXX)

##Order available schemes such that active scheme is in index 0
  #Index 0 will be the default scheme in scheme stack
schemeList.pop(schemeList.index(activeScheme + ".lua"))
schemeList.insert(0,activeScheme + ".lua")


####################################################################################
#######                             Color Buttons                            #######
####################################################################################

##Active scheme colors path : to change to local when directory moved to awesome
pathActiveScheme_XXX = "/home/jeremie1001/.config/awesome/themes/schemes/"+activeScheme+".lua"

##Read all colors into list
with open(pathActiveScheme_XXX) as f:
    content = f.read().splitlines()

##Color Buttons stack to switch between schemes
colorButtonsStack = Gtk.Stack()
colorButtonsStack.set_hexpand(False)
colorButtonsStack.set_vexpand(True)

##Save scheme to file
def saveScheme(self, widget, path, listParam, activeSchemeVar):
  if activeSchemeVar == "new":
    return
  listParam = settingSetter(listParam, activeSchemeVar, "theme")
  settingLuaWriter(path, listParam)

##Add all color Buttons
  #For loop through all available schemes
    #Parse lua button code into labels for colors 1-8 + A,B & usable hex code
    #Create color button with hex code string using GDK library
    #Attach each to grid
    #Add grid to stack of available schemes
    #Save scheme to file
for schemeItem in schemeList:
  schemeItemLabel = schemeItem.replace(".lua", "")
  pathScheme_XXX = "/home/jeremie1001/.config/awesome/themes/schemes/"+schemeItemLabel+".lua"
  with open(pathScheme_XXX) as f:
    schemeContentRaw = f.read().splitlines()
  colorButtonsGrid = Gtk.Grid()
  i=0
  for schemeContentRawLine in schemeContentRaw:
    if schemeContentRawLine.replace(" ", "").startswith('color'):
      colorButtonsGrid.attach(Gtk.Label(schemeContentRawLine[2:9]), 0, i, 1, 1)
      colorButton = Gtk.ColorButton.new_with_color(Gdk.color_parse(schemeContentRawLine[-9:-2]))

      colorButtonsGrid.attach(colorButton, 1, i, 1, 1)
      i+=1

  colorButtonsStack.add_named(colorButtonsGrid, schemeItemLabel)

  saveSchemeButton = Gtk.Button()
  saveSchemeButton.set_label("Save Scheme")

  colorButtonsGrid.attach(saveSchemeButton, 0, i, 2, 1)

  saveSchemeButton.connect("clicked", saveScheme, saveSchemeButton, pathSettings_XXX, parsedTable, schemeItemLabel)


colorButtonsGrid = Gtk.Grid()
labelsList = ["ColorA","ColorB","Color1","Color2","Color3","Color4","Color5","Color6","Color7","Color8"]
i=0
for labelsItem in labelsList:
    colorButtonsGrid.attach(Gtk.Label(labelsItem), 0, i, 1, 1)
    colorButton = Gtk.ColorButton.new_with_color(Gdk.color_parse("#000000"))

    colorButtonsGrid.attach(colorButton, 1, i, 1, 1)
    i+=1
colorButtonsStack.add_named(colorButtonsGrid, "new")

saveSchemeButton = Gtk.Button()
saveSchemeButton.set_label("Save Scheme")
colorButtonsGrid.attach(saveSchemeButton, 0, i, 2, 1)


####################################################################################
#######                       Generate Schemes Combo Box                     #######
####################################################################################

##Label for combo box
themeLabel = Gtk.Label("Theme")

##Combo box
themeComboBox = Gtk.ComboBoxText()

##Add available schemes to combo box, and "new" option
  #Combo box items label == text
for schemeItem in schemeList:
  themeComboBox.append(schemeItem.replace(".lua", ""),schemeItem.replace(".lua", ""))
themeComboBox.append("new","(new scheme)")

##changeActiveComboBox(self, widget, stack, submenu)
  #widget :: Gtk.Widget() : Widget being signaled to
  #stack :: Gtk.Stack() : Stack being updated
  #return :: Bool : Boolean indicating if stack was changed
def stackSelector(self, widget, stack):
  stack.set_visible_child_name(widget.get_active_id())
  ##### NEED TO CHANGE PARSED TABLE ACTIVE VARIABLE HERE
  #settingSetter(parsedTable, widget.get_active_id(), "bar", "colors", "focused")

##Combo box signal statement that updates color buttons stack
themeComboBox.connect("changed", stackSelector, themeComboBox, colorButtonsStack)

##Change combo box to active scheme
themeComboBox.set_active_id(activeScheme)


####################################################################################
#######                           New Theme Creator                          #######
####################################################################################


####################################################################################
#######                            Save as button                            #######
####################################################################################


####################################################################################
#######                          Final page creation                         #######
####################################################################################

##Page box
colors = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=1)

##Overall page grid
colorsGrid = Gtk.Grid()
colors.add(colorsGrid)

##Attach all items to grid to grid
colorsGrid.attach(themeLabel, 0, 0, 1, 1)
colorsGrid.attach(themeComboBox, 1, 0, 1, 1)
colorsGrid.attach(colorButtonsStack, 0, 1, 2, 1)
