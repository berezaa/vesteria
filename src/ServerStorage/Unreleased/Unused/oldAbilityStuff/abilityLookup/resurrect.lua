local abilityAnimations = game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local debris = game:GetService("Debris")
local players = game:GetService("Players")

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local network 			= modules.load("network")
	local damage 			= modules.load("damage")
	local placeSetup 		= modules.load("placeSetup")
	local tween	 			= modules.load("tween")

local entitiesFolder = placeSetup.awaitPlaceFolder("entities")

local abilityData = {
	id = 45,
	
	name = "Resurrect",
	image = "rbxassetid://4079577146",
	description = "Cast on a fallen player's tombstone to return them to life. (Requires staff.)",
	mastery = "",
	layoutOrder = 0;
	maxRank = 1,
	
	statistics = {
		[1] = {
			cooldown = 120,			
			manaCost = 250,
		},
	},
	
	windupTime = 0.75,
	
	securityData = {
	},
	
	equipmentTypeNeeded = "staff",
}

local RANGE = 24

local function createEffectPart()
	local part = Instance.new("Part")
	part.Anchored = true
	part.CanCollide = false
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	return part
end

local function resurrectEffect(position)
	local sphere = createEffectPart()
	sphere.Material = "Neon"
	sphere.Shape = Enum.PartType.Ball
	sphere.Position = position
	sphere.Color = script.ring.Color
	sphere.Size = Vector3.new(1, 1, 1)
	sphere.Parent = entitiesFolder
	
	tween(sphere, {"Size", "Transparency"}, {sphere.Size * 16, 1}, 1)
	debris:AddItem(sphere, 1)
	
	local cylinder = createEffectPart()
	cylinder.Material = "Neon"
	cylinder.Shape = Enum.PartType.Cylinder
	cylinder.Size = Vector3.new(64, 1, 1)
	cylinder.CFrame =
		CFrame.new(position) *
		CFrame.Angles(0, 0, math.pi / 2) *
		CFrame.new(28, 0, 0)
	cylinder.Color = script.ring.Color
	cylinder.Parent = entitiesFolder
	
	tween(cylinder, {"Size", "Transparency"}, {Vector3.new(64, 8, 8), 1}, 1)
	debris:AddItem(cylinder, 1)
	
	local ring = script.ring:Clone()
	ring.Position = position
	ring.Parent = entitiesFolder
	
	tween(ring, {"Size", "Transparency"}, {ring.Size * 16, 1}, 1)
	debris:AddItem(ring)
	
	local soundPart = createEffectPart()
	soundPart.Size = Vector3.new(0, 0, 0)
	soundPart.Transparency = 1
	soundPart.Position = position
	soundPart.Parent = entitiesFolder
	
	local sound = script.revive:Clone()
	sound.Parent = soundPart
	sound:Play()
	debris:AddItem(soundPart, sound.TimeLength)
end

local function markTombstoneEffect(position)
	local sphere = createEffectPart()
	sphere.Material = "Neon"
	sphere.Shape = Enum.PartType.Ball
	sphere.Position = position
	sphere.Color = script.ring.Color
	sphere.Size = Vector3.new(1, 1, 1)
	sphere.Parent = entitiesFolder
	
	tween(sphere, {"Size", "Transparency"}, {sphere.Size * 8, 1}, 1)
	debris:AddItem(sphere, 1)
	
	local sparkles = createEffectPart()
	sparkles.Size = Vector3.new(6, 6, 6)
	sparkles.Position = position
	sparkles.Transparency = 1
	
	local emitter = script.sparklesEmitter:Clone()
	emitter.Parent = sparkles
	
	sparkles.Parent = entitiesFolder
	
	delay(5, function()
		emitter.Enabled = false
		wait(emitter.Lifetime.Max)
		sparkles:Destroy()
	end)
end

function abilityData:execute_server(player, abilityExecutionData, isAbilitySource, resurrectedPlayer)
	if not isAbilitySource then return end
	if not resurrectedPlayer then return end
	
	local char = resurrectedPlayer.Character
	if not char then return end
	local manifest = char.PrimaryPart
	if not manifest then return end
	local state = manifest:FindFirstChild("state")
	if not state then return end
	
	local isPlayerSpawning = resurrectedPlayer:FindFirstChild("isPlayerSpawning")
	if not isPlayerSpawning then return end
	
	if state.Value == "dead" then
		local tag = Instance.new("BoolValue")
		tag.Name = "resurrecting"
		tag.Value = true
		tag.Parent = resurrectedPlayer
	
		resurrectedPlayer:LoadCharacter()
	end
	
	local point = manifest.Position
	
	network:fireAllClients("abilityFireClientCall", abilityExecutionData, self.id, "markTombstone", point)
	
	-- if the server's still spawning the bro give it a bit
	while isPlayerSpawning.Value do
		wait()
	end
	
	network:invoke("teleportPlayerCFrame_server", resurrectedPlayer, CFrame.new(point))
	
			network:fireAllClients("signal_alertChatMessage", 
			{
				Text = "✨ " .. resurrectedPlayer.Name .. " was resurrected by " .. player.Name .. " ✨"; 
				Font = Enum.Font.SourceSansBold; 
				Color = Color3.fromRGB(255, 223, 106)
			})		
	network:fireAllClients("abilityFireClientCall", abilityExecutionData, self.id, "resurrect", point)
end

function abilityData:execute_client(abilityExecutionData, func, position)
	if func == "resurrect" then
		resurrectEffect(position)
	elseif func == "markTombstone" then
		markTombstoneEffect(position)
	end
end

function abilityData:execute(renderCharacterContainer, abilityExecutionData, isAbilitySource, guid)
	local root = renderCharacterContainer.PrimaryPart
	if not root then return end
	
	-- acquire the weapon for some fancy animations
	local weapons = network:invoke("getCurrentlyEquippedForRenderCharacter", renderCharacterContainer.entity)
	local weaponManifest = weapons["1"] and weapons["1"].manifest
	if not weaponManifest then return end
	local weaponMagic = weaponManifest:FindFirstChild("magic")
	if not weaponMagic then return end
	local castEffect = weaponMagic:FindFirstChild("castEffect")
	if not castEffect then return end
	
	-- activate particles and wind up the attack
	castEffect.Enabled = true
	
	local track = renderCharacterContainer.entity.AnimationController:LoadAnimation(abilityAnimations["mage_ascend"])
	track:Play()
	
	-- cause the player to stop a moment
	-- free them up later, though
	if isAbilitySource then
		network:invoke("setCharacterArrested", true)
		delay(track.Length, function()
			network:invoke("setCharacterArrested", false)
		end)
	end
	
	-- channeling sound
	local channelSound = script.channel:Clone()
	channelSound.Parent = root
	channelSound:Play()
	debris:AddItem(channelSound, channelSound.TimeLength)
	
	-- AND NOW WE WIND UP
	wait(self.windupTime)
	
	-- disable ongoing effects gracefully
	castEffect.Enabled = false
	
	-- casting sound
	local castSound = script.cast:Clone()
	castSound.Parent = root
	castSound:Play()
	debris:AddItem(castSound, castSound.TimeLength)
	
	-- acquire the players we could cast this on
	if isAbilitySource then
		--[[
		local validPlayers = {}
		
		local partyData = network:invokeServer("playerRequest_getMyPartyData")
		if partyData then
			for _, member in pairs(partyData.members) do
				table.insert(validPlayers, member.player)
			end
		else
			table.insert(validPlayers, players.LocalPlayer)
		end
		]]
		
		local validPlayers = game.Players:GetPlayers()
		
		-- get their tombstones (if any)
		local resurrectedPlayer = nil
		local nearestPlayer = nil
		local bestDistance = RANGE
		
		local function checkValidPlayer(validPlayer)
			local char = validPlayer.Character
			if not char then return end
			print("char")
			local manifest = char.PrimaryPart
			if not manifest then return end
			print("manifest")
			local state = manifest:FindFirstChild("state")
			if not state then return end
			print("state", state.Value)
			
			if state.Value == "dead" then
				print("dead")
				local distance = (manifest.Position - root.Position).Magnitude
				if distance < bestDistance then
					print("range")
					resurrectedPlayer = validPlayer
					nearestPlayer = validPlayer
					bestDistance = distance
				end
			end
		end
		
		for _, validPlayer in pairs(validPlayers) do
			checkValidPlayer(validPlayer)
		end
		
		-- need this stuff to do anything so yeah
		if not nearestPlayer then return end
		if not resurrectedPlayer then return end
		
		-- do the actual resurrecting
		network:fireServer("abilityFireServerCall", abilityExecutionData, self.id, resurrectedPlayer)
	end
end

return abilityData