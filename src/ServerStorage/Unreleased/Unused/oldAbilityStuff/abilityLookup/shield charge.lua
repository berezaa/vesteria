local abilityAnimations = game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local debris = game:GetService("Debris")

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local network 			= modules.load("network")
	local damage 			= modules.load("damage")
	local placeSetup 		= modules.load("placeSetup")
	local tween	 			= modules.load("tween")
	local ability_utilities = modules.load("ability_utilities")
	local effects           = modules.load("effects")
	local detection         = modules.load("detection")
	local physics			= modules.load("physics")

local entitiesFolder = placeSetup.awaitPlaceFolder("entities")

local abilityData = {
	id = 61,
	
	name = "Shield Charge",
	image = "rbxassetid://1193579056",
	description = "Rush forward with your shield, bashing enemies and stunning them. (Requires shield.)",
	mastery = "More damage.",
	layoutOrder = 0;
	maxRank = 10,
	
	statistics = ability_utilities.calculateStats{
		maxRank = 10,
		static = {
			cooldown = 5,
			distance = 24,
		},
		staggered = {
			damageMultiplier = {first = 2, final = 3, levels = {2, 5, 8}},
			cooldown = {first = 10, final = 6, levels = {3, 6, 9}},
			stunDuration = {first = 1, final = 2, levels = {4, 7, 10}},
		},
		pattern = {
			manaCost = {base = 15, pattern = {2, 2, 3}},
		},
	},
	
	securityData = {
		playerHitMaxPerTag = 64,
		isDamageContained = true,
		projectileOrigin = "character",
	},
	
	windupTime = 0.25,
	duration = 0.5,
}

function abilityData._serverProcessDamageRequest(sourceTag, baseDamage)
	if sourceTag == "strike" then
		return baseDamage, "physical", "direct"
	end
end

function abilityData:execute_server(player, abilityExecutionData, isAbilitySource, target)
	if not isAbilitySource then return end
	
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

function abilityData:tryDealWeaponDamage(player, guid, weapon, victims, isAbilitySource, abilityExecutionData)
	local targets = damage.getDamagableTargets(player)
	for _, target in pairs(targets) do
		if not victims[target] then
			local targetPosition = detection.projection_Box(target.CFrame, target.Size, weapon.Position)
			if detection.boxcast_singleTarget(weapon.CFrame, weapon.Size * 2, targetPosition) then
				victims[target] = true
				
				local sound = script.bonk:Clone()
				sound.Parent = target
				sound:Play()
				debris:AddItem(sound, sound.TimeLength)
				
				if isAbilitySource then
					network:fire("requestEntityDamageDealt", target, targetPosition, "ability", self.id, "strike", guid)
					network:fireServer("abilityFireServerCall", abilityExecutionData, self.id, target)
				end
			end
		end
	end
end

function abilityData:execute(renderCharacterContainer, abilityExecutionData, isAbilitySource, guid)
	local root = renderCharacterContainer.PrimaryPart
	if not root then return end
	local entity = renderCharacterContainer:FindFirstChild("entity")
	if not entity then return end
	local animator = entity:FindFirstChild("AnimationController")
	if not animator then return end
	
	-- get the gear
	local equipment = network:invoke("getCurrentlyEquippedForRenderCharacter", renderCharacterContainer.entity)
	if not equipment then return end
	local offhand = equipment["11"]
	if not offhand then return end
	if offhand.baseData.equipmentType ~= "shield" then return end
	offhand = offhand.manifest
	if not offhand then return end
	
	local victims = {}
	
	-- animation
	local track = animator:LoadAnimation(abilityAnimations.shield_charge)
	
	track:Play()
	
	local movement
	if isAbilitySource then
		movement = network:invoke("getMovementVelocity")
		
		network:invoke("setCharacterArrested", true)
	end
	
	wait(self.windupTime)
	
	-- stop
	if isAbilitySource then		
		local direction = (movement.magnitude > 0.01) and movement.unit or root.CFrame.LookVector
		local distance = abilityExecutionData["ability-statistics"]["distance"]
		local speed = distance / self.duration
		local velocity = direction * speed
		network:invoke("setMovementVelocity", velocity)
		
		-- don't rotate (or rotate properly)
		-- also pass through
		local char = game.Players.LocalPlayer.Character
		if char and char.PrimaryPart then
			local gyro = char.PrimaryPart:FindFirstChild("hitboxGyro")
			if gyro then
				gyro.CFrame = CFrame.new(Vector3.new(), velocity)
			end
			
			physics:setWholeCollisionGroup(char, "passthrough")
		end
	end
	
	-- poll out and deal damage
	local duration = self.duration
	
	while duration > 0 do
		local dt = wait(0.05)
		duration = duration - dt
		
		self:tryDealWeaponDamage(game.Players.LocalPlayer, guid, offhand, victims, isAbilitySource, abilityExecutionData)
	end
	
	-- done
	if isAbilitySource then
		network:invoke("setMovementVelocity", Vector3.new())
		network:invoke("setCharacterArrested", false)
		
		-- fix collisions
		local char = game.Players.LocalPlayer.Character
		if char then
			physics:setWholeCollisionGroup(char, "characters")
		end
	end
end

return abilityData