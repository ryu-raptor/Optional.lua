-- Constructor
local function Optional(instance, parentTable)
    local optionalObject = {}
    -- Add fix for Optional method call.
    local metatable = {
        type = "Optional",
        instance = instance,
        __index = function(table, key)
            if not instance then return Optional(nil)
            else return Optional(instance[key], optionalObject) end
        end, 
        __call = function(func, ...)
            if not instance then return Optional(nil)
            else
                -- check method call
                local args = {...}
                if parentTable == args[1] then
                    -- unwapping optional method self
                    local t = getmetatable(args[1])
                    args[1] = t.instance
                    return Optional(instance(table.unpack(args)))
                end
                return Optional(instance(...))
            end
        end,
        __tostring = function(v)
            local description = instance
            if not description then description = "nil" end
            return "Optional("..tostring(description)..")"
        end
    }
    setmetatable(optionalObject, metatable)

    return optionalObject
end

return Optional

