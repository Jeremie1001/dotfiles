import ast
import re

pathSettings_XXX = "/home/jeremie1001/.config/awesome/settings/init.lua"

with open(pathSettings_XXX) as f:
    luaSRC = f.read()[9:-3]

luaParsed = luaSRC.replace("{", "[").replace("}", "]").replace("] =", ",").replace(",\n","],\n")
luaParsed = "[" + luaParsed.replace(" ","").replace("\t","").replace("\n","") + "]]"
luaParsed = re.sub('([0-9]),', '"\\1",', luaParsed)

parsedTable = ast.literal_eval(luaParsed)

def settingFinderHelper(listParam, itemParam):
  i=0
  for item in listParam:
    if item[0] == itemParam:
      return item[1]
    i+=1
  return None

def settingFinder(listParam, *itemParam):
  result = listParam
  for i in range(0, len(itemParam)):
    result = settingFinderHelper(result, itemParam[i])
    if result == None:
      return result
  return result

print(settingFinder(parsedTable, "default_programs", "email"))
