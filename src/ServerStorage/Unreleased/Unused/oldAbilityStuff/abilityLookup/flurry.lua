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
	id 	= 27;
	
	--> generic information <--
	name 		= "Flurry";
	image 		= "rbxassetid://4079577011";
	description = "Deal quick and powerful strikes to your enemy.";
	
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
	equipmentTypeNeeded = "dagger";
}

function abilityData._serverProcessDamageRequest(sourceTag, baseDamage)
	if sourceTag == "strike" then
		return baseDamage, "physical", "direct"
	end
end

function abilityData.__serverValidateMovement(player, previousPosition, currentPosition)
	local abilityStatisticsData = network:invoke("getAbilityStatisticsForRank", abilityData, network:invoke("getPlayerAbilityRankByAbilityId", player, abilityData.id))
	
	return (currentPosition - previousPosition).magnitude <= abilityStatisticsData.range * 2
end

local function onAnimationStopped()
	
end

-- attempts 1, and 2
local attempt = 1

function abilityData:execute(renderCharacterContainer, 	abilityExecutionData, isAbilitySource, guid)
	
	-- todo: fix
	if not renderCharacterContainer:FindFirstChild("entity") then return end
	
	local currentlyEquipped = network:invoke("getCurrentlyEquippedForRenderCharacter", renderCharacterContainer.entity)
	local currentWeaponManifest = currentlyEquipped["1"] and currentlyEquipped["1"].manifest
	if not currentWeaponManifest then return end
	
	local animationTrack = renderCharacterContainer.entity.AnimationController:LoadAnimation(script.flurryAnimation)
	
	local keyframeConnection
	local stoppedConnection
	
	local keyPositions = {}
	local damageTarget
	
	local function onKeyframeReached(keyframeName)
		if not renderCharacterContainer:FindFirstChild("entity") or not renderCharacterContainer.entity.PrimaryPart then return end
		
		if attempt == 1 then
			if keyframeName ~= "slash0" and isAbilitySource then
				local damagableTargets = damage.getDamagableTargets()
				
				for i, serverHitbox in pairs(damage.getDamagableTargets(game.Players.LocalPlayer)) do
					local boxcastOriginCF 	= currentWeaponManifest.CFrame
					local boxProjection_serverHitbox = detection.projection_Box(serverHitbox.CFrame, serverHitbox.Size, boxcastOriginCF.p)
					if detection.boxcast_singleTarget(boxcastOriginCF, currentWeaponManifest.Size * Vector3.new(5, 3, 5), boxProjection_serverHitbox) then
						network:fire("requestEntityDamageDealt", serverHitbox, boxProjection_serverHitbox, "ability", self.id, "strike", guid)
					end
				end
			end
		elseif attempt == 2 then
			local offset = currentWeaponManifest.CFrame:toObjectSpace(renderCharacterContainer.entity.PrimaryPart.CFrame)
			if keyframeName == "slash0" then
				local damagableTargets = damage.getDamagableTargets()
				
				-- todo: infront and cone and dist
				for i, v in pairs(damagableTargets) do
					if (v.Position - renderCharacterContainer.entity.PrimaryPart.Position).magnitude <= 30 then
						damageTarget = v
						
						break
					end
				end
				
				if damageTarget then
					table.insert(keyPositions, offset)
				end
			elseif damageTarget then
				local previousOffset = keyPositions[#keyPositions]
				
				table.insert(keyPositions, offset)
				
				local dir = (offset.p - previousOffset.p) * Vector3.new(1, 1, 0)
				local entitySize = math.max(damageTarget.Size.X, damageTarget.Size.Y, damageTarget.Size.Z) / 2 + 3
				
				local crescentStartCF 	= renderCharacterContainer.entity.PrimaryPart.CFrame * (-dir * entitySize) - renderCharacterContainer.entity.PrimaryPart.CFrame.p + damageTarget.Position
				local crescentEndCF 	= renderCharacterContainer.entity.PrimaryPart.CFrame * (dir * entitySize) - renderCharacterContainer.entity.PrimaryPart.CFrame.p + damageTarget.Position
				
				local crescentStrike 	= script.flurryCrescent:Clone()
				crescentStrike.Parent 	= workspace.CurrentCamera
				crescentStrike.CFrame 	= CFrame.new(crescentStartCF, crescentEndCF) * CFrame.Angles(0, 0, math.pi / 2)
				crescentStrike.Transparency = 1
				
				tween(crescentStrike, {"CFrame"}, {CFrame.new(crescentEndCF, crescentEndCF + dir)}, 0.5, Enum.EasingStyle.Quad)
				tween(crescentStrike, {"Transparency"}, {0}, 0.5, Enum.EasingStyle.Quad)
				
				game:GetService("Debris"):AddItem(crescentStrike, 0.5)
				
				if isAbilitySource then
					network:fire("requestEntityDamageDealt", damageTarget, damageTarget.Position, "ability", self.id, "strike", guid)
				end
			end
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