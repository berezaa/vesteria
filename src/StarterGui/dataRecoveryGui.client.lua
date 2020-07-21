local network = require(game:GetService("ReplicatedStorage"):WaitForChild("modules")).load("network")
local items = require(game:GetService("ReplicatedStorage"):WaitForChild("itemData"))

local localPlayer = game.Players.LocalPlayer
local folder = localPlayer.PlayerGui:WaitForChild("gameUI"):WaitForChild("dataRecovery")

local menu = folder:WaitForChild("menu")
local equipment = menu:WaitForChild("equipment")
local inventory = menu:WaitForChild("inventory")
local prevButton = menu:WaitForChild("previous")
local nextButton = menu:WaitForChild("next")
local selectButton = menu:WaitForChild("select")
local confirmButton = menu:WaitForChild("confirm")
local info = menu:WaitForChild("info")
local loading = menu:WaitForChild("loading")

local prompt = folder:WaitForChild("prompt")
local promptConfirm = prompt:WaitForChild("confirm")
local promptCancel = prompt:WaitForChild("cancel")

local hasShown = false

local function clearMenu()
	for _, child in pairs(equipment:GetChildren()) do
		if child:IsA("ImageLabel") then
			child:Destroy()
		end
	end

	for _, child in pairs(inventory:GetChildren()) do
		if child:IsA("ImageLabel") then
			child:Destroy()
		end
	end
end

local function howLongAgo(playerData)
	local since = os.time() - playerData.lastSaveTimestamp or 0

	local days = math.floor(since / 60 / 60 / 24)
	since = since - days * 24 * 60 * 60
	local hours = math.floor(since / 60 / 60)
	since = since - hours * 60 * 60
	local minutes = math.floor(since / 60)

	return string.format("%dd %dh %dm", days, hours, minutes)
end

local function showData(playerData)

	clearMenu()

	local function newLabel(item, parent)
		local label = Instance.new("ImageLabel")
		label.Image = items[item.id] and items[item.id].image or ""

		if item.stacks and item.stacks > 1 then
			local number = Instance.new("TextLabel")
			number.BackgroundTransparency = 1
			number.Size = UDim2.new(1, 0, 1, 0)
			number.TextColor3 = Color3.new(1, 1, 1)
			number.TextStrokeColor3 = Color3.new(0, 0, 0)
			number.TextStrokeTransparency = 0
			number.Text = item.stacks
			number.Parent = label
		end

		label.Parent = parent
	end

	for _, item in pairs(playerData.equipment) do
		newLabel(item, equipment)
	end

	for _, item in pairs(playerData.inventory) do
		newLabel(item, inventory)
	end

	info.Text = string.format(
		"Version: %d    Level: %d    Exp: %d    Class: %s    Gold: %d    Approx. %s ago",
		playerData.globalData.version,
		playerData.level,
		playerData.exp,
		playerData.class,
		playerData.gold,
		howLongAgo(playerData)
	)
end

local function toggleButtons(visible)
	confirmButton.Visible = false
	loading.Visible = not visible
	for _, button in pairs{nextButton, prevButton, selectButton} do
		button.Visible = visible
	end
end

network:connect("dataRecoveryRequested", "OnClientEvent", function(playerData, slot, flagName)
	if hasShown then return end
	hasShown = true

	prompt.Visible = true

	promptConfirm.Activated:Connect(function()
		prompt:Destroy()

		menu.Visible = true
		showData(playerData)

		local version = playerData.globalData.version
		local maxVersion = version

		nextButton.Activated:Connect(function()
			if version >= maxVersion then return end

			version = version + 1
			toggleButtons(false)
			local success, data, message = network:invokeServer("dataRecoveryGetVersion", slot, version)
			if not success then
				version = version - 1
			else
				showData(data)
			end
			toggleButtons(true)
		end)

		prevButton.Activated:Connect(function()
			if version <= 1 then return end

			version = version - 1
			toggleButtons(false)
			local success, data, message = network:invokeServer("dataRecoveryGetVersion", slot, version)
			if not success then
				version = version + 1
			else
				showData(data)
			end
			toggleButtons(true)
		end)

		selectButton.Activated:Connect(function()
			toggleButtons(false)
			loading.Visible = false
			confirmButton.Visible = true
			delay(2.5, function()
				toggleButtons(true)
			end)
		end)

		confirmButton.Activated:Connect(function()
			network:fireServer("dataRecoveryRequested", slot, version, flagName)
			menu:Destroy()
		end)
	end)

	promptCancel.Activated:Connect(function()
		prompt:Destroy()

		network:fireServer("dataRecoveryRejected", flagName)
	end)
end)