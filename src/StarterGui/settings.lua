local module = {}

local runService = game:GetService("RunService")

local player = game.Players.LocalPlayer
local playerGui = player.PlayerGui

local ui = playerGui.gameUI.menu_settings


function module.show()
	ui.Visible = not ui.Visible
end
function module.hide()
	ui.Visible = false
end

ui.close.Activated:connect(module.hide)

function module.refreshKeybinds()
	warn("settings.refreshKeybinds not ready")
end


-- module.remapTarget

local userSettings

function module.init(Modules)

	local network = Modules.network

	ui.close.Activated:connect(function()
		Modules.focus.toggle(ui)
	end)

	-- PAGE NAVIGATION


	local function openPage(pageName)
		for i,page in pairs(ui.pages:GetChildren()) do
			if page:IsA("GuiObject") then
				page.Visible = false
			end
		end
		for i,pageButton in pairs(ui.header.buttons:GetChildren()) do
			if pageButton:IsA("ImageButton") then
				pageButton.ImageColor3 = Color3.fromRGB(212, 212, 212)
			end
		end
		local targetPage = ui.pages:FindFirstChild(pageName)
		local targetPageButton = ui.header.buttons:FindFirstChild(pageName)
		targetPage.Visible = true
		targetPageButton.ImageColor3 = Color3.fromRGB(90, 225, 255)
	end

	openPage("options")

	for i,pageButton in pairs(ui.header.buttons:GetChildren()) do
		if pageButton:IsA("GuiButton") then
			pageButton.Activated:connect(function()
				openPage(pageButton.Name)
			end)
		end
	end

	-- OPTIONS

	-- volume slider
	local volumeFrame = ui.pages.options.volume

	volumeFrame.bar.InputBegan:connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then

			local startPointX = volumeFrame.bar.AbsolutePosition.X
			local endPointX = volumeFrame.bar.AbsolutePosition.X + volumeFrame.bar.AbsoluteSize.X

			local volume = volumeFrame.bar.slider.Position.X.Scale

			while input.UserInputState ~= Enum.UserInputState.Cancel and input.UserInputState ~= Enum.UserInputState.End do

				local inputPointX = input.Position.X - startPointX

				local newVolume = math.clamp(inputPointX / (endPointX - startPointX), 0, 1)

				if newVolume <= 0.05 then
					newVolume = 0
				end

				if volume ~= newVolume then
					-- fire volume changed
					network:fire("musicVolumeChanged", newVolume)
					volume = newVolume
				end

				volumeFrame.bar.slider.Position = UDim2.new(volume, 0, 0.5, 0)
				runService.Heartbeat:wait()
			end

			-- post volume changes to server
			if userSettings and (userSettings.musicVolume == nil or userSettings.musicVolume ~= volume) then
				network:invokeServer("requestChangePlayerSetting", "musicVolume", volume)
			end

		end
	end)

	-- main menu
	ui.pages.mainMenu.mainMenu.Activated:Connect(function()
		network:invokeServer("playerRequest_returnToMainMenu")
	end)

	-- KEYBINDS

	local keybinds = ui.pages.keybinds

	local keybindSample = keybinds:WaitForChild("sampleAction")
	keybindSample.Visible = false
	keybindSample.Parent = script

	module.keybindSample = keybindSample

	local function buttonClicked(button)
		local oldTarget = module.remapTarget

		if oldTarget then
			oldTarget.ImageColor3 = keybindSample.ImageColor3
			if oldTarget == button then
				module.remapTarget = nil
				return true
			end
		end

		module.remapTarget = button
		button.ImageColor3 = Color3.fromRGB(61, 255, 74)
	end

	function module.open()
		Modules.focus.toggle(ui)
	end

	function module.refreshKeybinds()

		-- after hitting my head with a brick twenty times, this is where I call it a day
		if keybindSample:FindFirstChild("title") == nil then
			return false
		end

		module.remapTarget = nil

		for i,child in pairs(keybinds:GetChildren()) do
			if child:IsA("GuiObject") then
				child:Destroy()
			end
		end

		local count = 0

		for actionName,action in pairs(Modules.input.actions) do
			local keybind = keybindSample:Clone()
			keybind.Name = actionName
			keybind.title.Text = actionName
			keybind.Parent = keybinds
			keybind.LayoutOrder = action.priority
			keybind.Visible = true

			keybind.MouseButton1Click:connect(function()
				buttonClicked(keybind)
			end)

			count = count + 1
		end

		local ysize = 10 + math.ceil(count/2) * (keybindSample.AbsoluteSize.Y + 5)
		keybinds.CanvasSize = UDim2.new(0,0,0,ysize)


	end

	userSettings = network:invoke("getCacheValueByNameTag", "userSettings")

	if userSettings.musicVolume then
		volumeFrame.bar.slider.Position = UDim2.new(userSettings.musicVolume, 0, 0.5, 0)
	end

	network:connect("propogationRequestToSelf", "Event", function(key, value)
		if key == "userSettings" then
			userSettings = value
			if userSettings.musicVolume then
				volumeFrame.bar.slider.Position = UDim2.new(userSettings.musicVolume, 0, 0.5, 0)
			end
		end
	end)

	--network:invokeServer("requestChangePlayerSetting", "clearingInteraction", true)

end

return module