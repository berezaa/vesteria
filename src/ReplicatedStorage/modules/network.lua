local RunService 	= game:GetService("RunService")
local module 		= {}

local RemoteEvent 		= Instance.new("RemoteEvent")
local RemoteFunction 	= Instance.new("RemoteFunction")
local BindableEvent 	= Instance.new("BindableEvent")
local BindableFunction 	= Instance.new("BindableFunction")

local log = {}
module.log = log

local methods = {
	-- camelCase method pointers
	fireServer 		= RemoteEvent.FireServer;
	fireClient 		= RemoteEvent.FireClient;
	fireAllClients 	= RemoteEvent.FireAllClients;
--	invokeServer 	= RemoteFunction.InvokeServer;
	invokeClient 	= RemoteFunction.InvokeClient;
	fire 			= BindableEvent.Fire;
	invoke 			= BindableFunction.Invoke;
	
	-- fire for table of players
	fireClients = function(obj, players, ...)
		for i, player in pairs(players) do
			obj:FireClient(player, ...)
		end
	end;
	
	-- fire for all players but one
	fireAllClientsExcludingPlayer = function(obj, excludedPlayer, ...)
		for i, player in pairs(game.Players:GetPlayers()) do
			if player ~= excludedPlayer then
				obj:FireClient(player, ...)
			end
		end
	end;
	
	-- fire based on custom checker function
	fireAllClientsCustomCheck = function(obj, checker, ...)
		for i, player in pairs(game.Players:GetPlayers()) do
			if checker(player) == true then
				obj:FireClient(player, ...)
			end
		end
	end;
	
	-- invoke table of players and gather their responses
	invokeClients = function(obj, players, ...)
		local output = {}
		for i, player in pairs(players) do
			output[player] = obj:InvokeClient(player, ...)
		end
		
		return output
	end;
	
	-- invoke all clients and gather their responses
	invokeAllClients = function(obj, ...)
		local output = {}
		for i, player in pairs(game.Players:GetPlayers()) do
			output[player] = obj:InvokeClient(player, ...)
		end
		
		return output
	end;
	
	-- invoke all clients excluding one player and gather their responses
	invokeAllClientsExcludingPlayer = function(obj, excludedPlayer, ...)
		local output = {}
		for i, player in pairs(game.Players:GetPlayers()) do
			if player ~= excludedPlayer then
				output[player] = obj:InvokeClient(player, ...)
			end
		end
		
		return output
	end;
	
	-- invoke based on custom checker and gather their responses
	invokeAllClientsCustomCheck = function(obj, checker, ...)
		local output = {}
		for i, player in pairs(game.Players:GetPlayers()) do
			if checker(player) == true then
				output[player] = obj:InvokeClient(player, ...)
			end
		end
		
		return output
	end;
}



-- creates new remote/bindable events/functions and allows immediate connection
function module:create(objName, objClass, connection, func)
	
	local parent = script
	
	if RunService:IsServer() then
--		if objClass == "RemoteEvent" and connection == "OnServerEvent" then
--			objClass = "BindableEvent"
--			connection = "Event"
--			parent = game.ServerStorage.serverNetwork
		if objClass == "RemoteFunction" and connection == "OnServerInvoke" then
			objClass = "BindableFunction"
			connection = "OnInvoke"
			parent = game.ServerStorage.serverNetwork	
		elseif objClass == "BindableEvent" then
			parent = game.ServerStorage.serverNetwork	
		elseif objClass == "BindableFunction" then
			parent = game.ServerStorage.serverNetwork	
		end
	end	
	
	if parent:FindFirstChild(objName) == nil then

		local obj = Instance.new(objClass)
		obj.Name = objName		
						
		if connection and func then
			if objClass == "BindableEvent" or objClass == "RemoteEvent" then
				local event = obj[connection]:connect(func)
				obj.Parent = parent
				
				return obj, event
			elseif objClass == "BindableFunction" or objClass == "RemoteFunction" then
				obj[connection] = func
				obj.Parent = parent
				
				return obj
			end
		end
		
		obj.Parent = parent
	else
		local obj = parent[objName]
		if connection ~= nil and func ~= nil then
			if objClass == "BindableEvent" or objClass == "RemoteEvent" then
				local event = obj[connection]:connect(func)
				obj.Parent = parent
				
				return obj, event
			elseif objClass == "BindableFunction" or objClass == "RemoteFunction" then
				obj[connection] = func
				obj.Parent = parent
				
				return obj
			end
		end
		
		return obj
	end
end

-- connection to bindable/remote event/functions
function module:connect(objName, connection, func)
	
	local obj
	
	if RunService:IsServer() then
--		if connection == "OnServerEvent" then
--			connection = "Event"
--			obj = game.ServerStorage.serverNetwork:WaitForChild(objName)
		if connection == "OnServerInvoke" then
			connection = "OnInvoke"
			obj = game.ServerStorage.serverNetwork:WaitForChild(objName)	
		elseif connection == "Event" or connection == "OnInvoke" then
			obj = game.ServerStorage.serverNetwork:WaitForChild(objName)	
		else
			obj = script:WaitForChild(objName)
		end
	else
		obj = script:WaitForChild(objName)
	end		
	
	if obj.ClassName == "BindableEvent" or obj.ClassName == "RemoteEvent" then
		local event = obj[connection]:connect(func)
		return obj, event
	elseif obj.ClassName == "BindableFunction" or obj.ClassName == "RemoteFunction" then
		obj[connection] = func
		return obj
	end
end

local function report(objName, method)
	log[method] = log[method] or {}
	log[method][objName] = (log[method][objName] or 0) + 1
end

function module:invokeServer(objName, ...)
	report(objName, "invokeServer")
	local playerRequest = game.ReplicatedStorage:WaitForChild("playerRequest")
	if playerRequest then
		return playerRequest:InvokeServer(objName, ...)
	else
		error("playerRequest not found")
	end
end
--[[
function module:fireServer(objName, ...)
	local signal = game.ReplicatedStorage:WaitForChild("signal")
	if signal then
		return signal:FireServer(objName, ...)
	else
		error("signal not found")
	end	 
end
]]
local function main()
	-- setup primary module metatable that hooks the methods up
	setmetatable(module, {
		__index = function(self, method)
			return function(self, objName, ...)
				local parent = script
				if RunService:IsServer() and (method == "invoke" or method == "fire") then
					parent = game.ServerStorage.serverNetwork
				end
				parent:WaitForChild(objName, 60)
				report(objName, method)
--				if method == "fireClient" or method == "fireAllClients" or method == "fireServer" then
--					warn("$net",objName,method,...)
--				end
				return methods[method](parent[objName], ...)
			end
		end;
	})
end

main()

return module