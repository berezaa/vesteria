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
	id = 57,
	
	name = "Simulacrum",
	image = "rbxassetid://4465750442",
	description = "Use dark magic to create a simulacrum. It mimics Warlock abilities. Reactivate to order it to charge the nearest enemy and explode.",
	mastery = "Shorter cooldown.",
	
	maxRank = 5,
	
	statistics = ability_utilities.calculateStats{
		maxRank = 5,
		static = {
			duration = 20,
			radius = 16,
		},
		dynamic = {
			manaCost = {5, 10},
		},
		staggered = {
			cooldown = {first = 10, final = 5, levels = {3, 5}},
			damageMultiplier = {first = 2, final = 3, levels = {2, 4}},
		}
	},
	
	windupTime = 0.9,
	
	securityData = {
		playerHitMaxPerTag = 64,
		isDamageContained = true,
		projectileOrigin = "character",
	},
}

-- as with magic missile, this got a lot dirtier after a redesign
-- probably because I was too opposed to starting over from scratch
-- if you're reading this, I'm sorry that it's not a bit nicer
-- to look at, but hey, that's just the reality with some abilities
-- Davidii

local FOLDER_NAME = "warlockSimulacrumData"

local function forEachPart(object, callback)
	for _, desc in pairs(object:GetDescendants()) do
		if desc:IsA("BasePart") then
			callback(desc)
		end
	end
end

local function lerp(a, b, w)
	return a + (b - a) * w
end

local function getSimulacrumCreationPosition(abilityExecutionData)
	local origin =
		abilityExecutionData["mouse-world-position"] +
		Vector3.new(0, 8, 0)
	local ray = Ray.new(
		origin,
		Vector3.new(0, -16, 0)
	)
	local part, point = ability_utilities.raycastMap(ray)
	return point + Vector3.new(0, 2, 0)
end

function abilityData:execute_server(player, abilityExecutionData, isAbilitySource, guid)

	if not isAbilitySource then return end
	
	local char = player.Character
	if not char then return end
	local manifest = char.PrimaryPart
	if not manifest then return end
	
	local folder = player:FindFirstChild(FOLDER_NAME)
	if not folder then
		folder = Instance.new("Folder")
		folder.Name = FOLDER_NAME
		folder.Parent = player
	end
	
	local simCount = #folder:GetChildren()

	
	-- no simulacrum, make one and reset cooldown
	if simCount == 0 then

		network:fireAllClients("abilityFireClientCall", abilityExecutionData, self.id, "creationEffect")
		
		-- pause for the effects, should usually sync up
		wait(1)
		
		local sim = Instance.new("Folder")
		sim.Name = "simulacrum"
		
		local cframe = Instance.new("CFrameValue")
		cframe.Name = "cframe"
		cframe.Value =
			CFrame.new(getSimulacrumCreationPosition(abilityExecutionData)) *
			CFrame.Angles(0, math.pi * 2 * math.random(), 0)
		cframe.Parent = sim
		
		sim.Parent = folder
		
		debris:AddItem(sim, abilityExecutionData["ability-statistics"]["duration"])
		
		network:invoke("abilityCooldownReset_server", player, self.id)
	
	-- we have a simulacrum, have it rush to the nearest target and explode
	else
		local sim = folder:GetChildren()[1]
		
		-- find a chase target
		local targets = damage.getDamagableTargets(player)
		local bestDistanceSq = 32 ^ 2
		local bestTarget = nil
		for _, target in pairs(targets) do
			local delta = target.Position - sim.cframe.Value.Position
			local distanceSq = delta.X ^ 2 + delta.Y ^ 2 + delta.Z ^ 2
			if distanceSq < bestDistanceSq then
				bestTarget = target
				bestDistanceSq = distanceSq
			end
		end
		
		network:fireAllClientsExcludingPlayer("abilityFireClientCall", player, abilityExecutionData, self.id, "detonateSimulacrums", folder, bestTarget, false)
		
		-- intentionally an invoke here, so we wait for the client to detonate
		-- before we clean everything up
		network:invokeClient("abilityInvokeClientCall", player, abilityExecutionData, self.id, "detonateSimulacrums", folder, bestTarget, true, guid)
		
		-- get rid of all extant simulacrums
		folder:ClearAllChildren()
	end
end

function abilityData:detonateSimulacrums(abilityExecutionData, folder, target, isAbilitySource, guid)
	local castingPlayer = ability_utilities.getCastingPlayer(abilityExecutionData)
	
	local radius = abilityExecutionData["ability-statistics"]["radius"]
	local radiusSq = radius ^ 2
	
	for _, sim in pairs(folder:GetChildren()) do
		local model = sim:FindFirstChild("modelRef")
		if model then
			model = model.Value
			
			-- animation
			local animator = model:FindFirstChild("animationController")
			if animator then
				local animations = model:FindFirstChild("animations")
				if animations then
					local animation = animations:FindFirstChild("cast")
					if animation then
						local track = animator:LoadAnimation(animation)
						track:Play()
					end
				end
			end
			
			if target then
				local speed = 24
				effects.onHeartbeatFor(self.windupTime, function(dt, t, w)
					local delta = target.Position - model.PrimaryPart.Position
					local distance = delta.Magnitude
					local direction = delta / distance
					local traversed = speed * dt
					local movement
					if distance < 1 then
						movement = Vector3.new()
					elseif traversed >= distance then
						movement = delta
					else
						movement = direction * traversed
					end
					model:SetPrimaryPartCFrame(CFrame.new(
						model.PrimaryPart.Position + movement,
						target.Position
					))
				end)
			end
			
			-- all the effects after the animation has played
			delay(self.windupTime, function()
				if not model.Parent then return end
				
				-- explosion
				do
					local sphere = script.darkSphere:Clone()
					sphere.Position = model.PrimaryPart.Position
					sphere.Parent = entitiesFolder
					
					sphere.hit:Play()
					
					tween(sphere, {"Size", "Transparency"}, {Vector3.new(1, 1, 1) * radius * 2, 1}, 0.5)
				end
				
				-- fade out (server handles model cleanup)
				forEachPart(model, function(part)
					tween(part, {"Transparency"}, 1, 0.5)
				end)
				
				-- damage
				if isAbilitySource then
					local targets = damage.getDamagableTargets(castingPlayer)
					for _, target in pairs(targets) do
						local delta = target.Position - model.PrimaryPart.Position
						local distanceSq = delta.X ^ 2 + delta.Y ^ 2 + delta.Z ^ 2
						if distanceSq <= radiusSq then
							network:fire("requestEntityDamageDealt", target, target.Position, "ability", self.id, "explode", guid)
						end
					end
				end
			end)
		end
	end
	
	wait(self.windupTime)
end

function abilityData:creationEffect(abilityExecutionData)
	local castingPlayer = ability_utilities.getCastingPlayer(abilityExecutionData)
	if not castingPlayer then return end
	local char = castingPlayer.Character
	if not char then return end
	local manifest = char.PrimaryPart
	if not manifest then return end
	local renderCharacterContainer = network:invoke("getRenderCharacterContainerByEntityManifest", manifest)
	if not renderCharacterContainer then return end
	local root = renderCharacterContainer.PrimaryPart
	if not root then return end
	
	local creationPosition = getSimulacrumCreationPosition(abilityExecutionData)
	
	-- do a neat spiral thing
	do
		local darks = {}
		local darkCount = 3
		local rotStep = math.pi * 2 / darkCount
		for darkNumber = 1, darkCount do
			local dark = script.dark:Clone()
			dark.Parent = entitiesFolder
			
			table.insert(darks, {
				part = dark,
				rotOffset = rotStep * (darkNumber - 1),
			})
		end
		
		local duration = 0.5
		local rot = 0
		local rotSpeed = math.pi * 3 / duration
		local rise = -2
		local riseSpeed = 4 / duration
		local radius = 3
		
		local function setDark(dark)
			local darkRot = rot + dark.rotOffset
			local dx = math.cos(darkRot) * radius
			local dy = rise
			local dz = math.sin(darkRot) * radius
			
			dark.part.CFrame =
				CFrame.new(creationPosition) +
				Vector3.new(dx, dy, dz)
		end
		
		effects.onHeartbeatFor(duration, function(dt, t, w)
			rot = rot + rotSpeed * dt
			rise = rise + riseSpeed * dt
			
			for _, dark in pairs(darks) do
				if w < 1 then
					setDark(dark)
					
					if w < 0.5 then
						local w2 = w * 2
						dark.part.Position = lerp(root.Position, dark.part.Position, w2)
					end
				end
			end
			
			if w == 1 then
				duration = 0.5
				riseSpeed = -2 / duration
				local radiusSpeed = -3 / duration
				
				effects.onHeartbeatFor(duration, function(dt, t, w)
					rot = rot + rotSpeed * dt
					rise = rise + riseSpeed * dt
					radius = radius + radiusSpeed * dt
					
					for _, dark in pairs(darks) do
						if w < 1 then
							setDark(dark)
						elseif w == 1 then
							tween(dark.part, {"Transparency"}, 1, dark.part.trail.Lifetime)
							dark.part.trail.Enabled = false
							debris:AddItem(dark.part, dark.part.trail.Lifetime)
							
							-- sphere
							local sphere = script.darkSphere:Clone()
							sphere.Position = creationPosition
							sphere.Parent = entitiesFolder
							sphere.summon:Play()
							tween(sphere, {"Size", "Transparency"}, {Vector3.new(8, 8, 8), 1}, 1)
							debris:AddItem(sphere, 1)
						end
					end
				end)
			end
		end)
	end
end

function abilityData:execute_client(abilityExecutionData, func, ...)
	return self[func](self, abilityExecutionData, ...)
end

local function onSimulacrumAdded(sim)
	local model = script.simulacrum:Clone()
	local animator = model.animationController
	
	local ref = Instance.new("ObjectValue")
	ref.Name = "modelRef"
	ref.Value = model
	ref.Parent = sim
	
	forEachPart(model, function(part)
		local transparency = part.Transparency
		part.Transparency = 1
		tween(part, {"Transparency"}, transparency, 1)
	end)
	
	model:SetPrimaryPartCFrame(sim:WaitForChild("cframe").Value)
	model.Parent = entitiesFolder
	
	animator:LoadAnimation(model.animations.idle):Play()
end

local function onSimulacrumRemoved(sim)
	local ref = sim:FindFirstChild("modelRef")
	if not ref then return end
	
	ref.Value:Destroy()
end

local function onSimulacrumFolderAdded(folder)
	for _, child in pairs(folder:GetChildren()) do
		onSimulacrumAdded(child)
	end
	folder.ChildAdded:Connect(onSimulacrumAdded)
	folder.ChildRemoved:Connect(onSimulacrumRemoved)
end

local function onPlayerAdded(player)
	if player:FindFirstChild(FOLDER_NAME) then
		onSimulacrumFolderAdded(player[FOLDER_NAME])
	else
		local conn
		local function onChildAdded(child)
			if child.Name == FOLDER_NAME then
				onSimulacrumFolderAdded(child)
				conn:Disconnect()
			end
		end
		conn = player.ChildAdded:Connect(onChildAdded)
	end
end

local function onPlayerRemoving(player)
	if player:FindFirstChild(FOLDER_NAME) then
		for _, sim in pairs(player[FOLDER_NAME]:GetChildren()) do
			onSimulacrumRemoved(sim)
		end
	end
end

-- this probably won't cause issues, right?
if runService:IsClient() then
	local players = game:GetService("Players")
	players.PlayerAdded:Connect(onPlayerAdded)
	players.PlayerRemoving:Connect(onPlayerRemoving)
	for _, player in pairs(players:GetPlayers()) do
		onPlayerAdded(player)
	end
end

function abilityData:execute(renderCharacterContainer, 	abilityExecutionData, isAbilitySource, guid)
	local root = renderCharacterContainer.PrimaryPart
	if not root then return end
	
	local entity = renderCharacterContainer:FindFirstChild("entity")
	if not entity then return end
	
	if isAbilitySource then
		network:fireServer("abilityFireServerCall", abilityExecutionData, self.id, guid)
	end
end

return abilityData