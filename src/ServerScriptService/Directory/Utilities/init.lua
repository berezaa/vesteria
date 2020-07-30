function safeload(func)
    local success, retrieved = pcall(func)

    if not success then
        warn("ERROR MESSAGE", retrieved)
    end;

    return success, retrieved
end;

local Container = {} do
    for _, mod in pairs(script:GetChildren()) do
        if mod:IsA("ModuleScript") then
            local success, contents = safeload(function()
                return require(mod)    
            end)

            if success then
                Container[mod.Name] = contents;
            end;
        end;
    end;
end;

return Container