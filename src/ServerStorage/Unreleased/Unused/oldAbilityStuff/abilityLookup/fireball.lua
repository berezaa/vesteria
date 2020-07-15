local abilityAnimations = game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local debris = game:GetService("Debris")

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local network 			= modules.load("network")
	local damage 			= modules.load("damage")
	local placeSetup 		= modules.load("placeSetup")
	local tween	 			= modules.load("tween")
	local ability_utilities = modules.load("ability_utilities")

local entitiesFolder = placeSetup.awaitPlaceFolder("entities")

local abilityData = {
	id = 49,
	
	name = "Meteor Strike",
	image = "rbxassetid://3967026015",
	description = "Call down a flaming ball of magic which explodes, igniting nearby enemies.",
	
	layoutOrder = 0;
	maxRank = 10,
	
	statistics = ability_utilities.calculateStats{
		maxRank = 10,
		static = {
			cooldown = 8,
			range = 100,
		},
		staggered = {
			damageMultiplier = {first = 1.5, final = 2.5, levels = {2, 5, 8}},
			percentHealthBurned = {first = 15, final = 30, levels = {3, 6, 9}},
			radius = {first = 40, final = 62, levels = {4, 7, 10}},
		},
		pattern = {
			manaCost = {base = 25, pattern = {2, 3, 2}},
		},
	},
	
	windupTime = 0.75,
	
	securityData = {
		playerHitMaxPerTag = 64,
		isDamageContained = true,
		projectileOrigin = "character",
	},
	
	targetingData = {
		targetingType = "directSphere",
		range = "range",
		radius = "radius",
		
		onStarted = function(entityContainer, executionData)
			local attachment = network:invoke("getCurrentlyEquippedForRenderCharacter", entityContainer.entity)["1"].manifest.magic
			
			local emitter = script.fireball.emitter:Clone()
			emitter.Lifetime = NumberRange.new(0.5)
			emitter.Parent = attachment
			
			local light = Instance.new("PointLight")
			light.Color = BrickColor.new("Bright orange").Color
			light.Parent = attachment
			
			return {emitter = emitter, light = light}
		end,
		
		onEnded = function(entityContainer, executionData, data)
			data.emitter.Enabled = false
			debris:AddItem(data.emitter, data.emitter.Lifetime.Max)
			
			data.light:Destroy()
		end
	},
	
	equipmentTypeNeeded = "staff",
	disableAutoaim = true,
}

function createEffectPart()
	local part = Instance.new("Part")
	part.Anchored = true
	part.CanCollide = false
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	return part
end

function yeet()
	
end

function abilityData._serverProcessDamageRequest(sourceTag, baseDamage)
	if sourceTag == "explosion" then
		return baseDamage, "magical", "aoe"
	end
end

function abilityData:execute_server(player, abilityExecutionData, isAbilitySource)
	if not isAbilitySource then return end
	local char = player.Character
	if not char then return end
	local manifest = char.PrimaryPart
	if not manifest then return end

	local remote = Instance.new("RemoteEvent")
	remote.Name = "FlamecallTemporarySecureRemote"
	remote.OnServerEvent:connect(function(player, targets)
		for _, target in pairs(targets) do
			network:invoke(
				"applyStatusEffectToEntityManifest",
				target,
				"ablaze",
				{
					duration = 4,
					percent = abilityExecutionData["ability-statistics"]["percentHealthBurned"] / 100,
				},
				manifest,
				"ability",
				self.id
			)
		end
		
		remote:Destroy()
	end)
	remote.Parent = game.ReplicatedStorage
	return remote
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
	
	local remote
	if isAbilitySource then
		remote = network:invokeServer("abilityInvokeServerCall", abilityExecutionData, self.id)
	end
	
	-- activate particles and wind up the attack
	castEffect.Enabled = true
	
	local track = renderCharacterContainer.entity.AnimationController:LoadAnimation(abilityAnimations["mage_holdInFront"])
	track:Play()
	
	-- cause the player to stop a moment
	if isAbilitySource then
		network:invoke("setCharacterArrested", true)
	end
	
	wait(self.windupTime)
	
	-- free up the character
	if isAbilitySource then
		network:invoke("setCharacterArrested", false)
	end
	
	-- disable ongoing effects gracefully
	track:Stop(0.25)
	castEffect.Enabled = false
	
	
	
	-- casting sound
	local castSound = script.cast:Clone()
	castSound.Parent = root
	castSound:Play()
	debris:AddItem(castSound, castSound.TimeLength)
	
	local radius = abilityExecutionData["ability-statistics"]["radius"]
	local range = abilityExecutionData["ability-statistics"]["range"]
	local targetPosition = abilityExecutionData["absolute-mouse-world-position"]
	
	local targetVector = targetPosition - weaponMagic.WorldPosition
	if targetVector.magnitude >= range then
		targetVector = targetVector.unit * range
	end
	
	targetPosition = weaponMagic.WorldPosition + targetVector
	
	local explosionDelay = 1.25
	
	local function launch()
	
		-- flame ball!
		local fireball = script.fireball:Clone()
		local emitter = fireball.emitter
		local fireballColor = fireball.Color
		fireball.CFrame = CFrame.new(weaponMagic.WorldPosition) + Vector3.new(0,30,0)
		
		tween(fireball, {"CFrame"}, CFrame.new(targetPosition), explosionDelay, nil, Enum.EasingDirection.In)
		tween(fireball, {"Size"}, Vector3.new(1, 1, 1) * 4, explosionDelay)
		tween(fireball, {"Color"}, Color3.new(1, 1, 0.5), explosionDelay, Enum.EasingStyle.Linear)
		
		fireball.Parent = entitiesFolder
		
		delay(explosionDelay, function()
			-- explode
			fireball.hit:Play()
			emitter.Rate = emitter.Rate * radius/5
			tween(fireball, {"Size", "Transparency", "Color"}, {Vector3.new(1, 1, 1) * radius * 2, 1, fireballColor}, 0.25)
			delay(0.25, function()
				emitter.Enabled = false
				wait(emitter.Lifetime.Max)
				fireball:Destroy()
			end)
			
			-- damage and stuff
			if isAbilitySource then
				local targets = {}
				local radiusSq = radius * radius
				for _, target in pairs(damage.getDamagableTargets(game.Players.LocalPlayer)) do
					local delta = target.Position - targetPosition
					local distanceSq = delta.X * delta.X + delta.Y * delta.Y + delta.Z * delta.Z
					if distanceSq < radiusSq then
						network:fire("requestEntityDamageDealt", target, target.position, "ability", self.id, "explosion", guid)
						table.insert(targets, target)
					end
				end
				remote:FireServer(targets)
			end
		end)
	
	end
	
	launch()

end

return abilityData