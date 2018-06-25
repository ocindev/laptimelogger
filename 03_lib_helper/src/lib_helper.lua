--[[
    Helper library for the Project Cars 2 Dedicated Server. 
]]--



LibHelper = {}



-- Recursively prints the key/value pairs of any table, additionally adds the type of each entry
function LibHelper:DeepPrint (e)
    -- if e is a table, we should iterate over its elements
    if type(e) == "table" then
        for k,v in pairs(e) do -- for every element in the table
            print("KeyType: " .. type(k))
            print("Key: " .. k)
            DeepPrint(v)       -- recursively repeat the same procedure
        end
    else -- if not, we can just print it
        print("ValueType: " .. type(e))
        print("Value: " .. e)
    end
end