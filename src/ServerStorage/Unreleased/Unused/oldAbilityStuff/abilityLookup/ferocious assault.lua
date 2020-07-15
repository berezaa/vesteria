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

local entitiesFolder = placeSetup.awaitPlaceFolder("entities")

local abilityData = {
	id = 60,
	
	name = "Ferocious Assault",
	image = "rbxassetid://3006001373",
	description = "Unleash a furious sequence of blows. (Requires dual melee weapons.)",
	mastery = "More damage.",
	layoutOrder = 0;
	maxRank = 10,
	
	statistics = {
		[1] = {
			animationSpeed = 100,
			manaCost = 15,
			cooldown = 12,
			damageMultiplier = 1,
		},
		[2] = {
			manaCost = 17,
			damageMultiplier = 1.125,
		},
		[3] = {
			manaCost = 19,
			damageMultiplier = 1.5,
		},
		[4] = {
			manaCost = 21,
			damageMultiplier = 1.625,
		},
		[5] = {
			animationSpeed = 150,
			manaCost = 27,
		},
		[6] = {
			manaCost = 29,
			damageMultiplier = 1.75,
		},
		[7] = {
			manaCost = 31,
			damageMultiplier = 1.,
		},
		[8] = {
			manaCost = 33,
			damageMultiplier = 1.875,
		},
		[9] = {
			animationSpeed = 200,
			manaCost = 39,
		},
		[10] = {
			manaCost = 41,
			damageMultiplier = 2,
		},
	},
	
	securityData = {
		playerHitMaxPerTag = 64,
		isDamageContained = true,
		projectileOrigin = "character",
	},
	
	disableAutoaim = true,
}

function abilityData._serverProcessDamageRequest(sourceTag, baseDamage)
	if sourceTag == "strike" then
		return baseDamage, "physical", "direct"
	end
end

function abilityData:tryDealWeaponDamage(player, guid, weapon, victims)
	local targets = damage.getDamagableTargets(player)
	for _, target in pairs(targets) do
		if not victims[target] then
			local targetPosition = detection.projection_Box(target.CFrame, target.Size, weapon.Position)
			if detection.boxcast_singleTarget(weapon.CFrame, weapon.Size * 2, targetPosition) then
				victims[target] = true
				network:fire("requestEntityDamageDealt", target, targetPosition, "ability", self.id, "strike", guid)
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
	local mainHand = equipment["1"]
	local offhand = equipment["11"]
	if (not mainHand) or (not offhand) then return end
	if (mainHand.baseData.equipmentType ~= "sword") or (offhand.baseData.equipmentType ~= "sword") then return end
	mainHand = mainHand.manifest
	offhand = offhand.manifest
	if (not mainHand) or (not offhand) then return end
	local mainHandTrail = mainHand:FindFirstChild("Trail")
	local offhandTrail = offhand:FindFirstChild("Trail")
	if (not mainHandTrail) or (not offhandTrail) then return end
	
	local mainHandDamaging = false
	local offhandDamaging = false
	
	local mainHandVictims = {}
	local offhandVictims = {}
	
	local animationSpeed = abilityExecutionData["ability-statistics"]["animationSpeed"] / 100
	
	-- animation
	local track = animator:LoadAnimation(abilityAnimations.ferocious_assault)
	
	local emitters do
		emitters = {}
		for _, weapon in pairs{mainHand, offhand} do
			local emitter = script.emitter:Clone()
			emitter.Parent = weapon
			table.insert(emitters, emitter)
		end
	end
	
	local function onKeyframeReached(keyframe)
		if keyframe == "rightStart" then
			mainHandTrail.Enabled = true
			mainHandDamaging = true
			
			-- reset victims
			mainHandVictims = {}
			
			-- sound
			local sound = script.slash:Clone()
			sound.Parent = mainHand
			sound:Play()
			debris:AddItem(sound, sound.TimeLength)
		
		elseif keyframe == "rightStop" then
			mainHandTrail.Enabled = false
			mainHandDamaging = false
		
		elseif keyframe == "leftStart" then
			offhandTrail.Enabled = true
			offhandDamaging = true
			
			-- reset victims
			offhandVictims = {}
			
			-- sound
			local sound = script.slash:Clone()
			sound.Parent = offhand
			sound:Play()
			debris:AddItem(sound, sound.TimeLength)
		
		elseif keyframe == "leftStop" then
			offhandTrail.Enabled = false
			offhandDamaging = false
		end
	end
	track.KeyframeReached:Connect(onKeyframeReached)
	
	track:Play(nil, nil, animationSpeed)
	
	-- stop, swords time
	if isAbilitySource then
		network:invoke("setCharacterArrested", true)
	end
	
	-- poll out and deal damage
	local duration = track.Length / animationSpeed
	
	while duration > 0 do
		local dt = wait(0.05)
		duration = duration - dt
		
		if isAbilitySource then
			if mainHandDamaging then
				self:tryDealWeaponDamage(game.Players.LocalPlayer, guid, mainHand, mainHandVictims)
			end
			
			if offhandDamaging then
				self:tryDealWeaponDamage(game.Players.LocalPlayer, guid, offhand, offhandVictims)
			end
		end
	end
	
	for _, emitter in pairs(emitters) do
		emitter.Enabled = false
		debris:AddItem(emitter, emitter.Lifetime.Max)
	end
	
	-- swords time done
	if isAbilitySource then
		network:invoke("setCharacterArrested", false)
	end
end

return abilityData