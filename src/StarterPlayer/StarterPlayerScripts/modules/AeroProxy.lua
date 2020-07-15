-- Aero Proxy
-- Rocky28447
-- June 27, 2020


--[[

	A proxy module to allow  main menu Aero code to interface with
	the obfuscated network module. Only include functions that the
	Aero-side will need.
	
	AeroProxy.getGameSaveData()
	AeroProxy.renderCharacter(mask, appearanceData)

]]


local AeroProxy = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Modules = require((ReplicatedStorage.modules))
local Network = Modules.load("network")


function AeroProxy.getGameSaveData(fileNum)
	local globalDataSuccess, globalDataFromServer = Network:invokeServer("loadGame")
	return globalDataFromServer
end


function AeroProxy.renderCharacter(mask, appearanceData, player)
	return Network:invoke("createRenderCharacterContainerFromCharacterAppearanceData", mask, appearanceData, player)
end


function AeroProxy.getMovementAnimationForCharacter(character, animation)
	local animationController 	= character.entity:WaitForChild("AnimationController")
	local currentEquipment = Network:invoke("getCurrentlyEquippedForRenderCharacter", character.entity)
	
	local weaponType do
		if currentEquipment[1] then
			weaponType = currentEquipment[1].baseData.equipmentType
		end
	end

	return Network:invoke("getMovementAnimationForCharacter", animationController, animation, weaponType, nil)
end

return AeroProxy