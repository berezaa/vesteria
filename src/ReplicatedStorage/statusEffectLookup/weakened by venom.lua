local debris = game:GetService("Debris")

local statusEffectData = {
	--> identifying information <--
	id = 22;
	
	--> generic information <--
	name 				= "Weakened by Venom";
	activeEffectName 	= "Weakened by Venom";
	styleText 			= "Weakened by the venom of a Stingtail Staff.";
}

function statusEffectData.onStarted_server(activeStatusEffectData, entityManifest)
	local emitter = script.emitter:Clone()
	emitter.Parent = entityManifest
	
	activeStatusEffectData.__emitter = emitter
end

function statusEffectData.onEnded_server(activeStatusEffectData, entityManifest)
	local emitter = activeStatusEffectData.__emitter
	if not emitter then return end
	
	emitter.Enabled = false
	debris:AddItem(emitter, emitter.Lifetime.Max)
end

return statusEffectData