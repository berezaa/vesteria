local statusEffectData = {
	--> identifying information <--
	id = 5;

	--> generic information <--
	name 				= "Explode";
	activeEffectName 	= "Exploding";
	styleText 			= "This unit is exploding.";
	description 		= "";
	image 				= "rbxassetid://2528902271";

	--
	statusEffectApplicationData = {
		duration = 8;
	}
}

-- explode status effect works like this:
-- duration refers to the wind-up time BEFORE THE EXPLOSION!
-- when the effect is ADDED, the user will see the windup particle effects
-- when the effect is REMOVED, the explosion effect will actually occur and deal whatever damage

function statusEffectData.__clientApplyStatusEffectOnCharacter(renderCharacterContainer)
	if not renderCharacterContainer or not renderCharacterContainer:FindFirstChild("entity") then return false end


end

function statusEffectData.__clientApplyTransitionEffectOnCharacter(renderCharacterContainer)
	-- do nothing here
end

function statusEffectData.__clientRemoveStatusEffectOnCharacter(renderCharacterContainer)
	if not renderCharacterContainer or not renderCharacterContainer:FindFirstChild("entity") then return false end
end

function statusEffectData._serverExecutionFunction(activeStatusEffectData, entityManifest)

end

function statusEffectData._serverCleanupFunction(activeStatusEffectData, entityManifest)

end

function statusEffectData.onStarted_server(activeStatusEffectData, entityManifest)
	if entityManifest then

	end
end

function statusEffectData.onEnded_server(activeStatusEffectData, entityManifest)
	if entityManifest then

	end
end

return statusEffectData