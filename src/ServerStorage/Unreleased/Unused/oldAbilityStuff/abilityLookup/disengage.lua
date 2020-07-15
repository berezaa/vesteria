local abilityAnimations = game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local debris = game:GetService("Debris")

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local network 			= modules.load("network")
	local damage 			= modules.load("damage")
	local placeSetup 		= modules.load("placeSetup")
	local tween	 			= modules.load("tween")
	local effects           = modules.load("effects")
	local ability_utilities = modules.load("ability_utilities")

local entitiesFolder = placeSetup.awaitPlaceFolder("entities")
local animations = game.ReplicatedStorage:WaitForChild("abilityAnimations")

local abilityData = {
	id = 51,
	
	name = "Disengage",
	image = "rbxassetid://2735680078",
	description = "Leap backwards while shooting nearby targets. (Requires bow.)",
	mastery = "",
	maxRank = 10,
	
	windupTime = 0.25,
	
	statistics = ability_utilities.calculateStats{
		maxRank = 10,
		static = {
			cooldown = 4,
			range = 16,
		},
		staggered = {
			jumpSpeed = {first = 50, final = 150, levels = {3, 7}},
			damageMultiplier = {first = 1, final = 1.5, levels = {2, 4, 6, 8, 10}},
			range = {first = 16, final = 24, levels = {5, 9}},
		},
		pattern = {
			manaCost = {base = 5, pattern = {2, 1, 2, 3}},
		},
	},
	
	securityData = {
		playerHitMaxPerTag = 64,
		isDamageContained = true,
		projectileOrigin = "character",
	},
	
	equipmentTypeNeeded = "bow",
	disableAutoaim = true,
}

function abilityData._serverProcessDamageRequest(sourceTag, baseDamage)
	if sourceTag == "shot" then
		return baseDamage, "physical", "aoe"
	end
end

function abilityData:execute(renderCharacterContainer, abilityExecutionData, isAbilitySource, guid)
	local root = renderCharacterContainer.PrimaryPart
	if not root then return end
	local entity = renderCharacterContainer:FindFirstChild("entity")
	if not entity then return end
	
	local weapon = network:invoke("getCurrentlyEquippedForRenderCharacter", entity)
	if not weapon then return end
	weapon = weapon["1"] and weapon["1"].manifest
	if not weapon then return end
	
	local charAnimator = entity:FindFirstChild("AnimationController")
	if not charAnimator then return end
	local weaponAnimator = weapon:FindFirstChild("AnimationController")
	if not weaponAnimator then return end
	
	-- yeet myself backwards
	if isAbilitySource then
		local speed = abilityExecutionData["ability-statistics"]["jumpSpeed"]
		
		--get camera facing
		local cameraCFrame = workspace.CurrentCamera.CFrame
		
		-- reverse of where we're looking
		local direction = -cameraCFrame.LookVector
		
		-- flatten the vector so it's horizontal only
		direction = Vector3.new(direction.X, 0, direction.Z)
		
		-- create a cframe and rotate it 45 degrees
		local cframe = CFrame.new(Vector3.new(0, 0, 0), direction)
		cframe = cframe * CFrame.Angles(math.pi / 4, 0, 0)
		
		-- final direction
		local direction = cframe.LookVector
		
		-- boop me
		network:fire("applyJoltVelocityToCharacter", direction * speed)
	end
	
	-- play a shooting animation
	charAnimator:LoadAnimation(animations.player_tripleshot):Play(nil, nil, 2)
	weaponAnimator:LoadAnimation(animations.bow_tripleshot):Play(nil, nil, 2)
	
	-- make an arrow in the bow
	local arrow = script.arrow:Clone()
	arrow:ClearAllChildren()
	arrow.Anchored = false
	arrow.Parent = entitiesFolder
	
	local arrowHolder = weapon.slackRopeRepresentation.arrowHolder
	arrowHolder.C0 = CFrame.Angles(-math.pi / 2, 0, 0) * CFrame.new(0, -arrow.Size.Y / 2 - 0.2, 0)
	arrowHolder.Part1 = arrow
	
	debris:AddItem(arrow, self.windupTime)
	
	-- actually shoot people
	local targets = {}
	local castingPlayer = ability_utilities.getCastingPlayer(abilityExecutionData)
	local stats = abilityExecutionData["ability-statistics"]
	local rangeSq = stats.range ^ 2
	for _, target in pairs(damage.getDamagableTargets(castingPlayer)) do
		local delta = target.Position - root.Position
		local distanceSq = delta.X ^ 2 + delta.Z ^ 2
		if distanceSq <= rangeSq then
			table.insert(targets, target)
		end
	end
	
	local drawSound = script.draw:Clone()
	drawSound.Parent = root
	drawSound:Play()
	debris:AddItem(drawSound, drawSound.TimeLength)
	
	wait(self.windupTime)
	
	local shootSound = script.shoot:Clone()
	shootSound.Parent = root
	shootSound:Play()
	debris:AddItem(shootSound, shootSound.TimeLength)
	
	local speed = 128
	
	for _, target in pairs(targets) do
		local arrow = script.arrow:Clone()
		local trail = arrow.trail
		
		local function faceArrowToTarget()
			arrow.CFrame =
				CFrame.new(arrow.Position, target.Position) *
				CFrame.Angles(math.pi / 2, 0, 0)
		end
		
		arrow.Position = weapon.PrimaryPart.Position
		faceArrowToTarget()
		arrow.Parent = entitiesFolder
		
		effects.onHeartbeatFor(0, function(dt)
			local delta = target.Position - arrow.Position
			local distanceSq = delta.X ^ 2 + delta.Y ^ 2 + delta.Z ^ 2
			if distanceSq <= 4 then
				if isAbilitySource then
					network:fire("requestEntityDamageDealt", target, target.Position, "ability", self.id, "shot", guid)
				end
				
				arrow.Transparency = 1
				debris:AddItem(arrow, trail.Lifetime)
				
				return true
			else
				local direction = delta.Unit
				
				arrow.CFrame = arrow.CFrame + direction * speed * dt
				faceArrowToTarget()
			end
		end)
	end
end

return abilityData