local abilityAnimations = game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local projectile 		= modules.load("projectile")
	local placeSetup 		= modules.load("placeSetup")
	local client_utilities 	= modules.load("client_utilities")
	local network 			= modules.load("network")
	local utilities         = modules.load("utilities")

local debris = game:GetService("Debris")

local httpService = game:GetService("HttpService")

local statusEffectData = {
	--> identifying information <--
	id = 10;
	
	--> generic information <--
	name 				= "Ablaze";
	activeEffectName 	= "Ablaze";
	styleText 			= "On fire (and not in a good way).";
	description 		= "";
	image 				= "rbxassetid://2528902271";
	
	notSavedToPlayerData = true,
}

local MAX_DAMAGE_PER_SECOND = 256

function statusEffectData.onStarted_server(activeStatusEffectData, entityManifest)
	local emitterAttachment = Instance.new("Attachment")
	emitterAttachment.Position = Vector3.new(0, 0, 0)
	emitterAttachment.Parent = entityManifest
	
	local emitter = script.emitter:Clone()
	emitter.Parent = emitterAttachment
	
	activeStatusEffectData.__emitterAttachment = emitterAttachment
end

function statusEffectData.onEnded_server(activeStatusEffectData, entityManifest)
	local emitterAttachment = activeStatusEffectData.__emitterAttachment
	if not emitterAttachment then return end
	local emitter = emitterAttachment:FindFirstChild("emitter")
	if not emitter then return end
	
	emitter.Enabled = false
	debris:AddItem(emitterAttachment, emitter.Lifetime.Max)
end

function statusEffectData.execute(activeStatusEffectData, entityManifest, ticksPerSecond)
	local maxHealth = entityManifest:FindFirstChild("maxHealth")
	if not maxHealth then return end
	local damage = maxHealth.Value * activeStatusEffectData.statusEffectModifier.percent
	local duration = activeStatusEffectData.statusEffectModifier.duration
	local dps = math.min(damage / duration, MAX_DAMAGE_PER_SECOND)
	local damage = dps / ticksPerSecond
	if damage <= 0 then return end
	
	local entityType = entityManifest:FindFirstChild("entityType")
	if not entityType then return end
	entityType = entityType.Value
	
	local sourceGuid = activeStatusEffectData.sourceEntityGUID
	if not sourceGuid then return end
	local source = utilities.getEntityManifestByEntityGUID(sourceGuid)
	if not source then return end
	local sourceType = source:FindFirstChild("entityType")
	if not sourceType then return end
	sourceType = sourceType.Value
	if sourceType ~= "character" then
		return
	end
	local char = source.Parent
	local player = game.Players:GetPlayerFromCharacter(char)
	if not player then return end
	
	local damageData = {
		damage = damage,
		sourceType = "status",
		sourceId = statusEffectData.id,
		damageType = "magical",
		sourcePlayerId = player.UserId,
		sourceEntityGUID = activeStatusEffectData.sourceEntityGUID,
	}
	
	if entityType == "monster" then
		network:invoke("monsterDamageRequest_server", player, entityManifest, damageData)
	else
		network:invoke("playerDamageRequest_server", player, entityManifest, damageData)
	end
	
	-- remove this if my boy is dead
	local state = entityManifest:FindFirstChild("state")
	if not state then return end
	state = state.Value
	if state == "dead" then
		statusEffectData.onEnded_server(activeStatusEffectData, entityManifest)
	end
end

return statusEffectData