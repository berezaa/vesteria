local replicatedStorage = game:GetService("ReplicatedStorage")

local modules = require(replicatedStorage.modules)
local placeSetup = modules.load("placeSetup")

local resourceNodes = placeSetup.getPlaceFolder("resourceNodes")

local function getNodeFolder(name)
	local folder = resourceNodes:FindFirstChild(name)
	if not folder then
		folder = Instance.new("Folder")
		folder.Name = name
		folder.Parent = resourceNodes
	end
	return folder
end

local nodeSetupFunctions = {
	mining = function(node)
		local as = script.mining:Clone()
		as.Name = "attackableScript"
		as.Parent = node.PrimaryPart
	end,
}

local function setUpResources()
	for nodeType, func in pairs(nodeSetupFunctions) do
		local folder = getNodeFolder(nodeType)
		folder.ChildAdded:Connect(func)
		for _, node in pairs(folder:GetChildren()) do
			func(node)
		end
	end
end

setUpResources()

return {}