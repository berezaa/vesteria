local module = {
	description = "Heal over time."
}

local replicatedStorage = game:GetService("ReplicatedStorage")
	local modules = require(replicatedStorage.modules)
		local events = modules.load("events")

function module.__onStatusEffectBegan(statusEffect, t)
	
end

function module.__onStatusEffectEnded(statusEffect, t)
	
end

function module.__onStatusEffectTick(statusEffect, t)
	local rate = statusEffect.data.amount / statusEffect.data.duration
	
	local character = statusEffect.entity
	
	if character then
		-- turn into a table and triggerEvent so that the amount can be modified
		local healingData = {amount = rate * t; isImmuneToReduction = false}
		events.triggerEvent("beforeEntityHealed", character, healingData)
		
		-- heal the target
		character.Humanoid.Health = character.Humanoid.Health + healingData.amount
		print('heal in tick', t, healingData.amount)
		
		events.triggerEvent("afterEntityHealed", character, healingData)
	end
end

return module