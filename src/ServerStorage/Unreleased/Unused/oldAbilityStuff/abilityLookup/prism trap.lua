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
	id = 42,
	
	name = "Prism Trap",
	image = "rbxassetid://4079577550",
	description = "Place a trap at your feet that will immobilize the first enemy to step on it and explode.",
	mastery = "More damage.",
	
	maxRank = 10,
	
	statistics = ability_utilities.calculateStats{
		maxRank = 10,
		static = {
			cooldown = 10,
			trapDuration = 8,
		},
		staggered = {
			damageMultiplier = {first = 2, final = 3, levels = {2, 5, 8}},
			radius = {first = 12, final = 20, levels = {3, 6, 9}},
			rootDuration = {first = 3, final = 6, levels = {4, 7, 10}},
			traps = {first = 1, final = 3, levels = {1, 5, 10}, integer = true},
		},
		pattern = {
			manaCost = {base = 10, pattern = {2, 1, 3}},
		},
	},
	
	windupTime = 0.6,
	
	securityData = {
		playerHitMaxPerTag = 16,
		isDamageContained = true,
		projectileOrigin = "character",
	},
}

local COLORS = {
	BrickColor.new("Bright red"),
	BrickColor.new("Bright orange"),
	BrickColor.new("Bright yellow"),
	BrickColor.new("Bright green"),
	BrickColor.new("Bright blue"),
	BrickColor.new("Bright violet"),
}
local COLOR_COUNT = #COLORS

function createEffectPart()
	local part = Instance.new("Part")
	part.Anchored = true
	part.CanCollide = false
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	return part
end

function abilityData._serverProcessDamageRequest(sourceTag, baseDamage)
	if sourceTag == "trap" then
		return baseDamage, "magical", "projectile"
	end
end

local function isResilient(manifest)
	return manifest:FindFirstChild("resilient") ~= nil
end

function abilityData:execute_server(player, abilityExecutionData, isAbilitySource, guid)
	if not isAbilitySource then return end
	
	local char = player.Character
	if not char then return end
	local manifest = char.PrimaryPart
	if not manifest then return end
	
	local trapDuration = abilityExecutionData["ability-statistics"]["trapDuration"]
	local rootDuration = abilityExecutionData["ability-statistics"]["rootDuration"]
	local radius = abilityExecutionData["ability-statistics"]["radius"]
	local radiusSq = radius ^ 2
	
	local trapRadius = 2
	local trapRadiusSq = trapRadius ^ 2
	
	--local position = manifest.Position + Vector3.new(0, -1.5, 0)
	
	local function setTrap(position)
		local trap = Instance.new("Model")
		
		local partA = script.trap:Clone()
		partA.Position = position
		partA.locator.Position = partA.Position
		partA.gyro.CFrame = CFrame.new()
		partA.Parent = trap
		local colorOffsetA = math.random(1, COLOR_COUNT)
		
		local partB = partA:Clone()
		partB.Position = position + Vector3.new(0, 0.25, 0)
		partB.locator.Position = partB.Position
		partB.spinner.AngularVelocity = -partB.spinner.AngularVelocity
		partB.Parent = trap
		local colorOffsetB = math.random(1, COLOR_COUNT)
		
		effects.onHeartbeatFor(trapDuration + rootDuration, function(dt, t, w)
			local colorsPerSecond = COLOR_COUNT * 2
			local index = math.floor(t * colorsPerSecond)
			local indexA = (index + colorOffsetA) % COLOR_COUNT + 1
			local indexB = (index + colorOffsetB) % COLOR_COUNT + 1
			partA.BrickColor = COLORS[indexA]
			partB.BrickColor = COLORS[indexB]
		end)
		
		trap.Parent = entitiesFolder
		
		local sprung = false
		
		local function spring(target)
			sprung = true
			
			network:fireAllClients("abilityFireClientCall", abilityExecutionData, self.id, position, radius)
			for _, target in pairs(damage.getDamagableTargets(player)) do
				local delta = target.position - position
				local distanceSq = delta.X ^ 2 + delta.Z ^ 2
				if distanceSq <= radiusSq then
					network:fire("playerRequest_damageEntity_server", player, target, target.Position, "ability", self.id, "trap", guid)
				end
			end
			
			local hitSound = script.hit:Clone()
			hitSound.Parent = target
			hitSound:Play()
			debris:AddItem(hitSound, hitSound.TimeLength)
			
			if isResilient(target) then
				trap:Destroy()
				return
			end
			
			local newPosition = target.Position + Vector3.new(0, 4, 0)
			
			if target:FindFirstChildOfClass("BodyPosition") then
				local bpPart = Instance.new("Part")
				bpPart.Size = Vector3.new()
				bpPart.CanCollide = false
				bpPart.Transparency = 1
				bpPart.CFrame = target.CFrame
				bpPart.Parent = entitiesFolder
				
				local weld = Instance.new("WeldConstraint")
				weld.Part0 = bpPart
				weld.Part1 = target
				weld.Parent = bpPart
				
				local bp = Instance.new("BodyPosition")
				bp.MaxForce = Vector3.new(1e12, 1e12, 1e12)
				bp.Position = newPosition
				bp.Parent = bpPart
				
				delay(rootDuration, function()
					bpPart:Destroy()
					trap:Destroy()
				end)
			else
				local bp = Instance.new("BodyPosition")
				bp.MaxForce = Vector3.new(1e12, 1e12, 1e12)
				bp.Position = newPosition
				bp.Parent = target
				
				delay(rootDuration, function()
					bp:Destroy()
					trap:Destroy()
				end)
			end
			
			partA.locator.Position = newPosition + Vector3.new(0,  1, 0)
			partB.locator.Position = newPosition + Vector3.new(0, -1, 0)
		end
		
		local function update()
			local bestTarget = nil
			local bestDistanceSq = trapRadiusSq
			
			for _, target in pairs(damage.getDamagableTargets(player)) do
				local delta = target.Position - position
				local distanceSq = delta.X ^ 2 + delta.Z ^ 2
				if distanceSq <= bestDistanceSq then
					bestTarget = target
					bestDistanceSq = distanceSq
				end
			end
			
			if bestTarget then
				spring(bestTarget)
			end
		end
		
		spawn(function()
			while not sprung do
				update()
				wait(0.05)
			end
		end)
		
		delay(trapDuration, function()
			if not sprung then
				sprung = true
				trap:Destroy()
			end
		end)
	end
	
	local trapCount = abilityExecutionData["ability-statistics"]["traps"]
	
	if trapCount == 1 then
		setTrap(manifest.Position + Vector3.new(0, -1.5, 0))
	
	elseif trapCount == 2 then
		local cframe = manifest.CFrame
		local position = cframe.Position + Vector3.new(0, -1.5, 0)
		
		setTrap(position + cframe.RightVector * 4)
		setTrap(position - cframe.RightVector * 4)
	
	elseif trapCount == 3 then
		local cframe = manifest.CFrame
		local radius = 6
		
		local function getPosition(theta)
			theta = theta - math.pi / 2
			return (cframe * CFrame.new(math.cos(theta) * radius, -1.5, math.sin(theta) * radius)).Position
		end
		
		local circle = math.pi * 2
		setTrap(getPosition(circle * 0/3))
		setTrap(getPosition(circle * 1/3))
		setTrap(getPosition(circle * 2/3))
	end
end

function abilityData:execute_client(abilityExecutionData, point, radius)
	local sphere = createEffectPart()
	sphere.Shape = Enum.PartType.Ball
	sphere.Position = point
	sphere.Size = Vector3.new()
	sphere.Material = Enum.Material.Neon
	sphere.Parent = entitiesFolder
	
	local duration = 1
	tween(sphere, {"Size", "Transparency"}, {Vector3.new(1, 1, 1) * radius * 2, 1}, duration)
	
	local clock = 0
	effects.onHeartbeatFor(duration, function(dt)
		clock = clock - dt
		if clock <= 0 then
			clock = 0.1
			sphere.BrickColor = COLORS[math.random(1, #COLORS)]
		end
	end)
	
	debris:AddItem(sphere, duration)
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
	
	-- animation
	local track = renderCharacterContainer.entity.AnimationController:LoadAnimation(abilityAnimations["mage_slash_down"])
	track:Play()
	
	-- emitter
	local attachment = Instance.new("Attachment")
	attachment.Name = "TrickTrapEmitterAttachment"
	attachment.Parent = leftHand
	
	local emitter = script.whimsyEmitter:Clone()
	emitter.Parent = attachment
	
	-- turn off emitter so that it's finished when the windup is done
	delay(self.windupTime - emitter.Lifetime.Max, function()
		emitter.Enabled = false
	end)
	
	-- cause the player to stop a moment
	if isAbilitySource then
		network:invoke("setCharacterArrested", true)
	end
	
	-- pause for effect
	wait(self.windupTime)
	
	-- release the player gracefully
	track:Stop(0.25)
	if isAbilitySource then
		network:invoke("setCharacterArrested", false)
	end
	
	-- casting sound
	local castSound = script.cast:Clone()
	castSound.Parent = leftHand
	castSound:Play()
	debris:AddItem(castSound, castSound.TimeLength)
	
	-- summon the trap
	if isAbilitySource then
		network:invokeServer("abilityInvokeServerCall", abilityExecutionData, self.id, guid)
	end
end

return abilityData