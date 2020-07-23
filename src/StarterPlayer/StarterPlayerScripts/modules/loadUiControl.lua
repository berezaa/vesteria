return function()

spawn(function()
	script.Parent:WaitForChild("blackout")
	script.Parent.blackout.Visible = true
	script.Parent.blackout.BackgroundTransparency = 0
end)

local customizeTable

local runService = game:GetService("RunService")

local loading = true
local loadingassets = true
--[[
spawn(function()
	script.Parent:WaitForChild("spinner")
	while loading do
		script.Parent.spinner.Rotation = script.Parent.spinner.Rotation + 2
		runService.RenderStepped:wait()
	end
	script.Parent.spinner.Visible = false
end)
]]

local assets = game.ReplicatedStorage:WaitForChild("assets")

local function loadassets()
	local contentProvider 	= game:GetService("ContentProvider")
	local teleService		= game:GetService("TeleportService")

	-- no need to load assets if you are arriving from a teleport
	local arrivingFrom = teleService:GetTeleportSetting("arrivingTeleportId")
	if arrivingFrom and (arrivingFrom ~= 2015602902 and arrivingFrom ~= 2376885433) then
		return false
	end

	local contentList = {}

	table.insert(contentList, game.ReplicatedStorage:WaitForChild("characterAnimations"))
	table.insert(contentList, assets:WaitForChild("sounds"))
	table.insert(contentList, game:GetService("StarterGui"))
--	table.insert(contentList, game.ReplicatedStorage:WaitForChild("itemData"))
--	table.insert(contentList, game.ReplicatedStorage:WaitForChild("abilityLookup"))
	table.insert(contentList, assets:WaitForChild("accessories"))

	spawn(function()
		script.Parent.spinner.Visible = true
		local maxQueueSize = contentProvider.RequestQueueSize
		while loadingassets do
			local queueSize = contentProvider.RequestQueueSize
			if queueSize > maxQueueSize then
				maxQueueSize = queueSize
			end

			local loadedAssetCount = maxQueueSize - queueSize

--			contents.value.Text = tostring(loadedAssetCount) .. "/" .. tostring(maxQueueSize)

			script.Parent.spinner.Rotation = script.Parent.spinner.Rotation + 2
			runService.RenderStepped:wait()
		end
	end)

	-- make sure the loading UI is loaded in
	contentProvider:PreloadAsync({script.Parent})

	contentProvider:PreloadAsync(contentList)


	script.Parent.spinner.Image = "rbxgameasset://accept"
	script.Parent.spinner.ImageColor3 = Color3.fromRGB(132, 255, 98)
	script.Parent.spinner.Rotation = 0
	script.Parent.blackout.BorderColor3 = Color3.fromRGB(132, 255, 98)

	loadingassets = false
end

wait()

local player = game.Players.LocalPlayer
local rank = player:GetRankInGroup(4238824)
local isAdmin = true--rank >=5 or player:IsInGroup(5018342)
local isLegend = rank >= 2

if not isAdmin then
	script.Parent.menustatus.Text = "The game is currently closed. Please come back another time."
	return false
end

script.Parent.blackout.TextLabel.Visible = false

spawn(loadassets)

script.Parent.menustatus.Text = "Loading game files..."

local replicatedStorage = game:GetService("ReplicatedStorage")
local modules = require(replicatedStorage.modules)
local network = modules.load("network")
local levels = modules.load("levels")
local tween = modules.load("tween")
local configuration = modules.load("configuration")
local utilities = modules.load("utilities")
local money = require(script.Parent.money)

local deathScreen = require(script.Parent.deathScreen.deathScreen)

deathScreen.init({network = network, levels = levels, tween = tween, utilities = utilities, money = money })

--local isAdmin = game.Players.LocalPlayer:GetRankInGroup(4238824) >=3 or game.Players.LocalPlayer:IsInGroup(5018342)

local isAdmin = true--game.Players.LocalPlayer:GetRankInGroup(4238824) >=5
if not isAdmin then
	wait(5)
	script.Parent.main.Visible = false
	script.Parent.landing.Visible = false
	script.Parent.leftBar.Visible = false
	wait(1)
	tween(script.Parent.blackout, {"BackgroundTransparency"},{1},3 )
	script.Parent.menustatus.Text = "The game is currently closed. Please check back later."
	return false
end

script.Parent.menustatus.Text = "Loading data from server..."

local globalDataSuccess, globalDataFromServer = network:invokeServer("loadGame")

local globalData
if globalDataSuccess then
	globalData = globalDataFromServer
else
	script.Parent.menustatus.Text = "Failed to load data."
	wait(3)
end

loading = false

script.Parent.Notice.Visible = false
script.Parent.menustatus.Visible = false
script.Parent.blackout.Visible = true
script.Parent.blackout.TextLabel.Visible = false
--script.Parent.Enabled = true
script.Parent.landing.Visible = false
script.Parent.customize.Visible = false
script.Parent.main.Visible = false
script.Parent.onlineFriends.Visible = false
script.Parent.main.Frame.PlayButton.Visible = false

local input = require(script.Parent:WaitForChild("input"))

if input.mode.Value == "xbox" or game:GetService("UserInputService").GamepadEnabled then
	game.GuiService.GuiNavigationEnabled = true
	game.GuiService.AutoSelectGuiEnabled = true
	game.GuiService.SelectedObject = script.Parent.landing.play
end

local blur
local mainCharacter

-- scan for friends every minute
spawn(function()
	local friendsTag = {}
	while true do
		--print("!!getting friends")
		local friendInfo
		local success, fail = pcall(function()
			friendInfo = game.Players.LocalPlayer:GetFriendsOnline()
		end)
		if success then
			--print("!!starting Handshake")
			local friendsInfo = network:invokeServer("fetchPlayerFriendsInfo", friendInfo)
			--print("!!finished handshake",#friendsInfo)
			if friendsInfo then
				for i,tag in pairs(friendsTag) do
					if tag then
						tag:Destroy()
					end
				end
				friendsTag = {}
				for i,friend in pairs(friendsInfo) do
					local tag = script.Parent.onlineFriends.SampleFriend:Clone()
					tag.username.Text = friend.UserName
					tag.location.Text = friend.LastLocation
					tag.thumbnail.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=".. friend.VisitorId .."&width=100&height=100&format=png"
					tag.Parent = script.Parent.onlineFriends
					tag.Visible = true
					table.insert(friendsTag,tag)
				end
				script.Parent.onlineFriends.title.Visible = false
				if #friendsTag > 0 then
					script.Parent.onlineFriends.title.Visible = true
				end
			end
			--print("!!Finished logic")
			wait(30)
		else
			warn("GetOnlineFriends failed!")
			wait(10)
		end
	end
end)


function noticeskip()
	script.Parent.Notice.Visible = false
	script.Parent.main.Visible = true
	spawn(function()
		local serverMessage = require(script.Parent.main.serverMessage.serverMessage)
		serverMessage.init()
	end)
	script.Parent.onlineFriends.Visible = true

	if input.mode.Value == "xbox" then
		game.GuiService.GuiNavigationEnabled = true
		game.GuiService.SelectedObject = input.getBestButton(script.Parent.main.Frame)
	end

--	network:invoke("lockCameraPosition",script.Parent.CameraMainPos.Value,0.5)
--	if blur then
--		tween(blur, {"Size"}, 0, 0.5)
--	end
end


function land()
	script.Parent.landing.Visible = false
	game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
	game.StarterGui:SetCore("ChatBarDisabled", false)
	game.StarterGui:SetCore("ChatActive", true)
	game.StarterGui:SetCore("ChatWindowPosition", UDim2.new(0.7,-10,0.7,-30))
	script.Parent.Notice.Visible = true
	noticeskip()

	if input.mode.Value == "xbox" then
		game.GuiService.GuiNavigationEnabled = true
		game.GuiService.SelectedObject = input.getBestButton(script.Parent.Notice)
	end
end

land()

script.Parent.Notice.ok.MouseButton1Click:connect(noticeskip)
game.Players.LocalPlayer.PlayerGui:SetTopbarTransparency(1)
--game:GetService("StarterGui"):SetCore("TopbarEnabled", false)

local function updateInputMode()
	if input.mode.Value == "xbox" then
		script.Parent.customize.buttons.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		script.Parent.customize.shirtColor.UIGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		script.Parent.customize.hairColor.UIGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		script.Parent.customize.hairColor.Position = UDim2.new(0.5,0,0,90)
		script.Parent.customize.hairColor.AnchorPoint = Vector2.new(0.5,0)
		script.Parent.customize.shirtColor.Position = UDim2.new(0.5,0,0,90)
		script.Parent.customize.shirtColor.AnchorPoint = Vector2.new(0.5,0)
	else
		script.Parent.customize.buttons.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
		script.Parent.customize.shirtColor.UIGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
		script.Parent.customize.hairColor.UIGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
		script.Parent.customize.hairColor.Position = UDim2.new(0,5,0,90)
		script.Parent.customize.hairColor.AnchorPoint = Vector2.new(0,0)
		script.Parent.customize.shirtColor.Position = UDim2.new(0,5,0,90)
		script.Parent.customize.shirtColor.AnchorPoint = Vector2.new(0,0)
	end
end

input.mode.Changed:connect(updateInputMode)
updateInputMode()

script.Parent:WaitForChild("CameraLookat")
script.Parent:WaitForChild("CameraOrigin")

--network:invoke("lockCameraPosition",script.Parent.CameraMainPos.Value)

local runService = game:GetService("RunService")
local lookup = assets:WaitForChild("accessories")
local coolCamera = true
--[[
spawn(function()
	while coolCamera do
		local camSize = workspace.CurrentCamera.ViewportSize
		local ray = workspace.CurrentCamera:ScreenPointToRay(camSize.X,camSize.Y,300)
		local hitpart, hitpos = workspace:FindPartOnRay(ray)
		if hitpos then
			local lookat = script.Parent.CameraLookat.Value
			lookat = Vector3.new(hitpos.x + lookat.x, hitpos.y + lookat.y, hitpos.z + lookat.z)/2
			workspace.CurrentCamera.CFrame = CFrame.new(script.Parent.CameraOrigin.Value, lookat)
		end
		runService.RenderStepped:wait()
	end
end)
]]

local renderedItems = Instance.new("Folder")
renderedItems.Name = "renderedOptions"
renderedItems.Parent = workspace

local characterRender
local rand = Random.new(os.time())

local characterTable = {}

renderedItems.DescendantAdded:connect(function(object)
	if object.Name == "bodyPart" then
		local part = object.Parent
		part.Color = lookup:FindFirstChild("skinColor"):FindFirstChild(tostring(characterTable.accessories.skinColorId)).Value
	elseif object.Name == "hair_Head" and object:IsA("BasePart") then
		object.Color = lookup:FindFirstChild("hairColor"):FindFirstChild(tostring(characterTable.accessories.hairColorId)).Value
	elseif object.Name == "shirt" or object.Name == "shirtTag" then
		if object.Name == "shirtTag" then
			object = object.Parent
		end
		if object:IsA("BasePart") then
			object.Color = lookup:FindFirstChild("shirtColor"):FindFirstChild(tostring(characterTable.accessories.shirtColorId)).Value
		end
	end
end)

repeat wait() until not loadingassets
wait(1)

tween(script.Parent.blackout,{"BackgroundTransparency"},1,1)

local pastLanding

local function getItemFromHitpart(hitpart)
	for i,renderItem in pairs(renderedItems:GetChildren()) do
		if hitpart:IsDescendantOf(renderItem) then
			return renderItem
		end
	end
end

local selectedItem

local function selectItem(item)
	if selectedItem and selectedItem.Parent then
		selectedItem.PrimaryPart.Transparency = 1
		selectedItem = nil
	end
	if item then
		selectedItem = item
		item.PrimaryPart.Transparency = 0.3
	end
end







local inputModule = input

local _input
function InputChanged(input, processed)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		_input = input
	end
end

local cameraTravelTime = 3
local cameraTravelDistance = 15
local cameraTargetGoal = CFrame.new(script.Parent.CameraOrigin.Value, script.Parent.CameraLookat.Value)
local cameraTargetStart = cameraTargetGoal -cameraTargetGoal.lookVector*cameraTravelDistance
local cameraTarget = cameraTargetStart




local startTime = tick()

runService:BindToRenderStep("render", Enum.RenderPriority.Camera.Value-1, function()

	local arrived
	if tick() - startTime < cameraTravelTime then
		local movementVector = cameraTargetGoal.lookVector*cameraTravelDistance
		local t = math.clamp((tick()-startTime)/cameraTravelTime, 0, 1)
		cameraTarget = cameraTargetStart + movementVector * t^(1/7)
	elseif not arrived then
		arrived = true
		cameraTarget = cameraTargetGoal
	end

	local camSway = 0

	local hitpart, hitpos



	if --[[pastLanding and renderedItems and]] script.Parent.customize.Visible then

		cameraTarget = script.Parent.CameraTablePos.Value
		if cameraTarget == script.Parent.CameraTablePos.Value then
			camSway = 50
		end
		if _input then
			workspace.CurrentCamera.CFrame = script.Parent.CameraTablePos.Value
			local ray = workspace.CurrentCamera:ScreenPointToRay(_input.Position.X,_input.Position.Y,0)
			local renderedChildren = renderedItems:GetChildren()
				if #renderedChildren > 0 and (inputModule.mode.Value == "pc" or inputModule.mode.Value == "mobile") then

				local hitpart, hitpos = workspace:FindPartOnRayWithWhitelist(Ray.new(ray.Origin, ray.Direction * 250), renderedChildren, true)
				if hitpart then

					local item = getItemFromHitpart(hitpart)
					selectItem(item)
				else

					selectItem()
				end
			end
		end
		-- add camera sway effect, to a lessor extent
	elseif not pastLanding then
		camSway = 100
	end

	if camSway > 0 then
		if _input and arrived then
			local ray = workspace.CurrentCamera:ScreenPointToRay(_input.Position.X,_input.Position.Y,camSway)
			hitpart, hitpos = workspace:FindPartOnRay(ray)
			if hitpos then
				local lookat = cameraTarget.Position + cameraTarget.lookVector * 50
				lookat = Vector3.new(hitpos.x + lookat.x * 25, hitpos.y + lookat.y * 25, hitpos.z + lookat.z * 25)/26
				--workspace.CurrentCamera.CFrame = CFrame.new(cameraTarget.Position, lookat)
				_input = nil
--				network:invoke("lockCameraPosition",CFrame.new(cameraTarget.Position, lookat), 0.2)
			end
		elseif not arrived then
--			network:invoke("lockCameraPosition",CFrame.new(cameraTarget.Position, cameraTarget.Position + cameraTarget.lookVector))
		end
	end
end)

local connection = game:GetService("UserInputService").InputChanged:connect(InputChanged)



local mouseDownTime = 0





game:GetService("UserInputService").InputBegan:connect(function(input, absorbed)
	if not absorbed and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
		mouseDownTime = tick()
		InputChanged(input, absorbed)
	end
end)

local currentCategory


game:GetService("UserInputService").InputEnded:connect(function(input, absorbed)
	if not absorbed and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and tick() - mouseDownTime <= 2 then
		if selectedItem then
			--print("WOAH")
			local currentDisplayCategory = currentCategory
			if currentDisplayCategory == "skinColor" then
				currentDisplayCategory = "skinColorId"
			end
			characterTable.accessories[currentDisplayCategory] = tonumber(selectedItem.Name)

			network:invoke("applyCharacterAppearanceToRenderCharacter", characterRender.entity, characterTable)
		end
	end
end)

local referralFrame = script.Parent.Notice.content.referral

local referralPending

script.Parent.Notice.content.referral.invite.Frame.send.Activated:connect(function()
	if not referralPending then
		referralPending = true
		referralFrame.invite.Visible = false
		referralFrame.status.Visible = true
		referralFrame.status.wait.Visible = true
		referralFrame.status.status.Visible = false
		local success, status = network:invokeServer("sendReferral", referralFrame.invite.Frame.code.TextBox.Text)
		if game.Players.LocalPlayer:FindFirstChild("acceptedReferral") == nil then
			referralFrame.status.wait.Visible = false
			referralFrame.status.status.Visible = true
			referralFrame.status.status.Text = status
			if not success then
				wait(3)
				referralFrame.status.Visible = false
				referralFrame.invite.Visible = true
			end
		end
		referralPending = false
	end
end)

game.Players.LocalPlayer.ChildAdded:connect(function(Child)
	if Child.Name == "acceptedReferral" then
		referralFrame.status.status.Text = "Referral accepted! Play now to recieve 200 free Ethyr."
		referralFrame.status.Visible = true
		referralFrame.invite.Visible = false
		referralFrame.status.status.Visible = true
		referralFrame.status.wait.Visible = false
	end
end)
local closing
game.Players.LocalPlayer.ChildRemoved:connect(function(Child)
	if referralFrame.status.Visible and game.Players.LocalPlayer:FindFirstChild("acceptedReferral") == nil and game.Players.LocalPlayer:FindFirstChild("messagePending") == nil and not closing then
		closing = true
		referralFrame.status.status.Visible = true
		referralFrame.status.Visible = true
		referralFrame.invite.Visible = false
		referralFrame.status.wait.Visible = false
		referralFrame.status.status.Text = "Referral timed out. Please confirm you entered the username correctly and that the player is online"
		wait(3)
		closing = false
		referralFrame.status.Visible = false
		referralFrame.invite.Visible = true
	end
end)



local function reset()
	for i,oslot in pairs(script.Parent.main.Frame.DataSlots:GetChildren()) do
		if oslot:IsA("ImageButton") then
			oslot.ImageColor3 = Color3.fromRGB(126, 126, 126)
			oslot.PlayerData.Frame.ImageColor3 = Color3.fromRGB(36, 36, 36)

		end
	end
end

local playButton = script.Parent.main.play

script.Parent.DataSlot.Changed:Connect(function()

	reset()

	local slot = script.Parent.DataSlot.Value
	local real = script.Parent.main.Frame.DataSlots:FindFirstChild(tostring(slot))
--	if slot and real and real.PlayerData.Visible then
	if slot and real then
--		script.Parent.main.Frame.PlayButton.Slot.Text = "Slot " .. tostring(slot)
		playButton.Visible = true

		real.ImageColor3 = Color3.fromRGB(57, 212, 255)
		real.PlayerData.Frame.ImageColor3 = Color3.fromRGB(11, 73, 111)




		playButton.Flutter.ImageTransparency = 0.3
		playButton.Flutter.Size = UDim2.new(1,0,1,0)



		playButton.Flutter.Visible = true
		tween(playButton.Flutter,{"Size","ImageTransparency"},{UDim2.new(3,0,3,0),1},0.3)
	else
		playButton.Visible = false
	end
end)

local teleporting = false


local debounce = false

local function getModelAveragePosition(model)
	local preavg = Vector3.new()
	local totalcount = 0
	for i,part in pairs(model:GetChildren()) do
		if part:IsA("BasePart") then
			preavg = preavg + part.Position
			totalcount = totalcount + 1
		end
	end
	return preavg / totalcount
end



local function updateColors()
	for i,object in pairs(renderedItems:GetDescendants()) do
		if object.Name == "bodyPart" then
			local part = object.Parent
			part.Color = lookup:FindFirstChild("skinColor"):FindFirstChild(tostring(characterTable.accessories.skinColorId or 1)).Value
		elseif object.Name == "hair_Head" and object:IsA("BasePart") then
			object.Color = lookup:FindFirstChild("hairColor"):FindFirstChild(tostring(characterTable.accessories.hairColorId or 1)).Value
		elseif object.Name == "shirt" or object:FindFirstChild("shirtTag") then
			object.Color = lookup:FindFirstChild("shirtColor"):FindFirstChild(tostring(characterTable.accessories.shirtColorId or 1)).Value
		end
	end
	network:invoke("applyCharacterAppearanceToRenderCharacter", characterRender.entity, characterTable)
end


local function createRepresentationOfItem(item)

	local repre

	if item:IsA("Color3Value") then
		--print("ello")
		repre = script.colorRepre:Clone()
		repre.value.Color = item.Value
		repre.Name = item.Name
	else
		repre = item:Clone()
	end


	local avgpos = getModelAveragePosition(repre)
	-- reparent everything to root
	for i,part in pairs(repre:GetDescendants()) do
		if part:IsA("BasePart") then
			if part.Parent == repre and part:FindFirstChild("colorOverride") == nil then
				local bodyPartTag = Instance.new("BoolValue")
				bodyPartTag.Name = "bodyPart"
				bodyPartTag.Parent = part
			else
				part.Parent = repre
			end
			part.Anchored = true
		end
	end
	-- create a PrimaryPart using the avgPos
	local primaryPart = Instance.new("Part")
	primaryPart.Size = Vector3.new(2,0.5,2)
	primaryPart.CFrame = CFrame.new(avgpos - Vector3.new(0,2,0))
	primaryPart.Parent = repre
	primaryPart.Anchored = true
	primaryPart.TopSurface = Enum.SurfaceType.Smooth
	primaryPart.Material = Enum.Material.Neon
	primaryPart.Transparency = 1

	local immuneTag = Instance.new("BoolValue")
	immuneTag.Name = "colorOverride"
	immuneTag.Parent = primaryPart

	repre.PrimaryPart = primaryPart
	return repre
end

local displayConnection

local lastXboxSelected

local function generateCoolButtons()
	script.Parent.customize.xboxButtons:ClearAllChildren()
	for i,item in pairs(renderedItems:GetChildren()) do
		if item and item.PrimaryPart then
			local vector, onScreen = workspace.CurrentCamera:WorldToScreenPoint(item.PrimaryPart.Position)
			if onScreen then
				local button = script.Parent.customize.sampleXboxButton:Clone()
				button.Name = item.Name
				button.Parent = script.Parent.customize.xboxButtons
				button.Visible = input.mode.Value == "xbox"
				button.Position = UDim2.new(0, vector.X, 0, vector.Y + game.GuiService:GetGuiInset().Y)
				button.Activated:connect(function()
					if input.mode.Value == "xbox" then
						local currentDisplayCategory = currentCategory
						if currentCategory == "skinColor" then
							currentDisplayCategory = "skinColorId"
						end
						characterTable.accessories[currentDisplayCategory] = tonumber(button.Name)
						network:invoke("applyCharacterAppearanceToRenderCharacter", characterRender.entity, characterTable)
					end
				end)
				button.SelectionGained:connect(function()
					lastXboxSelected = item
					selectItem(item)
				end)
				button.SelectionLost:connect(function()
					if lastXboxSelected == item then
						selectItem(nil)
					end
				end)
			end
		end
	end
end

local function inputCheck()
	if input.mode.Value == "mobile" and workspace.CurrentCamera.ViewportSize.Y <= 700 then
		script.Parent.Notice.UIScale.Scale = 0.65
		script.Parent.main.UIScale.Scale = 0.7
		script.Parent.main.Size = UDim2.new(1.43, 0,1.43, 0)
		script.Parent.customize.UIScale.Scale = 0.7
		script.Parent.customize.Size = UDim2.new(1.43, 0,1.43, 0)
	else
		script.Parent.Notice.UIScale.Scale = 1
		script.Parent.main.UIScale.Scale = 1
		script.Parent.main.Size = UDim2.new(1, 0,1, 0)
		script.Parent.customize.UIScale.Scale = 1
		script.Parent.customize.Size = UDim2.new(1, 0,1, 0)
	end
end
inputCheck()

input.mode.Changed:connect(function()

	for i,button in pairs(script.Parent.customize.xboxButtons:GetChildren()) do
		if button:IsA("GuiObject") then
			button.Visible = input.mode.Value == "xbox"
		end
	end

	inputCheck()

end)

local function displayCategory(categoryName)
	renderedItems:ClearAllChildren()
	local items = lookup:FindFirstChild(categoryName)
	if items then
		local x = 0
		local z = 0

		local target = workspace:WaitForChild("Tabletop")


		for i,item in pairs(items:GetChildren()) do

			local repre = createRepresentationOfItem(item)
			local cf = target.CFrame * CFrame.new((z * 6) - target.Size.X/2 + 1.1, target.Size.Y/2 + (z * 3.2), (x * 2.5) - target.Size.Z/2 + 1.1)
			repre:SetPrimaryPartCFrame(cf)
			repre.Parent = renderedItems

			x = x + 1
			if x > 4 then
				x = 0
				z = z + 1
			end

		end
	end
	for i,button in pairs(script.Parent.customize.buttons:GetChildren()) do
		if button:IsA("ImageButton") then
			button.ImageColor3 = Color3.fromRGB(103, 255, 212)
		end
	end
	local newbutton = script.Parent.customize.buttons:FindFirstChild(categoryName)
	if newbutton then
		newbutton.ImageColor3 = Color3.fromRGB(255, 255, 255)
	end
	currentCategory = categoryName

	script.Parent.customize.hairColor.Visible = false
	script.Parent.customize.shirtColor.Visible = false
	if categoryName == "hair" then
		script.Parent.customize.hairColor.Visible = true
	elseif categoryName == "undershirt" then
		script.Parent.customize.shirtColor.Visible = true
	end
	generateCoolButtons()
end

for i,button in pairs(script.Parent.customize.buttons:GetChildren()) do
	if button:IsA("ImageButton") then
		button.Activated:connect(function()
			displayCategory(button.Name)
		end)
	end
end



local function playButtonActivated()
	if debounce then
		return false
	end
	debounce = true
	local slot = script.Parent.DataSlot.Value
	local real = script.Parent.main.Frame.DataSlots:FindFirstChild(tostring(slot))



--	if slot and real and real.PlayerData.Visible and not teleporting then
	if slot and real and not teleporting then

--		if real:FindFirstChild("customize") and not script.Parent.customize.Visible then
		if not (globalData and globalData.saveSlotData["-slot"..slot]) and not script.Parent.customize.Visible then
			script.Parent.main.Visible = false
			script.Parent.onlineFriends.Visible = false
			script.Parent.customize.Visible = true

			if input.mode.Value == "xbox" then
				game.GuiService.GuiNavigationEnabled = true
				game.GuiService.SelectedObject = input.getBestButton(script.Parent.customize)
			end

			characterTable.accessories = {}
			for i,category in pairs(lookup:GetChildren()) do
				local children = category:GetChildren()
				if #children > 0 then
					local categoryName = category.Name
					if categoryName == "skinColor" or categoryName == "shirtColor" or categoryName == "hairColor" then
						categoryName = categoryName .. "Id"
					end
					characterTable.accessories[categoryName] = 1;
				end

			end
			displayCategory("hair")

			for i,color in pairs(lookup:WaitForChild("hairColor"):GetChildren()) do
				if color:IsA("Color3Value") then
					local buttonRepre = script.Parent.customize.colorButtonSample:Clone()
					buttonRepre.ImageColor3 = color.value
					buttonRepre.Name = color.Name
					buttonRepre.Parent = script.Parent.customize.hairColor
					buttonRepre.Visible = true
					-- change hairColor
					buttonRepre.Activated:connect(function()
						characterTable.accessories["hairColorId"] = tonumber(buttonRepre.Name)
						updateColors()

					end)
				end
			end

			for i,color in pairs(lookup:WaitForChild("shirtColor"):GetChildren()) do
				if color:IsA("Color3Value") then
					local buttonRepre = script.Parent.customize.colorButtonSample:Clone()
					buttonRepre.ImageColor3 = color.value
					buttonRepre.Name = color.Name
					buttonRepre.Parent = script.Parent.customize.shirtColor
					buttonRepre.Visible = true
					-- change shirtColor
					buttonRepre.Activated:connect(function()
						characterTable.accessories["shirtColorId"] = tonumber(buttonRepre.Name)
						updateColors()

					end)
				end
			end

			characterRender = network:invoke("createRenderCharacterContainerFromCharacterAppearanceData", workspace:WaitForChild("characterMask"), characterTable)
			characterRender.Parent = workspace

			local animationController 	= characterRender.entity:WaitForChild("AnimationController")
			local currentEquipment 		= network:invoke("getCurrentlyEquippedForRenderCharacter", characterRender.entity)

			local weaponType do
				if currentEquipment[1] then
					weaponType = currentEquipment[1].baseData.equipmentType
				end
			end

			local track = network:invoke("getMovementAnimationForCharacter", animationController, "idling", weaponType, nil)

			if track then
				if typeof(track) == "Instance" then
					track:Play()
				elseif typeof(track) == "table" then
					for ii, obj in pairs(track) do
						obj:Play()
					end
				end
			end


			workspace.CurrentCamera.FieldOfView = 30
			-- Rob if you're seeing this I want you to know im in physical pain
			_G.Aero.Controllers.UI.CameraCFrame = script.Parent.CameraTablePos.Value
			_G.Aero.Controllers.UI.FileSelect.LeftPane.AnchorPoint = Vector2.new(1, 0)
--			network:invoke("lockCameraPosition",script.Parent.CameraTablePos.Value, 0.7)

			if blur then
				tween(blur,{"Size"},0,0.7)
			end

--			tween(workspace.CurrentCamera, {"FieldOfView"}, 30, 0.5)

			wait(0.7)
			cameraTarget = script.Parent.CameraTablePos.Value
			generateCoolButtons()

		else
			teleporting = true

			if script.Parent.customize.Visible and characterTable and characterTable.accessories then
				game:GetService("TeleportService"):SetTeleportSetting("playerAccessories",game:GetService("HttpService"):JSONEncode(characterTable.accessories))
				customizeTable = characterTable.accessories
			end
			--[[
			game:GetService("TeleportService"):SetTeleportSetting("arrivingTeleportId",game.PlaceId)
			game:GetService("TeleportService"):SetTeleportSetting("lastTimeStamp",real.Data.lastTimeStamp.Value)
			game:GetService("TeleportService"):SetTeleportSetting("dataSlot",slot)

			network:invoke("teleportPlayerTo",real.Data.lastLocation.Value)				]]
			script.Parent.Enabled = false
			tween(workspace.CurrentCamera, {"FieldOfView"}, {120}, 7)

			network:invoke("localPrepareForTeleport", real.Data.lastLocation.Value)

			local realm

			if (slot == 13 or slot == 14 or slot == 15) and isAdmin then
				realm = "mirror"
			end

			network:invokeServer("enterGame", real.Data.lastLocation.Value, nil, slot, customizeTable, realm)

		end


	else
		script.Parent.main.Frame.PlayButton.Visible = false
	end
	debounce = false
end

script.Parent.main.Frame.PlayButton.Activated:Connect(playButtonActivated)
script.Parent.main.play.Activated:Connect(playButtonActivated)
script.Parent.customize.play.Activated:Connect(playButtonActivated)


if input.mode.Value:lower() == "xbox" or game:GetService("UserInputService").GamepadEnabled then
	game.GuiService.GuiNavigationEnabled = true
	game.GuiService.AutoSelectGuiEnabled = true
	game.GuiService.SelectedObject = script.Parent.landing.play
end


local allowedSlots = 4

if isAdmin then
	allowedSlots = 20
elseif isLegend then
	allowedSlots = 10
end


local player = game.Players.LocalPlayer

script.Parent.main.Frame.DataSlots.CanvasSize = UDim2.new(0,0,0,10 + allowedSlots * (160))


local frameDataPair = {}

local function loadDataFrameLogic(Frame, data, overrideCustomize, slot)

	if Frame.character.ViewportFrame:FindFirstChild("entity") then
		Frame.character.ViewportFrame.entity:Destroy()
	end

	if Frame.character.ViewportFrame:FindFirstChild("entity2") then
		Frame.character.ViewportFrame.entity2:Destroy()
	end

	if data then

		frameDataPair[Frame] = data



		if (slot == 13 or slot == 14 or slot == 15) and isAdmin then
			Frame.Loading.Visible = false
			Frame.PlayerData.Level.Visible = false
			Frame.PlayerData.Location.Visible = false
			Frame.PlayerData.Class.Text = "Tester Slot"
			Frame.Data.lastLocation.Value = 3372071669
			Frame.PlayerData.Visible = true
			Frame.BGHolder.BG.Image = "https://www.roblox.com/Thumbs/Asset.ashx?width=768&height=432&assetId="..Frame.Data.lastLocation.Value
			Frame.BGHolder.BG.Visible = true
		elseif data.newb then
			Frame.Loading.Visible = false
			Frame.PlayerData.Level.Visible = false
			Frame.PlayerData.Location.Visible = false
			Frame.PlayerData.Class.Text = "New Adventure"
			Frame.Data.lastLocation.Value = 4561988219
			Frame.PlayerData.Visible = true
			Frame.BGHolder.BG.Image = "https://www.roblox.com/Thumbs/Asset.ashx?width=768&height=432&assetId="..Frame.Data.lastLocation.Value
			Frame.BGHolder.BG.Visible = true
			local customizeTag = Instance.new("BoolValue")
			customizeTag.Name = "customize"
			customizeTag.Parent = Frame
		else
			local lastLocation = data.lastLocation or 2064647391
			Frame.Data.lastLocation.Value = lastLocation
			Frame.Loading.Visible = false
			Frame.PlayerData.Level.Text = "lv. " ..  data.level
			Frame.PlayerData.Class.Text = data.class or "???"
			Frame.PlayerData.Location.Text = "-"
			Frame.BGHolder.BG.Image = "https://www.roblox.com/Thumbs/Asset.ashx?width=768&height=432&assetId="..lastLocation
			Frame.BGHolder.BG.Visible = true
			spawn(function()
				local info = game.MarketplaceService:GetProductInfo(lastLocation, Enum.InfoType.Asset)
				if info then
					Frame.PlayerData.Location.Text = info.Name
				end
			end)
			Frame.Data.lastLocation.Value = lastLocation
			Frame.PlayerData.Visible = true
			if data.accessories then



				local camera = Frame.character.ViewportFrame.CurrentCamera
				if camera == nil then
					camera = Instance.new("Camera")
					camera.Parent = Frame.character.ViewportFrame
					Frame.character.ViewportFrame.CurrentCamera = camera
				end

				local client = player
				local character = player.Character
				local mask = Frame.character.ViewportFrame.characterMask

				local characterAppearanceData = {}
				characterAppearanceData.equipment 	= data.equipment or {}
				characterAppearanceData.accessories = data.accessories or {}

				if configuration.getConfigurationValue("doUseProperAnimationForLoadingPlace", player) then
					spawn(function()
						local characterRender 	= network:invoke("createRenderCharacterContainerFromCharacterAppearanceData",mask, characterAppearanceData or {}, client)
						characterRender.Parent 	= workspace.CurrentCamera

						local animationController 	= characterRender.entity:WaitForChild("AnimationController")
						local currentEquipment 		= network:invoke("getCurrentlyEquippedForRenderCharacter", characterRender.entity)

						local weaponType do
							if currentEquipment[1] then
								weaponType = currentEquipment[1].baseData.equipmentType
							end
						end

						local track = network:invoke("getMovementAnimationForCharacter", animationController, "idling", weaponType, nil)

						if track then
							if typeof(track) == "Instance" then
								track:Play()
							elseif typeof(track) == "table" then
								for ii, obj in pairs(track) do
									obj:Play()
								end
							end

							spawn(function()
								while true do
									wait(0.1)

									if typeof(track) == "Instance" then
										if track.Length > 0 then
											break
										end
									elseif typeof(track) == "table" then
										local isGood = true
										for ii, obj in pairs(track) do
											if track.Length == 0 then
												isGood = false
											end
										end

										if isGood then
											break
										end
									end
								end

								if characterRender then
									local entity 	= characterRender.entity
									entity.Parent 	= script.Parent.ViewportFrame

									characterRender:Destroy()

									local focus 	= CFrame.new(entity.PrimaryPart.Position + entity.PrimaryPart.CFrame.lookVector * 6.3, entity.PrimaryPart.Position) * CFrame.new(-3,0,0)
									camera.CFrame 	= CFrame.new(focus.p + Vector3.new(0,1.5,0), entity.PrimaryPart.Position + Vector3.new(0,0.5,0))
								end
							end)
						end
					end)
				else
					spawn(function()
						local characterRender = network:invoke("createRenderCharacterContainerFromCharacterAppearanceData",mask, characterAppearanceData or {}, client)
						characterRender.Parent = workspace.CurrentCamera

						local animationController = characterRender.entity:WaitForChild("AnimationController")
						local track = animationController:LoadAnimation(mask.idle)
						track.Looped = true
						track.Priority = Enum.AnimationPriority.Idle
						track:Play()

						wait()

						if characterRender then
							local entity = characterRender.entity
							entity.Parent = Frame.character.ViewportFrame

							characterRender:destroy()
							local focus = CFrame.new(entity.PrimaryPart.Position + entity.PrimaryPart.CFrame.lookVector * 6.3, entity.PrimaryPart.Position) * CFrame.new(3,0,0)
							camera.CFrame = CFrame.new(focus.p + Vector3.new(0,1.5,0), entity.PrimaryPart.Position + Vector3.new(0,0.5,0))


						end
					end)
				end
			elseif not overrideCustomize then
				local customizeTag = Instance.new("BoolValue")
				customizeTag.Name = "customize"
				customizeTag.Parent = Frame
			end
		end



	else

		Frame.Loading.Sample.TextLabel.Text = "Failed!"
		wait(1)
		Frame.Loading.Sample.TextLabel.Text = "Load"
	end
end

local petContainer, petPreviewMaskCopy
function activateFrame(Frame)
	local i = tonumber(Frame.Name)
--	print("Click")
	if debounce then
		return false
	end
	if petContainer then
		petContainer:Destroy()
		petContainer = nil
	end
	debounce = true
--	print("Clack")
--		if Frame.PlayerData.Visible then
	if frameDataPair[Frame] then

		local data = frameDataPair[Frame]

		script.Parent.DataSlot.Value = i
		if mainCharacter then
			mainCharacter:Destroy()
			mainCharacter = nil
		end

		if data.accessories and not data.newb and not (isAdmin and (i == 13 or i == 14 or i == 15)) then
			local characterAppearanceData = {}
			characterAppearanceData.equipment 	= data.equipment
			characterAppearanceData.accessories = data.accessories

			mainCharacter 			= network:invoke("createRenderCharacterContainerFromCharacterAppearanceData", workspace:WaitForChild("characterPreviewMask"), characterAppearanceData)
			mainCharacter.Parent 	= workspace

			local class = string.lower(data.class)
			if class == "berserker" or class == "paladin" or class == "knight" then
				class = "warrior"
			elseif class == "sorcerer" or class == "cleric" or class == "warlock" then
				class = "mage"
			elseif class == "ranger" or class == "trickster" or class == "assassin" then
				class = "hunter"
			end

--			local banner = workspace.banners:FindFirstChild(string.lower(class) .. "Banner")

--			if banner then
--				banner 			= banner:Clone()
--				banner.Parent 	= mainCharacter
--				banner:SetPrimaryPartCFrame(
--					workspace:WaitForChild("characterPreviewMask").PrimaryPart.CFrame * CFrame.new(-6, -2.3, 4) * CFrame.Angles(0, math.pi / 2, 0)
--				)
--			end

			local petData do
				for i, equipmentSlotData in pairs(data.equipment) do
					warn("scanning for pet", equipmentSlotData.position == 10)
					if equipmentSlotData.position == 10 then
						petData = equipmentSlotData

						break
					end
				end
			end

			if petData then
				if petContainer then
					petContainer:Destroy()
					petContainer = nil
				end

				workspace.petPreviewMask.entityId.Value = petData.id

				petContainer = network:invoke("assembleEntityByManifest", workspace.petPreviewMask)
				network:invoke("setRenderDataByNameTag", workspace.petPreviewMask, "disableNameTagUI", true)
				network:invoke("setRenderDataByNameTag", workspace.petPreviewMask, "disableHealthBarUI", true)

			end

			local animationController 	= mainCharacter.entity:WaitForChild("AnimationController")
			local currentEquipment 		= network:invoke("getCurrentlyEquippedForRenderCharacter", mainCharacter.entity)

			local weaponType do
				if currentEquipment[1] then
					weaponType = currentEquipment[1].baseData.equipmentType
				end
			end

			local track = network:invoke("getMovementAnimationForCharacter", animationController, "idling", weaponType, nil)

			if track then
				if typeof(track) == "Instance" then
					track:Play()
				elseif typeof(track) == "table" then
					for ii, obj in pairs(track) do
						obj:Play()
					end
				end
			end
		end

	elseif not loading then
		--print("hola")
		loading = true

		spawn(function()
			while loading do
				Frame.Loading.Sample.TextLabel.Text = "."
				wait(0.3)
				if not loading then break end
				Frame.Loading.Sample.TextLabel.Text = ".."
				wait(0.3)
				if not loading then break end
				Frame.Loading.Sample.TextLabel.Text = "..."
				wait(0.3)
			end
		end)

		local data = network:invokeServer("loadPlayerData", i)
		loading = false

		loadDataFrameLogic(Frame, data, false, i)


		for e,otherFrame in pairs(script.Parent.main.Frame.DataSlots:GetChildren()) do
			if isAdmin and (i == 13 or i == 14 or i == 15) then
				loadDataFrameLogic(otherFrame, {}, true, tonumber(otherFrame.Name))
			end
			if globalData and globalData.saveSlotData then
				local globalData = data.globalData
				local quickData = globalData.saveSlotData["-slot"..otherFrame.Name]
				if quickData and not frameDataPair[otherFrame] then
					loadDataFrameLogic(otherFrame, quickData, true, tonumber(otherFrame.Name))
				end
			end
		end

	end

	debounce = false
end

for i=1,allowedSlots do
	local Frame = script.Parent.main.Frame.DataSlots.Sample:Clone()
	Frame.Name = tostring(i)
	Frame.Parent = script.Parent.main.Frame.DataSlots
	Frame.Slot.Text = "slot " .. tostring(i)
	Frame.PlayerData.Visible = false
	Frame.Loading.Visible = true
	Frame.LayoutOrder = i

	local loading = false

	if Frame.character.ViewportFrame:FindFirstChild("entity") then
		Frame.character.ViewportFrame.entity:Destroy()
	end

	if Frame.character.ViewportFrame:FindFirstChild("entity2") then
		Frame.character.ViewportFrame.entity2:Destroy()
	end

	Frame.MouseButton1Click:Connect(function()
		activateFrame(Frame)
	end)
	if i == 1 then
		spawn(function()
			-- ugly ugly hack
			activateFrame(Frame)
			activateFrame(Frame)
		end)
	end
	Frame.Visible = true
end

reset()

script.Parent.main.Frame.DataSlots.Sample:Destroy()







for e,otherFrame in pairs(script.Parent.main.Frame.DataSlots:GetChildren()) do
	local i = tonumber(otherFrame.Name)
	if isAdmin and (i == 13 or i == 14 or i == 15) then
		loadDataFrameLogic(otherFrame, {}, true, tonumber(otherFrame.Name))
	end
	if globalData then
		if globalData.saveSlotData then
			local quickData = globalData.saveSlotData["-slot"..otherFrame.Name]
			if quickData and not frameDataPair[otherFrame] then
				loadDataFrameLogic(otherFrame, quickData, true, tonumber(otherFrame.Name))
				if otherFrame.Name=="1" then
--							activateFrame(otherFrame)
				end
			end
		end

	end
end

if globalData then

	if globalData.ethyr then
		script.Parent.main.ethyr.amount.Text = tostring(globalData.ethyr) .. " Ethyr"
	else
		script.Parent.main.ethyr.amount.Text = "0 Ethyr"

	end



	script.Parent.main.ethyr.buy.Activated:Connect(function()
		script.Parent.main.products.Visible = not script.Parent.main.products.Visible
	end)

	for i,product in pairs(script.Parent.main.products:GetChildren()) do
		if product:FindFirstChild("productId") and product:FindFirstChild("buy") then
			product.buy.Activated:connect(function()
				game.MarketplaceService:PromptProductPurchase(game.Players.LocalPlayer, product.productId.Value)
			end)
		end
	end

end


--script.Parent.Enabled = true

network:connect("globalDataUpdated", "OnClientEvent", function(globalData)
	if globalData.ethyr then
		script.Parent.main.ethyr.amount.Text = tostring(globalData.ethyr) .. " Ethyr"
	else
		script.Parent.main.ethyr.amount.Text = "0 Ethyr"

	end
end)

game.Players.LocalPlayer:WaitForChild("DataLoaded")
--script.Parent.Enabled = false

if input.mode.Value == "xbox" or game:GetService("UserInputService").GamepadEnabled then
	game.GuiService.GuiNavigationEnabled = true
	game.GuiService.AutoSelectGuiEnabled = true
	game.GuiService.SelectedObject = script.Parent.landing.play
end


--https://www.roblox.com/Thumbs/Asset.ashx?width=768&height=432&assetId=2015602902


end
