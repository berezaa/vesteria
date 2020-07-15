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
	id = 41,
	
	name = "Switch Strike",
	image = "rbxassetid://4079576879",
	description = "Fling a whimsical spell which harms its target and then makes it switch places with you.",
	mastery = "More damage.",
	
	maxRank = 10,
	
	statistics = ability_utilities.calculateStats{
		maxRank =  10,
		static = {
			cooldown = 6,
		},
		staggered = {
			damageMultiplier = {first = 2, final = 3.6, levels = {2, 3, 5, 6, 8, 9}},
			projectileSpeed = {first = 50, final = 100, levels = {4, 7, 10}},
		},
		pattern = {
			manaCost = {base = 10, pattern = {2, 2, 4}},
		},
	},
	
	windupTime = 0.55,
	
	securityData = {
		playerHitMaxPerTag = 1,
		isDamageContained = true,
		projectileOrigin = "character",
	},
	
	abilityDecidesEnd = true,
	resetCooldownOnKill = true,
	
	targetingData = {
		targetingType = "projectile",
		projectileSpeed = 64,
		projectileGravity = 0.0001,
		
		onStarted = function(entityContainer, executionData)
			local track = entityContainer.entity.AnimationController:LoadAnimation(abilityAnimations.left_hand_targeting_sequence)
			track:Play()
			
			local projectionPart = entityContainer.entity.LeftHand
			
			return {track = track, projectionPart = projectionPart}
		end,
		
		onEnded = function(entityContainer, executionData, data)
			data.track:Stop()
		end
	},
}

local BOLT_COLORS = {
	BrickColor.new("Bright red"),
	BrickColor.new("Bright orange"),
	BrickColor.new("Bright yellow"),
	BrickColor.new("Bright green"),
	BrickColor.new("Bright blue"),
	BrickColor.new("Bright violet"),
}
local BOLT_COLOR_COUNT = #BOLT_COLORS

function createEffectPart()
	local part = Instance.new("Part")
	part.Anchored = true
	part.CanCollide = false
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	return part
end

function abilityData._serverProcessDamageRequest(sourceTag, baseDamage)
	if sourceTag == "bolt" then
		return baseDamage, "magical", "projectile"
	end
end

local function isResilient(manifest)
	return manifest:FindFirstChild("resilient") ~= nil
end

function swap(player, monster)
	local char = player.Character
	if not char then return end
	local root = char.PrimaryPart
	if not root then return end
	
	local cframeA = root.CFrame
	local cframeB = monster.CFrame
	
	if not isResilient(monster) then
		network:invoke("teleportPlayerCFrame_server", player, cframeB)
		monster.CFrame = cframeA
	end
end

function abilityData:execute_server(player, abilityExecutionData, isAbilitySource)
	if not isAbilitySource then return end
	
	local remote = Instance.new("RemoteEvent")
	remote.Name = "SwitchStrikeTemporarySecureRemote"
	remote.OnServerEvent:Connect(function(...)
		swap(...)
		remote:Destroy()
	end)
	remote.Parent = game.ReplicatedStorage
	debris:AddItem(remote, 30)
	
	return remote
end

function abilityData:execute(renderCharacterContainer, abilityExecutionData, isAbilitySource, guid)
	-- assurances
	local root = renderCharacterContainer.PrimaryPart
	if not root then return end
	local entity = renderCharacterContainer:FindFirstChild("entity")
	if not entity then return end
	local leftHand = entity:FindFirstChild("LeftHand")
	if not leftHand then return end
	local manifest = renderCharacterContainer.clientHitboxToServerHitboxReference.Value
	if not manifest then return end
	
	if abilityExecutionData["ability-state"] == "begin" then
		-- animation
		local track = renderCharacterContainer.entity.AnimationController:LoadAnimation(abilityAnimations["mage_cast_left_hand_top"])
		track:Play()
		
		-- emitter
		local attachment = Instance.new("Attachment")
		attachment.Name = "SwitchStrikeEmitterAttachment"
		attachment.Parent = leftHand
		
		local emitter = script.whimsyEmitter:Clone()
		emitter.Parent = attachment
		
		-- play a charge sound
		local chargeSound = script.charge:Clone()
		chargeSound.Parent = leftHand
		chargeSound:Play()
		
		-- turn off emitter so that it's finished when the windup is done
		delay(self.windupTime - emitter.Lifetime.Max, function()
			emitter.Enabled = false
		end)
		
		-- pause for effect
		wait(self.windupTime)
		
		-- stop charge sound
		chargeSound:Stop()
		chargeSound:Destroy()
		
		-- casting sound
		local castSound = script.cast:Clone()
		castSound.Parent = leftHand
		castSound:Play()
		debris:AddItem(castSound, castSound.TimeLength)
		
		if isAbilitySource then
			local newAbilityExecutionData = network:invoke("getAbilityExecutionData", abilityData.id, abilityExecutionData)
			newAbilityExecutionData["ability-state"] = "update"
			newAbilityExecutionData["ability-guid"] = guid
			network:invoke("client_changeAbilityState", abilityData.id, "update", newAbilityExecutionData, guid)
		end
		
	elseif abilityExecutionData["ability-state"] == "update" then
		local swapRemote
		if isAbilitySource then
			 swapRemote = network:invokeServer("abilityInvokeServerCall", abilityExecutionData, self.id)
		end
		
		-- launch the projectile!
		local startPoint = leftHand.Position
		local projectileSpeed = abilityExecutionData["ability-statistics"]["projectileSpeed"]
		local targetPoint = abilityExecutionData["mouse-target-position"]
		local direction = (targetPoint - startPoint).Unit
		
		-- local direction, targetPoint = projectile.getUnitVelocityToImpact_predictiveByAbilityExecutionData(startPoint, projectileSpeed, abilityExecutionData, 0)
		
		local castingPlayer = ability_utilities.getCastingPlayer(abilityExecutionData)
		
		local bolt = script.bolt:Clone()
		local trails = {bolt.trailBot, bolt.trailTop}
		bolt.Parent = entitiesFolder
		
		local ignoreList = projectile.makeIgnoreList{
			renderCharacterContainer,
			manifest
		}
		
		local boltSpinX = math.pi * 8 * math.random()
		local boltSpinZ = math.pi * 8 * math.random()
		
		projectile.createProjectile(
			startPoint,
			
			direction,
			
			projectileSpeed,
			
			bolt,
			
			function(hitPart)
				-- deactivate effects gracefully
				bolt.Transparency = 1
				for _, trail in pairs(trails) do
					trail.Enabled = false
				end
				debris:AddItem(bolt, trails[1].Lifetime)
				
				-- do damage and swap
				local canDamage, target = damage.canPlayerDamageTarget(castingPlayer, hitPart)
				if canDamage then
					-- effects for the swap
					for _, swapped in pairs{manifest, target} do
						local hitSound = script.swap:Clone()
						hitSound.Parent = swapped
						hitSound:Play()
						debris:AddItem(hitSound, hitSound.TimeLength)
						
						local smokePart = script.smokePart:Clone()
						smokePart.Position = swapped.Position
						smokePart.Parent = entitiesFolder
						spawn(function()
							smokePart.emitter:Emit(32)
							wait(smokePart.emitter.Lifetime.Max)
							smokePart:Destroy()
						end)
					end
					
					if isAbilitySource then
						network:fire("requestEntityDamageDealt", target, bolt.Position, "ability", self.id, "bolt", guid)
						swapRemote:FireServer(target)
					end
				end
			end,
			
			function(t)
				local colorsPerSecond = BOLT_COLOR_COUNT * 2
				local index = math.floor(t * colorsPerSecond) % BOLT_COLOR_COUNT + 1
				bolt.BrickColor = BOLT_COLORS[index]
				
				return CFrame.Angles(boltSpinX * t, 0, boltSpinZ * t)
			end,
			
			ignoreList,
			
			true,
			
			0
		)
			
		if isAbilitySource then
			network:fire("setIsPlayerCastingAbility", false)
			network:invoke("client_changeAbilityState", abilityData.id, "end")
		end
	end
end

return abilityData