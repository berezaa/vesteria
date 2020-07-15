local animations = game.ReplicatedStorage:WaitForChild("abilityAnimations")
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
	id = 31,
	
	name = "Ricochet",
	image = "rbxassetid://4465750391",
	description = "Shoot an arrow that will ricochet off its target, striking multiple targets.",
	mastery = "More ricochets",
	
	maxRank = 10,
	
	statistics = ability_utilities.calculateStats{
		maxRank = 10,
		static = {
			cooldown = 3,
		},
		staggered = {
			damageMultiplier = {first = 1, final = 1.5, levels = {2, 4, 6, 8, 10}},
			bounces = {first = 3, final = 10, levels = {3, 5, 7, 9}, integer = true},
		},
		pattern = {
			manaCost = {base = 5, pattern = {2, 3}},
		},
	},
	
	windupTime = 0.5,
	
	securityData = {
		playerHitMaxPerTag = 64,
		isDamageContained = true,
		projectileOrigin = "character",
	},
	
	abilityDecidesEnd = true,
	
	equipmentTypeNeeded = "bow",
	disableAutoaim = true,
}

function abilityData._serverProcessDamageRequest(sourceTag, baseDamage)
	if sourceTag == "boulder" then
		return baseDamage, "magical", "projectile"
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
		-- play a shooting animation
		charAnimator:LoadAnimation(animations.player_tripleshot):Play()
		weaponAnimator:LoadAnimation(animations.bow_tripleshot):Play()
		
		-- make an arrow in the bow
		local arrow = script.arrow:Clone()
		arrow:ClearAllChildren()
		arrow.Anchored = false
		arrow.Parent = entitiesFolder
		
		local arrowHolder = weapon.slackRopeRepresentation.arrowHolder
		arrowHolder.C0 = CFrame.Angles(-math.pi / 2, 0, 0) * CFrame.new(0, -arrow.Size.Y / 2 - 0.2, 0)
		arrowHolder.Part1 = arrow
		
		debris:AddItem(arrow, self.windupTime)
		
		--draw the bow sound
		local drawSound = script.draw:Clone()
		drawSound.Parent = root
		drawSound:Play()
		debris:AddItem(drawSound, drawSound.TimeLength)
	
		-- let the bow get drawn
		wait(self.windupTime)
	
		-- fire!
		local shootSound = script.shoot:Clone()
		shootSound.Parent = root
		shootSound:Play()
		debris:AddItem(shootSound, shootSound.TimeLength)
		
		updateAbilityExecution()
	
	elseif abilityExecutionData["ability-state"] == "update" then
		-- launch the projectile!
		local arrowsRemaining = abilityExecutionData["ability-statistics"]["bounces"]
		local castingPlayer = ability_utilities.getCastingPlayer(abilityExecutionData)
		local victims = {}
		
		local function isVictim(target)
			for _, victim in pairs(victims) do
				if victim == target then
					return true
				end
			end
			return false
		end
		
		local tryBouncing, fireArrow
		
		function tryBouncing(position, ignoreList, targetStruck)
			if arrowsRemaining <= 0 then return end
			if not targetStruck then return end
			
			table.insert(victims, targetStruck)
			table.insert(ignoreList, targetStruck)
			
			local renderContainer = network:invoke("getRenderCharacterContainerByEntityManifest", targetStruck)
			if renderContainer then
				table.insert(ignoreList, renderContainer)
			end
			
			local targets = damage.getDamagableTargets(castingPlayer)
			local bestDistanceSq = 32 ^ 2
			local bestTarget = nil
			for _, target in pairs(targets) do
				if not isVictim(target) then
					local delta = target.Position - position
					local distanceSq = delta.X ^ 2 + delta.Y ^ 2 + delta.Z ^ 2
					if distanceSq < bestDistanceSq then
						bestTarget = target
						bestDistanceSq = distanceSq
					end
				end
			end
			
			if bestTarget then
				fireArrow(position, bestTarget.Position, ignoreList)
			end
		end
		
		function fireArrow(startPoint, targetPoint, ignoreList)
			arrowsRemaining = arrowsRemaining - 1
			
			local arrow = script.arrow:Clone()
			local trail = arrow.trail
			arrow.Position = startPoint
			arrow.Parent = entitiesFolder
			
			local speed = 200
			local direction = projectile.getUnitVelocityToImpact_predictive(
				startPoint,
				speed,
				targetPoint,
				Vector3.new()
			)
			
			projectile.createProjectile(
				startPoint,
				
				direction or (targetPoint - startPoint).Unit,
				
				speed,
				
				arrow,
				
				function(hitPart)
					-- deactivate effects gracefully
					arrow.Transparency = 1
					trail.Enabled = false
					debris:AddItem(arrow, trail.Lifetime)
					arrow.hit:Play()
					
					-- do damage
					local canDamage, target = damage.canPlayerDamageTarget(castingPlayer, hitPart)
					if canDamage then
						if isAbilitySource then
							network:fire("requestEntityDamageDealt", target, arrow.Position, "ability", self.id, "boulder", guid)
						end
						
						-- shoot another arrow
						delay(0.1, function()
							tryBouncing(arrow.Position, ignoreList, target)
						end)
					end
				end,
				
				function(t)
					return CFrame.Angles(math.pi / 2, 0, 0)
				end,
				
				ignoreList,
				
				true,
				
				1
			)
		end
		
		local targetPoint = abilityExecutionData["mouse-target-position"]
		local ignoreList = projectile.makeIgnoreList{
			renderCharacterContainer,
			manifest
		}
		local startPoint = weapon.PrimaryPart.Position
		
		fireArrow(startPoint, targetPoint, ignoreList)
		wait(0.1)
		if isAbilitySource then
			network:fire("setIsPlayerCastingAbility", false)
			network:invoke("client_changeAbilityState", abilityData.id, "end")
		end
	end
end

return abilityData