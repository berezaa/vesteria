local loadUI = script.Parent.loadUI

if game.Players.LocalPlayer:FindFirstChild("DataLoaded") then
	loadUI.Enabled = false
else
	loadUI.Enabled = true
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
	loadUI.Load.Visible = false
	loadUI.Body.Visible = true
	loadUI.Blackout.Visible = true
	local slot = teleService:GetTeleportSetting("dataSlot")

	if accessories and type(accessories) == "string" then
		accessories = game:GetService("HttpService"):JSONDecode(accessories)
	end

	local success = network:invokeServer("loadPlayerData", slot, providedTimeStamp, accessories)
	if not success then
		warn("Failed to autoload data from teleport")
		loadUI.Load.Visible = true
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
	tween(loadUI.Blackout,{"BackgroundTransparency"},1,1)
	tween(loadUI.Body,{"Position"},UDim2.new(-1,0,0,0),1)
end






local debounce = false

local function loadfunction()
	if not debounce then
		debounce = true
		loadUI.Load.Text = "Loading..."
		local slot = 1
		local success = network:invokeServer("loadPlayerData", slot)
		if not success then
			loadUI.Load.Text = "Error!"
			wait(1)
			debounce = false
		end
		wait(0.5)
		loadUI.Load.Text = "Load Data"
	end
end

loadUI.Load.MouseButton1Click:connect(loadfunction)

spawn(function()
	wait(5)
	loadfunction()
end)

wait(1)
game.Players.LocalPlayer:WaitForChild("DataLoaded")
loadUI.Enabled = false




--https://www.roblox.com/Thumbs/Asset.ashx?width=768&height=432&assetId=2015602902