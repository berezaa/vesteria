
local teleService = game:GetService("TeleportService")

local sessionId = teleService:GetTeleportSetting("sessionId")
local joinTime = teleService:GetTeleportSetting("joinTime")
local telePartyInfo = teleService:GetTeleportSetting("partyInfo")

local teleportUITemplate = game.ReplicatedStorage:WaitForChild("teleportUI")
local teleportUITemplate_death = game.ReplicatedStorage:WaitForChild("teleportUIDeath")

local currentTeleportUI


local Player = game.Players.LocalPlayer

spawn(function()
	
	local existingTeleportUI = teleService:GetArrivingTeleportGui()
	if existingTeleportUI then
		existingTeleportUI.Status.Text = "Arriving..."
		
		
			repeat wait() until Player:FindFirstChild("PlayerGui")
			existingTeleportUI.Parent = Player.PlayerGui
		
		
			local replicatedStorage = game:GetService("ReplicatedStorage")
				local modules = require(replicatedStorage.modules)
					local network 	= modules.load("network")	
					local tween     = modules.load("tween")
					
			Player:WaitForChild("DataLoaded")
					
			tween(existingTeleportUI.Blackout,{"BackgroundTransparency"},1,1)
			tween(existingTeleportUI.logo,{"ImageTransparency"},1,1)	
			tween(existingTeleportUI.Description,{"TextTransparency","TextStrokeTransparency"},1,1)
			tween(existingTeleportUI.Destination,{"TextTransparency","TextStrokeTransparency"},1,1)
			tween(existingTeleportUI.Status,{"TextTransparency","TextStrokeTransparency"},1,1)
			wait(1)
			existingTeleportUI:Destroy()
		
	end
	game.ContentProvider:PreloadAsync({teleportUITemplate:WaitForChild("swoosh")})
	game.ContentProvider:PreloadAsync({teleportUITemplate:WaitForChild("gradient")})
end)

local teleporting = false



local modules = require(game.ReplicatedStorage:WaitForChild("modules"))
	local network 	= modules.load("network")
	local tween = modules.load("tween")
	local utilities = modules.load("utilities")
	
network:create("clientRequestingTeleport","BindableEvent")
network:create("forceSpawn","BindableEvent")

Player.CharacterAdded:Connect(function()
	wait()
	network:fire("forceSpawn")
end)
	


teleService.TeleportInitFailed:connect(function(player, teleportResult, errorMessage)
	if player == game.Players.LocalPlayer then
		currentTeleportUI = teleService:GetArrivingTeleportGui() or currentTeleportUI
		if currentTeleportUI then
			currentTeleportUI.Status.Text = "Teleport failed! ("..teleportResult.Name..")"
			wait(1.5)
			currentTeleportUI:Destroy()
			teleporting = false
		end
	end
end)

local preppingTeleportUI

local function prepTeleportUI(destination, teleportType)
	
	-- map to non-demo version and display that info
	local placeIdMapping = utilities.placeIdMapping
	for placeIdString, mappingId in pairs(placeIdMapping) do
		if destination == mappingId then
			destination = tonumber(placeIdString)
			break
		end
	end
	
	if preppingTeleportUI then
		return false
	end
	
	preppingTeleportUI = true
	
	if teleportType == "death" then
		local teleportUI = teleportUITemplate_death:Clone()
		teleportUI.Parent = Player.PlayerGui
		teleportUI.Enabled = true
		teleportUI.Blackout.Visible = true
		teleportUI.Blackout.BackgroundTransparency = 1
		tween(teleportUI.Blackout, {"BackgroundTransparency"}, 0, 0.5)
		teleService:SetTeleportGui(teleportUITemplate_death)
		wait(0.5)
		spawn(function()
			wait(1)
			preppingTeleportUI = false
		end)
		return teleportUI
	end
	
	
	
	teleportUITemplate.Thumbnail.Image = "https://www.roblox.com/Thumbs/Asset.ashx?width=768&height=432&assetId="..destination		

	local teleportUI = nil
	
	if not teleportUI then	
		teleportUI = teleportUITemplate:Clone()
		currentTeleportUI = teleportUI
		
		teleportUI.Blackout.BackgroundTransparency = 0
		teleportUI.Blackout.Position = UDim2.new(-1,0,0.5,0)
		
		
		teleportUI.Thumbnail.ImageTransparency = 1	
		teleportUI.gradient.ImageTransparency = 1
		
		
		teleportUI.logo.ImageTransparency = 1
		
		teleportUI.swoosh:Play()
		
		
		teleportUI.Description.TextTransparency = 1
		teleportUI.Destination.TextTransparency = 1
		teleportUI.Status.TextTransparency = 1
		
		
		tween(teleportUI.Blackout,{"Position"},UDim2.new(0,0,0.5,0),0.3)			
	end
	
	
	teleportUI.Parent = Player.PlayerGui

	
	teleportUI.Enabled = true
	
	teleService:SetTeleportGui(teleportUITemplate)
	
	local runService = game:GetService("RunService")
	
	teleportUI.spinner.Visible = true
	spawn(function()
		while teleporting do
			teleportUI.spinner.Rotation = teleportUI.spinner.Rotation + 2
			runService.RenderStepped:wait()
		end
	end)
	
	local preloadDone
	local infoDone
	
	spawn(function()
		teleportUI.Status.Text = "Loading..."
		wait(0.3)
		
		tween(teleportUI.Status,{"TextTransparency"},0,0.5)
	end)
	
	
	
	spawn(function()
		game.ContentProvider:PreloadAsync({teleportUI.logo, teleportUI.Thumbnail})
		preloadDone = true
	end)
	
	local info
	
	spawn(function()
		info = game.MarketplaceService:GetProductInfo(destination,Enum.InfoType.Asset	)
		infoDone = true
	end)
	
	local start = tick()
	repeat wait() until preloadDone and infoDone or (tick() - start > 10)
	
	local dif = tick() - start
	if dif < 0.3 then
		wait(0.3 - dif)
	end
	
	teleportUI.gradient.ImageTransparency = 0
	teleportUI.Thumbnail.UIScale.Scale = 1
	
	
	tween(teleportUI.logo,{"ImageTransparency"},0,0.7)
	tween(teleportUI.Thumbnail,{"ImageTransparency"},0,1)
	tween(teleportUI.Thumbnail.UIScale,{"Scale"}, 1.05, 1)
	tween(teleportUI.Description,{"TextTransparency"},0,0.5)
	tween(teleportUI.Destination,{"TextTransparency"},0,0.5)
	
	
	
	if info then
		teleportUI.Destination.Text = info.Name
		teleportUI.Description.Text = info.Description
		teleportUI.Status.Text = "Preparing to travel..."
		
		teleportUITemplate.Destination.Text = info.Name
		teleportUITemplate.Description.Text = info.Description
		teleportUITemplate.Status.Text = "Traveling to location..."	
		teleService:SetTeleportGui(teleportUITemplate)	
	else
		teleportUI.Status.Text = "Can't find travel info"
		teleportUITemplate.Status.Text = "Can't find travel info"
	end	
	spawn(function()
		wait(1)
		preppingTeleportUI = false
	end)
	
	
	return teleportUI
end

network:connect("signal_teleport", "OnClientEvent", prepTeleportUI)



local function teleportTo(placeId)

	local Player = game.Players.LocalPlayer
	local teleService = game:GetService("TeleportService")
	if Player:FindFirstChild("AnalyticsSessionId") then
		teleService:SetTeleportSetting("sessionId",Player.AnalyticsSessionId.Value)
	end
	if Player:FindFirstChild("JoinTime") then
		teleService:SetTeleportSetting("joinTime",Player.JoinTime.Value)
	end		

	local teleportUI = prepTeleportUI(placeId)	
	
	wait(0.5)
	teleportUI.Status.Text = "Traveling to location..."				
	wait(0.5)
	teleportUI.Body.Position = UDim2.new(0,0,0,0)
	teleportUI.Blackout.BackgroundTransparency = 0
	
	game.GuiService.SelectedObject = nil
	
	teleService:Teleport(placeId,nil,nil,teleportUI)	
end

network:create("teleportPlayerTo","BindableFunction","OnInvoke",teleportTo)

local currentPartyInfo

local function updateTeleportPart(teleportPart)
	if currentPartyInfo then
		teleportPart.CanCollide = true
		if not game.CollectionService:HasTag(teleportPart, "interact") then
			game.CollectionService:AddTag(teleportPart, "interact")
		end			
	else
		teleportPart.CanCollide = false
		if game.CollectionService:HasTag(teleportPart, "interact") then
			game.CollectionService:RemoveTag(teleportPart, "interact")
		end
	end	
end

local function prepDataForTeleport(destination)
						
	local teleportUI = prepTeleportUI(destination)
	
	local starttime = os.time()
	
	local analyticsSessionId
	if Player:FindFirstChild("AnalyticsSessionId") then
		analyticsSessionId = Player.AnalyticsSessionId.Value
	end
	
	local joinTime 
	if Player:FindFirstChild("JoinTime") then
		joinTime = Player.JoinTime.Value
	end
	
	local dataSlot = Player:FindFirstChild("dataSlot") and Player.dataSlot.Value or 1
	
	local TimeStamp = network:invokeServer("saveDataForTeleportation")
	if TimeStamp then
		
			
		if analyticsSessionId then
			teleService:SetTeleportSetting("sessionId",analyticsSessionId)
		end
		
		if joinTime then
			teleService:SetTeleportSetting("joinTime",joinTime)
		end							
				
		teleService:SetTeleportSetting("lastTimeStamp",TimeStamp)
		teleService:SetTeleportSetting("arrivingTeleportId", game.PlaceId)					
		
		teleService:SetTeleportSetting("dataSlot",dataSlot)

		teleportUI.Status.Text = "Traveling to location..."
		
		local difference = os.time() - starttime
		if difference <= 1 then
			wait(1-difference)
		end				
		
		teleportUI.Blackout.BackgroundTransparency = 0
		
		game.GuiService.SelectedObject = nil
		
		wait()	
	end
	
	return TimeStamp, teleportUI
	
end	

local function externalTP(destination)
	if Player:FindFirstChild("DataLoaded") == nil or Player:FindFirstChild("teleporting") or teleporting then
		return false
	end	
	
	teleporting = true
	
	local Timestamp, teleportUI = prepDataForTeleport(destination)
	if Timestamp then					
		teleService:Teleport(destination,nil,nil,teleportUI)
	else
		-- failed to save data, abort teleportation	
	end	
end

network:connect("externalTeleport", "OnClientEvent", externalTP)


network:create("localPrepareForTeleport", "BindableFunction", "OnInvoke", function(destination)
	teleporting = true
	
	local teleportUI = prepTeleportUI(destination)
end)

local function activate(teleportPart)

	updateTeleportPart(teleportPart)

	local destination = teleportPart:WaitForChild("teleportDestination").Value
	
	local db = false
	
	teleportPart.Touched:connect(function(hit)


		
		if Player:FindFirstChild("DataLoaded") == nil or Player:FindFirstChild("teleporting") then
			return false
		end
		if Player.Character and hit == Player.Character.PrimaryPart and (Player.Character.PrimaryPart.Position - teleportPart.Position).magnitude < 50 then
			
			
			if db then
				return false
			end
			
			local inParty = currentPartyInfo ~= nil
			local isForced = teleportPart:FindFirstChild("forced") and teleportPart.forced.Value
			
			if inParty and (not isForced) then
				network:fire("applyJoltVelocityToCharacter", teleportPart.CFrame.lookVector * 5)
				return
			end
			
			if not teleporting then
				teleporting = true
				local teleportUI = prepTeleportUI(destination)
				local success, fail = network:invokeServer("playerRequest_useTeleporter", teleportPart)
				if success then
				else
					teleportUI:Destroy()
					teleporting = false
				end
			end		
		end
	end)
end

local parts = game.CollectionService:GetTagged("teleportPart")
game.CollectionService:GetInstanceAddedSignal("teleportPart"):connect(activate)

for i,part in pairs(parts) do
	spawn(function()
		activate(part)
	end)
end

game.ReplicatedStorage.ChildAdded:Connect(function(Child)
	if Child.Name == "spawnPoints" then

		network:fire("forceSpawn")
	end
end)

local function getPartyLeaderUserId(partyInfo)
	for i,member in pairs(partyInfo.members) do
		local player = member.player
		if player and member.isLeader then
			return player.userId
		end 
	end
end

local function updatePartyInfo(partyInfo)
	
	partyInfo = partyInfo or network:invokeServer("playerRequest_getMyPartyData")
	currentPartyInfo = partyInfo
	

	for i,teleportPart in pairs(game.CollectionService:GetTagged("teleportPart")) do
		updateTeleportPart(teleportPart)
	end
	
	if partyInfo and partyInfo.teleportState == "teleporting" and not teleporting then
		network:invoke("setCharacterArrested",true)
		
		local partyTeleportInfo = {party_guid = partyInfo.guid; partyLeaderUserId = getPartyLeaderUserId(partyInfo)}
		teleService:SetTeleportSetting("partyInfo", partyTeleportInfo)

		if not currentPartyInfo.teleportDestination then
			error("AHHHHHH PANIC NO TELEPORT DESTINATION WHY HAVE YOU FORSAKEN ME LIKE THIS")
		end


		teleporting = true
		
		local teleportUI = prepTeleportUI(currentPartyInfo.teleportDestination)
		
		network:fireServer("signal_playerReadyToGroupTeleport")

		--[[

		local Timestamp, teleportUI = prepDataForTeleport(currentPartyInfo.teleportDestination)
		if Timestamp then					
		
			
			
		else
			-- failed to save data, abort teleportation	
		end
		
		]]

	end

end

updatePartyInfo()
network:connect("signal_myPartyDataChanged", "OnClientEvent", updatePartyInfo)


-- super hacky but so are humanoids so sue me
for i=1,3 do
	wait()
	network:fire("forceSpawn")
end

-- wait for data to report analytics
Player:WaitForChild("DataLoaded", 60)

-- Begin analytics setup


if sessionId and joinTime then
	network:invokeServer("requestContinueSession",sessionId,joinTime)
else
	network:invokeServer("requestNewSession")
end
