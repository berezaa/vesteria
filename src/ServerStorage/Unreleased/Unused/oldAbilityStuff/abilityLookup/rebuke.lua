local abilityAnimations = game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local debris = game:GetService("Debris")

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local network 			= modules.load("network")
	local damage 			= modules.load("damage")
	local placeSetup 		= modules.load("placeSetup")
	local tween	 			= modules.load("tween")
	local ability_utilities = modules.load("ability_utilities")
	local effects           = modules.load("effects")
	local utilities			= modules.load("utilities")

local entitiesFolder = placeSetup.awaitPlaceFolder("entities")

local abilityData = {
	id = 56,
	
	name = "Rebuke",
	image = "rbxassetid://4465750691",
	description = "Strike the area with a fierce rebuke, damaging and knocking away enemies.",
	mastery = "More damage and knockback.",
	layoutOrder = 0;
	maxRank = 10,
	
	statistics = ability_utilities.calculateStats{
		maxRank = 10,
		static = {
			radius = 32,
			cooldown = 16,
		},
		staggered = {
			damageMultiplier = {first = 2, final = 3, levels = {2, 3, 5, 6, 8, 9}},
			knockback = {first = 15000, final = 30000, levels = {4, 7, 10}},
		},
		pattern = {
			manaCost = {base = 20, pattern = {2, 2, 4}},
		},
	},
	
	windupTime = 1,
	
	securityData = {
		playerHitMaxPerTag = 64,
		isDamageContained = true,
		projectileOrigin = "character",
	},
	
	disableAutoaim = true,
	equipmentTypeNeeded = "sword",
}

function abilityData._serverProcessDamageRequest(sourceTag, baseDamage)
	if sourceTag == "blast" then
		return baseDamage, "magical", "aoe"
	end
end



function abilityData._abilityExecutionDataCallback(playerData, ref_abilityExecutionData)
	ref_abilityExecutionData["bounceback"] =
		playerData and playerData.nonSerializeData.statistics_final.activePerks["bounceback"]
end
function abilityData:execute_server(player, abilityExecutionData, isAbilitySource, targetPoint, monsters)
	if not isAbilitySource then return end
	
	for _, monster in pairs(monsters) do
		if abilityExecutionData["bounceback"] then
			utilities.playSound("bounce", monster)
		end		
		local multiplier = abilityExecutionData["bounceback"] and 15 or 1
		ability_utilities.knockbackMonster(monster, targetPoint, abilityExecutionData["ability-statistics"]["knockback"] * multiplier)
	end
end

function abilityData:execute(renderCharacterContainer, abilityExecutionData, isAbilitySource, guid)
	local root = renderCharacterContainer.PrimaryPart
	if not root then return end
	local entity = renderCharacterContainer:FindFirstChild("entity")
	if not entity then return end
	local animator = entity:FindFirstChild("AnimationController")
	if not animator then return end
	
	local track = animator:LoadAnimation(abilityAnimations.warrior_forwardDownslash)
	track:Play()
	
	if isAbilitySource then
		network:invoke("setCharacterArrested", true)
	end
	
	local targetPoint do
		local cframe =
			root.CFrame *
			CFrame.new(0, 0, -6)
		targetPoint = cframe.Position
	end
	
	-- sounds!
	for _, soundTemplate in pairs{script.cast1, script.cast2} do
		local sound = soundTemplate:Clone()
		sound.Parent = root
		sound:Play()
		debris:AddItem(sound, sound.TimeLength)
	end
	
	-- sword fallin' from the sky!
	do
		local fadeDuration = 4
		
		local cframe = CFrame.new(
			targetPoint +
			Vector3.new(0, -2.5, 0)
		) *
			CFrame.Angles(0, math.pi * 2 * math.random(), 0) *
			CFrame.Angles(math.pi / 6 * math.random(), 0, 0) *
			CFrame.Angles(0, math.pi * 2 * math.random(), 0) *
			CFrame.new(0, 8, 0)
		
		local finishCFrame = cframe * CFrame.Angles(math.pi, 0, 0)
		local startCFrame = cframe * CFrame.new(0, 512, 0) * CFrame.Angles(math.pi, 0, 0)
		
		local sword = script.sword:Clone()
		sword.CFrame = startCFrame
		sword.Parent = entitiesFolder
		
		tween(sword, {"CFrame"}, finishCFrame, self.windupTime, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		
		delay(self.windupTime, function()
			sword.hit:Play()
			debris:AddItem(sword, sword.hit.TimeLength)
			
			tween(sword, {"Transparency"}, 1, fadeDuration)
		end)
	end
	
	wait(self.windupTime)
	
	if isAbilitySource then
		network:invoke("setCharacterArrested", false)
	end
	
	local stats = abilityExecutionData["ability-statistics"]
	
	--explosions??
	do
		local duration = 1
		local radius = stats.radius
		local ringDiameter = radius * 2 + 8
		local ringCount = 3
		
		local easingStyle = Enum.EasingStyle.Quint
		local easingDirection = Enum.EasingDirection.Out
		
		local sphere = script.sphere:Clone()
		sphere.Position = targetPoint
		sphere.Parent = entitiesFolder
		tween(
			sphere,
			{"Size", "Transparency"},
			{Vector3.new(radius * 2, radius / 2, radius * 2), 1},
			duration,
			easingStyle,
			easingDirection
		)
		delay(duration, function()
			sphere.emitter.Enabled = false
			wait(sphere.emitter.Lifetime.Max)
			sphere:Destroy()
		end)
		
		for _ = 1, ringCount do
			local ring = script.ring:Clone()
			ring.CFrame =
				CFrame.new(targetPoint) *
				CFrame.Angles(math.pi * 2 * math.random(), 0, math.pi * 2 * math.random())
			ring.Parent = entitiesFolder
			tween(
				ring,
				{"Size", "Transparency"},
				{Vector3.new(ringDiameter, 2, ringDiameter), 1},
				duration,
				easingStyle,
				easingDirection
			)
			debris:AddItem(ring, duration)
		end
	end
	
	-- yeet them, bruh!
	local char = game.Players.LocalPlayer.Character
	if not char then return end
	local manifest = char.PrimaryPart
	if not manifest then return end
	
	local player = ability_utilities.getCastingPlayer(abilityExecutionData)
	local targets = damage.getDamagableTargets(player)
	local monstersToKnockBack = {}
	for _, target in pairs(targets) do
		local delta = target.Position - targetPoint
		local distance = delta.Magnitude
		if distance <= stats.radius then
			if isAbilitySource then
				network:fire("requestEntityDamageDealt", target, target.position, "ability", self.id, "blast", guid)
				
				if	target:FindFirstChild("entityType") and
					target.entityType.Value == "monster"
				then
					table.insert(monstersToKnockBack, target)
				end
			end
			
			-- if this is me, yeet me away
			if target == manifest then
				local multiplier = abilityExecutionData["bounceback"] and 15 or 1
				ability_utilities.knockbackLocalPlayer(targetPoint, stats.knockback * multiplier)
			end

		end
	end
	
	if isAbilitySource then
		network:fireServer("abilityFireServerCall", abilityExecutionData, self.id, targetPoint, monstersToKnockBack)
	end
end

return abilityData