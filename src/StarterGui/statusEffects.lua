-- local status effect display
-- berezaa
local module = {}
local ui = script.Parent.gameUI.statusEffects

function module.init(Modules)

	local tween = Modules.tween
	local utilities = Modules.utilities

	local replicatedStorage = game:GetService("ReplicatedStorage")
		local itemLookup = require(replicatedStorage:WaitForChild("itemData"))
		local abilityLookup = require(replicatedStorage:WaitForChild("abilityLookup"))

	local function updateStatusEffects(newValue)
		for i, child in pairs(ui.contents:GetChildren()) do
			if child:IsA("GuiObject") then
				child:Destroy()
			end
		end

		local character = game.Players.LocalPlayer.Character
		if character and character.PrimaryPart then

			local success, statusEffectData = utilities.safeJSONDecode(newValue)

			if success then
				for i, statusEffect in pairs(statusEffectData) do
					if (not statusEffect.hideInStatusBar) and (not statusEffect.statusEffectModifier.hideInStatusBar) then
						local indicator = ui.sample:Clone()

						local sourceType = statusEffect.sourceType
						local sourceId = statusEffect.sourceId
						local variant = statusEffect.variant
						local executionData = {variant = variant}

						if not statusEffect.icon then
							if sourceType == "item" then
								local itemData = itemLookup[sourceId]
								indicator.itemIcon.Image = itemData.image
								indicator.itemIcon.Visible = true
							elseif sourceType == "ability" then
								local abilityData = abilityLookup[sourceId](nil, executionData)
								indicator.Image = abilityData.image
								indicator.itemIcon.Visible = false
							end
						else
							local abilityData = abilityLookup[sourceId]
							indicator.itemIcon.Image = statusEffect.icon
							indicator.itemIcon.Visible = true
						end

						indicator.Parent = ui.contents
						indicator.Visible = true

						if statusEffect.ticksNeeded then
							local durationLeft = (statusEffect.ticksNeeded - statusEffect.ticksMade) / Modules.configuration.getConfigurationValue("activeStatusEffectTickTimePerSecond")

							indicator.progress.Size = UDim2.new(1, 0, 1 - (durationLeft / statusEffect.statusEffectModifier.duration), 0)
							tween(indicator.progress, {"Size"}, UDim2.new(1,0,1,0), durationLeft - 0.5, Enum.EasingStyle.Linear)

							game.Debris:AddItem(indicator, durationLeft)
						else

						end
					end
				end
			end
		end
		--[{"sourceId":2,"duration":45,"id":"regenerate","durationLeft":45,"sourceType":"ability"}]
	end

	updateStatusEffects(game.Players.LocalPlayer.Character.PrimaryPart.statusEffectsV2.Value)
	game.Players.LocalPlayer.Character.PrimaryPart.statusEffectsV2.changed:connect(updateStatusEffects)
end

return module
