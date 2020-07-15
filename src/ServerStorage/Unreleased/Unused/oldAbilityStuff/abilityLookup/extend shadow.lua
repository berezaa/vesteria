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
local runService 	= game:GetService("RunService")
local itemLookup 	= require(game:GetService("ReplicatedStorage"):WaitForChild("itemData"))

local abilityData = {
	--> identifying information <--
	id 	= 23;
	
	manaCost	= 15;
	
	--> generic information <--
	name 		= "Extend Shadow";
	image 		= "http://www.roblox.com/asset/?id=1879548550";
	description = "Send forth your shadow to impale your enemy";
		
	--> execution information <--
	animationName 	= {};
	windupTime 		= 0.2;
	maxRank 		= 10;
	
	--> combat stats <--
	statistics = {
		[1] = {
			distance 					= 20;
			cooldown 					= 5;
			manaCost 					= 10;
			damageMultiplier 			= 3;
		};			
	};
	
	dontDisableSprinting = true;
}

-- network:fireServer("playerRequest_damageEntity", player, serverHitbox, damagePosition, sourceType, sourceId, sourceTag, guid)
function abilityData._serverProcessDamageRequest(sourceTag, baseDamage)
	return baseDamage, "physical", "direct"
end

function abilityData.__serverValidateMovement(player, previousPosition, currentPosition)
	return true
end

--							(renderCharacterContainer, 	targetPosition, isAbilitySource, hitNormal, nil, 	guid)
function abilityData:execute(renderCharacterContainer, 	abilityExecutionData, isAbilitySource, guid)
	-- todo: fix
	if not renderCharacterContainer:FindFirstChild("entity") then return end
	
	if renderCharacterContainer.entity.PrimaryPart then
		local originPart = renderCharacterContainer.entity.PrimaryPart
--		local connection do
--			local function onRenderStepped()
--				local shadowRay 		= Ray.new(originPart.Position, Vector3.new(0, -10, 0))
--				local hitPart, hitPos 	= workspace:FindPartOnRayWithIgnoreList(shadowRay, {workspace.CurrentCamera; workspace.placeFolders})
--				
--				if hitPart then
--					shadowPart.CFrame = CFrame.new(hitPos) * CFrame.Angles(0, 0, math.pi / 2)
--				end
--			end
--			
--			-- tick it once at least!
--			onRenderStepped()
--			
--			connection = runService.RenderStepped:connect(onRenderStepped)
--		end
		
		local targetPosition do
			local shadowRay 		= Ray.new(abilityExecutionData["absolute-mouse-world-position"] + Vector3.new(0, 3, 0), Vector3.new(0, -999, 0))
			local hitPart, hitPos 	= workspace:FindPartOnRayWithIgnoreList(shadowRay, {workspace.CurrentCamera; workspace.placeFolders})
			
			if hitPart then
				targetPosition = hitPos + Vector3.new(0, 2, 0)
			end
		end
		
		if targetPosition then
			local backOffset 		= 1.5
			
			local dashDirection 	= targetPosition - originPart.Position
			local speed 			= 100
			local shadowMovement 	= script.shadowProjection:Clone() do
				shadowMovement.Parent = workspace.CurrentCamera
			end
			
			local startTime = tick() do
				while true do
					local t 				= tick() - startTime
					local nextPos 			= originPart.Position - dashDirection.unit * backOffset + dashDirection.unit * speed * t
					
					local shadowRay 		= Ray.new(nextPos + Vector3.new(0, 1, 0), Vector3.new(0, -999, 0))
					local hitPart, hitPos 	= workspace:FindPartOnRayWithIgnoreList(shadowRay, {workspace.CurrentCamera; workspace.placeFolders})
				
					if hitPart then
						shadowMovement.CFrame = CFrame.new(
							hitPos,
							hitPos + dashDirection
						) * CFrame.Angles(0, 0, math.pi / 2) + Vector3.new(0, 0.025, 0)
					end
					
					if t >= (dashDirection.magnitude + backOffset) / speed then
						break
					else
						runService.RenderStepped:Wait()
					end
				end
			end
			
			local lifetime = shadowMovement.Trail.Lifetime
			
			delay(lifetime, function()
				shadowMovement:Destroy()
			end)
			
			local shadowPart = script.shadow:Clone() do
				shadowPart.Parent = workspace.CurrentCamera
			end
			
			local startTime2 = tick() do
				while true do
					local i = math.clamp((tick() - startTime2) / 0.5, 0, 1)
					
					shadowPart.Size 	= Vector3.new(0.05, 30 * i, 30 * i)
					shadowPart.CFrame 	= CFrame.new(shadowMovement.Position) * CFrame.Angles(0, 0, math.pi / 2)
					
					if i >= 1 then
						break
					else
						runService.RenderStepped:Wait()
					end
				end
			end
			
			local startTime3 = tick() do
				local shadowSpikes = script.shadowSpikes:Clone() do
					shadowSpikes.Parent = workspace.CurrentCamera
					shadowSpikes.Size 	= shadowPart.Size
				end
				
				while true do
					local i = math.clamp((tick() - startTime3) / 0.5, 0, 1) ^ (1 / 3)
					
					shadowSpikes.Size 	= Vector3.new(shadowPart.Size.Y - 5, 7 * i, shadowPart.Size.Z - 5)
					shadowSpikes.CFrame = CFrame.new(shadowPart.Position) + Vector3.new(0, shadowSpikes.Size.Y / 2, 0)
					
					if i >= 1 then
						break
					else
						runService.RenderStepped:Wait()
					end
				end
				
				if isAbilitySource then
					for i, entityManifest in pairs(damage.getDamagableTargets(game.Players.LocalPlayer)) do
						local boxcastOriginCF 				= shadowSpikes.CFrame
						local boxProjection_serverHitbox 	= detection.projection_Box(entityManifest.CFrame, entityManifest.Size, boxcastOriginCF.p)
						if detection.boxcast_singleTarget(boxcastOriginCF, shadowSpikes.Size * Vector3.new(3, 2, 3), boxProjection_serverHitbox) then
							network:fire("requestEntityDamageDealt", entityManifest, boxProjection_serverHitbox, "ability", self.id, nil, guid)
						end
					end
				end
			
				delay(lifetime, function()
					shadowSpikes:Destroy()
			
					local startTime4 = tick() do
						while true do
							local i = math.clamp((tick() - startTime4) / 0.5, 0, 1)
							
							shadowPart.Size 	= Vector3.new(0.05, 30 * (1 - i), 30 * (1 - i))
							shadowPart.CFrame 	= CFrame.new(shadowMovement.Position) * CFrame.Angles(0, 0, math.pi / 2)
							
							if i >= 1 then
								break
							else
								runService.RenderStepped:Wait()
							end
						end
					end
					
					shadowPart:Destroy()
				end)
			end
		end
	end
end

return abilityData