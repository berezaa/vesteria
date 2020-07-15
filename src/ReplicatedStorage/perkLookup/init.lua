--[[
	
	perkFolder
		table perks
		table sharedValues
	
	perkData
		string title
		string description
		function apply[ref statistics_final]
		table modifierData
		
		-- "ref damageData" can be modified to modify the damage dealt
		function onAbilityHit[sourceEntity, sourceType, sourceId, targetManifest, ref damageData]
		function onBasicAttackHit[sourceEntity, sourceType, sourceId, targetManifest, ref damageData]
		
		function onDamageDealt[sourceEntity, sourceType, sourceId, targetManifest, ref damageData]
		function onDamageReceived[sourceEntity, sourceType, sourceId, targetManifest, ref damageData]
--]]

local perkLookup = {}

for i,folder in pairs(script:GetChildren()) do
	local perkFolderData = require(folder)
	for perkName, perk in pairs(perkFolderData.perks) do
		if perkFolderData.sharedValues then
			for key, data in pairs(perkFolderData.sharedValues) do
				perk[key] = data
			end
		end
		perk.folder = folder.Name
		perkLookup[perkName] = perk
	end
end

return perkLookup
