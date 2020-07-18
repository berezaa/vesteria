local module = {}

local ui = script.Parent.gameUI.right.buttons

function module.init(Modules)

	local tween = Modules.tween

	ui.openEquipment.Activated:connect(function()
		Modules.equipment.show()
	end)
	ui.openInventory.Activated:connect(function()
		Modules.inventory.show()
	end)
	ui.openAbilities.Activated:connect(function()
		Modules.abilities.show()
	end)
	ui.openSettings.Activated:connect(function()
		Modules.settings.show()
	end)

	for _, button in pairs(ui:GetChildren()) do
		if button:IsA("GuiButton") then
			local function selected()
				-- Hide other buttons
				for _, button in pairs(ui:GetChildren()) do
					if button:IsA("GuiButton") then
						button.ZIndex = 1
					end
				end
				button.ZIndex = 2
				local position = button.Position
				local newPosition = UDim2.new(position.X.Scale, position.X.Offset, position.Y.Scale, -36)
				tween(button, {"Position"}, newPosition, 0.5)
			end
			local function unselected()
				local position = button.Position
				local newPosition = UDim2.new(position.X.Scale, position.X.Offset, position.Y.Scale, 0)
				tween(button, {"Position"}, newPosition, 0.5)
			end
			button.MouseEnter:connect(selected)
			button.SelectionGained:connect(selected)
			button.MouseLeave:connect(unselected)
			button.SelectionLost:connect(unselected)
		end
	end
end

return module
