-- player interaction - inspect page
-- berezaa
local module = {}

local activePlayer
local ui = script.Parent.gameUI.inspectPlayer

local slotData = {}


function module.init(Modules)
	local tween = Modules.tween
	local network = Modules.network
	local configuration = Modules.configuration

	local replicatedStorage = game:GetService("ReplicatedStorage")
		local itemLookup = require(replicatedStorage:WaitForChild("itemData"))
		local itemAttributes = require(replicatedStorage:WaitForChild("itemAttributes"))

	local slots = {}

	local currentPartyInfo

	local function updatePartyInfo(partyInfo)
		if partyInfo == nil then
			partyInfo = network:invokeServer("playerRequest_getMyPartyData")
		end
		if partyInfo then
			for _, partyMemberInfo in pairs(partyInfo.members) do

				local player = partyMemberInfo.player

				if player == game.Players.LocalPlayer then
					partyInfo.isClientPartyLeader = partyMemberInfo.isLeader
				end
			end
		end
		currentPartyInfo = partyInfo
	end

	local function isPlayerInParty(player)
		if currentPartyInfo and currentPartyInfo.members then
			for _, entry in pairs(currentPartyInfo.members) do
				if entry.player == player then
					return true
				end
			end
		end
	end

	network:connect("signal_myPartyDataChanged", "OnClientEvent", function(partyInfo)
		updatePartyInfo(partyInfo)
		if ui.Visible and activePlayer then
			module.open(activePlayer, true)
		end
	end)
	spawn(function()
		updatePartyInfo()
	end)

	for _, slot in pairs(ui.content.equipment:GetChildren()) do
		if slot:IsA("ImageButton") or slot:IsA("ImageLabel") then
			slot.item.Image = ""
			slot.frame.Visible = false
			slot.shine.Visible = false
			slot.ImageTransparency = 0.5
			slot.LayoutOrder = 99
			slotData[slot] = {}
			table.insert(slots, slot)

			local function show()
				network:invoke("populateItemHoverFrame", itemLookup[slotData[slot].id], "inspect", slotData[slot])
			end
			local function hide()
				network:invoke("populateItemHoverFrame")
			end

			slot.item.MouseEnter:connect(show)
			slot.item.SelectionGained:connect(show)

			slot.item.MouseLeave:connect(hide)
			slot.item.SelectionLost:connect(hide)
		end
	end

	function module.close()
		if ui.Visible then
			Modules.focus.toggle(ui)
		end
		network:invoke("populateItemHoverFrame")
		ui.Visible = false
		activePlayer = nil
	end

	ui.close.Activated:connect(module.close)

	function module.open(player, isUpdate)

		if ui.Visible and player == activePlayer and not isUpdate then
			module.close()
			return
		end

		for i,button in pairs(ui.content.buttons:GetChildren()) do
			if button:FindFirstChild("fail") then
				button.fail.Visible = false
			end
			if button:FindFirstChild("success") then
				button.success.Visible = false
			end
			if button:FindFirstChild("icon") then
				button.icon.Visible = true
			end
		end



		local partyButton = ui.content.buttons:FindFirstChild("request party")
		local isPartyMember = isPlayerInParty(player)
		if isPartyMember then

			if player == game.Players.LocalPlayer then
				if currentPartyInfo then
					partyButton.ImageColor3 = Color3.fromRGB(247, 0, 4)
					partyButton.tooltip.Value = "Leave Party"
					partyButton.Active = true
				else
					partyButton.ImageColor3 = Color3.fromRGB(95, 95, 95)
					partyButton.tooltip.Value = "Not in Party"
					partyButton.Active = false
				end
			elseif currentPartyInfo and currentPartyInfo.isClientPartyLeader then
				partyButton.ImageColor3 = Color3.fromRGB(247, 0, 4)
				partyButton.tooltip.Value = "Kick from Party"
				partyButton.Active = true
			else
				partyButton.ImageColor3 = Color3.fromRGB(95, 95, 95)
				partyButton.tooltip.Value = "Already in Party"
				partyButton.Active = false
			end
		else
			partyButton.ImageColor3 = Color3.fromRGB(80, 247, 222)
			partyButton.tooltip.Value = "Invite to Party"
			partyButton.Active = true
		end

		if not ui.Visible then
			Modules.focus.toggle(ui)
		end
		ui.UIScale.Scale = (Modules.input.menuScale or 1) * 0.75
		Modules.tween(ui.UIScale, {"Scale"}, (Modules.input.menuScale or 1), 0.5, Enum.EasingStyle.Bounce)


		activePlayer = player
		ui.content.info.username.Text = player.Name

		local class = player:FindFirstChild("class") and player.class.Value:lower() or "unknown"
		local emblemVisible
		if class:lower() ~= "adventurer" then
			ui.content.info.username.emblem.Image = "rbxgameasset://Images/emblem_"..class:lower()
			ui.content.info.username.emblem.Visible = true
			emblemVisible = true
		else
			ui.content.info.username.emblem.Visible = false
		end

		for i,statText in pairs(ui.content.stats:GetChildren()) do
			if statText:IsA("TextLabel") then
			local stat = player:FindFirstChild(statText.Name)
				if stat then
					statText.Text = statText.Name:upper()..": "..tostring(stat.Value)
				else
					statText.Text = statText.Name:upper()..": ???"
				end
				local textBounds = game:GetService("TextService"):GetTextSize(statText.Text, statText.TextSize, statText.Font, Vector2.new()).X
				statText.Size = UDim2.new(0, textBounds + 5, 1, 0)
			end
		end

		local level = player:FindFirstChild("level") and player.level.Value or 0
		ui.content.level.Text = "Lvl. ".. level

		local label = ui.content.info.level.value
		label.Text = "Lvl. "..level

		local xSize = game.TextService:GetTextSize(label.Text, label.TextSize, label.Font, Vector2.new()).X + 16
		ui.content.info.level.Size = UDim2.new(0, xSize, 0, 26)

		local referrals = player:FindFirstChild("referrals") and player.referrals.Value or 0
		if referrals > 0 then
			local label = ui.content.info.referrals.value
			label.Text = tostring(referrals)

			local xSize = game.TextService:GetTextSize(label.Text, label.TextSize, label.Font, Vector2.new()).X + 41
			ui.content.info.referrals.Size = UDim2.new(0, xSize, 0, 26)


			ui.content.info.referrals.Visible = true
		else
			ui.content.info.referrals.Visible = false
		end


		local extend = (emblemVisible and 22) or 0

		local textSize = game:GetService("TextService"):GetTextSize(player.Name, ui.content.info.username.TextSize, ui.content.info.username.Font, Vector2.new()).X
		ui.content.info.username.Size = UDim2.new(0, textSize + 5 + (extend), 0, 30)

		for i,slot in pairs(slots) do
			slot.item.Image = ""
			slot.frame.Visible = false
			slot.shine.Visible = false
			slot.ImageTransparency = 0.5
			slot.LayoutOrder = 99
			slot.stars.Visible = false
			slot.attribute.Visible = false
			Modules.fx.setFlash(slot.frame, false)
		end

		if player.Character and player.Character.PrimaryPart and player.Character.PrimaryPart:FindFirstChild("appearance") then
			local data = game:GetService("HttpService"):JSONDecode(player.Character.PrimaryPart.appearance.Value)
			if data then
				if data.equipment then
					for i, equipment in pairs(data.equipment) do
						local slot = slots[i]
						local realItem = itemLookup[equipment.id]
						slot.stars.Visible = false
						slot.attribute.Visible = false
						if realItem then
							slot.item.Image = realItem.image
							slot.item.ImageColor3 = Color3.new(1,1,1)

							slot.frame.Visible = true
							slot.shine.Visible = true
							slot.ImageTransparency = 0

							if equipment.attribute then
								local attributeData = itemAttributes[equipment.attribute]
								if attributeData and attributeData.color then
									slot.attribute.ImageColor3 = attributeData.color
									slot.attribute.Visible = true
								end
							end

							if equipment.dye then
								slot.item.ImageColor3 = Color3.fromRGB(equipment.dye.r, equipment.dye.g, equipment.dye.b)
							end
							local titleColor, itemTier = Modules.itemAcquistion.getTitleColorForInventorySlotData(equipment)

							slot.frame.ImageColor3 = (itemTier and itemTier > 1 and titleColor) or Color3.fromRGB(106, 105, 107)
							slot.shine.ImageColor3 = titleColor or Color3.fromRGB(179, 178, 185)
							slot.shine.Visible = titleColor ~= nil and itemTier > 1

							Modules.fx.setFlash(slot.frame, slot.shine.Visible)

							slotData[slot] = equipment
							slot.LayoutOrder = equipment.position

							slot.stars.Visible = false
							local upgrades = equipment.successfulUpgrades
							if upgrades then
								for i,child in pairs(slot.stars:GetChildren()) do
									if child:IsA("ImageLabel") then
										child.ImageColor3 = titleColor or Color3.new(1,1,1)
										child.Visible = false
									elseif child:IsA("TextLabel") then
										child.TextColor3 = titleColor or Color3.new(1,1,1)
										child.Visible = false
									end
								end
								if upgrades <= 3 then
									for i,star in pairs(slot.stars:GetChildren()) do
										local score = tonumber(star.Name)
										if score then
											star.Visible = score <= upgrades
										end
									end
									slot.stars.exact.Visible = false
								else
									slot.stars["1"].Visible = true
									slot.stars.exact.Visible = true
									slot.stars.exact.Text = upgrades
								end
								slot.stars.Visible = true

							end



						end
					end
				end

				-- yeet right here

				if ui.character.ViewportFrame:FindFirstChild("entity") then
					ui.character.ViewportFrame.entity:Destroy()
				end

				if ui.character.ViewportFrame:FindFirstChild("entity2") then
					ui.character.ViewportFrame.entity2:Destroy()
				end

				local camera = ui.character.ViewportFrame.CurrentCamera
				if camera == nil then
					camera = Instance.new("Camera")
					camera.Parent = ui.character.ViewportFrame
					ui.character.ViewportFrame.CurrentCamera = camera
				end

				local client = player
				local character = player.Character
				local mask = ui.character.ViewportFrame.characterMask

				local characterAppearanceData = {}
				characterAppearanceData.equipment 	= data.equipment or {}
				characterAppearanceData.accessories = data.accessories or {}

				local characterRender = network:invoke("createRenderCharacterContainerFromCharacterAppearanceData",mask, characterAppearanceData or {}, client)
				characterRender.Parent = workspace.CurrentCamera

				local animationController = characterRender.entity:WaitForChild("AnimationController")
				--[[
				local track = animationController:LoadAnimation(mask.idle)
				track.Looped = true
				track.Priority = Enum.AnimationPriority.Idle
				track:Play()
				]]


				local currentEquipment = network:invoke("getCurrentlyEquippedForRenderCharacter", characterRender.entity)


				local weaponType do
					if currentEquipment["1"] then
						weaponType = currentEquipment["1"].baseData.equipmentType
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
							wait()

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

							if ui.character.ViewportFrame:FindFirstChild("entity") then
								ui.character.ViewportFrame.entity:Destroy()
							end

							local entity 	= characterRender.entity
							entity.Parent 	= ui.character.ViewportFrame

							characterRender:Destroy()
							local focus 	= CFrame.new(entity.PrimaryPart.Position + entity.PrimaryPart.CFrame.lookVector * 6.3, entity.PrimaryPart.Position) * CFrame.new(3,0,0)
							camera.CFrame 	= CFrame.new(focus.p + Vector3.new(0,1.5,0), entity.PrimaryPart.Position + Vector3.new(0,0.5,0))
						end
					end)
				else
					local track = animationController:LoadAnimation(mask.idle)
					track.Looped = true
					track.Priority = Enum.AnimationPriority.Idle
					track:Play()
				end

		--[[

				spawn(function()
					wait()
					if characterRender then
						local entity = characterRender.entity
						entity.Parent = ui.character.ViewportFrame

						characterRender:destroy()
						local focus = CFrame.new(entity.PrimaryPart.Position + entity.PrimaryPart.CFrame.lookVector * 6.3, entity.PrimaryPart.Position) * CFrame.new(3,0,0)
						camera.CFrame = CFrame.new(focus.p + Vector3.new(0,1.5,0), entity.PrimaryPart.Position + Vector3.new(0,0.5,0))


					end
				end)
		]]

			end
		end
	end

	function module.tradeRequest()
		if activePlayer and ui.Visible and ui.content.buttons["request trade"].icon.Visible then
			if not configuration.getConfigurationValue("isTradingEnabled") then
				Modules.notifications.alert({text = "Trading is temporarily disabled."}, 2)
			end

			local button = ui.content.buttons["request trade"]
			button.icon.Visible = false
			local success = network:invokeServer("playerRequest_requestTrade", activePlayer)

			if success then
				button.success.Visible = true
				Modules.notifications.alert({text = "Sent "..activePlayer.Name.." a trade request."}, 2)
			else
				button.fail.Visible = true
			end

			spawn(function()
				wait(1)
				button.fail.Visible = false
				button.success.Visible = false
				button.icon.Visible = true
			end)

		end
	end





	ui.content.buttons["request trade"].Activated:Connect(module.tradeRequest)
	network:invoke("addInputAction", "request trade", module.tradeRequest, "T", 6)


	function module.guildRequest()
		local button = ui.content.buttons["guild"]
		if activePlayer and ui.Visible and button.Visible and button.icon.Visible then
			local activePlayerName = activePlayer.Name
			Modules.notifications.alert({text = "Invited "..activePlayerName.." to your guild."}, 2)

			button.icon.Visible = false

			local waiting = true

			button.loading.Visible = true
			spawn(function()
				while waiting do
					button.loading.Text = "."
					wait(0.5)
					button.loading.Text = ".."
					wait(0.5)
					button.loading.Text = "..."
					wait(0.5)
				end
				button.loading.Visible = false
			end)

			local success, status = network:invokeServer("playerRequest_invitePlayerToGuild", activePlayer)
			button.loading.Visible = false
			waiting = false

			if success then
				button.success.Visible = true
				Modules.notifications.alert({text = activePlayerName .. " accepted your guild invite!"}, 2)
			else
				Modules.notifications.alert({text = status or "The guild invite failed."}, 2)
				button.fail.Visible = true
			end

			spawn(function()
				wait(1)
				button.fail.Visible = false
				button.success.Visible = false
				button.icon.Visible = true
			end)
		end
	end

	ui.content.buttons["guild"].Activated:connect(module.guildRequest)

	function module.partyRequest()
		if activePlayer and ui.Visible and ui.content.buttons["request party"].icon.Visible then


			local button = ui.content.buttons["request party"]
			button.icon.Visible = false

			local target = activePlayer
			local success, reason

			if button.tooltip.Value == "Kick from Party" then
				pcall(function()
					success, reason = network:invokeServer("playerRequest_leaveParty", target)
				end)
			elseif button.tooltip.Value == "Leave Party" then
				pcall(function()
					success, reason = network:invokeServer("playerRequest_leaveParty")
				end)
				if success then
					button.success.Visible = true
					Modules.notifications.alert({text = "Left the party."}, 2)
				elseif reason then
					button.fail.Visible = true
					Modules.notifications.alert({text = reason or "Error occured"}, 2)
				end
			else
				pcall(function()
					success, reason = network:invokeServer("playerRequest_invitePlayerToMyParty", target)
				end)
				if success then
					button.success.Visible = true
					Modules.notifications.alert({text = "Invited "..target.Name.." to the party."}, 2)
				elseif reason then
					button.fail.Visible = true
					Modules.notifications.alert({text = reason or "Error occured"}, 2)
				end
			end



			local waiting = true




			waiting = false




			spawn(function()
				wait(1)
				button.fail.Visible = false
				button.success.Visible = false
				button.icon.Visible = true
			end)

		end
	end

	ui.content.buttons["request party"].Activated:Connect(module.partyRequest)
	network:invoke("addInputAction", "request party", module.partyRequest, "P", 6)

	function module.duelRequest()
		if activePlayer and ui.Visible and ui.content.buttons["request duel"].icon.Visible then

			local button = ui.content.buttons["request duel"]
			button.icon.Visible = false

			local target = activePlayer
			local success = network:invokeServer("playerRequest_requestChallenge", target)


			if success then
				button.success.Visible = true
				Modules.notifications.alert({text = "Sent "..target.Name.." a duel challenge."}, 2)
			else
				button.fail.Visible = true
			end
			spawn(function()
				wait(1)
				button.fail.Visible = false
				button.success.Visible = false
				button.icon.Visible = true
			end)
		end
	end

	ui.content.buttons["request duel"].Activated:Connect(module.duelRequest)
	network:invoke("addInputAction", "request duel", module.duelRequest, "U", 6)
end



return module


