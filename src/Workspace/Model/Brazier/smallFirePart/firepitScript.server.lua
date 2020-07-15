
local replicatedStorage 	= game:GetService("ReplicatedStorage")
	local modules = require(replicatedStorage:WaitForChild("modules"))
		local network 		= modules.load("network")
		
	
local firetime = 0

		
local function ignite(player, firepit)
	if firepit == script.Parent then
		for i,v in pairs(script.Parent:GetChildren()) do
			pcall(function()
				v.Enabled = true
			end)
		end	
		game.CollectionService:RemoveTag(script.Parent,"interact")
		firetime = os.time()
	end
	

	
end

local function dampen()
	for i,v in pairs(script.Parent:GetChildren()) do
		pcall(function()
			v.Enabled = false
		end)
	end
	game.CollectionService:AddTag(script.Parent,"interact")

end

network:create("ignireFirePit","RemoteFunction","OnServerInvoke",ignite)

while wait(1) do
	if script.Parent.Fire.Enabled and os.time() - firetime > 30 then
		dampen()
	end
end

