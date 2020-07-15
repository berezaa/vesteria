local abilityAnimations = game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local projectile 		= modules.load("projectile")
	local placeSetup 		= modules.load("placeSetup")
	local client_utilities 	= modules.load("client_utilities")
	local network 			= modules.load("network")
	local damage 			= modules.load("damage")
	local detection 		= modules.load("detection")
	local utilities 		= modules.load("utilities")

local entitiesFolder = placeSetup.getPlaceFolder("entities")

local httpService = game:GetService("HttpService")

local abilityData = {
	--> identifying information <--
	id 	= 29;
	
	--> generic information <--
	name 		= "Battle Cry";
	image 		= "rbxassetid://2574647455";
	description = "Aggro all enemies onto your character and temporarily break their defenses.";
	
	damageType = "physical";
		
	--> execution information <--
	windupTime 		= 0.1;
	maxRank 		= 10;
	cooldown 		= 3;
	cost 			= 10;
	
	--> combat stats <--
	statistics = {
		[1] = {
			damageMultiplier 	= 0;
			range 				= 200;
			cooldown 			= 3;
			manaCost			= 35;
			defenseBreak 		= 5;
		}; [2] = {
			defenseBreak 		= 10;
		}; [3] = {
			defenseBreak 		= 15;
			range 				= 25;
		}; [4] = {
			defenseBreak 		= 20;
		}; [5] = {
			range 				= 30;
			defenseBreak 		= 25;
		};																	
		
	};
	
	--- ehhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
	damage 		= 30;
	maxRange 	= 30;
}

function abilityData._serverProcessAbilityHit(player, abilityStatistics, abilityGUID, entityManifestHit, sourceTag)
	if entityManifestHit and entityManifestHit:FindFirstChild("entityType") and entityManifestHit.entityType.Value == "monster" then
		-- monsterEntity, targetEntity, targetEntitySetSource, targetEntityLockType)
		network:invoke("setMonsterTargetEntity", entityManifestHit, player.Character.PrimaryPart, "ability", 1)
		
		return true
	end
	
	return false
end

local function onAnimationStopped()
	
end

function abilityData:execute(renderCharacterContainer, 	abilityExecutionData, isAbilitySource, guid)
	
	-- todo: fix
	if not renderCharacterContainer:FindFirstChild("entity") then return end
	
	local currentlyEquipped = network:invoke("getCurrentlyEquippedForRenderCharacter", renderCharacterContainer.entity)
	local currentWeaponManifest = currentlyEquipped["1"] and currentlyEquipped["1"].manifest
	if not currentWeaponManifest then return end
	
	local animationTrack 	= renderCharacterContainer.entity.AnimationController:LoadAnimation(script.battleCryAnimation)
	local connection 		= animationTrack.Stopped:connect(onAnimationStopped)
	
	animationTrack:Play()
	
	if isAbilitySource and renderCharacterContainer.entity.PrimaryPart then
		local abilityAggroRange = abilityExecutionData["ability-statistics"].range
		local entities 			= damage.getDamagableTargets(game.Players.LocalPlayer)
		local battleCryPosition = renderCharacterContainer.entity.PrimaryPart.Position
		
		for i, entityManifest in pairs(entities) do
			if (entityManifest.Position - battleCryPosition).magnitude <= abilityAggroRange then
				network:fireServer("playerRequest_abilityHitEntity", self.id, guid, entityManifest, "battle-cry")
			end
		end
	end
end

return abilityData