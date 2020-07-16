local statusEffectData = {
	--> identifying information <--
	id 	= 1;

	--> generic information <--
	name 				= "Potion";
	activeEffectName 	= "Potioning";
	styleText 			= "Activated a potion.";
	description 		= "";
	image 				= "rbxassetid://2528902271";
}

--							(renderCharacterContainer, 	targetPosition, isAbilitySource, hitNormal, nil, 	guid)
function statusEffectData.execute(activeStatusEffectData, entityManifest, activeStatusEffectTickTimePerSecond)
	local healthHealed 	= activeStatusEffectData.statusEffectModifier.healthToHeal or 0
	local manaRestored 	= activeStatusEffectData.statusEffectModifier.manaToRestore or 0
	local duration 		= activeStatusEffectData.statusEffectModifier.duration or 5

	if entityManifest:FindFirstChild("health") and entityManifest:FindFirstChild("maxHealth") and healthHealed > 0 then
		entityManifest.health.Value = math.clamp(
			entityManifest.health.Value + healthHealed / duration / activeStatusEffectTickTimePerSecond,
			0,
			entityManifest.maxHealth.Value
		)
	end

	if entityManifest:FindFirstChild("mana") and entityManifest:FindFirstChild("maxMana") and manaRestored > 0 then
		entityManifest.mana.Value = math.clamp(
			entityManifest.mana.Value + manaRestored / duration / activeStatusEffectTickTimePerSecond,
			0,
			entityManifest.maxMana.Value
		)
	end
end

function statusEffectData.onStatusEffectApplied_server(player)

end

function statusEffectData.onStatusEffectRemoved_server(player)

end

function statusEffectData.onStatusEffectApplied_client(player)

end

function statusEffectData.onStatusEffectRemoved_client(player)

end

return statusEffectData