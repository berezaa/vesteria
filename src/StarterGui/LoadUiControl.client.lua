if game.Players.LocalPlayer:FindFirstChild("DataLoaded") then
	script.Parent.Enabled = false	
else
	script.Parent.Enabled = true
end

local replicatedStorage = game:GetService("ReplicatedStorage")
	local modules = require(replicatedStorage.modules)
		local network 	= modules.load("network")
		local tween		= modules.load("tween")




local teleService = game:GetService("TeleportService")

local teleportData = teleService:GetLocalPlayerTeleportData() or {}

local arrivingFrom = teleportData.arrivingFrom
local providedTimeStamp = teleportData.dataTimestamp 
local accessories = teleportData.playerAccessories

if arrivingFrom then
	script.Parent.Load.Visible = false
	script.Parent.Body.Visible = true
	script.Parent.Blackout.Visible = true
	local slot = teleService:GetTeleportSetting("dataSlot")

	if accessories and type(accessories) == "string" then
		accessories = game:GetService("HttpService"):JSONDecode(accessories)
	end
	
	local success = network:invokeServer("loadPlayerData", slot, providedTimeStamp, accessories)		
	if not success then
		warn("Failed to autoload data from teleport")
		script.Parent.Load.Visible = true
	end
	

	local rand = Random.new(os.time())

	local arrivedFrom = arrivingFrom
	
	--[[
	local function spawnPlayer()
		repeat wait() until game.Players.LocalPlayer.Character
		local root = game.Players.LocalPlayer.Character.PrimaryPart
		if arrivedFrom then
			local parts = game.CollectionService:GetTagged("teleportPart")
			for i,part in pairs(parts) do
				if part:FindFirstChild("teleportDestination") and part.teleportDestination.Value == arrivedFrom then
					local target = part.CFrame
					local disp = part.CFrame.lookVector * 30
					root.CFrame = target + disp + Vector3.new(rand:NextNumber() * 4, 0, rand:NextNumber() * 4)
					return true
				end
				
			end
		end
	end
	
	spawn(spawnPlayer)	
	]]
	wait(1.5)
	tween(script.Parent.Blackout,{"BackgroundTransparency"},1,1)
	tween(script.Parent.Body,{"Position"},UDim2.new(-1,0,0,0),1)
end 





		
local debounce = false		

local function loadfunction()
	if not debounce then
		debounce = true
		script.Parent.Load.Text = "Loading..."
		local slot = 1
		local success = network:invokeServer("loadPlayerData", slot)
		if not success then
			script.Parent.Load.Text = "Error!"
			wait(1)
			debounce = false
		end
		wait(0.5)		
		script.Parent.Load.Text = "Load Data"
	end
end
		
script.Parent.Load.MouseButton1Click:connect(loadfunction)

spawn(function()
	wait(5)
	loadfunction()
end)

wait(1)
game.Players.LocalPlayer:WaitForChild("DataLoaded")
script.Parent.Enabled = false




--https://www.roblox.com/Thumbs/Asset.ashx?width=768&height=432&assetId=2015602902