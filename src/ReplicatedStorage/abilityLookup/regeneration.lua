--Modules
local Modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
local Network = Modules.load("network")
local Effects = Modules.load("effects")
local Tween = Modules.load("tween")
local PlaceSetup = Modules.load("placeSetup")

--Ability Assets


--Ability Base Data
local abilityData = {
	--> Identifying Information <--
	id = 1;
	
	--> Generic Information <--
	name = "Regeneration";
	image = "rbxassetid://2528903781";
	description = "Regenerates all players health who are within a certain radius of cast";
		
	--> Misc Information <--
	animationName = {"cast", "prayer"};
	windupTime = 1;
	
	--> Execution Data <--
	executionData = {
		level = 1;
		maxLevel = 15;
	};
	
	--> Ability Stats <--
	statistics = {
		healing = 5;
		distance = 10;
		
		manaCost = 30;
		cooldown = 4;
		
		increasingStat = "healing";	
		increaseExponent = 0.2;						
	};
	
	prerequisites = {
		playerLevel = 1;
		
		classRestricted = false;
		developerOnly = false;
		
		abilities = {};
	};
}

--Client Execute Function
function abilityData:execute(abilityExecutionData, isAbilitySource)
	local renderCharacterContainer = abilityExecutionData.casterCharacter
	local abilityGuid = abilityExecutionData.abilityGuid
	
	if not renderCharacterContainer or not abilityExecutionData or not isAbilitySource or not abilityGuid then return false end
	if not renderCharacterContainer.PrimaryPart then return false end
	
	local root = renderCharacterContainer.PrimaryPart
	local playerData = Network:invoke("getPlayerData", renderCharacterContainer)
	local showWeapons = Effects.hideWeapons(renderCharacterContainer.entity)
	
	--If casting player is source then freeze player during ability
	if isAbilitySource then
		Network:invoke("setCharacterArrested", true)
		
		delay(self.windupTime, function()
			Network:invoke("setCharacterArrested", false)
		end)
	end
	
	--Animation Here
	local animTrack = renderCharacterContainer.entity.AnimationController:LoadAnimation(abilityAnims.prayer)
	animTrack:Play()
	
	--Cast Sound Here
	local castSound = abilitySounds.cast
	castSound.Parent = root
	castSound:Play()
	game.Debris:AddItem(castSound, castSound.TimeLength)
	
	wait(self.windupTime)
	
	animTrack:Stop(0.5)
	showWeapons()
	
	--Ability Sound Here
	local abilitySound = abilitySounds.prayer
	abilitySound.Parent = root
	abilitySound:Play()
	game.Debris:AddItem(abilitySound, abilitySound.TimeLength)
	
	--Define Ability Statistics
	local radius = abilityExecutionData["statistics"]["radius"]
	local diameter = radius * 2
	
	local ring = abilityEffects.ring:Clone()
	ring.CFrame = CFrame.new(root.CFrame.p)
	ring.Parent = PlaceSetup.awaitPlaceFolder("entities")
	
	Tween(ring, {"Size"}, Vector3.new(diameter, 1, diameter), 0.25)
	Tween(ring, {"Transparency"}, 1, 1)
	game.Debris:AddItem(ring, 1)

	return true, self.statistics.cooldown
end

--Server Execute Function
function abilityData:execute_server(castPlayer, abilityExecutionData, isAbilitySource)
	
end

return abilityData