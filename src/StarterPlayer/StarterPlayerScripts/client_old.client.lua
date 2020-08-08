script.Parent:WaitForChild("assets")

_G.print = function(...)
	if game.PlaceId == 2061558182 then
		print(...)
	end
end

local priorityServices = {"animationInterface", "entityRenderer", "playerDataPropogationCache"}

local services 		= script.Parent:WaitForChild("repo")

local replicatedStorage = game:GetService("ReplicatedStorage")
	local modules = require(replicatedStorage.modules)
		local network = modules.load("network")
		

local function onGetPlayerService(serviceName)
	return require(services[serviceName])
end

local function main()

	network:create("getPlayerService", "BindableFunction", "OnInvoke", onGetPlayerService)
	
	
	local servicesTable = {}
	
	for i,serviceName in pairs(priorityServices) do
		local module = services:FindFirstChild(serviceName)
		if module then
			local service
			local Success, Error = pcall(function()
				service = require(module)
			end)
			
			if not Success then
				warn("client service "..module.Name.." failed to load!")
				warn(Error)
			end	
			servicesTable[serviceName] = service		
		end
	end
	
	-- initiate all regular services in client folder
	for i, module in pairs(services:GetChildren()) do
		if module:IsA("ModuleScript") and not servicesTable[module.Name] then
			local service
			local Success, Error = pcall(function()
				service = require(module)
			end)
			
			if not Success then
				warn("client service "..module.Name.." failed to load!")
				warn(Error)
			end
			servicesTable[module.Name] = service
		end
	end
end

main()

local StarterGui = game:GetService("StarterGui")