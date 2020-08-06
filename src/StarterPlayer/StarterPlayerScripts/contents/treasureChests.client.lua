-- Author: berezaa
-- Handles chest opening and makes previously-accessed chests already open

local replicatedStorage = game:GetService("ReplicatedStorage")
local modules = require(replicatedStorage:WaitForChild("modules"))
local network = modules.load("network")
local tween = modules.load("tween")
local utilities = modules.load("utilities")

game.Players.LocalPlayer:WaitForChild("dataLoaded", 60)

local treasureChests = {}
local billboards = {}

local assetsFolder = replicatedStorage:WaitForChild("assets")
local assetFolder = script.Parent.Parent:WaitForChild("assets")
local progressUi = assetFolder:WaitForChild("chestBillboard")

local function addBillboardToChest(treasureChest)
	if treasureChest:FindFirstChild("progressUi") == nil then
		local ui = progressUi:Clone()
		ui.ImageLabel.ImageTransparency = 1
		ui.TextLabel.TextTransparency = 1
		ui.TextLabel.TextStrokeTransparency = 1
		ui.Adornee = treasureChest.PrimaryPart
		local totalChests = 0
		local openedChests = 0
		for _, chestInfo in pairs(treasureChests) do
			totalChests = totalChests + 1
			if chestInfo.open then
				openedChests = openedChests + 1
			end
		end
		ui.TextLabel.Text = tostring(openedChests) .. "/" .. tostring(totalChests)
		ui.Enabled = true
		ui.Parent = treasureChest
		tween(ui.ImageLabel, {"ImageTransparency"}, 0, 1)
		tween(ui.TextLabel, {"TextTransparency","TextStrokeTransparency"}, 0, 1)
		table.insert(billboards, ui)
	end
end

local INTERVAL = 30 * 60 * 24

local function getTime()
	-- 7AM/PM PT, 10AM/PM ET
	return os.time() - INTERVAL / 12
end

local playerTreasureData = network:invoke("getCacheValueByNameTag", "treasure")

network:connect("propogationRequestToSelf", "Event", function(key, data)
	if key == "treasure" then
		playerTreasureData = data
	end
end)

-- create model for chest and add it to world, hide bounding box
local function registerTreasureChest(chestRoot)
	local isOldStyle = game.CollectionService:HasTag(chestRoot.PrimaryPart, "interact")

	local chestPropsModule = chestRoot:FindFirstChild("chestProps") or assetsFolder.defaultChestProps
	local chestProps = require(chestPropsModule)
	local defaultChestProps = require(assetsFolder.defaultChestProps)

	-- wierd assignment here. It's getting the chest model from the chest props, or falling back on default if undefined
	-- this should probably be cleaned up but it's 12:50AM and im tired
	-- ~ nimblz
	local chestModel = assetsFolder.chests:FindFirstChild(
		chestProps.chestModel or defaultChestProps.chestModel
	) or assetsFolder.chests:FindFirstChild("defaultChest")


	if isOldStyle then
		chestModel = chestRoot
	else
		chestModel = chestModel:Clone()

		chestModel.Parent = chestRoot
	end

	local animationController = chestModel:WaitForChild("AnimationController")
	local chestOpenAnimation = chestModel:WaitForChild("chestOpen")
	local chestOpenLoopAnimation = chestModel:WaitForChild("chestOpenLoop")

	local chestLockedTrack = Instance.new("Animation", chestModel)
	chestLockedTrack.Name = "chestLocked"
	chestLockedTrack.AnimationId = "rbxassetid://3916391981"

	local openTrack = animationController:LoadAnimation(chestOpenAnimation);
	local openLoopTrack = animationController:LoadAnimation(chestOpenLoopAnimation);
	local lockedTrack = animationController:LoadAnimation(chestLockedTrack)

	openTrack.Looped = false
	openTrack.Priority = Enum.AnimationPriority.Action

	lockedTrack.Looped = false
	lockedTrack.Priority = Enum.AnimationPriority.Action

	openLoopTrack.Looped = true
	openLoopTrack.Priority = Enum.AnimationPriority.Core

	local chestRootPart = chestRoot.PrimaryPart or chestRoot:WaitForChild("RootPart")

	local chestModelRootPart = chestModel.PrimaryPart

	chestModel:SetPrimaryPartCFrame(chestRootPart.CFrame * CFrame.new(0, (-chestRootPart.Size.Y/2) + (chestModelRootPart.Size.Y/2), 0))

	chestRootPart.Transparency = 1

	if not isOldStyle then
		local attackScript = assetFolder.attackableScript:Clone()
		attackScript.Parent = chestModelRootPart

		game.CollectionService:AddTag(chestModelRootPart, "attackable")
	end


	local chest = {
		chestRoot = chestRoot;
		chestModel = chestModel;
		controller = animationController;
		openTrack = openTrack;
		lockedTrack = lockedTrack;
		openLoopTrack = openLoopTrack;
		open = false;
	}

	treasureChests[chestRoot.Name] = chest

	local today = math.floor(getTime() / INTERVAL)
	local chestData = playerTreasureData["place-"..game.PlaceId].chests[chestModel.Name]
	local specialContents = chestModel:FindFirstChild("inventory") or chestModel:FindFirstChild("ironChest") or chestModel:FindFirstChild("goldChest")
	local chestOpen
	if specialContents then
		chestOpen = chestData and chestData.open
	else
		chestOpen = chestData and (chestData.open >= today)
	end
	if chestOpen then
		chest.openLoopTrack:Play()
		chest.open = true
		if chestModel:FindFirstChild("Glow") then
			chestModel.Glow.Transparency = 1
		end
	end
end

for i,treasureChest in pairs(game.CollectionService:GetTagged("treasureChest")) do
	coroutine.wrap(function() registerTreasureChest(treasureChest) end)()
end
game.CollectionService:GetInstanceAddedSignal("treasureChest"):connect(registerTreasureChest)


local function openTreasureChest(treasureChest)
	local chestInfo = treasureChests[treasureChest.Name]
	if chestInfo and not chestInfo.open then
		local chestModel = chestInfo.chestModel
		local glow = chestModel:FindFirstChild("Glow")

		utilities.playSound("chest_unlock", chestModel.PrimaryPart)

		local lock = chestModel:FindFirstChild("Lock")
		if lock then
			tween(lock, {"Transparency"}, 1, 1)
		end

		local rewards, status = network:invokeServer("playerRequest_openTreasureChest", treasureChest)

		if status then
			return nil, status
		end

		chestInfo.open = true

		local track
		if rewards then
			track = chestInfo.openTrack
		else
			track = chestInfo.lockedTrack
		end

		if rewards then
			track:Play()
			track.KeyframeReached:connect(function(key)
				if key == "opened" then
					chestInfo.openLoopTrack:Play()
					if glow then
						glow.Transparency = 0
						tween(glow,{"Transparency"},1,1)
						if glow:FindFirstChild("ParticleEmitter") then
							glow.ParticleEmitter.Color = ColorSequence.new(glow.Color)
							glow.ParticleEmitter:Emit(50)
						end
					end

					utilities.playSound("chest_reward", glow)
				end
			end)
	--		addBillboardToChest(chestModel)
		elseif status and typeof(status) == "number" then
			glow.Transparency = 1
			track:Play()

			track.KeyframeReached:connect(function(key)
				if key == "opened" then
					chestInfo.openLoopTrack:Play()
				end
			end)
			if script.Parent.Parent:FindFirstChild("goldChest") or script.Parent.Parent:FindFirstChild("ironChest") then
				local alert = {
					text = "You've already opened this chest.";
					textColor3 = Color3.new(1,1,1);
					backgroundColor3 = Color3.new(0.9,0.3,0.2);
					backgroundTransparency = 0;
					textStrokeTransparency = 1;
					id = "goldchest"..script.Parent.Parent.Name;
				}
		--		Modules.notifications.alert(alert, 3)
				network:fire("alert", {text = alert}, 2)
			else

				for i=0,2 do
					local alert = {
						text = "Chest can be opened again in " .. utilities.timeToString(status - i);
						textColor3 = Color3.new(1,1,1);
						backgroundColor3 = Color3.new(0.9,0.75,0.2);
						backgroundTransparency = 0;
						textStrokeTransparency = 1;
						id = "chest"..script.Parent.Parent.Name;
					}
			--		Modules.notifications.alert(alert, 3)
					network:fire("alert", {text = alert}, 1)
					wait(1)
				end
				local alert = {
					text = "Chest can be opened again in " .. utilities.timeToString(status - 3);
					textColor3 = Color3.new(1,1,1);
					backgroundColor3 = Color3.new(0.9,0.75,0.2);
					backgroundTransparency = 0;
					textStrokeTransparency = 1;
					id = "chest"..script.Parent.Parent.Name;
				}
		--		Modules.notifications.alert(alert, 3)
				network:fire("alert", alert, 0.5)

			end
		end
		return rewards, status
	end
	return nil, "You cant open that."
end
network:create("openTreasureChest_client", "BindableFunction", "OnInvoke", openTreasureChest)












