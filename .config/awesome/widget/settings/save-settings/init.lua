--require('widget.settings.save-settings')(settings, "/home/jeremie1001/.config/awesome/settings/init.lua")

function printTable(t, f)

  local function printTableHelper(obj, cnt)

     local cnt = cnt or 0

     if type(obj) == "table" then

        io.write("\n", string.rep("\t", cnt), "{\n")
        cnt = cnt + 1

        for k,v in pairs(obj) do

           if type(k) == "string" then
              io.write(string.rep("\t",cnt), '["'..k..'"]', ' = ')
           end

           if type(k) == "number" then
              io.write(string.rep("\t",cnt), "["..k.."]", " = ")
           end

           printTableHelper(v, cnt)
           io.write(",\n")
        end

        cnt = cnt-1
        io.write(string.rep("\t", cnt), "}")

     elseif type(obj) == "string" then
        io.write(string.format("%q", obj))

     else
        io.write(tostring(obj))
     end 
  end

  if f == nil then
     printTableHelper(t)
  else
     io.output(f)
     io.write("return")
     printTableHelper(t)
     io.output(io.stdout)
  end
end

return printTable