-- 10_MinuteAdRevenue
-- 7/27/2020

--[[
    Implementation Example:

    local import = require(game.ReplicatedStorage:WaitForChild("Import"))



    -- [ SINGLE EXAMPLE ] --
    local SomeModule = import "Module"

    -- [ NESTED EXAMPLE ] --
    local SomeModule = import "Folder/Module"

    --[ INSTANCE EXAMPLE ] --
    local SomeModule = import(ModuleScript) 

    -- [ FULL TREE EXAMPLE ] --
    local SomeModule = import("Folder/Module", true)


    -- [ OTHER USAGE ] --
    local require = import

    require("Folder/Module") or require("Module") or require(ModuleScript)



    "Full Branch" Hierarchy:
    {
        contents = require(instance),
        instance = instance,
        details = {
            path = path, --string, ex: "file", "folder/file"
            ancestor = ancestor -- this is the "container" (example: ReplicatedStorage)
        }
    }
]]

local Map = require(script:WaitForChild("Map"))

local Directory = { Loaded = {} } do
    Directory.__index = Directory

    function Directory.new(container)
        return setmetatable({Container = container}, Directory)
    end;

    function Directory:Implement(tree, meta)
        tree.__index = tree

        local newFile = setmetatable(tree, meta or {})

        Directory.Loaded[newFile.details.path] = tree 
    end;

    function Directory:Request(path, getFullContents)
        local function getFile()
            if self.Loaded[path] then
                if getFullContents then
                    return self.Loaded[path]
                else
                    return self.Loaded[path].contents
                end;
            end;
        end;

        return getFile() or error("Unable to find file from path:", path)
    end;

    function Directory:Pull(path, presetContainer)
        local container = presetContainer or self.Container

        local file = container do
            local fileTree = string.split(path, "/")

            for _, fileName in pairs(fileTree) do
                file = file:WaitForChild(fileName)
            end;
        end;

        return file, container
    end;

    function Directory:Load(path, container)
        local branch = (function(dir)
            local mod, ancestor = self:Pull(dir, container)

            local success, contents = pcall(function()
                return {
                    contents = require(mod),
                    instance = mod,
                    details = {
                        path = path,
                        ancestor = ancestor
                    }
                };
            end)

            return (success and contents) or warn("Failed to load module:", mod:GetFullName(), contents)
        end)(path)

        if branch then
            return branch
        end;
    end;

    function Directory:init()
        if Map then
            for _, hardcode in pairs(Map) do
                local newDirectory = Directory.new(hardcode.container)

                for _, path in next, hardcode.map do
                    local branch = newDirectory:Load(path)

                    if branch then
                        --local metatable = {}
                        self:Implement(branch) --, metatable)
                    else
                        warn(path, "Could not be preloaded into import")
                    end;
                end;
            end;
        end;
    end;
end;

Directory:init()

return function(dir, full)
    local safeload = function(path, fullContents)
        return pcall(function()
            return (typeof(path) == "string" and Directory:Request(path, fullContents)) or 
                (path:IsA("ModuleScript") and require(path)) or
                    error("Couldn't import from:", path)
        end)
    end;

    local success, file = safeload(dir, full)

    return (success and file) or nil
end;