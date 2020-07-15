local abilityAnimations = game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local debris = game:GetService("Debris")
local runService = game:GetService("RunService")

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local network 			= modules.load("network")
	local damage 			= modules.load("damage")
	local placeSetup 		= modules.load("placeSetup")
	local tween	 			= modules.load("tween")
	local ability_utilities = modules.load("ability_utilities")
	local effects           = modules.load("effects")
	local projectile        = modules.load("projectile")

local entitiesFolder = placeSetup.awaitPlaceFolder("entities")

local abilityData = {
	id = 52,
	
	name = "Earthcall",
	image = "rbxassetid://4079577918",
	description = "Hurl a boulder at your target, damaging and stunning them if it hits.",
	mastery = "",
	
	maxRank = 10,
	
	statistics = ability_utilities.calculateStats{
		maxRank = 10,
		static = {
			cooldown = 4,
		},
		staggered = {
			damageMultiplier = {first = 1, final = 3, levels = {2, 4, 6, 8, 10}},
			stunDuration = {first = 1, final = 3, levels = {3, 5, 7, 9}},
		},
		pattern = {
			manaCost = {base = 6, pattern = {2, 4}},
		},
	},
	
	windupTime = 0.9,
	castingSpeed = 1.5,
	
	securityData = {
		playerHitMaxPerTag = 1,
		isDamageContained = true,
		projectileOrigin = "character",
	},
	
	abilityDecidesEnd = true,
	
	equipmentTypeNeeded = "staff",
	disableAutoaim = true,
	
	projectileSpeed = 128,
	
	targetingData = {
		targetingType = "projectile",
		projectileSpeed = "projectileSpeed",
		projectileGravity = 1,
		
		onStarted = function(entityContainer, executionData)
			local attachment = network:invoke("getCurrentlyEquippedForRenderCharacter", entityContainer.entity)["1"].manifest.magic
			
			local emitter = script.targetingEmitter:Clone()
			emitter.Parent = attachment
			
			return {emitter = emitter, projectionPart = attachment}
		end,
		
		onEnded = function(entityContainer, executionData, data)
			data.emitter.Enabled = false
			game:GetService("Debris"):AddItem(data.emitter, data.emitter.Lifetime.Max)
		end
	},
}

function abilityData._serverProcessDamageRequest(sourceTag, baseDamage)
	if sourceTag == "boulder" then
		return baseDamage, "magical", "projectile"
	end
end

local function stun(player, abilityExecutionData, target)
	local char = player.Character
	if not char then return end
	local manifest = char.PrimaryPart
	if not manifest then return end
	
	local stats = abilityExecutionData["ability-statistics"]
	network:invoke(
		"applyStatusEffectToEntityManifest",
		target,
		"stunned",
		{
			duration = stats.stunDuration,
			modifierData = {
				walkspeed_totalMultiplicative = -1,
			},
		},
		manifest,
		"ability",
		abilityData.id
	)
end

function abilityData:execute_server(player, abilityExecutionData, isAbilitySource)
	if not isAbilitySource then return end
	
	local remote = Instance.new("RemoteEvent")
	remote.Name = "EarthcallTemporarySecureRemote"
	remote.OnServerEvent:Connect(function(...)
		stun(...)
		remote:Destroy()
	end)
	remote.Parent = game.ReplicatedStorage
	debris:AddItem(remote, 30)
	
	return remote
end

function abilityData:execute(renderCharacterContainer, abilityExecutionData, isAbilitySource, guid)
	local windupTime = self.windupTime / self.castingSpeed
	
	-- assurances
	local root = renderCharacterContainer.PrimaryPart
	if not root then return end
	local entity = renderCharacterContainer:FindFirstChild("entity")
	if not entity then return end
	local weapons = network:invoke("getCurrentlyEquippedForRenderCharacter", renderCharacterContainer.entity)
	local weaponManifest = weapons["1"] and weapons["1"].manifest
	if not weaponManifest then return end
	local weaponMagic = weaponManifest:FindFirstChild("magic")
	if not weaponMagic then return end
	local castEffect = weaponMagic:FindFirstChild("castEffect")
	if not castEffect then return end
	local manifest = renderCharacterContainer.clientHitboxToServerHitboxReference.Value
	if not manifest then return end
	
	-- shorthand update function
	local function updateAbilityExecution()
		if not isAbilitySource then return end
		
		local newAbilityExecutionData = network:invoke("getAbilityExecutionData", abilityData.id, abilityExecutionData)
		newAbilityExecutionData["ability-state"] = "update"
		newAbilityExecutionData["ability-guid"] = guid
		network:invoke("client_changeAbilityState", abilityData.id, "update", newAbilityExecutionData, guid)
	end
	
	if abilityExecutionData["ability-state"] == "begin" then
		-- animation
		local track = entity.AnimationController:LoadAnimation(abilityAnimations["mage_strike_down_top"])
		track:Play(nil, nil, self.castingSpeed)
		
		-- activate particles and wind up the attack
		castEffect.Enabled = true
		
		-- play a charge sound
		local chargeSound = script.charge:Clone()
		chargeSound.Parent = root
		chargeSound:Play()
		
		-- grow a boulder over time
		do
			local boulder = script.boulder:Clone()
			boulder:ClearAllChildren()
			local goalSize = boulder.Size
			boulder.Size = Vector3.new(0, 0, 0)
			boulder.Parent = entitiesFolder
			
			effects.onHeartbeatFor(windupTime, function(dt, t, w)
				boulder.Size = goalSize * w
				boulder.CFrame = weaponMagic.WorldCFrame
				if w == 1 then
					boulder:Destroy()
				end
			end)
		end
		
		-- pause for effect
		wait(windupTime)
		
		-- stop gracefully
		track:Stop(0.25)
		castEffect.Enabled = false
		
		-- stop charge sound
		chargeSound:Stop()
		chargeSound:Destroy()
		
		updateAbilityExecution()
	
	elseif abilityExecutionData["ability-state"] == "update" then
		-- get remote
		local stunRemote
		if isAbilitySource then
			 stunRemote = network:invokeServer("abilityInvokeServerCall", abilityExecutionData, self.id)
		end
		
		-- casting sound
		local castSound = script.cast:Clone()
		castSound.Parent = root
		castSound:Play()
		debris:AddItem(castSound, castSound.TimeLength)
		
		-- launch the projectile!
		local targetPoint = abilityExecutionData["mouse-target-position"]
		local castingPlayer = ability_utilities.getCastingPlayer(abilityExecutionData)
		
		local boulder = script.boulder:Clone()
		local trail = boulder.trail
		local emitter = boulder.emitter
		boulder.Parent = entitiesFolder
		
		local ignoreList = projectile.makeIgnoreList{
			renderCharacterContainer,
			manifest
		}
		
		local direction = projectile.getUnitVelocityToImpact_predictive(
			weaponMagic.WorldPosition,
			self.projectileSpeed,
			targetPoint,
			Vector3.new(),
			1
		)
		
		projectile.createProjectile(
			weaponMagic.WorldPosition,
			
			direction or (targetPoint - weaponMagic.WorldPosition).Unit,
			
			self.projectileSpeed,
			
			boulder,
			
			function(hitPart)
				-- deactivate effects gracefully
				boulder.Transparency = 1
				trail.Enabled = false
				emitter:Emit(8)
				debris:AddItem(boulder, math.max(trail.Lifetime, emitter.Lifetime.Max))
				boulder.hit:Play()
				
				-- do damage and swap
				local canDamage, target = damage.canPlayerDamageTarget(castingPlayer, hitPart)
				if canDamage then
					if isAbilitySource then
						stunRemote:FireServer(abilityExecutionData, target)
						network:fire("requestEntityDamageDealt", target, boulder.Position, "ability", self.id, "boulder", guid)
					end
				end
			end,
			
			function(t)
				return CFrame.new()
			end,
			
			ignoreList,
			
			false,
			
			1
		)
		
		network:fire("setIsPlayerCastingAbility", false)
		network:invoke("client_changeAbilityState", abilityData.id, "end")
	end
end

return abilityData