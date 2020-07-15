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

local metadata = {
	cost = 0;
	upgradeCost = 0;
	maxRank = 1;
	layoutOrder = 1;
	
	requirement = function(playerData)
		if playerData.nonSerializeData.playerPointer:FindFirstChild("developer") then
			return true
		else
			return false
		end
	end;
}

local abilityData = {
	--> identifying information <--
	id 	= 19;
	metadata = metadata;
	
	manaCost	= 0;
	
	--> generic information <--
	name 		= "Summon";
	image 		= "rbxassetid://2528903781";
	description = "Call forth a player or monster by name.";
		
	--> execution information <--
	animationName 	= {};
	windupTime 		= 1.5;
	maxRank 		= 1;
	
	--> combat stats <--
	statistics = {
		[1] = {
			cooldown 					= 5;
			manaCost 					= 0;
			damageMultiplier 			= 0;
		};
	};
}

local CHORD_LENGTH = 0.5

function abilityData.summonGate(cf, radius, abilityExecutionData, guid)
	if radius < 2 then
		radius = 2
	end
	
	local c = CHORD_LENGTH / 2
	local angleForChord = 2 * math.sin(c / radius)
	local n 			= 2 * math.pi / angleForChord
	
	local segments = {}
	
	local gateSegment 		= Instance.new("Part")
	gateSegment.Size 		= Vector3.new(0.5, 0.05, CHORD_LENGTH)
	gateSegment.BrickColor 	= BrickColor.new("Institutional white")
	gateSegment.Material 	= Enum.Material.Neon
	gateSegment.Anchored 	= true
	gateSegment.CanCollide 	= false
	
	local i = 0
	local isServer = runService:IsServer()
	
	while n > 0 do
		i = i + 1
		
		local multiplier = 1 do
			if n > 1 then
				n = n - 1
			else
				multiplier 	= n
				n 			= 0
			end
		end
		
		local segment 	= gateSegment:Clone()
		segment.Parent 	= isServer and workspace.placeFolders.entities or workspace.CurrentCamera
		segment.CFrame 	= cf * CFrame.Angles(0, angleForChord * i, 0) * CFrame.new(0, 0, radius)
		
		table.insert(segments, segment)
		
		if i % 2 == 0 then
			wait()
		end
	end
	
	wait(1)
	
	local portal = gateSegment:Clone()
	portal.Shape = Enum.PartType.Cylinder
	portal.Size = Vector3.new(0.05, radius * 2 + CHORD_LENGTH, radius * 2 + CHORD_LENGTH)
	portal.CFrame = cf * CFrame.Angles(0, 0, math.pi / 2)
	portal.Parent = isServer and workspace.placeFolders.entities or workspace.CurrentCamera
	portal.Transparency = 0.015
	
	local portalHide 		= gateSegment:Clone()
	portalHide.Shape 		= Enum.PartType.Cylinder
	portalHide.Material 	= Enum.Material.Glass
	portalHide.Size 		= Vector3.new(0.07, radius * 2 + 0.1 + CHORD_LENGTH, radius * 2 + 0.1 + CHORD_LENGTH)
	portalHide.CFrame 		= cf * CFrame.Angles(0, 0, math.pi / 2)
	portalHide.Parent 		= isServer and workspace.placeFolders.entities or workspace.CurrentCamera
	portalHide.Transparency = 0.999
	
	if abilityData.execute_server then
		if runService:IsClient() then
			-- yield the thread here until the server thumbs up that we're good to move forward
			abilityExecutionData["summon-end-position"] = cf.p

			network:invokeServer("abilityExecuteServerCall", abilityExecutionData, abilityData.id, guid)
		end
	end

	spawn(function()
		for i = 1, 0, -1 / (abilityData.windupTime * 0.75 * 30) do
			portalHide.Size 	= Vector3.new(0.06, i * (radius * 2 + 0.1), i * (radius * 2 + 0.1))
			portalHide.CFrame 	= cf * CFrame.Angles(0, 0, math.pi / 2)
			
			wait()
		end
		
		for i,v in pairs(segments) do
			v:Destroy()
		end segments = nil
		
		wait(0.75)
		
		for i = 0, 1, 1 / (1 * 30) do
			portalHide.Size 	= Vector3.new(0.06, i * (radius * 2 + 0.1), i * (radius * 2 + 0.1))
			portalHide.CFrame 	= cf * CFrame.Angles(0, 0, math.pi / 2)
			
			wait()
		end
		
		portal:Destroy()
		portalHide:Destroy()
	end)
end

-- network:fireServer("playerRequest_damageEntity", player, serverHitbox, damagePosition, sourceType, sourceId, sourceTag, guid)
function abilityData._serverProcessDamageRequest(sourceTag, baseDamage)
	return baseDamage, "magical", "direct"
end

function abilityData:execute_server(castPlayer, abilityExecutionData, isAbilitySource)
	local message = castPlayer.Chatted:Wait()

	if castPlayer and castPlayer.Character and castPlayer.Character.PrimaryPart then
		local mode, targetInfo = string.match(message, "(%w+) (.+)")
								
		if mode and targetInfo then
			local target, count = string.match(targetInfo, "([%w%_]+)%s*(%d*)")
			count   	= (count == nil or count == "") and 1 or tonumber(count)
			mode 		= string.lower(mode)
			
			if target and count then
				if mode == "monster" then
					print("debug monster")
					if monsterLookup[target] and isAbilitySource then
						for i = 1, count do
							
							for i,v in pairs(abilityExecutionData) do
								print(i, " || ", v)
							end
							
							--print(abilityExecutionData["summon-end-position"])
							
							local monster = network:invoke(
								"spawnMonster",
								target,
								abilityExecutionData["summon-end-position"],
								nil,
								{master = castPlayer}
							)
						end
					end
				elseif mode == "player" then
					print("debug player")
					local targetPlayer = game.Players:FindFirstChild(target) do
						if not targetPlayer then
							targetPlayer = network:invoke("serverEchoForPlayerSummon", target, isAbilitySource)
						end
					end
						
					if isAbilitySource then
						if targetPlayer and targetPlayer.Character and targetPlayer.Character.PrimaryPart then
							pcall(function()
								abilityData.summonGate(
									targetPlayer.Character.PrimaryPart.CFrame - Vector3.new(0, targetPlayer.Character.PrimaryPart.Size.Y / 2 + 0.05, 0),
									4,
									nil,
									nil
								)
							end)
						end
						
						spawn(function()
							wait(abilityData.windupTime)
							
							if targetPlayer and targetPlayer.Character and targetPlayer.Character.PrimaryPart then
								network:invoke("teleportPlayerCFrame_server", targetPlayer, CFrame.new(
									abilityExecutionData["summon-end-position"],
									Vector3.new(castPlayer.Character.PrimaryPart.Position.X, abilityExecutionData["summon-end-position"].Y, castPlayer.Character.PrimaryPart.Position.Z)
								))
							end
						end)
					end
				end
			end
		end
	end
end

--							(renderCharacterContainer, 	targetPosition, isAbilitySource, hitNormal, nil, 	guid)
function abilityData:execute(renderCharacterContainer, 	abilityExecutionData, isAbilitySource, guid)
	-- todo: fix
	if not renderCharacterContainer:FindFirstChild("entity") then return end
	
	local tPos = renderCharacterContainer.entity.PrimaryPart.Position + renderCharacterContainer.entity.PrimaryPart.CFrame.lookVector * 7
	
	local ray 							= Ray.new(tPos, Vector3.new(0, -10, 0))
	local hitPart, hitPos, hitNormal 	= workspace:FindPartOnRayWithIgnoreList(ray, {renderCharacterContainer})
	
	if hitPart then
		hitPos = hitPos + Vector3.new(0, 0.05, 0)
		
		local cf = CFrame.new(hitPos, hitPos + hitNormal) * CFrame.Angles(math.pi / 2, 0, 0)
		
		if isAbilitySource then
			abilityData.summonGate(cf, 4, abilityExecutionData, guid)
		else
			spawn(function()
				abilityData.summonGate(cf, 4, abilityExecutionData, guid)
			end)
		end
	end
end

return abilityData