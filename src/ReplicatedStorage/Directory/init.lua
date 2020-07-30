-- utility
function safeload(func)
    local success, retrieved = pcall(func)

    if not success then
        warn("ERROR MESSAGE", retrieved)
    end;

    return success, retrieved
end;

-- handler
local Directory = { _internal = game:GetDescendants() } do
    Directory.__index = Directory

    function Directory:Util()
        local _, util = safeload(function()
            require(script:WaitForChild("Utilities"))
        end)

        return util
    end;

    function Directory:Filter(file)
        local passed = true do
            if not file:IsA("ModuleScript") then
                passed = false
            end;

            if file:IsDescendantOf(script) then
                passed = false
            end;
        end;

        return passed
    end;

    function Directory:Load()
        local filterList = {}

        for _, file in ipairs(self._internal) do
            if self:Filter(file) then
                local succeeded, contents = safeload(function()
                    return require(file)
                end)

                if succeeded then
                    filterList[file.Name] = contents;
                end;
            end;
        end;

        self.utilities = self:Util()
        self._internal = filterList

        return self._internal
    end;

    function Directory:Environment()
        local env = {};

        function env:GetPlayerData(player)
            -- do shit
        end;

        return env
    end;

    function Directory:Implement(lib)
        for _, file in next, self.codebase do
            safeload(function()
                if file.init then
                    file:init(lib)
                end;
            end)
        end;

        return self
    end;

    function Directory:init()
        local table = self.utilities.Table

        local meta = table.merge(self:Environment(), Directory)
        meta.__index = meta

        local directory = setmetatable({ packages = self:Load() }, meta) do
            -- proxy
            directory:Implement({
                __index = function(self, key)
                    if directory.packages[key] then
                        return directory.packages[key]
                    else
                        return directory[key]
                    end;
                end;

                __newindex = function(self, key, value)
                    if directory.packages[key] then
                        directory.packages[key] = value
                    else
                        directory[key] = value
                    end;
                end;
            })
        end;
    end;
end;

--Directory:init()

return Directory