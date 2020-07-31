-- Master local script
local modules = {}

local player = game.Players.LocalPlayer

local PlayerScripts = script.Parent
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local directories = {ReplicatedStorage.modules, PlayerScripts.contents}

local beginInit = false

local function setup(directory)
    for _, moduleScript in pairs(directory:GetDescendants()) do
        if moduleScript:IsA("ModuleScript") then
            print("$ client", "require module", moduleScript.Name)
            modules[moduleScript.Name] = require(moduleScript)
        end
    end
end

local function initialize()
    for moduleName, module in pairs(modules) do
        if typeof(module) == "table" and (module.init and not module.__initialized) then
            print("$ client", "initialize module", moduleName)
            module.init(modules)
            module.__initialized = true
        end
    end
end

for _, directory in pairs(directories) do
    -- Get all static modules
    setup(directory)
    -- Ongoing support
    directory.DescendantAdded:connect(function(moduleScript)
        if moduleScript:IsA("ModuleScript") then
            print("$ client", "require module", moduleScript.Name)
            local module = require(moduleScript)
            modules[moduleScript.Name] = module
            if typeof(module) == "table" and module.init and beginInit then
                print("$ client", "initialize module", moduleScript.Name)
                module.init(modules)
            end
        end
    end)
end

table.sort(modules, function(module1, module2)
    return (module1.priority or 10) < (module2.priority or 10)
end)

beginInit = true
initialize()

-- Gui has to be done seperately unless we disable reloading (which is a bad idea)
-- Can't just use the DescendantAdded method either because init has to run after all requires
local function onCharacterAdded()
    setup(player.PlayerGui)
    initialize()
end

player.CharacterAdded:connect(onCharacterAdded)
local character = player.Character
if character then
    onCharacterAdded()
end
print("$ client", "all modules in queue initialized")