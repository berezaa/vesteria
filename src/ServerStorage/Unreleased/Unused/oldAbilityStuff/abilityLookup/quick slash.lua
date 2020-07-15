local abilityAnimations = game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local projectile 		= modules.load("projectile")
	local placeSetup 		= modules.load("placeSetup")
	local client_utilities 	= modules.load("client_utilities")
	local network 			= modules.load("network")
	local damage 			= modules.load("damage")
	local detection 		= modules.load("detection")
	local ability_utilities = modules.load("ability_utilities")
	local utilities			= modules.load("utilities")

local entitiesFolder = placeSetup.getPlaceFolder("entities")

local httpService = game:GetService("HttpService")

local abilityData = {
	--> identifying information <--
	id 	= 26;
	
	--> generic information <--
	name 		= "Quick Slash";
	image 		= "rbxassetid://3736598536";
	description = "Leap forward and knock enemies up.";
	
	damageType = "physical";
	
	layoutOrder = 0;
		
	--> execution information <--
	windupTime 		= 0.1;
	maxRank 		= 10;
	cooldown 		= 3;
	cost 			= 10;
	
	--> combat stats <--
	statistics = {
		[1] = {
			damageMultiplier 	= 2.0;
			range 		= 10;
			cooldown 	= 3;
			manaCost	= 8;
		}; [2] = {
			damageMultiplier = 2.1;
			manaCost	= 9;
		}; [3] = {
			damageMultiplier = 2.15;
			manaCost	= 10;
			cooldown 	= 2.5;
		}; [4] = {
			damageMultiplier = 2.2;
			manaCost	= 11;
		}; [5] = {
			damageMultiplier = 2.25;
			manaCost	= 12;
		}; [6] = {
			damageMultiplier = 2.3;
			manaCost	= 13;
			cooldown 	= 2;
		}; [7] = {
			damageMultiplier = 2.35;
			manaCost	= 14;
		}; [8] = {
			damageMultiplier = 2.4;
			manaCost	= 15;
		}; [9] = {
			damageMultiplier = 2.45;
			cooldown 	= 1.5;
			manaCost	= 16;
		}; [10] = {
			damageMultiplier = 2.5;
			manaCost	= 17;
		}; 																		
		
	};
	
	--- ehhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
	damage 		= 30;
	maxRange 	= 30;
	equipmentTypeNeeded = "sword";
}

function abilityData._serverProcessDamageRequest(sourceTag, baseDamage)
	if sourceTag == "uppercut" then
		return baseDamage, "physical", "direct"
	end
end

function abilityData.__serverValidateMovement(player, previousPosition, currentPosition)
	local abilityStatisticsData = network:invoke("getAbilityStatisticsForRank", abilityData, network:invoke("getPlayerAbilityRankByAbilityId", player, abilityData.id))
	
	return (currentPosition - previousPosition).magnitude <= abilityStatisticsData.range * 2
end

local function onAnimationStopped()
	
end

function abilityData._abilityExecutionDataCallback(playerData, ref_abilityExecutionData)
	ref_abilityExecutionData["bounceback"] =
		playerData and playerData.nonSerializeData.statistics_final.activePerks["bounceback"]
end
local function getKnockbackAmount(abilityExecutionData)
	return abilityExecutionData["bounceback"] and 15000 or 1000
end
function abilityData:execute_server(player, abilityExecutionData, isAbilitySource, targetPoint, monster, knockbackAmount)
	if not isAbilitySource then return end
	if abilityExecutionData["bounceback"] then
		utilities.playSound("bounce", monster)
	end			
	ability_utilities.knockbackMonster(monster, targetPoint, knockbackAmount, 0.2)
end
function abilityData:doKnockback(abilityExecutionData, target, point, amount)
	if	target:FindFirstChild("entityType") and
		target.entityType.Value == "monster"
	then
		network:fireServer("abilityFireServerCall", abilityExecutionData, self.id, point, target, amount)
	end
	
	local player = game.Players.LocalPlayer
	local char = player.Character
	if not char then return end
	local manifest = char.PrimaryPart
	if not manifest then return end
	
	if target == manifest then
		ability_utilities.knockbackLocalPlayer(point, amount)
	end
end

function abilityData:execute(renderCharacterContainer, 	abilityExecutionData, isAbilitySource, guid)
	
	-- todo: fix
	if not renderCharacterContainer:FindFirstChild("entity") then return end
	
	local currentlyEquipped = network:invoke("getCurrentlyEquippedForRenderCharacter", renderCharacterContainer.entity)
	local currentWeaponManifest = currentlyEquipped["1"] and currentlyEquipped["1"].manifest
	if not currentWeaponManifest then return end
	
	local trail

	if currentWeaponManifest then
		--[[
		local sound = script.cast:Clone()
		sound.Parent = currentWeaponManifest
		-- we should start regularly making other people's ability cast sounds quieter
		if not isAbilitySource then
			sound.Volume = sound.Volume * 0.7
		end
		sound:Play()
		game.Debris:AddItem(sound,5)
		]]
		local attach0 = currentWeaponManifest:FindFirstChild("bottomAttachment")
		local attach1 = currentWeaponManifest:FindFirstChild("topAttachment")
		
		if attach0 and attach1 then
			trail = script.Trail:Clone()
			trail.Name = "groundSlamTrail"
			trail.Parent = currentWeaponManifest
			trail.Attachment0 = attach0
			trail.Attachment1 = attach1
			trail.Enabled = true
		end
		
		
	end	
	


	if isAbilitySource then

		local movementVelocity = network:invoke("getMovementVelocity")	
			
		
		network:invoke("setMovementVelocity", Vector3.new())
		network:invoke("setCharacterArrested", false)
	
		local localCharacter = game.Players.LocalPlayer.Character	
		
		if movementVelocity then
			network:fire("applyJoltVelocityToCharacter", (movementVelocity + Vector3.new(0,7,0) * 3))
		end
	end			

	local animationTrack = renderCharacterContainer.entity.AnimationController:LoadAnimation(script.quickSlashAnimation)
	animationTrack:Play()
	animationTrack:AdjustSpeed(3)
	
	local duration = animationTrack.Length / animationTrack.Speed
	
	if isAbilitySource then
		spawn(function()
			local hitDebounceTable = {}
			
			while true do
				if animationTrack.IsPlaying then
					-- todo: consider just using serverHitbox in `monsterManifestCollectionFolder` ?
					for i, serverHitbox in pairs(damage.getDamagableTargets(game.Players.LocalPlayer)) do
						if not hitDebounceTable[serverHitbox] then
							local boxcastOriginCF 	= currentWeaponManifest.CFrame
							local boxProjection_serverHitbox = detection.projection_Box(serverHitbox.CFrame, serverHitbox.Size, boxcastOriginCF.p)
							if detection.boxcast_singleTarget(boxcastOriginCF, currentWeaponManifest.Size * Vector3.new(3, 1.5, 3), boxProjection_serverHitbox) then
								hitDebounceTable[serverHitbox] = true
																
								network:fire("requestEntityDamageDealt", serverHitbox, boxProjection_serverHitbox, "ability", self.id, "uppercut", guid)
							
								
								
								--knockback
								self:doKnockback(abilityExecutionData, serverHitbox, boxProjection_serverHitbox, getKnockbackAmount(abilityExecutionData))
							end
						end
					end
					
					wait(1 / 20)
				else
					break
				end
			end
		end)
		
	end
	
	wait(duration)
	
	if trail then
		trail:Destroy()
	end	
	
	return true
end

return abilityData