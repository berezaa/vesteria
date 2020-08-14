-- centralized input dohikey
-- berezaa

-- TO ADD AN ACTION TO KEYBIND:

-- network:invoke("addInputAction", UNIQUE_ACTION_NAME, FUNCTION_TO_CALL, DEFAULT_KEYBIND)

-- Note: for DEFAULT_KEYBIND, use a shortcut from module.shortcuts, not the Enum.KeyCode.Name

local USI = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local module = {}
local keybinds = {}
local inputObjects = {}
local actions = {}

local network
local tween
local control
local settings

local gameUi = script.Parent.gameUI
local mode = script.Parent.mode

module.actions = actions
module.menuScale = 1
module.mode = mode

module.shortcuts = {
	Unknown = "???";
	-- Numbers
	One = "1"; KeypadOne = "1"; Two = "2"; KeypadTwo = "2";
	Three = "3"; KeypadThree = "3"; Four = "4"; KeypadFour = "4";
	Five = "5"; KeypadFive = "5"; Six = "6"; KeypadSix = "6";
	Seven = "7"; KeypadSeven = "7"; Eight = "8"; KeypadEight = "8";
	Nine = "9"; KeypadNine = "9"; Zero = "0"; KeypadZero = "0";
	-- Everything else
	Backspace = "BkS"; Clear = "Clr"; Return = "Rtn"; Hash = "#"; Dollar = "$"; Percent = "%";
	Ampersand = "&"; Quote = "\""; LeftParenthesis = "("; RightParenthesis = ")"; Asterisk = "*"; Plus = "+";
	Comma = ","; Minus = "-"; Period = "."; Slash = "/"; Colon = ":"; Semicolon = ";";
	LessThan = "<"; GreaterThan = ">"; Question = "?"; At = "@"; LeftBracket = "["; RightBracket = "]";
	Caret = "^"; Underscore = "_"; Backquote = "`"; LeftCurly = "{"; RightCurly = "}"; Pipe = "|";
	Tilde = "~"; Delete = "Del"; Insert = "Ins"; Home = "Hm"; PageUp = "PgUp"; PageDown = "PgDn";
	NumLock = "NmLk"; CapsLock = "CpLk"; ScrollLock = "ScLk"; RightShift = "Rshft"; LeftShift = "Lshft"; RightControl = "Rctrl";
	LeftControl = "Lctrl"; RightAlt = "Ralt"; LeftAlt = "Lalt"; RightMeta = "Rmta"; LeftMeta = "Lmta"; RightSuper = "Rspr";
	LeftSuper = "Lspr"; Break = "Brk"; Power = "Pwr";
}
-- track all gui objects that belong to a specific (or multiple) platforms
local platformSpecificGuiObjects = {}

local shortcuts = module.shortcuts

local setupComplete


local function preferencesUpdated()
	if setupComplete then
		for _, inputObject in pairs(inputObjects) do
			local actionName = inputObject.Name
			local action = actions[actionName]
			if inputObject and inputObject:IsA("GuiObject") and inputObject:FindFirstChild("keyCode") then
				if action and action.bindedTo then
					inputObject.keyCode.Text = action.bindedTo
				else
					inputObject.keyCode.Text = " "
				end
			end
		end
		settings.refreshKeybinds()
	end
end

function module.addAction(name, target, default, priority)
	priority = priority or 5
	local action = {["target"] = target; ["default"] = default; ["priority"] = priority;}

	-- check for an existing binding
	for input,actionName in pairs(keybinds) do
		if name == actionName then
			action["bindedTo"] = input
			action["priority"] = priority

			-- check for an inputObject
			preferencesUpdated()

			break
		end
	end

	actions[name] = action
end

local add = module.addAction

local function addInputObject(object)
	if object:IsA("GuiObject") and object:IsDescendantOf(game.Players.LocalPlayer) then
		local actionName = object.Parent.Name
		object.Name = actionName

		if object:IsA("ImageLabel") or object:IsA("ImageButton") then
			local colorValue = Instance.new("Color3Value")
			colorValue.Name = "originalColor"
			colorValue.Value = object.ImageColor3
			colorValue.Parent = object
		end

		table.insert(inputObjects,object)
		--inputObjects[actionName] = object

		-- check for an existing action
		local action = actions[actionName]
		if object:FindFirstChild("keyCode") then

			if action and action.bindedTo then
				object.keyCode.Text = action.bindedTo
			else
				object.keyCode.Text = " "
			end
		end
	end
end

for _, object in pairs(game.CollectionService:GetTagged("inputObject")) do
	addInputObject(object)
end

module.menuButtons = {}
for _, button in pairs(gameUi.right.buttons:GetChildren()) do
	if button:IsA("GuiButton") then
		module.menuButtons[button.Name] = button
	end
end

-- make all buttons play a cute click sound
local function buttonSetup(button)
	if button:IsA("GuiButton") then
		button.MouseButton1Click:connect(function()
			local clickSound = Instance.new("Sound")
			clickSound.Name = "clickSound"
			clickSound.SoundId = "rbxassetid://997701190"
			clickSound.Parent = button
			clickSound.Volume = 0.1
			clickSound:Play()
			game.Debris:AddItem(clickSound,3)
		end)
	end
end
for _, guiButton in pairs(gameUi:GetDescendants()) do
	buttonSetup(guiButton)
end
gameUi.DescendantAdded:connect(function(guiButton)
	buttonSetup(guiButton)
end)

local currentFocusFrame

-- do something cool

function module.setCurrentFocusFrame(focusFrame)
	if currentFocusFrame and currentFocusFrame ~= focusFrame then
		currentFocusFrame.Visible = false
	end
	currentFocusFrame = focusFrame
end

local function updateModeDisplay()

end

local buttonsFrame = gameUi.right.buttons

function module.init(Modules)
	tween = Modules.tween
	control = Modules.control
	network = Modules.network
	settings = Modules.settings

	network:create("addInputAction","BindableFunction","OnInvoke",add)

	local currentlySelectedButtonTooltip

	local function processGuiObject(guiObject)
		if guiObject:IsA("GuiObject") then
			if (guiObject:FindFirstChild("xbox") or guiObject:FindFirstChild("pc") or guiObject:FindFirstChild("mobile")) then
				table.insert(platformSpecificGuiObjects, guiObject)
			end
			if guiObject:FindFirstChild("bindable") then
				guiObject.SelectionGained:connect(function()
					Modules.hotbarHandler.showSelectionPrompt(guiObject)
				end)
				guiObject.SelectionLost:connect(function()
					Modules.hotbarHandler.hideSelectionPrompt(guiObject)
				end)
			end
		 -- "populateItemHoverFrameWithTextData"

			if guiObject:FindFirstChild("tooltip") then
				guiObject.MouseEnter:connect(function()
					currentlySelectedButtonTooltip = guiObject
						network:invoke("populateItemHoverFrameWithTextData", {text = guiObject.tooltip.Value; source = guiObject})
				end)
				guiObject.MouseLeave:connect(function()
					if currentlySelectedButtonTooltip == guiObject then
						currentlySelectedButtonTooltip = nil
					end
					network:invoke("populateItemHoverFrameWithTextData", {source = guiObject})
				end)

				guiObject.tooltip.Changed:connect(function()
					if currentlySelectedButtonTooltip == guiObject then
						network:invoke("populateItemHoverFrameWithTextData", {text = guiObject.tooltip.Value; source = guiObject})
					end
				end)

			end

			if guiObject:IsA("ImageButton") and (guiObject.Parent == buttonsFrame or guiObject.Image == "rbxassetid://29202694692" or guiObject.Image == "rbxassetid://2920343923" or guiObject.Image == "rbxassetid://3437374574shadow" or guiObject.Image == "rbxassetid://3437374574" or guiObject.Image == "rbxassetid://3437766345" ) then
				local function selectionGained()
					if guiObject.Active then

						if guiObject.Parent == buttonsFrame then
				--			tween(guiObject.icon.UIScale, {"Scale"}, 1.2, 0.3)
				--			tween(guiObject.icon, {"ImageTransparency"}, 0, 0.3)
						else
							--[[
							local selection = guiObject:FindFirstChild("selectionGlow")
							if selection == nil then
								if guiObject.Image == "rbxassetid://3437374574shadow" or guiObject.Image == "rbxassetid://3437766345" then
									selection = script.selectionGlow_new:Clone()
									selection.Name = "selectionGlow"
								else
									selection = script.selectionGlow:Clone()
								end

								selection.Parent = guiObject
								if guiObject.Parent == buttonsFrame then
									selection.ImageColor3 = guiObject.icon.ImageColor3
								end
							end
							tween(selection, {"ImageTransparency"}, 0.45, 0.3)
							]]
						end
					end
				end
				local function selectionLost()

					if guiObject.Parent == buttonsFrame then
				--		tween(guiObject.icon.UIScale, {"Scale"}, 1, 0.3)
				--		tween(guiObject.icon, {"ImageTransparency"}, 1, 0.3)
					else
						local selection = guiObject:FindFirstChild("selectionGlow")
						if selection then
							if guiObject.Image == "rbxassetid://3437766345" or "rbxassetid://3445513431" then
								tween(selection, {"ImageTransparency"}, 1, 0)
							else
								tween(selection, {"ImageTransparency"}, 1, 0.2)
							end


						end
					end
				end
				local function activated(inputObject)

					if inputObject.UserInputType == Enum.UserInputType.MouseButton1 or inputObject.UserInputType == Enum.UserInputType.Gamepad1 or inputObject.UserInputType == Enum.UserInputType.Touch then



						if guiObject.Active then
							selectionLost()
							if guiObject.Image == "rbxassetid://3437766345" then
								guiObject.Image = "rbxassetid://3445513431"
								local padding
								local existingPadding = guiObject:FindFirstChild("UIPadding")
								if existingPadding == nil then
									padding = script.Parent.effects.clickPadding:Clone()
									padding.Parent = guiObject
								else
									existingPadding.PaddingTop = UDim.new(existingPadding.PaddingTop.Scale, existingPadding.PaddingTop.Offset + 4)
								end
								repeat wait() until inputObject.UserInputState == Enum.UserInputState.Cancel or inputObject.UserInputState == Enum.UserInputState.End
								wait(0.1)
								guiObject.Image = "rbxassetid://3437766345"
								if padding then
									padding:Destroy()
								elseif existingPadding then
									existingPadding.PaddingTop = UDim.new(existingPadding.PaddingTop.Scale, existingPadding.PaddingTop.Offset - 4)
								end

							elseif guiObject.Image ~= "rbxassetid://3445513431" then
								-- old buttons
								local dark = guiObject:FindFirstChild("activationDark")
								if dark == nil then
									dark = script.Parent.effects.activationDark:Clone()
									dark.Parent = guiObject
								end
								tween(dark, {"ImageTransparency"}, 0.5, 0.15)
								spawn(function()
									wait(0.2)
									tween(dark, {"ImageTransparency"}, 1, 0.3)
								end)


							end

						end
					end
				end
				guiObject.MouseEnter:connect(selectionGained)
				guiObject.SelectionGained:connect(selectionGained)

				guiObject.MouseLeave:connect(selectionLost)
				guiObject.SelectionLost:connect(selectionLost)

				guiObject.InputBegan:connect(activated)
			end

		end
	end

	for _, guiObject in pairs(gameUi.Parent:GetDescendants()) do
		processGuiObject(guiObject)
	end

	script.Parent.DescendantAdded:connect(processGuiObject)

	game.CollectionService:GetInstanceAddedSignal("inputObject"):connect(addInputObject)

	local function setInputObjectsVisible(visible)
		for _, inputObject in pairs(inputObjects) do
			if inputObject then
				inputObject.Visible = visible
			end
		end
	end


	-- display relevant information for that input mode
	function updateModeDisplay()
		setInputObjectsVisible(mode.Value == "pc")
		for _, guiObject in pairs(platformSpecificGuiObjects) do
			guiObject.Visible = guiObject:FindFirstChild(mode.Value) ~= nil
		end
		if mode.Value == "mobile" then
			module.menuScale = 0.7
			gameUi.leftBar.UIScale.Scale = 0.65
--			gameUi.leftBar.Position = UDim2.new(0, 5,1, -50)

			gameUi.bottomRight.UIScale.Scale = 0.65
			gameUi.bottomRight.Size = UDim2.new(1, 0,1.625, 0)

			if gameUi.bottomRight.hotbarFrame.content:FindFirstChild("hotbarButton10") then
				gameUi.bottomRight.hotbarFrame.content:FindFirstChild("hotbarButton10").Visible = false
			end
			if gameUi.bottomRight.hotbarFrame.decor:FindFirstChild("10") then
				gameUi.bottomRight.hotbarFrame.decor:FindFirstChild("10").Visible = false
			end
			gameUi.bottomRight.AnchorPoint = Vector2.new(1,1)
			gameUi.bottomRight.Position = UDim2.new(1,0,1,0)
		else
			module.menuScale = 1

			gameUi.leftBar.UIScale.Scale = 1
			gameUi.leftBar.Size = UDim2.new(0, 100,1, -250)
---			gameUi.leftBar.Position = UDim2.new(0, 5,1, -110)
--			gameUi.leftBar.Position = UDim2.new(0, 5,1, -200)

			gameUi.bottomRight.UIScale.Scale = 1
			gameUi.bottomRight.Size = UDim2.new(1, 0, 1, 0)
			gameUi.bottomRight.AnchorPoint = Vector2.new(0.5,1)
			gameUi.bottomRight.Position = UDim2.new(0.5,0,1,0)
			gameUi.bottomRight.Size = UDim2.new(1, 0, 1, 0)
			if gameUi.bottomRight.hotbarFrame.content:FindFirstChild("hotbarButton10") then
				gameUi.bottomRight.hotbarFrame.content:FindFirstChild("hotbarButton10").Visible = true
			end
			if gameUi.bottomRight.hotbarFrame.decor:FindFirstChild("10") then
				gameUi.bottomRight.hotbarFrame.decor:FindFirstChild("10").Visible = true
			end
			if mode.Value == "xbox" or game.GuiService:IsTenFootInterface() then
				module.menuScale = 1.2
				gameUi.bottomRight.UIScale.Scale = 1.2
			end
		end
		network:fireServer("signal_inputChanged", mode.Value)
	end

	if USI.TouchEnabled and not USI.MouseEnabled then
		mode.Value = "mobile"
	end
	mode.Changed:connect(updateModeDisplay)
	-- I'm sorry
	spawn(updateModeDisplay)
	spawn(preferencesUpdated)

	-- old postInit
	spawn(function()
		local remapping = false

		game.GuiService.AutoSelectGuiEnabled = false
		game.GuiService.CoreGuiNavigationEnabled = false

		local function changeKeybindAction(keybind, actionName)
			-- Make sure the action is valid


			local action = actions[actionName]
			if action == nil then
				return warn("Action",actionName,"not found")
			end

			if not setupComplete then
				return warn("Input module not set up yet")
			end

			if remapping then
				return false
			end
			remapping = true

			-- Ask before overriding an existing action
			local existingBindActionName = keybinds[keybind]
			local existingAction
			if existingBindActionName then
				existingAction = actions[existingBindActionName]
				if existingAction then
					if not Modules.prompting_Fullscreen.prompt("This will override an existing action ("..existingBindActionName.."). Are you sure?") then
						remapping = false
						return false
					end
				end
			end

			-- Execute order 66
			local success = network:invokeServer("playerRequestSetKeyAction",keybind,actionName)
			if success then

				local oldkeybind = action.bindedTo
				if oldkeybind then
					keybinds[oldkeybind] = nil
				end

				keybinds[keybind] = actionName
				action.bindedTo = keybind

				if existingAction then
					existingAction.bindedTo = nil
				end

				preferencesUpdated()
				remapping = false
				return true
			else
				remapping = false
				warn("Server rejected keybind change")
			end
		end

		local function setup()

			local userSettings = network:invoke("getCacheValueByNameTag", "userSettings")
			keybinds = {}
			if userSettings and userSettings.keybinds then
				keybinds = userSettings.keybinds
			end

			for key,actionName in pairs(keybinds) do
				local action = actions[actionName]
				if action then
					action.bindedTo = key
				end
			end

			-- apply default keys (but don't override!)
			for actionName,action in pairs(actions) do
				local default = action.default
				if default and action["bindedTo"] == nil and keybinds[default] == nil then
					-- apply keybind (no need to ping the server)
					keybinds[default] = actionName
					action["bindedTo"] = default
				end
			end
			setupComplete = true
			preferencesUpdated()
			updateModeDisplay()
		end

		spawn(setup)

		--local hotbarBinds = {"1", "2", "Q", "E", "R", "G", "V", "3", "4", "5"}

		-- add hard-coded actions


		add("openEquipment",Modules.equipment.show,"Q",3)
		add("openInventory",Modules.inventory.show,"E",3)
		add("openAbilities",Modules.abilities.show,"R",3)
		add("openSettings",Modules.settings.show,"G",3)

	--	add("openQuestLog",Modules.questLog.open,"L",3)
	--	add("openMonsterBook",Modules.monsterBook.open,"B",3)
	--	add("openGuild",Modules.guild.open,"P",3)
		add("interact",Modules.interaction.interact,"C",4)
	--	add("cameraLock",function() network:invoke("toggleCameraLock") end, "Tab", 4)
		add("emote1",function() network:invoke("playerRequest_performEmote", "dance") end, "N", 7)
		add("emote2",function() network:invoke("playerRequest_performEmote", "sit") end, "M", 7)

		--add("defaultPoint",function() network:invoke("playerRequest_performEmote", "point") end, "P", 7)



		USI.InputChanged:connect(function(input, absorbed)

			if input.UserInputType == Enum.UserInputType.Keyboard or input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
				mode.Value = "pc"
			elseif input.UserInputType == Enum.UserInputType.Gamepad1 then
				mode.Value = "xbox"
			elseif input.UserInputType == Enum.UserInputType.Touch then
				mode.Value = "mobile"
			end

			if mode.Value ~= "mobile" then
	--			network:invoke("setMobileMovementDirection", nil)
				network:fire("mobileMovementDirectionChanged", nil)
				network:fire("mobileCameraRotationChanged", nil)
			end
		end)

		--mobile stuff
		local touchJoystick = gameUi:WaitForChild("touchJoystick")

		touchJoystick.Visible = false

		local touchJoystickActive = false
		local touchJoystickDirection

		local cameraMovementActive = false

		USI.TouchStarted:connect(function(touch, processed)
			if not processed then
				local startPos = touch.Position
				if startPos.x < 300 and startPos.y > workspace.CurrentCamera.ViewportSize.y * 0.6 then
					if not touchJoystickActive then
						touchJoystick.Position = UDim2.new(0, startPos.x, 0, startPos.y)
						touchJoystickActive = true
						touchJoystick.Visible = true
						-- while the same finger is still down
						while touch.UserInputState ~= Enum.UserInputState.End and touch.UserInputState ~= Enum.UserInputState.Cancel do
							local pos = touch.Position
							local difference = pos - startPos

							control.doSprint(difference.magnitude > 80)

							if difference.magnitude > 35 then
								difference = difference.unit * 35
							end
							touchJoystick.stick.Position = UDim2.new(0.5, difference.X, 0.5, difference.Y)
	--						network:invoke("setMobileMovementDirection", difference.unit)
							network:fire("mobileMovementDirectionChanged", difference.unit)
							RunService.RenderStepped:wait()
						end
	--					network:invoke("setMobileMovementDirection", Vector2.new())
						network:fire("mobileMovementDirectionChanged", nil)
						control.doSprint(false)
						touchJoystickActive = false
						touchJoystick.Visible = false
					end
				else
					if not cameraMovementActive then
						cameraMovementActive = true
						while touch.UserInputState ~= Enum.UserInputState.End and touch.UserInputState ~= Enum.UserInputState.Cancel do
							local pos = touch.Position
							local difference = pos - startPos
							network:fire("mobileCameraRotationChanged", difference * 0.3)
							startPos = pos
							RunService.RenderStepped:wait()
						end
						cameraMovementActive = false
						network:fire("mobileCameraRotationChanged", Vector2.new())
					end
				end
			end
		end)



		USI.InputEnded:connect(function(input, absorbed)
			if input.KeyCode == Enum.KeyCode.ButtonL2 and Modules.hotbarHandler.focused then
				Modules.hotbarHandler.releaseFocus(input)
			end
		end)


		USI.InputBegan:connect(function(input, absorbed)

			if input.UserInputType == Enum.UserInputType.Keyboard or input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
				mode.Value = "pc"
			elseif input.UserInputType == Enum.UserInputType.Gamepad1 then
				mode.Value = "xbox"
			elseif input.UserInputType == Enum.UserInputType.Touch then
				mode.Value = "mobile"
			end

			if not absorbed then
				if mode.Value == "xbox" then

					if Modules.hotbarHandler.focused then
						Modules.hotbarHandler.releaseFocus(input)
					else
						if input.KeyCode == Enum.KeyCode.ButtonB then
							if Modules.interaction.currentInteraction then
								Modules.interaction.stopInteract()
							else
								Modules.focus.close()
							end
							game.GuiService.SelectedObject = nil
							print("$ nil a")
						elseif input.KeyCode == Enum.KeyCode.ButtonX then
							if Modules.itemAcquistion.closestItem then
								Modules.itemAcquistion.pickupInputGained(input)
							else
								Modules.interaction.interact()
							end

						elseif input.KeyCode == Enum.KeyCode.ButtonY then
							if game.GuiService.SelectedObject and game.GuiService.SelectedObject:FindFirstChild("bindable") then
							else
	--							Modules.playerMenu.open()
							end

						elseif input.KeyCode == Enum.KeyCode.ButtonSelect then
							Modules.settings.open()
	--					elseif input.KeyCode == Enum.KeyCode.DPadRight then
	--						Modules.skillBooks.open()
						elseif input.KeyCode == Enum.KeyCode.ButtonL2 then
							Modules.hotbarHandler.captureFocus()
						end
					end

				elseif mode.Value == "pc" then
					local key = shortcuts[input.KeyCode.Name] or input.KeyCode.Name

					-- remapping active
					local remapTarget = Modules.settings.remapTarget
					if remapTarget then
						local actionName = Modules.settings.remapTarget.Name
						local action = actions[actionName]
						if action then
							local success = changeKeybindAction(key, actionName)
							if success then
							end
							return false
						end
					end

					local actionName = keybinds[key]
					if actionName then
						local action = actions[actionName]
						if action and (not action.active) and type(action.target) == "function" then

							action.active = true
							-- cool visual effect
							for i,inputObject in pairs(inputObjects) do
								if inputObject.Name == actionName then
									if inputObject and inputObject:IsA("ImageLabel") then
										local color = Color3.fromRGB(0, 255, 255)
										inputObject.ImageColor3 = color
										if inputObject:FindFirstChild("keyCode") then
											inputObject.keyCode.TextColor3 = color
										end
									end
								end
							end

							action.target(input) -- pass the input object
							wait()
							action.active = false
							wait(0.15)

							-- reset visual effect
							if not action.active then
								for i,inputObject in pairs(inputObjects) do
									if inputObject.Name == actionName then
										if inputObject and inputObject:IsA("ImageLabel") then
											local color = inputObject:FindFirstChild("originalColor") and inputObject.originalColor.Value or Color3.fromRGB(40, 40, 40)
											inputObject.ImageColor3 = color
											if inputObject:FindFirstChild("keyCode") then
												inputObject.keyCode.TextColor3 = Color3.new(1,1,1)
											end
										end
									end
								end
							end

						end
					end

				end
			end
		end)

		for i,button in pairs(buttonsFrame:GetChildren()) do
			if button:IsA("GuiButton") then
				button.MouseButton1Click:connect(function()
					local action = actions[button.Name]
					if action and action.target then
						action.target()
					end
				end)
			end
		end
	end)

end




return module
