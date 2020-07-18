-- player interaction - inspect page
-- berezaa
local module = {}

local activePlayer

local ui = script.Parent.gameUI.inspectPlayerPreview
local slotData = {}


function module.init(Modules)
	local tween = Modules.tween
	local network = Modules.network
	local configuration = Modules.configuration

	local replicatedStorage = game:GetService("ReplicatedStorage")
		local itemLookup = require(replicatedStorage:WaitForChild("itemData"))
		local itemAttributes = require(replicatedStorage:WaitForChild("itemAttributes"))

	local slots = {}


	for i,slot in pairs(ui.content.equipment:GetChildren()) do
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

	local lastSelectedButton

	function module.close()

		ui.Visible = false
		activePlayer = nil

	end


	function module.open(player, selectedButton)

		lastSelectedButton = selectedButton

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

		local level = player:FindFirstChild("level") and player.level.Value or 0

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

							Modules.fx.setFlash(slot.frame, titleColor ~= nil and itemTier > 1	)

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






			end
		end
		ui.Visible = true
	end

	local player = game.Players.LocalPlayer

	local Mouse = player:GetMouse()

	local function reposition()

		if ui.Visible then
			local screensize = workspace.CurrentCamera.ViewportSize

			local x, y

			if Modules.input.mode.Value == "pc" then
				local x = Mouse.X + 15
				local y = Mouse.Y - 5



				if x + ui.AbsoluteSize.X > screensize.X then
					x = Mouse.X - 15 - ui.AbsoluteSize.X
				end

				local yDisplacement = (y + ui.AbsoluteSize.Y) - (screensize.Y - 36)

				if yDisplacement > 0 then
					y = y - yDisplacement
				end

				local targetPosition = UDim2.new(0, x, 0, y)
				ui.Position = targetPosition
			elseif Modules.input.mode.Value == "xbox" then
				local frame = game.GuiService.SelectedObject

				local x = frame.AbsolutePosition.X + frame.AbsoluteSize.X + 10
				if x > screensize.X then
					x = frame.AbsolutePosition.X - ui.AbsoluteSize.X - 10
				end

				local y = frame.AbsolutePosition.Y + frame.AbsoluteSize.Y/2 - ui.AbsoluteSize.Y/2
				local targetPosition = UDim2.new(0, x, 0, y)
				ui.Position = targetPosition
			end
		end
	end


	game:GetService("RunService").RenderStepped:connect(reposition)

end



return module


