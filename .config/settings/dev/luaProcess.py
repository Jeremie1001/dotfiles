import ast
import re


####################################################################################
#######                       Convert Lua Table to Python                    #######
####################################################################################

##Path : to change to local when directory moved to awesome
pathSettings_XXX = "/home/jeremie1001/.config/awesome/settings/init.lua"

##Read to luaSRC
with open(pathSettings_XXX) as f:
  luaSRC = f.read()

##Parse
luaParsed = luaSRC.replace(" ","").replace("\t","").replace("\n","")
luaParsed = luaParsed[7:-2]
luaParsed = "[" + luaParsed.replace("{", "[").replace("}", "]").replace("]=", ",").replace(",]","],]").replace(",[","],[").replace("],[[",",[[") + "]]"
luaParsed = re.sub('\[([0-9]),', '["\\1",', luaParsed)
  #re = REGEX package

##Convert string to table
parsedTable = ast.literal_eval(luaParsed)


####################################################################################
#######                    Return settings values from keys                  #######
####################################################################################

##settingFinderHelper(listParam, itemParam)
  #listParam :: string : list being searched
  #itemParam :: string : key
def settingFinderHelper(listParam, itemParam):
  i=0
  for item in listParam:
    if item[0] == itemParam:
      return item[1]
    i+=1
  return None

##settingFinder(listParam, *itemParam)
  #listParam :: string : list being searched = parsedTable
  #*itemParam :: string : keys as seperate strings to each level
  #result :: string : value of key returned, ==None if key does not exist
def settingFinder(listParam, *itemParam):
  result = listParam
  for i in range(0, len(itemParam)):
    result = settingFinderHelper(result, itemParam[i])
    if result == None:
      return result
  return result


####################################################################################
#######                     Change settings value from keys                  #######
####################################################################################

##settingSetterHelper(listParam, itemParam)
  #listParam :: string : list being searched
  #itemParam :: string : key
def settingSetterHelper(listParam, itemParam):
  i=0
  for item in listParam:
    if item[0] == itemParam:
      return [i, item[1]]
    i+=1
  return None

##settingSetter(listParam, *itemParam)
  #listParam :: string : list being searched = parsedTable
  #*itemParam :: string : keys as seperate strings to each level
  #result :: string : value of key returned, ==None if key does not exist
def settingSetter(listParam, newValue, *itemParam):

  ##Obtain all nested indexes of the requested parameter
    #Return as a list of integers
    #Iterates through each level of listParam using settingSetterHelper and when a match is found records index i to indexList
    #settingSetterHelper returns index i
  indexList = []
  result = listParam
  for i in range(0, len(itemParam)):
    indexList.append(settingSetterHelper(result, itemParam[i])[0])
    result = settingSetterHelper(result, itemParam[i])[1]
    if result == None:
      return results
  
  ##Changes itemParam to newValue
    #Using i and j counters iterates to indices found in indexList
    #Once arrived changes value
    #Returns full listParam post change
  newListParam = listParam
  j=0
  for i in indexList:
    j+=1
    if j < len(indexList):
      newListParam = newListParam[i][1]
    else:
      newListParam = newListParam[i]
  newListParam[1] = newValue

  newListParam = listParam
  return newListParam

####################################################################################
#######                       Convert Python Table to Lua                    #######
####################################################################################

##settingLuaWriter(path, listParam)
  #path :: string : path to lua settings file to be written to
  #listParam :: string : list being searched = parsedTable
  #result :: string : returns back listParam parsed to lua
def settingLuaWriter(path, listParam):

  ##Change table to string
  pythonParsed = str(listParam)

  ##Parse from Python to Lua
  pythonParsed = re.sub('\[\'([0-9]+)\',', '[\\1] =' ,pythonParsed)
  pythonParsed = re.sub('\[\'([\w-]+)\',', '["\\1"] =',pythonParsed)
  pythonParsed = pythonParsed.replace("],", ",")
  pythonParsed = pythonParsed.replace("],", "},")
  pythonParsed = pythonParsed.replace("] = [", "] = {")
  pythonParsed = pythonParsed.replace("]}", ",}")
  pythonParsed = pythonParsed.replace("]]", ",}")
  pythonParsed = pythonParsed.replace("[[", "{[")
  pythonParsed = pythonParsed.replace("\'", "\"")
  pythonParsed = pythonParsed.replace(" ", "")
  pythonParsed = "return" + pythonParsed

  ##Write lua table to settings file
    #"w" write mode such as to overwrite file
  with open(pathSettings_XXX, "w") as f:
    luaSRC = f.write(pythonParsed)

  return pythonParsed



##Examples of 3 function defined in this file
  #settingFinderExample
    #settingFinder(parsedTable, "colors", "right", "clock")
  #settingSetterExample
    #parsedTable = settingSetter(parsedTable, "dracula", "theme")
  #settingLuaWriterExample 
    #settingLuaWriter(pathSettings_XXX, parsedTable)


