-- Sample for Optional.lua

local Optional = require "Optional"
local iflet = require "iflet"

function fopen(filepath, mode) --> Optional(handler)
    return Optional(io.open(filepath, mode))
end

function fclose(handler)
    iflet (handler) (function(handler)
        io.close(handler)
    end)
end

local handler = fopen("notfound.txt", "r") -- This function fails

local content = handler:read("a") -- This operation returns Optional(nil). This operation cannot done. colon method call fails(BUG)
iflet(content)(function(content)
    print(content)
end)(function()
    print("This file was not found.")
end)

fclose(handler) -- This operation succeeds, Optional(nil) is safely closed.

handler = fopen("file.txt", "w")
handler:write("file wrote") -- This operation fails(colon method call bug)
fclose(handler)


