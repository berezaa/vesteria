local abilityAnimations = game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local projectile 		= modules.load("projectile")
	local placeSetup 		= modules.load("placeSetup")
	local client_utilities 	= modules.load("client_utilities")
	local network 			= modules.load("network")
	local damage 			= modules.load("damage")
	local detection 		= modules.load("detection")
	local physics			= modules.load("physics")

local httpService 	= game:GetService("HttpService")
local itemLookup 	= require(game:GetService("ReplicatedStorage"):WaitForChild("itemData"))
local runService 	= game:GetService("RunService")

local monsterLookup = require(game:GetService("ReplicatedStorage"):WaitForChild("monsterLookup"))

local abilityData = {
	--> identifying information <--
	id 	= 21;
	
	manaCost	= 1;
	
	--> generic information <--
	name 		= "Infernus";
	image 		= "rbxassetid://2528903781";
	description = "lol be a dragon";
		
	--> execution information <--
	animationName 	= {};
	windupTime 		= 1.5;
	maxRank 		= 1;
	
	--> combat stats <--
	statistics = {
		[1] = {
			flameConeAngle 		= 15;
			flameConeDistance 	= 10;
			flameConeSpeed 		= 10;
			
			cooldown 			= 5;
			duration 			= 5;
			manaCost 			= 1;
			damageMultiplier 	= 1;
		};
	};
	
	abilityDecidesEnd = true;
}

-- network:fireServer("playerRequest_damageEntity", player, serverHitbox, damagePosition, sourceType, sourceId, sourceTag, guid)
function abilityData._serverProcessDamageRequest(sourceTag, baseDamage)
	return baseDamage, "magical", "dot"
end

function abilityData:execute(renderCharacterContainer, abilityExecutionData, isAbilitySource, guid)
	-- todo: fix
	if not renderCharacterContainer:FindFirstChild("entity") then return end
	
	local currentlyEquipped 	= network:invoke("getCurrentlyEquippedForRenderCharacter", renderCharacterContainer.entity)
	local currentWeaponManifest = currentlyEquipped["1"] and currentlyEquipped["1"].manifest
	if not currentWeaponManifest or not currentWeaponManifest:FindFirstChild("magic") then return end
	
	local castingPoint = currentWeaponManifest:FindFirstChild("infernusCastPoint") do
		if not castingPoint then
			castingPoint 		= script.container.infernusCastPoint:Clone()
			castingPoint.Parent = currentWeaponManifest
		end
	end
	
	if abilityExecutionData["ability-state"] == "begin" or abilityExecutionData["ability-state"] == "update" then
		if not isAbilitySource then
			castingPoint.ParticleEmitter.Enabled 	= abilityExecutionData.areFlamesVisible or false
			castingPoint.CFrame 					= CFrame.new(
														castingPoint.Position,
														castingPoint.Position + (abilityExecutionData.flamesDirection or Vector3.new(0, 1, 0))
													)
		end
			
		if isAbilitySource and abilityExecutionData["ability-state"] == "begin" then
			spawn(function()
				local areFlamesEnabled 	= false
				local flamesDirection 	= (castingPoint.CFrame * CFrame.new(0, 0, -1)):toObjectSpace(castingPoint.CFrame).p
				
				local function onInputBegan(inputObject)
					if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
						areFlamesEnabled = true
					end
				end
				
				local function onInputChanged(inputObject)
					if inputObject.UserInputType == Enum.UserInputType.MouseMovement then
						flamesDirection = (castingPoint.CFrame * CFrame.new(0, 0, -1)):toObjectSpace(castingPoint.CFrame).p
					end
				end
				
				local function onInputEnded(inputObject)
					if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
						areFlamesEnabled = false
					end
				end
				
				local conn1 = game:GetService("UserInputService").InputBegan:connect(onInputBegan)
				local conn2 = game:GetService("UserInputService").InputChanged:connect(onInputChanged)
				local conn3 = game:GetService("UserInputService").InputEnded:connect(onInputEnded)
				
				local startTime = tick()
				while tick() - startTime <= abilityExecutionData["ability-statistics"].duration do
					abilityExecutionData.areFlamesVisible 	= areFlamesEnabled
					abilityExecutionData.flamesDirection 	= flamesDirection
					abilityExecutionData["ability-state"] 	= "update"
					
					castingPoint.ParticleEmitter.Enabled 	= abilityExecutionData.areFlamesVisible or false
					castingPoint.CFrame 					= CFrame.new(
																castingPoint.Position,
																castingPoint.Position + (abilityExecutionData.flamesDirection or Vector3.new(0, 1, 0))
															)
					
					network:invoke("client_changeAbilityState", abilityData.id, "update", abilityExecutionData, guid)
					
					runService.Stepped:Wait()
				end
				
				conn1:disconnect()
				conn2:disconnect()
				conn3:disconnect()
				
				network:invoke("client_changeAbilityState", abilityData.id, "end", abilityExecutionData, guid)
			end)
		end
	elseif abilityExecutionData["ability-state"] == "end" then
		castingPoint:Destroy()
	end
end

return abilityData