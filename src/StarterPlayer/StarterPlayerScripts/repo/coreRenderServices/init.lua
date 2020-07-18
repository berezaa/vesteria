local Container = {} do
    for _, service in pairs(script:GetChildren()) do
        local success, contents = pcall(function()
            local module = require(service)

            if type(module) == "table" and module.init then
                --module:init()
            end;

            return module
        end)

        if success then
            Container[service.Name] = contents
        else
            warn("DEBUG:", service.Name, "has failed to load, [Error Message]: \n"..contents)
        end;
    end;
end;

function Container:Hook(tab, mod)
    return setmetatable(tab, Container[mod])
end;

return function(key)
    if not Container[key] then
        local iterations = 0

        repeat
            wait(1)
            iterations = iterations + 1
        until Container[key] or iterations > 10

        print(key, "is marked as", Container[key])

        return Container[key] 
    else
        return Container[key]
    end;
end;