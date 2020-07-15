local metadata = {
	cost = 2;
	upgradeCost = 2;
	maxRank = 8;
	
	requirement = function(playerData)
		return true;
	end;
	
	variants = {
		regeneration = {
			default = true;
			cost = 0;
			requirement = function(playerData)
				return true
			end;			
		};
		darkRitual = {
			cost = 1;
			requirement = function(playerData)
				return playerData.nonSerializeData.statistics_final.vit >= 10
			end;
		};
		haste = {
			cost = 1;
			requirement = function(playerData)
				return playerData.nonSerializeData.statistics_final.dex >= 10
			end;
		};		
	}	
}

local ABILITY_ID = 2

local debris = game:GetService("Debris")
local runService = game:GetService("RunService")
local abilityAnimations = game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
local network = modules.load("network")
	local damage 			= modules.load("damage")
	local placeSetup 		= modules.load("placeSetup")
	local tween	 			= modules.load("tween")
	local effects           = modules.load("effects")
	local ability_utilities = modules.load("ability_utilities")

local entitiesFolder = placeSetup.awaitPlaceFolder("entities")

-- being as barebones as possible to try to break things
local defaultData = {
	id = ABILITY_ID;
	metadata = metadata;
}
local regenerationData = {
	--> identifying information <--
	id 	= ABILITY_ID;
	metadata = metadata;
	--> generic information <--
	name 		= "Regeneration";
	image 		= "rbxassetid://2528901754";
	description = "Restore some health over time.";
		
	--> execution information <--
	statistics = {
		[1] = {
			cooldown 	= 12;
			healing		= 60;
			duration 	= 5;
			manaCost	= 15;
		};
		[2] = {
			healing		= 100;
			duration 	= 5;
			manaCost	= 25;
		};		
		[3] = {
			healing		= 140;
			duration 	= 7;
			manaCost	= 28;
		};	
		[4] = {
			healing		= 210;
			duration 	= 7;
			manaCost	= 42;
		};		
		[5] = {
			healing		= 280;
			duration 	= 7;
			manaCost	= 56;
		};		
		[6] = {
			healing		= 360;
			duration 	= 9;
			manaCost	= 60;
		};	
		[7] = {
			healing		= 480;
			duration 	= 9;
			manaCost	= 80;
		};
		[8] = {
			healing		= 700;
			duration 	= 10;
			manaCost	= 100;
			tier = 3;
		};										
	};
	
	maxRank 	= 8;
	
	startAbility_server = function(self, sourcePlayer, targetPlayer, abilityExecutionData)
								-- 											 statusEffectId, sourcePlayer, sourceType, sourceId, 		playerCastOn)
		--local wasApplied, reason = network:invoke("applyPlayerStatusEffect", "regenerate", 	 sourcePlayer, "ability",  self.id,  targetPlayer or sourcePlayer)
		--local wasApplied, reason = network:invoke("applyPlayerStatusEffect", sourcePlayer, "ability", self.id, targetPlayer)
			
		local playerData = network:invoke("getPlayerData", targetPlayer)
		
		if playerData then
			--local abilityStatistics = network:invoke("getAbilityStatisticsForRank", abilityData, network:invoke("getPlayerAbilityRankByAbilityId", sourcePlayer, abilityData.id))
			
			local abilityStatistics = abilityExecutionData["ability-statistics"]
			
			local duration = abilityStatistics["duration"]
			local regeneration = abilityStatistics["healing"]
			
			local wasApplied, reason = network:invoke("applyStatusEffectToEntityManifest", targetPlayer.Character.PrimaryPart, "regenerate", {
				healthToHeal 	= regeneration;
				duration 		= abilityStatistics["duration"];
			}, sourcePlayer.Character.PrimaryPart, "ability", self.id, abilityExecutionData.variant)
		
			return wasApplied, reason
		end
		
		return false, "no player data"
	end;
	
	stopAbility_server = function(self, sourcePlayer, targetPlayer)
		--network:invoke("removePlayerStatusEffect", sourcePlayer, "ability", self.id, targetPlayer)
	end;
			
	execute = function(self, renderCharacterContainer, abilityExecutionData, isAbilitySource, guid)
		if not renderCharacterContainer.PrimaryPart then return end
		
	
		local regeneration_specks 	= script.regeneration_specks:Clone()
		regeneration_specks.Parent 	= renderCharacterContainer.PrimaryPart
		
		local regeneration_sound 	= script.regeneration_sound:Clone()
		regeneration_sound.Parent 	= renderCharacterContainer.PrimaryPart
		regeneration_sound:Play()
		game.Debris:AddItem(regeneration_sound,3)
		-- edit, just make the particles last 1 sec
		spawn(function()
			wait(1)
			regeneration_specks.Enabled = false
		end)
		game.Debris:AddItem(regeneration_specks,3)
	end;	
	cleanup = function(self, renderCharacterContainer)
		if not renderCharacterContainer.PrimaryPart then return end
	end;
	onStatusEffectBegan = function(self, renderCharacterContainer)
	
	end;
	onStatusEffectEnded = function(self, renderCharacterContainer)
	
	end									
}
local hasteData = {
	--> identifying information <--
	id 	= ABILITY_ID;
	metadata = metadata;
	--> generic information <--
	name 		= "Haste";
	image 		= "rbxassetid://4830540307";
	description = "Temporarily increase movement speed and stamina recovery.";
		
	--> execution information <--
	statistics = {
		[1] = {
			cooldown = 20;
			walkspeed = 1;
			staminaRecovery	= 0.5;
			duration = 6;
			manaCost = 10;
		};	
		[2] = {
			staminaRecovery	= 1;
			manaCost = 12;
		};			
		[3] = {
			duration = 9;
			manaCost = 16;
		};	
		[4] = {
			walkspeed = 2;
			manaCost = 22;
		};
		[5] = {
			duration = 12;
			manaCost = 26;
		};				
		[6] = {
			staminaRecovery	= 1.5;
			manaCost = 28;
		};
		[7] = {
			walkspeed = 3;
			manaCost = 34;
		};							
		[8] = {
			cooldown = 15;
			tier = 3;
		};													
	};
	
	maxRank 	= 8;
	
	startAbility_server = function(self, sourcePlayer, targetPlayer, abilityExecutionData)
								-- 											 statusEffectId, sourcePlayer, sourceType, sourceId, 		playerCastOn)
		--local wasApplied, reason = network:invoke("applyPlayerStatusEffect", "regenerate", 	 sourcePlayer, "ability",  self.id,  targetPlayer or sourcePlayer)
		--local wasApplied, reason = network:invoke("applyPlayerStatusEffect", sourcePlayer, "ability", self.id, targetPlayer)
			
		local playerData = network:invoke("getPlayerData", targetPlayer)
		
		if playerData then
			--local abilityStatistics = network:invoke("getAbilityStatisticsForRank", abilityData, network:invoke("getPlayerAbilityRankByAbilityId", sourcePlayer, abilityData.id))
			
			local abilityStatistics = abilityExecutionData["ability-statistics"]
			
			local duration = abilityStatistics["duration"]
			local regeneration = abilityStatistics["healing"]
			
			local wasApplied, reason = network:invoke("applyStatusEffectToEntityManifest", targetPlayer.Character.PrimaryPart, "empower", {
				modifierData = {
					walkspeed = abilityStatistics["walkspeed"];
					staminaRecovery = abilityStatistics["staminaRecovery"];
				},
				duration 		= abilityStatistics["duration"];
				variant 		= "haste";
			}, sourcePlayer.Character.PrimaryPart, "ability", self.id, abilityExecutionData.variant)
		
			return wasApplied, reason
		end
		
		return false, "no player data"
	end;

			
	execute = function(self, renderCharacterContainer, abilityExecutionData, isAbilitySource, guid)
		if not renderCharacterContainer.PrimaryPart then return end
		
	
		local regeneration_specks 	= script.haste_specks:Clone()
		regeneration_specks.Parent 	= renderCharacterContainer.PrimaryPart
		
		local regeneration_sound 	= script.haste_sound:Clone()
		regeneration_sound.Parent 	= renderCharacterContainer.PrimaryPart
		regeneration_sound:Play()
		game.Debris:AddItem(regeneration_sound,3)
		regeneration_specks.Enabled = false
		regeneration_specks:Emit(10)
		game.Debris:AddItem(regeneration_specks,5)
	end;	
								
}

local darkRitualData = {
	id = ABILITY_ID,
	metadata = metadata;
	name = "Dark Ritual",
	image = "rbxassetid://4827276298",
	description = "Sacrifice your own health to gain mana.",
	maxRank = 8,	
	LURCH_DURATION = 0.75,
	LURCH_HITS = 3,
		
	statistics = {
		[1] = {
			cooldown = 1,
			manaCost = 0,
			healthCost = 100,
			manaRestored = 50,
		},
		[2] = {
			healthCost = 150,
			manaRestored = 75,
		},
		[3] = {
			healthCost = 200,
			manaRestored = 100,
		},
		[4] = {
			healthCost = 250,
			manaRestored = 125,
		},
		[5] = {
			healthCost = 300,
			manaRestored = 150,
		},
		[6] = {
			healthCost = 350,
			manaRestored = 175,
		},
		[7] = {
			healthCost = 400,
			manaRestored = 200,
		},
		[8] = {
			healthCost = 500,
			manaRestored = 250,
			tier = 3;
		},																	
	};
	
	securityData = {
		playerHitMaxPerTag = 64,
		projectileOrigin = "character",
	},
	
	disableAutoaim = true,
	

	
	darkEffect = function(partA, partB, spin, duration, bezierStretch)
		
		local dark = script.dark:Clone()
		local trail = dark.trail
		dark.CFrame = partA.CFrame
		dark.Parent = entitiesFolder
		
		local offsetB = CFrame.Angles(0, 0, spin) * CFrame.new(0, bezierStretch, 0)
		local offsetC = CFrame.Angles(0, 0, -spin) * CFrame.new(0, bezierStretch, 0)
		
		effects.onHeartbeatFor(duration, function(dt, t, w)
			local startToFinish = CFrame.new(partA.Position, partB.Position)
			local finishToStart = CFrame.new(partB.Position, partA.Position)
			
			local a = startToFinish.Position
			local b = (startToFinish * offsetB).Position
			local c = (finishToStart * offsetC).Position
			local d = finishToStart.Position
		
			local ab = a + (b - a) * w
			local cd = c + (d - c) * w
			local p = ab + (cd - ab) * w
			
			dark.CFrame = CFrame.new(p)
		end)
		
		delay(duration, function()
			dark.Transparency = 1
			trail.Enabled = false
			debris:AddItem(dark, trail.Lifetime)
		end)
	end;	
	
	execute_server = function(self, player, abilityExecutionData, isAbilitySource)
		if not isAbilitySource then return end
		
		local character = player.Character
		if not character then return end
		local manifest = character.PrimaryPart
		if not manifest then return end
		local health = manifest:FindFirstChild("health")
		if not health then return end
		local mana = manifest:FindFirstChild("mana")
		if not mana then return end
		local maxMana = manifest:FindFirstChild("maxMana")
		if not maxMana then return end
		
		local damage = abilityExecutionData["ability-statistics"]["healthCost"]
		local manaRestored = abilityExecutionData["ability-statistics"]["manaRestored"]
		
		local health = manifest:FindFirstChild("health")
		if not health then return end
		
		local damagePerStep = damage / self.LURCH_HITS
		local stepTime = self.LURCH_DURATION / self.LURCH_HITS
		
		spawn(function()
			local desiredHealth = health.Value
			
			for _ = 1, self.LURCH_HITS do
				if health.Value > 0 then
					desiredHealth = health.Value - damagePerStep
					health.Value = desiredHealth
					if health.Value <= 0 then
						if player.Character.PrimaryPart.health.Value <= 0 then
							local text = "☠ " .. player.Name .. " sacrificed more than they could afford to ☠"
							network:fireAllClients("signal_alertChatMessage", {
								Text = text,
								Font = Enum.Font.SourceSansBold,
								Color = Color3.fromRGB(255, 130, 100),
							})					
						end						
					end
					wait(stepTime)
				end
			end
		end)		
		
		wait(self.LURCH_DURATION)
		mana.Value = math.min(mana.Value + manaRestored, maxMana.Value)
	end;			

	execute = function(self, renderCharacterContainer, abilityExecutionData, isAbilitySource, guid)
		local root = renderCharacterContainer.PrimaryPart
		if not root then return end
		local entity = renderCharacterContainer:FindFirstChild("entity")
		if not entity then return end
		local upperTorso = entity:FindFirstChild("UpperTorso")
		if not upperTorso then return end
		local hitboxRef = renderCharacterContainer:FindFirstChild("clientHitboxToServerHitboxReference")
		if not hitboxRef then return end
		local manifest = hitboxRef.Value
		if not manifest then return end
		
		-- first thing to do is spawn off the server call
		if isAbilitySource then
			network:fireServer("abilityFireServerCall", abilityExecutionData, self.id)
		end
		
		-- now we can do fake stuff
		local damage = abilityExecutionData["ability-statistics"]["healthCost"]
		
		local track = renderCharacterContainer.entity.AnimationController:LoadAnimation(abilityAnimations["warlock_dark_ritual"])
		track:Play()
		
		-- effects
		local attachment = Instance.new("Attachment")
		attachment.Parent = upperTorso
		local darkEmitter = script.darkEmitter:Clone()
		darkEmitter.Parent = attachment
		local manaEmitter = script.manaEmitter:Clone()
		manaEmitter.Parent = attachment
		
		-- do a fake, client-sided damage
--		self.injureOverTime(manifest, damage, self.LURCH_DURATION, self.LURCH_HITS)
		
		-- sound for getting hurt
		local damageSound = script.damage:Clone()
		damageSound.Parent = root
		damageSound:Play()
		debris:AddItem(damageSound, damageSound.TimeLength)
		
		-- let the dark emitter emit for the lurch
		wait(self.LURCH_DURATION - darkEmitter.Lifetime.Max)
		
		-- turn the emitter off at the moment such that
		-- when the lurch is finished, the dark is gone
		darkEmitter.Enabled = false
		
		-- wait for the dark to be gone
		wait(darkEmitter.Lifetime.Max)
		
		-- emit some mana!
		manaEmitter:Emit(64)
		
		-- sound for restoring mana
		local manaSound = script.restore:Clone()
		manaSound.Parent = root
		manaSound:Play()
		debris:AddItem(manaSound, manaSound.TimeLength)
		
		-- get rid of everything when the mana is done
		debris:AddItem(attachment, manaEmitter.Lifetime.Max)
	end	
				
}


function generateAbilityData(playerData, abilityExecutionData)
	abilityExecutionData = abilityExecutionData or {}
	if playerData then
		local variant
		for i, ability in pairs(playerData.abilities) do
			if ability.id == ABILITY_ID then
				variant = ability.variant
			end
		end
		abilityExecutionData.variant = variant or "regeneration"
	end

	if abilityExecutionData.variant == "regeneration" then
		return regenerationData
	elseif abilityExecutionData.variant == "darkRitual" then
		return darkRitualData
	elseif abilityExecutionData.variant == "haste" then
		return hasteData
	end
	
	-- default (barebones as possible to try to break things)
	return defaultData
end

return generateAbilityData




