return function()

local replicatedStorage 	= game:GetService("ReplicatedStorage")
	local modules = require(replicatedStorage:WaitForChild("modules"))
		local network 		= modules.load("network")
		
	
local firetime = 0

local DURATION = 300
--[[
local fireLoop = Instance.new("Sound")
fireLoop.SoundId = "rbxassetid://2564068359"
fireLoop.Looped = true
fireL

local fireIgnite = Instance.new("Sound")
fireIgnite.SoundId = "rbxassetid://2564068060"
]]

game.CollectionService:AddTag(script.Parent, "firepit")

if script.Parent:IsA("BasePart") then
	script.Parent.Anchored = true
end

local sounds = game.ReplicatedStorage:WaitForChild("sounds")
if sounds:FindFirstChild("fireLoop") then
	fireLoop = sounds.fireLoop:Clone()
	fireLoop.Parent = script.Parent
end
if sounds:FindFirstChild("fireIgnite") then
	fireIgnite = sounds.fireIgnite:Clone()
	fireIgnite.Parent = script.Parent
end

		
local function ignite(player, firepit)

	if firepit == script.Parent then
		if fireIgnite then
			fireIgnite:Play()
		end
		for i,v in pairs(script.Parent:GetChildren()) do
			pcall(function()
				v.Enabled = true
			end)
		end	
		if fireLoop then
			fireLoop:Play()
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
	if fireLoop then
		fireLoop:Stop()
	end
	game.CollectionService:AddTag(script.Parent,"interact")

end

network:create("igniteFirePit","RemoteEvent","OnServerEvent",ignite)

while wait(1) do
	if script.Parent.Fire.Enabled and os.time() - firetime > DURATION then
		dampen()
	end
end
--

	
	
end