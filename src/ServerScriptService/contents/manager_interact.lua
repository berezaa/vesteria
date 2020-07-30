local collectionService = game:GetService("CollectionService")

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
local network = modules.load("network")
local utilities = modules.load("utilities")

network:create("attackInteractionSoundPlayed", "RemoteEvent", "OnServerEvent", function(player, part, soundName)
	if not player then return end
	if not player.Character then return end
	if not player.Character.PrimaryPart then return end
	
	local distance = (part.Position - player.Character.PrimaryPart.Position).Magnitude
	local range = 4 + math.max(part.Size.X, part.Size.Y, part.Size.Z)
	if distance < range then
		network:fireAllClientsExcludingPlayer("attackInteractionSoundPlayed", player, player.Character.PrimaryPart.Position, soundName)
	end
end)

network:create("attackInteractionAttackableAttacked", "RemoteEvent", "OnServerEvent", function(player, part, hitPosition)
	if not player then return end
	if not player.Character then return end
	if not player.Character.PrimaryPart then return end
	
	if not collectionService:HasTag(part, "attackable") then return end
	local module = part:FindFirstChild("attackableScript")
	if not module then return end
	module = require(module)
	
	local distance = (part.Position - player.Character.PrimaryPart.Position).Magnitude
	local range = 4 + math.max(part.Size.X, part.Size.Y, part.Size.Z)
	if distance > range then return end
	
	module.onAttackedServer(player)
	network:fireAllClientsExcludingPlayer("attackInteractionAttackableAttacked", player, player, part, hitPosition)
end)

return {}
