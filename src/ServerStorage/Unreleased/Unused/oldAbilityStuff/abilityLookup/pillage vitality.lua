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
	local utilities         = modules.load("utilities")

local entitiesFolder = placeSetup.awaitPlaceFolder("entities")

local abilityData = {
	id = 40,
	
	name = "Pillage Vitality",
	image = "rbxassetid://4079576752",
	description = "Hurl a dark bolt which steals health from its victim.",
	mastery = "More health stolen.",
	
	maxRank = 10,
	
	statistics = ability_utilities.calculateStats{
		maxRank = 10,
		static = {
			cooldown = 2,
		},
		staggered = {
			damageMultiplier = {first = 1, final = 2, levels = {2, 5, 8}},
			healing = {first = 50, final = 100, levels = {3, 6, 9}},
			projectileSpeed = {first = 50, final = 100, levels = {4, 7, 10}},
			bolts = {first = 1, final = 3, levels = {1, 5, 10}, integer = true},
		},
		pattern = {
			manaCost = {base = 10, pattern = {2, 3, 3}}
		}
	},

	windupTime = 0.55,
	
	securityData = {
		playerHitMaxPerTag = 4,
		isDamageContained = true,
		projectileOrigin = "character",
	},
	
	abilityDecidesEnd = true,
	
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
	}
}

local FOLDER_NAME = "warlockSimulacrumData"

local function hasSimulacrum(player)
	local folder = player:FindFirstChild(FOLDER_NAME)
	if folder then
		return #folder:GetChildren() > 0
	end
	return false
end

local function getSimulacrum(abilityExecutionData)
	local castingPlayer = ability_utilities.getCastingPlayer(abilityExecutionData)
	if not castingPlayer then return end
	
	local folder = castingPlayer:FindFirstChild(FOLDER_NAME)
	if not folder then return end
	
	local sims = folder:GetChildren()
	if #sims == 0 then return end
	
	local sim = sims[1]
	if not sim then return end
	
	local ref = sim:FindFirstChild("modelRef")
	if not ref then return end
	
	return ref.Value
end

local function createEffectPart()
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

local function heal(player, abilityExecutionData)
	local character = player.Character
	if not character then return end
	local manifest = character.PrimaryPart
	if not manifest then return end
	
	local healing = abilityExecutionData["ability-statistics"]["healing"]
	utilities.healEntity(manifest, manifest, healing)
end

function abilityData:execute_server(player, abilityExecutionData, isAbilitySource)
	if not isAbilitySource then return end
	
	local uses = 1
	if hasSimulacrum(player) then
		uses = uses + 1
	end
	
	local remote = Instance.new("RemoteEvent")
	remote.Name = "PillageVitalityTemporarySecureRemote"
	remote.OnServerEvent:Connect(function(...)
		heal(...)
		
		uses = uses - 1
		if uses <= 0 then
			remote:Destroy()
		end
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
	local upperTorso = entity:FindFirstChild("UpperTorso")
	if not upperTorso then return end
	
	-- target acquisition
	local targetPoint =
		abilityExecutionData["target-position"] or
		abilityExecutionData["mouse-world-position"]
	local castingPlayer = ability_utilities.getCastingPlayer(abilityExecutionData)
	
	-- do we have to duplicate with a simulacrum?
	local sim = getSimulacrum(abilityExecutionData)
	
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
		local track = renderCharacterContainer.entity.AnimationController:LoadAnimation(abilityAnimations["mage_cast_left_hand_top"])
		track:Play()
		
		-- animation: simulacrum
		if sim then
			local animator = sim:FindFirstChild("animationController")
			if animator then
				animator:LoadAnimation(abilityAnimations["mage_cast_left_hand_top"]):Play()
			end
			
			sim:SetPrimaryPartCFrame(CFrame.new(
				sim.PrimaryPart.Position,
				Vector3.new(
					targetPoint.X,
					sim.PrimaryPart.Position.Y,
					targetPoint.Z
				)
			))
		end
		
		-- emitter
		local attachment = Instance.new("Attachment")
		attachment.Name = "PillageVitalityEmitterAttachment"
		attachment.Parent = leftHand
		
		local emitter = script.darkEmitter:Clone()
		emitter.Parent = attachment
		
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
		
		-- update the ability
		updateAbilityExecution()
	
	elseif abilityExecutionData["ability-state"] == "update" then
		-- casting sound
		local castSound = script.cast:Clone()
		castSound.Parent = leftHand
		castSound:Play()
		debris:AddItem(castSound, castSound.TimeLength)
	
		-- launch the projectile!
		local function fireProjectile(startPoint)
			local healRemote
			if isAbilitySource then
				healRemote = network:invokeServer("abilityInvokeServerCall", abilityExecutionData, self.id)
			end
			
			local bolt = script.bolt:Clone()
			bolt.Parent = entitiesFolder
			
			local ignoreList = projectile.makeIgnoreList{
				renderCharacterContainer,
				renderCharacterContainer.clientHitboxToServerHitboxReference.Value
			}
			
			local function bloodEffect(partA, partB, spin)
				local duration = 1
				local bezierStretch = 16
				
				local blood = script.blood:Clone()
				local trail = blood.trail
				blood.CFrame = partA.CFrame
				blood.Parent = entitiesFolder
				
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
					
					blood.CFrame = CFrame.new(p)
				end)
				
				delay(duration, function()
					blood.Transparency = 1
					trail.Enabled = false
					debris:AddItem(blood, trail.Lifetime)
				end)
			end
			
			local function lifeStealEffect(target)
				for blood = 1, 3 do
					local spin = (blood - 2) * (math.pi / 3)
					bloodEffect(target, upperTorso, spin)
				end
				
				delay(1, function()
					-- restore sound
					local restoreSound = script.restore:Clone()
					restoreSound.Parent = root
					restoreSound:Play()
					debris:AddItem(restoreSound, restoreSound.TimeLength)
					
					-- blood poof
					local duration = 1
					
					local sphere = createEffectPart()
					sphere.Shape = Enum.PartType.Ball
					sphere.Color = script.blood.Color
					sphere.Material = Enum.Material.Neon
					sphere.Size = Vector3.new()
					sphere.CFrame = CFrame.new(upperTorso.Position)
					sphere.Parent = entitiesFolder
					
					tween(sphere, {"Size", "Transparency"}, {Vector3.new(8, 8, 8), 1}, duration)
					effects.onHeartbeatFor(duration, function()
						sphere.CFrame = CFrame.new(upperTorso.Position)
					end)
					debris:AddItem(sphere, duration)
					
					-- actually heal
					if isAbilitySource then
						healRemote:FireServer(abilityExecutionData)
					end
				end)
			end
			
			local projectileSpeed = abilityExecutionData["ability-statistics"]["projectileSpeed"]
			local targetPoint = abilityExecutionData["mouse-target-position"]
			local direction = (targetPoint - startPoint).Unit
			
			-- local direction, targetPoint = projectile.getUnitVelocityToImpact_predictiveByAbilityExecutionData(startPoint, projectileSpeed, abilityExecutionData, 0)
			
			projectile.createProjectile(
				startPoint,
				
				direction,
				
				projectileSpeed,
				
				bolt,
				
				function(hitPart)
					bolt.Transparency = 1
					bolt.emitterAttachment.emitter.Enabled = false
					debris:AddItem(bolt, bolt.emitterAttachment.emitter.Lifetime.Max)
					
					local canDamage, target = damage.canPlayerDamageTarget(castingPlayer, hitPart)
					if canDamage then
						-- sound effect
						local hitSound = script.hit:Clone()
						hitSound.Parent = target
						hitSound:Play()
						debris:AddItem(hitSound, hitSound.TimeLength)
						
						-- succ effect
						lifeStealEffect(target)
						
						if isAbilitySource then
							network:fire("requestEntityDamageDealt", target, bolt.Position, "ability", self.id, "bolt", guid)
						end
					end
				end,
				
				function(t)
					return CFrame.Angles(0, math.pi, math.pi * 2 * t)
				end,
				
				ignoreList,
				
				true,
				
				0
			)
		end
		
		fireProjectile(leftHand.Position)
		
		if sim and sim.Parent then
			local leftHand = sim:FindFirstChild("LeftHand")
			if leftHand then
				fireProjectile(leftHand.Position)
			end
		end
		
		-- maybe fire another!
		if isAbilitySource then
			if abilityExecutionData["times-updated"] < abilityExecutionData["ability-statistics"]["bolts"] then
				updateAbilityExecution()
			else
				network:fire("setIsPlayerCastingAbility", false)
				network:invoke("client_changeAbilityState", abilityData.id, "end")
			end
		end
	end
end

return abilityData