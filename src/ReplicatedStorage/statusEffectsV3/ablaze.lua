--[[
	data {}
		int damage
		string sourceEntityGUID
]]

local module = {
	description = "Lose health over time! Jump into water to put out.";
	doesStack 	= true;
}

local replicatedStorage = game:GetService("ReplicatedStorage")
	local modules = require(replicatedStorage.modules)
		local network = modules.load("network")
		local entityUtilities = modules.load("entityUtilities")
		local events = modules.load("events")

local activeEffects = {}

function module.__onStatusEffectBegan(statusEffect)
	local targetEntity = entityUtilities.getEntityManifestByEntityGUID(statusEffect.targetEntityGUID)
	
	if not targetEntity then return end
	
	local ablazeEmitter 	= script.emitter:Clone()
	ablazeEmitter.Name 		= "ablazeEmitter"
	ablazeEmitter.Parent 	= targetEntity
	
	activeEffects[statusEffect.guid] = statusEffect
	
	coroutine.wrap(function()
		while activeEffects[statusEffect] and statusEffect.isActive do
			local targetEntity = entityUtilities.getEntityManifestByEntityGUID(statusEffect.targetEntityGUID)
			
			if targetEntity then
				local hitPart, hitPosition, hitNormal, hitMaterial = workspace:FindPartOnRayWithWhitelist(
					Ray.new(
						targetEntity.Position,
						Vector3.new(0, -targetEntity.Size.Y / 2 - 3, 0)
					),
					
					{workspace.Terrain}
				)
				
				if hitMaterial == Enum.Material.Water then
					statusEffect:stop()
					
					break
				end
				
				-- how often we checkin?
				wait(1.5)
			else
				break
			end
		end
	end)()
end

function module.__onStatusEffectEnded(statusEffect)
	activeEffects[statusEffect.guid] = nil
	
	local targetEntity = entityUtilities.getEntityManifestByEntityGUID(statusEffect.targetEntityGUID)
	
	if not targetEntity then return end
	
	if targetEntity:FindFirstChild("ablazeEmitter") then
		targetEntity.ablazeEmitter:Destroy()
	end
end

-- note: the statusEffect here is NON-FUNCTIONAL
-- it lost all its functionality, it was JSONified. ONLY READ FROM THE OBJECT.
function module.__onClientStatusEffectBegan(statusEffect)
	
end

-- note: the statusEffect here is NON-FUNCTIONAL
-- it lost all its functionality, it was JSONified. ONLY READ FROM THE OBJECT.
function module.__onClientStatusEffectEnded(statusEffect)
	
end

function module.__onStatusEffectTick(statusEffect, t)
	local rate = statusEffect.data.damage / statusEffect.data.duration
	
	local targetEntity = entityUtilities.getEntityManifestByEntityGUID(statusEffect.targetEntityGUID)
	local sourceEntity = entityUtilities.getEntityManifestByEntityGUID(statusEffect.sourceEntityGUID)
	
	if targetEntity then
		-- turn into a table and triggerEvent so that the amount can be modified
		-- if applicable
		local burnData = {
			damage = rate * t * statusEffect.stacks;
			
			sourceType = "status";
			sourceId = statusEffect.id;
			damageType = "physical";
			sourceEntityGUID = statusEffect.sourceEntityGUID;
		}
		
		-- apply damage
		local entityType = targetEntity:FindFirstChild("entityType")
		if not entityType then return end
		entityType = entityType.Value
	
		if entityType == "monster" then
			network:invoke("monsterDamageRequest_server", nil, targetEntity, burnData)
		else
			network:invoke("playerDamageRequest_server", nil, targetEntity, burnData)
		end	
	end
end

return module