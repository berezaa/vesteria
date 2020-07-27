--Modules
local Modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
local network = Modules.load("network")
local Effects = Modules.load("effects")
local Tween = Modules.load("tween")
local Damage = Modules.load("damage")
local Detection = Modules.load("detection")
local PlaceSetup = Modules.load("placeSetup")

--Ability Assets
local replicatedStorage = game.ReplicatedStorage
local abilityAnims = replicatedStorage.assets.abilityAnimations
local abilitySounds = replicatedStorage.assets.abilities[script.Name].sounds
local abilityEffects = replicatedStorage.assets.abilities[script.Name].effects

--Ability Base Data
local abilityData = {
	--> Identifying Information <--
	id = 2;

	--> Generic Information <--
	name = "Ground Slam";
	image = "rbxassetid://3736598447";
	description = "AOE Damage Ability";

	--> Misc Information <--
	animationName = {"cast", "prayer"};
	windupTime = 0.5;
	speedMulti = 1.5;

	--> Execution Data <--
	executionData = {
		level = 1;
		maxLevel = 5;
	};

	--> Ability Stats <--
	statistics = {
		damage = 25;
		radius = 15;

		manaCost = 10;
		cooldown = 4;

		increasingStat = "radius";
		increaseExponent = 0.2;
	};

	prerequisites = {
		playerLevel = 1;

		classRestricted = false;
		developerOnly = false;

		abilities = {};
	};
}

--Client Execute Function
function abilityData:execute(abilityExecutionData, isAbilitySource)
	local character = abilityExecutionData.casterCharacter
	local renderCharacterContainer = network:invoke("getRenderCharacterContainerByEntityManifest", character.PrimaryPart)

	if not renderCharacterContainer or not renderCharacterContainer.PrimaryPart then return false end

	local currentlyEquipped = network:invoke("getCurrentlyEquippedForRenderCharacter", renderCharacterContainer.entity)
	local currentWeaponManifest = currentlyEquipped["1"] and currentlyEquipped["1"].manifest

	if not currentWeaponManifest then return end

	local animTrack = renderCharacterContainer.entity.AnimationController:LoadAnimation(abilityAnims.warrior_forwardDownslash)
	local trail

	local sound = abilitySounds.cast:Clone()
	sound.Parent = currentWeaponManifest
	sound:Play()
	game.Debris:AddItem(sound, 5)

	local attach0 = currentWeaponManifest:FindFirstChild("bottomAttachment")
	local attach1 = currentWeaponManifest:FindFirstChild("topAttachment")

	if attach0 and attach1 then
		trail = abilityEffects.Trail:Clone()
		trail.Name = "groundSlamTrail"
		trail.Attachment0 = attach0
		trail.Attachment1 = attach1
		trail.Parent = currentWeaponManifest
		trail.Enabled = true
	end

	animTrack:Play(0.1, 1, self.speedMulti or 1)
	wait(animTrack.Length * 0.06 / animTrack.Speed)

	if isAbilitySource then
		local movementVelocity = network:invoke("getMovementVelocity")
		local movementDirection

		if movementVelocity.magnitude > 0 then
			movementDirection = movementVelocity.unit
		else
			movementDirection = character.PrimaryPart.CFrame.lookVector * 0.05
		end

		network:invoke("setCharacterArrested", true)

		local bodyGyro = character.PrimaryPart.hitboxGyro
		local bodyVelocity = character.PrimaryPart.hitboxVelocity

		bodyGyro.CFrame = CFrame.new(Vector3.new(), movementDirection)
		movementDirection = movementDirection + Vector3.new(0, 1, 0)

		network:invoke("setMovementVelocity", movementDirection * 23 * animTrack.Speed)
	end

	wait(animTrack.Length * 0.36 / animTrack.Speed)

	local timeLeft = 30
	local startTime = tick()
	local hitPart, hitPosition, hitNormal

	animTrack:AdjustSpeed(0)

	if isAbilitySource then
		network:invoke("setMovementVelocity", Vector3.new())
		network:invoke("setCharacterArrested", false)
	end

	repeat
		local ray = Ray.new(currentWeaponManifest.Position + (renderCharacterContainer.PrimaryPart.CFrame.lookVector * 3) + Vector3.new(0, 2.5, 0), Vector3.new(0, -10, 0))
		hitPart, hitPosition, hitNormal = workspace:FindPartOnRayWithIgnoreList(ray, {renderCharacterContainer, currentWeaponManifest})
		wait()
	until hitPart or (tick() - startTime) >= timeLeft

	if trail then
		trail:Destroy()
	end

	if isAbilitySource then
		network:invoke("setCharacterArrested", true)
	end

	animTrack:AdjustSpeed(self.speedMulti)

	spawn(function()
		if not hitPart then return false end

		local shockwave1 = abilityEffects.shockwaveEntity:Clone()
		local shockwave2 = abilityEffects.shockwaveEntity:Clone()

		shockwave1.Parent = entitiesFolder
		shockwave2.Parent = entitiesFolder

		local radius = abilityExecutionData.abilityData["statistics"].radius
		local dustPart = abilityEffects.dustPart:Clone()
		dustPart.Parent = workspace.CurrentCamera
		dustPart.CFrame = CFrame.new(hitPosition)
		dustPart.Dust.Speed = NumberRange.new(30 * (radius/10), 50 * (radius/10))
		dustPart.Dust:Emit(100)
		game.Debris:AddItem(dustPart,6)

		local sound = abilitySounds.impact:Clone()
		sound.Parent = dustPart
		sound:Play()

		if isAbilitySource then
			for i, v in pairs(Damage.getDamagableTargets(game.Players.LocalPlayer)) do
				local targetPosition = Detection.projection_Box(v.CFrame, v.Size, hitPosition)
				if ((targetPosition - hitPosition) * Vector3.new(1,0,1)).magnitude <= radius * 0.7 and ((targetPosition - hitPosition) * Vector3.new(0,1,0)).magnitude <= (radius/2) * 0.7 then
					network:fire("requestEntityDamageDealt", v, hitPosition, "ability", self.id, "shockwave", abilityExecutionData.abilityGuid)
					--self:doKnockback(abilityExecutionData, v, hitPosition, getKnockbackAmount(abilityExecutionData))
				elseif ((targetPosition - hitPosition) * Vector3.new(1,0,1)).magnitude <= radius and ((targetPosition - hitPosition) * Vector3.new(0,1,0)).magnitude <= (radius/2) then
					network:fire("requestEntityDamageDealt", v, hitPosition, "ability", self.id, "shockwave-outer", abilityExecutionData.abilityGuid)
					--self:doKnockback(abilityExecutionData, v, hitPosition, getKnockbackAmount(abilityExecutionData))
				end
			end
		end

		local cf = CFrame.new(hitPosition, hitPosition + hitNormal) * CFrame.Angles(math.pi / 2, 0, 0)
		local multi = Vector3.new(radius * 1.7, -1.1, radius * 1.7)
		local base = Vector3.new(0.25, 1.5, 0.25)
		local duration = 1

		shockwave1.Size = base
		shockwave2.Size = base
		shockwave1.CFrame = cf
		shockwave2.CFrame = cf
		shockwave1.Transparency = 0
		shockwave2.Transparency = 0

		Tween(shockwave1, {"Size", "Transparency"}, {base + multi, 1}, duration, Enum.EasingStyle.Quad)
		Tween(shockwave2, {"Size", "Transparency"}, {base + multi, 1}, duration, Enum.EasingStyle.Quint)

		game.Debris:AddItem(shockwave1, 1)
		game.Debris:AddItem(shockwave2, 1)
	end)

	animTrack:AdjustSpeed(self.speedMulti * 1.65)
	wait(animTrack.Length * 0.4 / animTrack.Speed)

	if isAbilitySource then
		network:invoke("setCharacterArrested", false)
	end

	return true, self.statistics.cooldown
end

--Server Execute Function
function abilityData:execute_server(castPlayer, abilityExecutionData, isAbilitySource)

end

return abilityData