local abilityAnimations = game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local projectile 		= modules.load("projectile")
	local placeSetup 		= modules.load("placeSetup")
	local client_utilities 	= modules.load("client_utilities")
	local network 			= modules.load("network")
	local damage 			= modules.load("damage")
	local detection 		= modules.load("detection")
	local tween				= modules.load("tween")

local entitiesFolder = placeSetup.getPlaceFolder("entities")

local httpService = game:GetService("HttpService")

local abilityData = {
	--> identifying information <--
	id 	= 28;
	
	--> generic information <--
	name 		= "Holy Slash";
	image 		= "rbxassetid://4079576639";
	description = ".";
	
	damageType = "physical";
		
	--> execution information <--
	windupTime 		= 0.1;
	maxRank 		= 10;
	cooldown 		= 3;
	cost 			= 10;
	
	--> combat stats <--
	statistics = {
		[1] = {
			damageMultiplier 	= 2.00;
			range 				= 5;
			coneAngle 			= 30;
			cooldown 			= 3;
			manaCost			= 1--35;
		}; [2] = {
			damageMultiplier = 2.10;
		}; [3] = {
			damageMultiplier 	= 2.20;
			manaCost			= 30;
			range 				= 7;
		}; [4] = {
			damageMultiplier = 2.30;
		}; [5] = {
			damageMultiplier 	= 2.40;
			manaCost			= 25;
			range 				= 10;
		};																
		
	};
	
	--- ehhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
	damage 		= 30;
	maxRange 	= 30;
	equipmentTypeNeeded = "sword";
}

function abilityData._serverProcessDamageRequest(sourceTag, baseDamage)
	if sourceTag == "strike" then
		return baseDamage, "physical", "direct"
	elseif sourceTag == "crescent" then
		return baseDamage, "magical", "projectile"
	end
end

function abilityData.__serverValidateMovement(player, previousPosition, currentPosition)
	local abilityStatisticsData = network:invoke("getAbilityStatisticsForRank", abilityData, network:invoke("getPlayerAbilityRankByAbilityId", player, abilityData.id))
	
	return (currentPosition - previousPosition).magnitude <= abilityStatisticsData.range * 2
end

local function onAnimationStopped()
	
end

function abilityData:execute(renderCharacterContainer, 	abilityExecutionData, isAbilitySource, guid)
	
	-- todo: fix
	if not renderCharacterContainer:FindFirstChild("entity") then return end
	
	local currentlyEquipped = network:invoke("getCurrentlyEquippedForRenderCharacter", renderCharacterContainer.entity)
	local currentWeaponManifest = currentlyEquipped["1"] and currentlyEquipped["1"].manifest
	if not currentWeaponManifest then return end
	
	local animationTrack = renderCharacterContainer.entity.AnimationController:LoadAnimation(script.holySlashAnimation)
	
	local keyframeConnection
	local stoppedConnection
	
	local damageTarget
	
	local function onKeyframeReached(keyframeName)
		if not renderCharacterContainer:FindFirstChild("entity") or not renderCharacterContainer.entity.PrimaryPart then return end
		
		local primaryPart = renderCharacterContainer.entity.PrimaryPart
		
		if keyframeName == "releaseCrescent" then
			local releaseDirection 	= primaryPart.CFrame.lookVector
			local crescentOrigin 	= primaryPart.CFrame + releaseDirection * 3
			
			local crescentStartCFrame 	= CFrame.new(crescentOrigin.p + releaseDirection * 2, crescentOrigin.p + releaseDirection * 3)
			local crescentFinishCFrame 	= CFrame.new(crescentOrigin.p + releaseDirection * 50, crescentOrigin.p + releaseDirection * 51)
			
			local crescentStrike 	= script.holySlashCrescent:Clone()
			crescentStrike.Parent 	= workspace.CurrentCamera
			crescentStrike.CFrame 	= crescentStartCFrame
			
			crescentStrike.Transparency = 0.5
			
			projectile.createProjectile(
				crescentStartCFrame.p,
				releaseDirection,
				60,
				crescentStrike,
				function(hitPart, hitPosition, hitNormal, hitMaterial, t)
					if hitPart then
						local canDamageTarget, trueTarget = damage.canPlayerDamageTarget(game.Players.LocalPlayer, hitPart)
						if canDamageTarget and trueTarget then
							network:fire("requestEntityDamageDealt", trueTarget, hitPosition, "ability", self.id, "crescent", guid)
						end
					end
					
					game:GetService("Debris"):AddItem(crescentStrike, 0.1)
				end,
		
				function(t)
					return CFrame.new()
				end,
				
				{crescentStrike; renderCharacterContainer; renderCharacterContainer.clientHitboxToServerHitboxReference.Value},
				
				true,
				
				0.001
			)
		end
	end
	
	local function onAnimationTrackStopped()
		keyframeConnection:disconnect()
		stoppedConnection:disconnect()
	end
	
	keyframeConnection 	= animationTrack.KeyframeReached:connect(onKeyframeReached)
	stoppedConnection 	= animationTrack.Stopped:connect(onAnimationTrackStopped)
	
	animationTrack:Play()
end

return abilityData