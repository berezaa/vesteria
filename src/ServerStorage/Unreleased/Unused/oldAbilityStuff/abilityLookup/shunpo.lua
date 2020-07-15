local abilityAnimations = game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local projectile 		= modules.load("projectile")
	local placeSetup 		= modules.load("placeSetup")
	local client_utilities 	= modules.load("client_utilities")
	local utilities 		= modules.load("utilities")
	local network 			= modules.load("network")
	local damage 			= modules.load("damage")
	local detection 		= modules.load("detection")
	local physics			= modules.load("physics")

local httpService 	= game:GetService("HttpService")
local itemLookup 	= require(game:GetService("ReplicatedStorage"):WaitForChild("itemData"))

local metadata = {
	cost = 3;
	upgradeCost = 2;
	maxRank = 8;
	layoutOrder = 3;
	
	requirement = function(playerData)
		return playerData.class == "Hunter";
	end;
}


local abilityData = {
	--> identifying information <--
	id 	= 13;
	
	manaCost	= 15;
	metadata = metadata;
	
	--> generic information <--
	name 		= "Shunpo";
	image 		= "rbxassetid://3736597862";
	description = "Leap forward and slash them to pieces.";
	description_key = "abilityDescription_shunpo";
	
	prerequisite = {{id = 6; rank = 3}};
	layoutOrder = 3;		
		
	--> execution information <--
	animationName 	= {};
	windupTime 		= 0.2;
	maxRank 		= 10;
	
	--> combat stats <--
	statistics = {
		[1] = {
			distance 					= 20;
			cooldown 					= 7;
			manaCost 					= 10;
			damageMultiplier 			= 1.60;
		};
		[2] = {
			distance 					= 22;
			manaCost 					= 11;
			damageMultiplier 			= 1.8;
		};		
		[3] = {
			distance 					= 24;
			manaCost 					= 12;
			damageMultiplier 			= 2.0;
		};			
		[4] = {
			distance 					= 26;
			manaCost 					= 13;
			damageMultiplier 			= 2.2;
		};		
		[5] = {
			distance 					= 30;
			manaCost 					= 15;
			cooldown					= 5;
			tier						= 3;
		};						
		[6] = {
			distance 					= 32;
			manaCost 					= 17;
			damageMultiplier 			= 2.5;
		};	
		[7] = {
			distance 					= 34;
			manaCost 					= 19;
			damageMultiplier 			= 2.8;
		};	
		[8] = {
			damageMultiplier 			= 3.2;
			manaCost 					= 24;
			cooldown					= 3;
			tier						= 4;
		};												
	};
	
	securityData = {
		playerHitMaxPerTag 	= 1;
--		maxHitLockout 		= 1;
		isDamageContained 	= true;
	};
	
	dontDisableSprinting = true;
	equipmentTypeNeeded = "dagger",
}

-- network:fireServer("playerRequest_damageEntity", player, serverHitbox, damagePosition, sourceType, sourceId, sourceTag, guid)
function abilityData._serverProcessDamageRequest(sourceTag, baseDamage, serverHitbox)
	if sourceTag == "dash-through" then
		utilities.playSound("shunpoImpact", serverHitbox)
		return baseDamage, "physical", "direct"
	end
end

function abilityData.__serverValidateMovement(player, previousPosition, currentPosition)
	local abilityStatisticsData = network:invoke("getAbilityStatisticsForRank", abilityData, network:invoke("getPlayerAbilityRankByAbilityId", player, abilityData.id))
	
	return (currentPosition - previousPosition).magnitude <= abilityStatisticsData.distance * 2.5
end

function abilityData._abilityExecutionDataCallback(playerData, ref_abilityExecutionData)
	if playerData then
		local stats = playerData.nonSerializeData.statistics_final
		ref_abilityExecutionData["battydagger"] = stats.activePerks["battydagger"]
	end
end

function abilityData:execute_server(player, abilityExecutionData, isAbilitySource)
	if not isAbilitySource then return end
	
	if abilityExecutionData["battydagger"] then
		network:invoke("abilityCooldownReset_server", player, self.id)
	end
end

function abilityData:execute(renderCharacterContainer, 	abilityExecutionData, isAbilitySource, guid)
	-- todo: fix
	if not renderCharacterContainer:FindFirstChild("entity") then return end
	
	if renderCharacterContainer.entity.PrimaryPart then
		local animationTrack = renderCharacterContainer.entity.AnimationController:LoadAnimation(abilityAnimations.shunpo_start)
		
		utilities.playSound("shunpoCast", renderCharacterContainer.entity.PrimaryPart)
		
		animationTrack:Play(nil,nil,1.5)

		spawn(function()	
			wait((self.windupTime/2)/ animationTrack.Speed)
			if script:FindFirstChild("dustpart") then
				local dustpart = script.dustpart:Clone()
				dustpart.Parent = workspace.CurrentCamera
				dustpart.CFrame = CFrame.new(renderCharacterContainer.entity.PrimaryPart.Position - Vector3.new(0,2.8,0))
				dustpart.Dust:Emit(50)
				game.Debris:AddItem(dustpart,5)
			end		
		end)	
		
		
		wait(self.windupTime/ animationTrack.Speed)
		
		if not renderCharacterContainer:FindFirstChild("entity") then return end
		
		local currentlyEquipped = network:invoke("getCurrentlyEquippedForRenderCharacter", renderCharacterContainer.entity)
		local currentWeaponManifest = currentlyEquipped["1"] and currentlyEquipped["1"].manifest
		if not currentWeaponManifest then return end
		
		local castingWeaponBaseData = itemLookup[abilityExecutionData["cast-weapon-id"]]

		if not castingWeaponBaseData then
			return false
		end

		local trail
		if castingWeaponBaseData and castingWeaponBaseData.equipmentType == "dagger" then
			if currentWeaponManifest then
				if script:FindFirstChild("cast") then
					local sound = script.cast:Clone()
					sound.Parent = currentWeaponManifest
					-- we should start regularly making other people's ability cast sounds quieter
					if not isAbilitySource then
						sound.Volume = sound.Volume * 0.7
					end
					sound:Play()
					game.Debris:AddItem(sound,5)
				end
				
				local attach0 = currentWeaponManifest:FindFirstChild("bottomAttachment")
				local attach1 = currentWeaponManifest:FindFirstChild("topAttachment")
				
				if attach0 and attach1 then
					trail = script.Trail:Clone()
					trail.Name = "shadowStepTrail"
					trail.Parent = currentWeaponManifest
					trail.Attachment0 = attach0
					trail.Attachment1 = attach1
					trail.Enabled = true
				end
				
				
			end	
		end		
			

		
		-- todo: fix
		if not renderCharacterContainer:FindFirstChild("entity") then return end
		
		local animationTrack = renderCharacterContainer.entity.AnimationController:LoadAnimation(abilityAnimations.shunpo_end)
		
		
		animationTrack:Play(0.1, 1, 2)
		
		local movementVelocity
		
		if isAbilitySource then
			
			local localCharacter = game.Players.LocalPlayer.Character	
			if not localCharacter then
				return false
			end
			
			physics:setWholeCollisionGroup(localCharacter, "passthrough")
		
			movementVelocity = network:invoke("getMovementVelocity")
			if movementVelocity and movementVelocity.magnitude > 0 then
				-- unitify it...
				movementVelocity = movementVelocity.unit
				
				local startPosition = renderCharacterContainer.entity.PrimaryPart.Position
				local targetTPPosition = renderCharacterContainer.entity.PrimaryPart.Position + movementVelocity * abilityExecutionData["ability-statistics"].distance
							
				if renderCharacterContainer:FindFirstChild("clientHitboxToServerHitboxReference") then
			--		renderCharacterContainer.clientHitboxToServerHitboxReference.Value.CFrame = CFrame.new(targetTPPosition, targetTPPosition + movementVelocity) -- CFrame.new(hitPosition - movementVelocity * 5, hitPosition + movementVelocity)
					network:invoke("setCharacterArrested", true)
					network:invoke("setMovementVelocity", movementVelocity * 150 * ((abilityExecutionData["ability-statistics"].distance * 1) / 20))
					
							
							
					if localCharacter and localCharacter.PrimaryPart then			
						local bodyGyro 		= localCharacter.PrimaryPart:FindFirstChild("hitboxGyro")
						if bodyGyro then
							bodyGyro.CFrame = CFrame.new(Vector3.new(), movementVelocity)
						end	
					end							
						
					if castingWeaponBaseData and castingWeaponBaseData.equipmentType == "dagger" then
						local mg = (targetTPPosition - startPosition).magnitude

						local hitboxSize 	= Vector3.new(6, 6, mg)
						local hitboxCFrame 	= CFrame.new(startPosition, targetTPPosition) * CFrame.new(0, 0, -mg * 0.5)
						
						local damageTargets = damage.getDamagableTargets(game.Players.LocalPlayer)
						for i, damageTarget in pairs(damageTargets) do
							local damageTargetProjection = detection.projection_Box(damageTarget.CFrame, damageTarget.Size, hitboxCFrame.p)
							
							if detection.boxcast_singleTarget(hitboxCFrame, hitboxSize, damageTargetProjection) then
								network:fire("requestEntityDamageDealt", damageTarget, 		damageTargetProjection, 	"ability", 	self.id, "dash-through", guid)
							end
						end
					end
				
					
		--			network:fire("applyJoltVelocityToCharacter", movementVelocity * 40)
				end
			end
		end
		
		wait((animationTrack.Length * 0.35) / animationTrack.Speed)
		if isAbilitySource then
			
			network:invoke("setMovementVelocity", Vector3.new())
			network:invoke("setCharacterArrested", false)
		
			local localCharacter = game.Players.LocalPlayer.Character	
			if localCharacter then
				physics:setWholeCollisionGroup(localCharacter, "characters")
			end
			
			if movementVelocity then
				network:fire("applyJoltVelocityToCharacter", movementVelocity * 40)
			end
		end	
		if trail then
			trail.Enabled = false
			game.Debris:AddItem(trail, 1)
		end
	end
	
	if isAbilitySource then
		network:fireServer("abilityFireServerCall", abilityExecutionData, self.id)
	end
end

return abilityData