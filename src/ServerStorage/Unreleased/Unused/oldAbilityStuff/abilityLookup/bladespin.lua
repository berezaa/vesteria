local abilityAnimations = game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local debris = game:GetService("Debris")

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local network 			= modules.load("network")
	local damage 			= modules.load("damage")
	local placeSetup 		= modules.load("placeSetup")
	local tween	 			= modules.load("tween")
	local ability_utilities = modules.load("ability_utilities")
	local effects           = modules.load("effects")

local entitiesFolder = placeSetup.awaitPlaceFolder("entities")

local abilityData = {
	id = 55,
	
	name = "Blade Spin",
	image = "rbxassetid://4465750273",
	description = "Become a whirlwind of blades, constantly damaging enemies near you. (Requires dual melee weapons.)",
	mastery = "More damage and longer duration.",
	layoutOrder = 0;
	maxRank = 10,
	
	statistics = ability_utilities.calculateStats{
		maxRank = 10,
		static = {
			radius = 12,
		},
		staggered = {
			damageMultiplier = {first = 2.5, final = 3.5, levels = {2, 5, 8}},
			duration = {first = 2.5, final = 5, levels = {3, 6, 9}},
			cooldown = {first = 12, final = 9, levels = {4, 7, 10}},
		},
		pattern = {
			manaCost = {base = 10, pattern = {2, 3, 3}},
		},
	},
	
	windupTime = 0.75,
	
	securityData = {
		playerHitMaxPerTag = 64,
		isDamageContained = true,
		projectileOrigin = "character",
	},
	
	disableAutoaim = true,
	equipmentTypeRequired = "sword",
}

local SPIN_STEP_TIME = 0.2

function abilityData._serverProcessDamageRequest(sourceTag, baseDamage)
	if sourceTag == "spin" then
		return baseDamage * SPIN_STEP_TIME, "physical", "aoe"
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
	local mainHand = equipment["1"]
	local offhand = equipment["11"]
	if (not mainHand) or (not offhand) then return end
	if (mainHand.baseData.equipmentType ~= "sword") or (offhand.baseData.equipmentType ~= "sword") then return end
	
	local startTrack = animator:LoadAnimation(abilityAnimations.bladespin_start)
	local loopTrack  = animator:LoadAnimation(abilityAnimations.bladespin_loop)
	local endTrack   = animator:LoadAnimation(abilityAnimations.bladespin_end)
	
	-- play the startup track
	startTrack:Play()
	
	-- channel sound
	local channelSound = script.channel:Clone()
	channelSound.Parent = root
	channelSound:Play()
	debris:AddItem(channelSound, channelSound.TimeLength)
	
	-- let the startup track play
	wait(self.windupTime)
	
	-- start the loop
	loopTrack:Play(0)
	
	local stats = abilityExecutionData["ability-statistics"]
	local duration = stats.duration
	local radiusSq = stats.radius ^ 2
	
	-- set up some neat crescents
	do
		local effectDuration = duration + 0.75
		
		local crescents = {}
		for radiusFactor = 0.25, 1, 0.25 do
			local rotOffset = math.pi * 2 * math.random()
			
			for index, halfSpin in pairs{0, math.pi} do
				local radius = stats.radius * radiusFactor
				if index == 1 then
					radius = radius - 2
				end
				
				local crescent = script.crescent:Clone()
				crescent.Size = Vector3.new(radius * 2, 0.05, radius)
				
				-- fade in
				local transparency = crescent.Transparency
				crescent.Transparency = 1
				tween(crescent, {"Transparency"}, transparency, 0.25)
				
				-- fade out when it's time
				delay(effectDuration - 0.25, function()
					tween(crescent, {"Transparency"}, 1, 0.25)
					wait(0.25)
					crescent:Destroy()
				end)
				
				-- parent
				crescent.Parent = entitiesFolder
				
				-- keep track
				table.insert(crescents, {
					part = crescent,
					rotOffset = rotOffset + halfSpin,
				})
			end
		end
		
		local rotSpeed = math.pi * 8
		
		effects.onHeartbeatFor(effectDuration, function(dt, t, w)
			for index, crescent in pairs(crescents) do
				local dy = index - 2
				local theta = t * rotSpeed + crescent.rotOffset
				
				crescent.part.CFrame =
					CFrame.new(root.Position) *
					CFrame.new(0, dy, 0) *
					CFrame.Angles(0, theta, 0) *
					CFrame.new(0, 0, -crescent.part.Size.Z / 2)
			end
		end)
	end
	
	-- go through the full duration of the spin
	local timer = 0
	while timer < duration do
		-- sound effects
		spawn(function()
			local soundsThisStep = 3
			for soundNumber = 1, soundsThisStep do
				local slashSound = script.slash:Clone()
				slashSound.PlaybackSpeed = 0.8 + 0.4 * math.random()
				slashSound.Parent = root
				slashSound:Play()
				debris:AddItem(slashSound, slashSound.TimeLength / slashSound.PlaybackSpeed)
				
				wait(SPIN_STEP_TIME / soundsThisStep)
			end
		end)
		
		-- timer control
		local dt = wait(SPIN_STEP_TIME)
		timer = timer + dt
		
		if isAbilitySource then
			-- damage all targets in range
			local targets = damage.getDamagableTargets(game.Players.LocalPlayer)
			for _, target in pairs(targets) do
				local delta = target.Position - root.Position
				local distanceSq = delta.X ^ 2 + delta.Z ^ 2
				if (distanceSq < radiusSq) and (delta.Y ^ 2 < radiusSq) then
					network:fire("requestEntityDamageDealt", target, target.position, "ability", self.id, "spin", guid)
				end
			end
		end
	end
	
	-- transition animations
	loopTrack:Stop(0)
	endTrack:Play(0)
end

return abilityData