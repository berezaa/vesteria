local abilityAnimations = game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local projectile 		= modules.load("projectile")
	local placeSetup 		= modules.load("placeSetup")
	local client_utilities 	= modules.load("client_utilities")
	local network 			= modules.load("network")

local entityManifestCollectionFolder = placeSetup.awaitPlaceFolder("entityManifestCollection")

local httpService = game:GetService("HttpService")

local metadata = {
	cost = 1;
	upgradeCost = 2;
	maxRank = 8;
	layoutOrder = 3;
	
	requirement = function(playerData)
		return playerData.class == "Warrior";
	end;
}

local abilityData = {
	--> identifying information <--
	id 	= 8;
	metadata = metadata;
	--> generic information <--
	name 		= "Combat Roll";
	image 		= "rbxassetid://3736598336";
	description = "Character dodges in movement direction.";
	
	damageType = "physical";
		
	prerequisite = {{id = 26; rank = 1}};
	layoutOrder = 1;	
	duration = 1;		
		
	--> execution information <--
	animationName 	= "combat_roll";
	windupTime 		= 0.1;
	maxRank 		= 5;
	cooldown		= 3;
	
	--> combat stats <--
	statistics = {
		[1] = {
			speed 		= 70;
			cooldown 	= 4;
			manaCost	= 5;
			duration = 1;
		};
		[2] = {
			speed 		= 80;
			cooldown 	= 3.7;
			manaCost	= 6;
		};		
		[3] = {
			speed 		= 90;
			cooldown 	= 3.4;
			manaCost	= 7;
		};	
		[4] = {
			speed 		= 100;
			cooldown 	= 3.1;
			manaCost	= 8;
		};			
		[5] = {
			cooldown 	= 2.6;
			manaCost	= 9;
			tier = 3;
		};		
		[6] = {
			cooldown 	= 2.1;
			manaCost	= 10;
		};		
		[7] = {
			cooldown 	= 1.6;
			manaCost	= 11;
		};	
		[8] = {
			speed 		= 120;
			cooldown 	= 1;
			manaCost	= 15;
			tier = 4;
		};									
	};
	
	dontDisableSprinting = true;

}

function abilityData:execute_server(player, abilityExecutionData, isAbilitySource, targetPoint, monster, knockbackAmount)
	if not isAbilitySource then return end
end

function abilityData.__serverValidateMovement(player, previousPosition, currentPosition, distance)
	local abilityStatisticsData = network:invoke("getAbilityStatisticsForRank", abilityData, network:invoke("getPlayerAbilityRankByAbilityId", player, abilityData.id))
	
	return (currentPosition - previousPosition).magnitude <= abilityStatisticsData.speed * 1.5
end

--							(renderCharacterContainer, 	targetPosition, isAbilitySource, hitNormal, nil, 	guid)
function abilityData:execute(renderCharacterContainer, 	abilityExecutionData, isAbilitySource, guid)
	-- todo: fix
	if not renderCharacterContainer:FindFirstChild("entity") then return false end
	

	local animationTrack = renderCharacterContainer.entity.AnimationController:LoadAnimation(abilityAnimations[self.animationName])
	
	animationTrack:Play()
	if renderCharacterContainer.PrimaryPart then
		local sound = script.sound:Clone()
		sound.Parent = renderCharacterContainer.PrimaryPart
		if not isAbilitySource then
			sound.Volume = sound.Volume * 0.5
		end
		sound:Play()
		game.Debris:AddItem(sound,5)
	end
	
	
	if isAbilitySource then
		-- todo: fix
		if not renderCharacterContainer:FindFirstChild("entity") then return end
		
		local movementVelocity = network:invoke("getMovementVelocity")
		if movementVelocity then
			
			if not (movementVelocity.magnitude > 0) then
				movementVelocity = renderCharacterContainer.PrimaryPart.CFrame.lookVector
			end
			
			local localCharacter = game.Players.LocalPlayer.Character
			if not localCharacter or not localCharacter.PrimaryPart then
				return false
			end
			
			network:invoke("setCharacterArrested", true)
		
	--		local movementDirection = CFrame.new(abilityExecutionData["cast-origin"] * Vector3.new(1, 0, 1), abilityExecutionData["mouse-world-position"] * Vector3.new(1, 0, 1)).lookVector
		
		
			local movementDirection = movementVelocity.unit
			
			local bodyGyro 		= localCharacter.PrimaryPart.hitboxGyro
			local bodyVelocity 	= localCharacter.PrimaryPart.hitboxVelocity
			
			bodyGyro.CFrame = CFrame.new(Vector3.new(), movementDirection)
			
			--movementDirection =	movementDirection + Vector3.new(0, 1, 0)
			
			local speed = abilityExecutionData["ability-statistics"].speed
			
			network:invoke("setMovementVelocity", movementDirection * speed)
			
			local duration = (animationTrack.Length - self.windupTime) 
			local startTime = tick()
			
			local heartbeatConnection = game:GetService("RunService").Heartbeat:connect(function()
				local t = (tick() - startTime) / duration
				network:invoke("setMovementVelocity", movementDirection * speed * (1-t))
			end)
			
			spawn(function()
				wait((animationTrack.Length * 0.6) - self.windupTime) 	
				
				heartbeatConnection:disconnect()
				
				network:invoke("setMovementVelocity", Vector3.new())
				network:fire("applyJoltVelocityToCharacter", movementDirection * speed * 0.5)
				network:invoke("setCharacterArrested", false)
			end)
		else
			return false
		end
	end
	
	wait(0.5)
	
	return true
end

return abilityData