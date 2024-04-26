--- This folder includes file for background used in the background of the to do panel processing

-- todo.json has task written in json format
  -- date keys: follow a 'aYYYYMMDD' format
    -- The starting 'a' is added since json key must be a string
  -- Other keys
    -- title: title of the task
    -- description: description of the task
    -- status: 0 if not completed yet, 1 if completed

-- practicecode.lua
  -- Lua testing code used in a lua compiler used during development of the json processing code
  -- Includes:
    -- json.lua library file
    -- Block of code for inserting new events into json (not added to configs yet)
    -- Block of code for reading all events, their title and descriptions resctively for a given 