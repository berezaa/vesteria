local abilityAnimations = game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local projectile 		= modules.load("projectile")
	local placeSetup 		= modules.load("placeSetup")
	local client_utilities 	= modules.load("client_utilities")
	local network 			= modules.load("network")
	local detection 		= modules.load("detection")
	local damage 			= modules.load("damage")

local metadata = {
	cost = 2;
	upgradeCost = 2;
	maxRank = 8;
	layoutOrder = 3;
	
	requirement = function(playerData)
		return playerData.class == "Hunter";
	end;
}


local entityManifestCollectionFolder = placeSetup.awaitPlaceFolder("entityManifestCollection")

local httpService = game:GetService("HttpService")

local abilityData = {
	--> identifying information <--
	id 	= 6;
	book 		= "hunter";
	metadata = metadata;
	--> generic information <--
	name 		= "Execute";
	image 		= "rbxassetid://3736597640";
	description = "A powerful finisher. Resets cooldown if it lands a kill.";
	
	damageType = "physical";
		
	prerequisite = {{id = 7; rank = 1}};
	layoutOrder = 2;			
		
	--> execution information <--
	animationName 		= {"dagger_execute"};
	windupTime 			= 0.1;
	maxRank 			= 10;
	resetCooldownOnKill = true;
	
	--> combat stats <--
	statistics = {
		[1] = {
			damageMultiplier 	= 2;
			manaCost 			= 10;
			cooldown 			= 6;
		}; [2] = {
			damageMultiplier 	= 2.2;
			manaCost 			= 11;
		}; [3] = {
			damageMultiplier 	= 2.4;
			manaCost 			= 12;
		}; [4] = {
			damageMultiplier 	= 2.6;
			manaCost 			= 13;			
		}; [5] = {
			damageMultiplier 	= 2.9;
			manaCost 			= 15;
			cooldown 			= 5;
			tier 				= 3;	
		}; [6] = {
			damageMultiplier 	= 3.2;
			manaCost 			= 17;	
		}; [7] = {
			damageMultiplier 	= 3.5;
			manaCost 			= 19;	
		}; [8] = {
			damageMultiplier 	= 4.0;
			manaCost 			= 22;
			tier 				= 4;	
		};
	};
	
	securityData = {
		playerHitMaxPerTag 	= 1;
--		maxHitLockout 		= 1;
		isDamageContained 	= true;
	};
	
	damage 		= 50;
	maxRange 	= 30;
	equipmentTypeNeeded = "dagger";
}

function abilityData._abilityExecutionDataCallback(playerData, ref_abilityExecutionData)
	ref_abilityExecutionData["one good hit"] = playerData and playerData.nonSerializeData.statistics_final.activePerks["one good hit"]
end

function abilityData._serverProcessDamageRequest(sourceTag, baseDamage)
	if sourceTag == "strike" then
		return baseDamage, "physical", "direct"
	elseif sourceTag == "shadowblast" then
		return baseDamage * 1.5, "magical", "aoe"
	end
end

local function explode(playerSource)
	local explosionBall = Instance.new("Part")
	local scaler = Instance.new("SpecialMesh")
	
	explosionBall.Size = Vector3.new(explodeRadius*2,explodeRadius*2,explodeRadius*2)
	explosionBall.Shape = Enum.PartType.Ball
	explosionBall.Color = Color3.fromRGB(255,255,255)
	explosionBall.Anchored = true
	explosionBall.CanCollide = false
	explosionBall.Material = Enum.Material.Neon
	explosionBall.CFrame = CFrame.new(hitPosition)
	
	scaler.Scale = Vector3.new(0,0,0)
	scaler.MeshType = Enum.MeshType.Sphere
	scaler.Parent = explosionBall
	
	explosionBall.Parent = workspace.CurrentCamera
	
	tween(explosionBall, {"Transparency"}, {1}, explodeDurration, Enum.EasingStyle.Linear)
	tween(explosionBall, {"Color"}, {Color3.fromRGB(0,255,100)}, explodeDurration, Enum.EasingStyle.Linear)
	tween(scaler, {"Scale"}, {Vector3.new(1,1,1) * 1.25}, explodeDurration, Enum.EasingStyle.Quint)
	game:GetService("Debris"):AddItem(explosionBall, explodeDurration*1.15)
	
	-- do some AOE dmg
	if associatePlayer == client then
		for i, v in pairs(damage.getDamagableTargets(client)) do
			local vSize = (v.Size.X + v.Size.Y + v.Size.Z)/6
			if (v.Position - hitPosition).magnitude <= (explodeRadius) + vSize and v ~= needsToHit then
				delay(0.1, function()
					network:fire("requestEntityDamageDealt", v, hitPosition, "equipment")
				end)
			end
		end
		if needsToHit then
			delay(0.1, function()
				network:fire("requestEntityDamageDealt", needsToHit, hitPosition, "equipment")
			end)
		end
	end
end

function abilityData.onPlayerKilledMonster_server(player, monster)
	local playerData = network:invoke("getPlayerData", player)
	if playerData then
		local abilityRank = network:invoke("getPlayerAbilityRankByAbilityId", player, abilityData.id)
		local stats = playerData.nonSerializeData.statistics_final
		local abilityStats = abilityData.statistics[abilityRank]
				
		local healAmt = 0
		local manaAmt = 0
		local manaCost = abilityStats.manaCost
							
		if stats.vit >= 30 then
			healAmt = 40
		end
		if stats.vit >= 60 then
			healAmt = 100
		end
		if stats.vit >= 100 then
			healAmt = 150
			manaAmt = manaCost
		end
		
		local character = player.Character
		if not character then return end
		local manifest = character.PrimaryPart
		if not manifest then return end
		local health = manifest:FindFirstChild("health")
		if not health then return end
		local maxHealth = manifest:FindFirstChild("maxHealth")
		if not maxHealth then return end
		local mana = manifest:FindFirstChild("mana")
		if not mana then return end
		local maxMana = manifest:FindFirstChild("maxMana")
		if not maxMana then return end
		
		health.Value = math.min(health.Value + healAmt, maxHealth.Value)
		mana.Value = math.min(mana.Value + manaAmt, maxMana.Value)
	end
end

function abilityData:execute_server(player, abilityExecutionData, isAbilitySource, entity)
	if not isAbilitySource then return end
	
	if abilityExecutionData["one good hit"] then
		-- can't affect resilient targets
		if entity:FindFirstChild("resilient") then return end
		
		local health = entity:FindFirstChild("health")
		if not health then return end
		local maxHealth = entity:FindFirstChild("maxHealth")
		if not maxHealth then return end
		
		-- only proceed if they're under 25% health
		if (health.Value / maxHealth.Value) > 0.25 then return end
		
		local entityType = entity:FindFirstChild("entityType")
		if not entityType then return end
		entityType = entityType.Value
		
		local damageData = {
			damage = health.Value * 2,
			sourceType = "ability",
			sourceId = self.id,
			damageType = "physical",
			sourcePlayerId = player.UserId,
		}
		
		if entityType == "monster" then
			network:invoke("monsterDamageRequest_server", player, entity, damageData)
		else
			network:invoke("playerDamageRequest_server", player, entity, damageData)
		end
	end
end

function abilityData:validateDamageRequest(monsterManifest, hitPosition)
	return (monsterManifest - hitPosition).magnitude <= 8
end 

function abilityData:execute(renderCharacterContainer, 	abilityExecutionData, isAbilitySource, guid)
	-- todo: fix
	if not renderCharacterContainer:FindFirstChild("entity") then return end
	
	local currentlyEquipped 	= network:invoke("getCurrentlyEquippedForRenderCharacter", renderCharacterContainer.entity)
	local currentWeaponManifest = currentlyEquipped["1"] and currentlyEquipped["1"].manifest
	if not currentWeaponManifest then return end
	
	local animationTrack = renderCharacterContainer.entity.AnimationController:LoadAnimation(abilityAnimations[self.animationName[1]])
	animationTrack:Play()
	
	if renderCharacterContainer.PrimaryPart then
		local sound = script.sound:Clone()
		sound.Parent = renderCharacterContainer.PrimaryPart
		sound:Play()
		game.Debris:AddItem(sound,5)
	end	
	
	local dust = script.Dust:Clone()
	dust.Parent = currentWeaponManifest
	dust.Enabled = true
							
	game.Debris:AddItem(dust, 3)
	
	
	wait(self.windupTime)
	
	-- todo: fix
	if not renderCharacterContainer:FindFirstChild("entity") then return end
	
	if isAbilitySource then
		local hitDebounceTable = {}
		local damagableTargets = damage.getDamagableTargets(game.Players.LocalPlayer)
		while animationTrack.IsPlaying do
			-- todo: consider just using serverHitbox in `monsterManifestCollectionFolder` ?
			for i, monsterManifest in pairs(damagableTargets) do
				if not hitDebounceTable[monsterManifest] then
					local boxcastOriginCF 	= currentWeaponManifest.CFrame
					local boxProjection_serverHitbox = detection.projection_Box(monsterManifest.CFrame, monsterManifest.Size, boxcastOriginCF.p)
					if detection.boxcast_singleTarget(boxcastOriginCF, currentWeaponManifest.Size * Vector3.new(4, 4, 4), boxProjection_serverHitbox) then
						hitDebounceTable[monsterManifest] = true
						
						if dust then
							local dustPart = Instance.new("Part")
							dustPart.CFrame = CFrame.new(boxProjection_serverHitbox)
							dustPart.CanCollide = false
							dustPart.Anchored = true
							dustPart.Transparency = 1
							dustPart.Parent = workspace.CurrentCamera							
							
							local dustCopy = dust:Clone()
							dustCopy.Parent = dustPart
							dustCopy.Enabled = false
							dustCopy:Emit(50)
							
							game.Debris:AddItem(dustPart,5)
						end
						
						network:fire("requestEntityDamageDealt", monsterManifest, boxProjection_serverHitbox, "ability", self.id, "strike", guid)
						
						if abilityExecutionData["one good hit"] then
							network:fireServer("abilityFireServerCall", abilityExecutionData, self.id, monsterManifest)
						end
					end
				end
			end
			
			wait(1 / 20)
		end
		if dust then
			dust.Enabled = false
			game.Debris:AddItem(dust, 2)
		end
	end
end

return abilityData