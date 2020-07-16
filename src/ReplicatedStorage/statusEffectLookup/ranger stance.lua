local abilityAnimations = game:GetService("ReplicatedStorage").assets:WaitForChild("abilityAnimations")

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
local network = modules.load("network")
local events = modules.load("events")

local debris = game:GetService("Debris")
local itemLookup = require(game.ReplicatedStorage.itemData)

local statusEffectData = {
	--> identifying information <--
	id = 7;

	--> generic information <--
	name 				= "Ranger's Stance";
	activeEffectName 	= "Ranger's Stance";
	styleText 			= "In ranger's stance.";
	description 		= "";
	image 				= "rbxassetid://2528902271";

	notSavedToPlayerData = true,
}

local function findTrackByAnimation(animator, animation)
	for _, track in pairs(animator:GetPlayingAnimationTracks()) do
		if track.Animation == animation then
			return track
		end
	end
	return nil
end

function statusEffectData.__clientApplyTransitionEffectOnCharacter(renderCharacterContainer)
	local entity = renderCharacterContainer:FindFirstChild("entity")
	if not entity then return end

	local animator = entity:FindFirstChild("AnimationController")
	if not animator then return end

	local startTrack = animator:LoadAnimation(abilityAnimations.rangerStanceStarting)
	startTrack.Looped = true
	startTrack:Play()

	delay(startTrack.Length - 0.05, function()
		if not startTrack.IsPlaying then return end

		local idleTrack = animator:LoadAnimation(abilityAnimations.rangerStanceIdling)
		idleTrack:Play(0)

		startTrack:Stop(0)
	end)
end

function statusEffectData.__clientRemoveStatusEffectOnCharacter(renderCharacterContainer)
	local entity = renderCharacterContainer:FindFirstChild("entity")
	if not entity then return end

	local animator = entity:FindFirstChild("AnimationController")
	if not animator then return end

	local leaveTrack = animator:LoadAnimation(abilityAnimations.rangerStanceExiting)
	leaveTrack:Play(0)

	local startTrack = findTrackByAnimation(animator, abilityAnimations.rangerStanceStarting)
	if startTrack then
		startTrack:Stop(0)
	end

	local idleTrack = findTrackByAnimation(animator, abilityAnimations.rangerStanceIdling)
	if idleTrack then
		idleTrack:Stop(0)
	end
end

function statusEffectData.onStarted_server(activeStatusEffectData, entityManifest)
	local emitterAttachment = Instance.new("Attachment")
	emitterAttachment.Position = Vector3.new(0, -2, 0)
	emitterAttachment.Parent = entityManifest

	local emitter = script.emitter:Clone()
	emitter.Parent = emitterAttachment

	activeStatusEffectData.__emitterAttachment = emitterAttachment

	activeStatusEffectData.__eventGuid = events:registerForEvent("playerEquipmentChanged", function(player)
		local char = player.Character
		if not char then return end
		local manifest = char.PrimaryPart
		if not manifest then return end

		if manifest == entityManifest then
			network:invoke("revokeStatusEffectByStatusEffectGUID", activeStatusEffectData.statusEffectGUID)
		end
	end)
end

function statusEffectData.onEnded_server(activeStatusEffectData, entityManifest)
	local emitterAttachment = activeStatusEffectData.__emitterAttachment
	if not emitterAttachment then return end
	local emitter = emitterAttachment:FindFirstChild("emitter")
	if not emitter then return end

	emitter.Enabled = false
	debris:AddItem(emitterAttachment, emitter.Lifetime.Max)

	events:deregisterEventByGuid(activeStatusEffectData.__eventGuid)
end

function statusEffectData.execute(activeStatusEffectData, entityManifest, ticksPerSecond)
	local manaCost = activeStatusEffectData.statusEffectModifier.manaCost / ticksPerSecond

	local mana = entityManifest:FindFirstChild("mana")
	if not mana then return end

	if mana.Value >= manaCost then
		mana.Value = mana.Value - manaCost
	else
		network:invoke("revokeStatusEffectByStatusEffectGUID", activeStatusEffectData.statusEffectGUID)
	end

	-- revoke instantly if we're not holding a bow, ok?
	local player = game.Players:GetPlayerFromCharacter(entityManifest.Parent)
	if player then
		local playerData = network:invoke("getPlayerData", player)
		local equipment = playerData.equipment

		for _, equipmentInfo in pairs(equipment) do
			if equipmentInfo.position == 1 then
				local itemData = itemLookup[equipmentInfo.id]
				if itemData then
					if itemData.equipmentType ~= "bow" then
						network:invoke("revokeStatusEffectByStatusEffectGUID", activeStatusEffectData.statusEffectGUID)
					end
				end
			end
		end
	end
end

return statusEffectData