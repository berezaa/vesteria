local abilityAnimations = game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local debris = game:GetService("Debris")
local runService = game:GetService("RunService")

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local network 			= modules.load("network")
	local damage 			= modules.load("damage")
	local placeSetup 		= modules.load("placeSetup")
	local tween	 			= modules.load("tween")
	local effects           = modules.load("effects")
	local ability_utilities = modules.load("ability_utilities")

local entitiesFolder = placeSetup.awaitPlaceFolder("entities")

local abilityData = {
	id = 39,
	
	name = "Dark Ritual",
	image = "rbxassetid://4079576139",
	description = "Sacrifice your own health to gain mana.",
	mastery = "",
	layoutOrder = 0;
	maxRank = 1,
	
	statistics = {
		[1] = {
			cooldown = 1,
			manaCost = 0,
			healthCost = 100,
			manaRestored = 50,
		},
	},
	
	securityData = {
		playerHitMaxPerTag = 64,
		projectileOrigin = "character",
	},
	
	disableAutoaim = true,
}

local LURCH_DURATION = 0.75
local LURCH_HITS = 3
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

function injureOverTime(manifest, damage, duration, hits)
	local health = manifest:FindFirstChild("health")
	if not health then return end
	
	local damagePerStep = damage / hits
	local stepTime = duration / hits
	
	spawn(function()
		local desiredHealth = health.Value
		
		for _ = 1, hits do
			desiredHealth = math.max(1, health.Value - damagePerStep)
			health.Value = desiredHealth
			wait(stepTime)
		end
	end)
end

function abilityData:execute_server(player, abilityExecutionData, isAbilitySource)
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
	if hasSimulacrum(player) then
		manaRestored = manaRestored * 2
	end
	
	injureOverTime(manifest, damage, LURCH_DURATION, LURCH_HITS)
	wait(LURCH_DURATION)
	mana.Value = math.min(mana.Value + manaRestored, maxMana.Value)
end

local function darkEffect(partA, partB, spin, duration, bezierStretch)
	
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
end

function abilityData:execute(renderCharacterContainer, abilityExecutionData, isAbilitySource, guid)
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
	injureOverTime(manifest, damage, LURCH_DURATION, LURCH_HITS)
	
	-- sound for getting hurt
	local damageSound = script.damage:Clone()
	damageSound.Parent = root
	damageSound:Play()
	debris:AddItem(damageSound, damageSound.TimeLength)
	
	-- simulacrum boi
	local player = ability_utilities.getCastingPlayer(abilityExecutionData)
	if player and hasSimulacrum(player) then
		local sim = getSimulacrum(abilityExecutionData)
		local partA = sim.PrimaryPart
		local partB = root
		for _ = 1, 2 do
			darkEffect(partA, partB, math.pi * 2 * math.random(), LURCH_DURATION, 4)
		end
	end
	
	-- let the dark emitter emit for the lurch
	wait(LURCH_DURATION - darkEmitter.Lifetime.Max)
	
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

return abilityData