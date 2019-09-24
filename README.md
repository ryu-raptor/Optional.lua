# Optional.lua
Introduces an Optional type to Lua.

## Sample
~~~
local Optional = require "Optional"
local iflet = require "iflet"

function fopen(filepath, mode) --> Optional(handler)
    return Optional(io.open(filepath, mode))
end

function fclose(handler)
    iflet (handler) (function(handler) -- if given handler is not Optional(nil) then closes the file.
        io.close(handler)
    end)
end

local handler = fopen("notfound.txt", "r") -- This function fails internally and returns Optional(nil)

local content = handler:read("a") -- This method call also fails and returns Optional(nil)
iflet(content)(function(content) -- Check wether content is not Optional(nil) then unwrap content and do things.
    print(content)
end)(function()
    print("This file was not found.")
end)

fclose(handler) -- This operation succeeds, Optional(nil) is safely closed.

handler = fopen("file.txt", "w")
handler:write("file wrote") -- This operation fails(colon method call bug)
fclose(handler)
~~~
