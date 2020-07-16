local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
local network = modules.load("network")
local events = modules.load("events")

local statusEffectData = {
	--> identifying information <--
	id = 5;

	--> generic information <--
	name 				= "Stealth";
	activeEffectName 	= "Stealthed";
	styleText 			= "This unit is stealthed.";
	description 		= "";
	image 				= "rbxassetid://2528902271";

	--
	statusEffectApplicationData = {
		duration = 8;
	}
}

local effectTagName = "stealthStatusEffectVisualEffectTag"

function statusEffectData.__clientApplyStatusEffectOnCharacter(renderCharacterContainer)
	if not renderCharacterContainer or not renderCharacterContainer:FindFirstChild("entity") then return false end

	-- hide stealthed units
	local transparencyToSetTo = 1 do
		if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character.PrimaryPart then
			local isClient = renderCharacterContainer.clientHitboxToServerHitboxReference.Value == game.Players.LocalPlayer.Character.PrimaryPart

			if isClient then
				-- what user sees
				transparencyToSetTo = 0.8
			else
				transparencyToSetTo = 1
			end
		end
	end

--	local tag = renderCharacterContainer.entity.PrimaryPart:FindFirstChild(effectTagName)
--	if not tag then return end

	for i, obj in pairs(renderCharacterContainer.entity:GetChildren()) do
		if obj:IsA("BasePart") and obj ~= renderCharacterContainer.entity.PrimaryPart then
			obj.Transparency 	= transparencyToSetTo
			obj.Material 		= Enum.Material.Glass
		end
	end
end

function statusEffectData.__clientApplyTransitionEffectOnCharacter(renderCharacterContainer)
	if not renderCharacterContainer or not renderCharacterContainer:FindFirstChild("entity") then return false end

	-- hide stealthed units
	local transparencyToSetTo = 1 do
		if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character.PrimaryPart then
			local isClient = renderCharacterContainer.clientHitboxToServerHitboxReference.Value == game.Players.LocalPlayer.Character.PrimaryPart

			if isClient then
				-- what user sees
				transparencyToSetTo = 0.8
			else
				transparencyToSetTo = 1
			end
		end
	end

	local tag = Instance.new("BoolValue")
	tag.Name = effectTagName
	tag.Parent = renderCharacterContainer.entity.PrimaryPart

	local iters = 10
	local models = {}

		spawn(function()
		for i = 1, iters do
			if not tag.Parent then return end

			local transparency = transparencyToSetTo * i / iters

			for _, obj in pairs(renderCharacterContainer.entity:GetDescendants()) do
				if obj:IsA("BasePart") and obj ~= renderCharacterContainer.entity.PrimaryPart then
					obj.Transparency 	= transparency
					obj.Material 		= Enum.Material.Glass

				elseif obj:IsA("RopeConstraint") then
					obj.Visible = false
				end
			end

			wait(1 / 30)
		end

		statusEffectData.__clientApplyStatusEffectOnCharacter(renderCharacterContainer)
	end)
end

function statusEffectData.__clientRemoveStatusEffectOnCharacter(renderCharacterContainer)
	local tag = renderCharacterContainer.entity.PrimaryPart:FindFirstChild(effectTagName)
	if tag then
		tag:Destroy()
	end

	for _, obj in pairs(renderCharacterContainer.entity:GetDescendants()) do
		if obj:IsA("BasePart") and obj ~= renderCharacterContainer.entity.PrimaryPart then
			obj.Transparency = 0
			obj.Material = Enum.Material.SmoothPlastic
		elseif obj:IsA("RopeConstraint") then
			obj.Visible = true
		end
	end
end

function statusEffectData.onStarted_server(activeStatusEffectData, entityManifest)
	local stealthTag = Instance.new("BoolValue", entityManifest)
	stealthTag.Name = "isStealthed"
	stealthTag.Value = true

	if entityManifest and entityManifest:FindFirstChild("entityType") and entityManifest.entityType.Value == "character" then
		local stealthedPlayer = game.Players:GetPlayerFromCharacter(entityManifest.Parent)

		local function onStealthBroken(player)
			if player ~= stealthedPlayer then return end

			local char = player.Character
			if not char then return end
			local manifest = char.PrimaryPart
			if not manifest then return end

			if manifest == entityManifest then
				network:invoke("revokeStatusEffectByStatusEffectGUID", activeStatusEffectData.statusEffectGUID)
			end
		end

		activeStatusEffectData.__eventGuids = {
			events:registerForEvent("playerUsedAbility", function(player, abilityId)
				local abilitiesById = require(game.ReplicatedStorage.abilityLookup)
				local abilityData = abilitiesById[abilityId]
				if not abilityData.doesNotBreakStealth then
					onStealthBroken(player)
				end
			end),
			events:registerForEvent("playerWillUseBasicAttack", onStealthBroken),
			events:registerForEvent("playerWillTakeDamage", onStealthBroken)
		}

		activeStatusEffectData.__damageEventGuid = events:registerForEvent("playerWillDealDamage", function(player, damageData)
			if player ~= stealthedPlayer then return end

			if damageData.sourceType == "equipment" then
				damageData.damage = damageData.damage * activeStatusEffectData.statusEffectModifier.damageMultiplier
				events:deregisterEventByGuid(activeStatusEffectData.__damageEventGuid)
			end
		end)
	end
end

function statusEffectData.onEnded_server(activeStatusEffectData, entityManifest)
	if entityManifest:FindFirstChild("isStealthed") then
		entityManifest.isStealthed:Destroy()
	end

	if entityManifest and entityManifest:FindFirstChild("entityType") and entityManifest.entityType.Value == "character" then
		for _, guid in pairs(activeStatusEffectData.__eventGuids) do
			events:deregisterEventByGuid(guid)
		end

		delay(1, function()
			events:deregisterEventByGuid(activeStatusEffectData.__damageEventGuid)
		end)

		local player = game.Players:GetPlayerFromCharacter(entityManifest.Parent)
		if not player then return end

		if player.Character and player.Character.PrimaryPart and player.Character.PrimaryPart:FindFirstChild("isStealthed") then
			player.Character.PrimaryPart.isStealthed:Destroy()
		end
	end
end

return statusEffectData