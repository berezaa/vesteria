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
	local detection 		= modules.load("detection")

local entitiesFolder = placeSetup.awaitPlaceFolder("entities")

local abilityData = {
	id = 43,
	
	name = "Shadow Flurry",
	image = "rbxassetid://4079577011",
	description = "Assault the area in front of you with your shadow. (Requires dagger.)",
	mastery = "More damage.",
	
	maxRank = 10,
	
	statistics = ability_utilities.calculateStats{
		maxRank = 10,
		static = {
			cooldown = 10,
		},
		staggered = {
			damageMultiplier = {first = 1, final = 2, levels = {2, 3, 5, 6, 8, 9}},
			strikeCount = {first = 4, final = 7, levels = {4, 7, 10}, integer = true},
		},
		pattern = {
			manaCost = {base = 6, pattern = {2, 2, 5}},
		},
	},
	
	windupTime = 0.25,
	
	securityData = {
		playerHitMaxPerTag = 6,
		isDamageContained = true,
	},
	
	equipmentTypeNeeded = "dagger",
}

local function createShadow(entity)
	local shadow = Instance.new("Model")
	
	for _, object in pairs(entity:GetDescendants()) do
		if object:IsA("BasePart") then
			local part = object:Clone()
			for _, child in pairs(part:GetChildren()) do
				if (not child:IsA("SpecialMesh")) then
					child:Destroy()
				end
			end
			part.Anchored = true
			if part.Transparency < 1 then
				part.Color = Color3.new(0, 0, 0)
				part.Transparency = 0.5
				part.Material = Enum.Material.SmoothPlastic
			end
			part.Parent = shadow
			
			if object == entity.PrimaryPart then
				shadow.PrimaryPart = part
			end
		end
	end
	
	return shadow
end

local function forEachPart(model, callback)
	for _, object in pairs(model:GetDescendants()) do
		if object:IsA("BasePart") then
			callback(object)
		end
	end
end

local function lerp(a, b, w)
	return a + (b - a) * w
end

function abilityData._serverProcessDamageRequest(sourceTag, baseDamage)
	if sourceTag == "strike" then
		return baseDamage, "physical", "aoe"
	end
end

function abilityData:validateDamageRequest(monsterManifest, hitPosition)
	return (monsterManifest - hitPosition).magnitude <= 8
end

function abilityData:execute(renderCharacterContainer, 	abilityExecutionData, isAbilitySource, guid)
	local root = renderCharacterContainer.PrimaryPart
	if not root then return end
	
	local currentlyEquipped = network:invoke("getCurrentlyEquippedForRenderCharacter", renderCharacterContainer.entity)
	local currentWeaponManifest = currentlyEquipped["1"] and currentlyEquipped["1"].manifest
	if not currentWeaponManifest then return end
	
	local animationTrack = renderCharacterContainer.entity.AnimationController:LoadAnimation(abilityAnimations["dagger_execute"])
	animationTrack:Play()
	
	local slashSound = script.slash:Clone()
	slashSound.Parent = root
	slashSound:Play()
	debris:AddItem(slashSound, slashSound.TimeLength)
	
	delay(self.windupTime - 0.1, function()
		local darkSound = script.dark:Clone()
		darkSound.Parent = root
		darkSound:Play()
		debris:AddItem(darkSound, darkSound.TimeLength)
	end)
	
	wait(self.windupTime)
	
	-- create a shadow template for later use
	local shadowTemplate = createShadow(renderCharacterContainer.entity)
	
	-- where will we hit and how big are the hits
	local point = (root.CFrame * CFrame.new(0, 0, -6)).Position
	local radius = 8
	local radiusSq = radius ^ 2
	
	local function dealDamage()
		if not isAbilitySource then return end
		
		local targets = damage.getDamagableTargets(game.Players.LocalPlayer)
		for _, target in pairs(targets) do
			local delta = target.Position - point
			local distanceSq = delta.X ^ 2 + delta.Z ^ 2
			if distanceSq <= radiusSq then
				network:fire("requestEntityDamageDealt", target, target.position, "ability", self.id, "strike", guid)
			end
		end
	end
	
	-- create shadow clones
	local strikeCount = abilityExecutionData["ability-statistics"]["strikeCount"]
	local shadows = {}
	for strikeNumber = 1, strikeCount do
		local shadow = shadowTemplate:Clone()
		local theta = (math.pi * 2) * ((strikeNumber - 1) / strikeCount)
		local r = 12
		local dx = math.cos(theta) * r
		local dy = 6
		local dz = math.sin(theta) * r
		shadow:SetPrimaryPartCFrame(CFrame.new(
			point + Vector3.new(dx, dy, dz),
			point
		))
		forEachPart(shadow, function(part)
			local transparency = part.Transparency
			part.Transparency = 1
			tween(part, {"Transparency"}, transparency, 0.25)
		end)
		shadow.Parent = entitiesFolder
		
		table.insert(shadows, shadow)
	end
	
	local rushDuration = 0.25
	for _, shadow in pairs(shadows) do
		local tweenPart = Instance.new("Part")
		tweenPart.CFrame = shadow.PrimaryPart.CFrame
		tween(tweenPart, {"CFrame"}, tweenPart.CFrame + (point - shadow.PrimaryPart.Position), rushDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		effects.onHeartbeatFor(rushDuration, function(dt, t, w)
			shadow:SetPrimaryPartCFrame(tweenPart.CFrame)
			if w == 1 then
				forEachPart(shadow, function(part)
					tween(part, {"Transparency"}, 1, 0.25)
				end)
				debris:AddItem(shadow, 0.25)
				dealDamage()
			end
		end)
		wait(rushDuration * 0.5)
	end
end

return abilityData