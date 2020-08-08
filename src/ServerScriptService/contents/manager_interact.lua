local module = {}

local CollectionService = game:GetService("CollectionService")

local network

local function attackInteractionSoundPlayed(player, part, soundName)
	if not player then return end
	if not player.Character then return end
	if not player.Character.PrimaryPart then return end

	local distance = (part.Position - player.Character.PrimaryPart.Position).Magnitude
	local range = 4 + math.max(part.Size.X, part.Size.Y, part.Size.Z)
	if distance < range then
		network:fireAllClientsExcludingPlayer("attackInteractionSoundPlayed", player, player.Character.PrimaryPart.Position, soundName)
	end
end



local function attackInteractionAttackableAttacked(player, part, hitPosition)
	if not player then return end
	if not player.Character then return end
	if not player.Character.PrimaryPart then return end

	if not CollectionService:HasTag(part, "attackable") then return end
	local attackableModule = part:FindFirstChild("attackableScript")
	if not attackableModule then return end
	local attackable = require(attackableModule)

	local distance = (part.Position - player.Character.PrimaryPart.Position).Magnitude
	local range = 4 + math.max(part.Size.X, part.Size.Y, part.Size.Z)
	if distance > range then return end

	attackable.onAttackedServer(player)
	network:fireAllClientsExcludingPlayer("attackInteractionAttackableAttacked", player, player, part, hitPosition)
end



function module.init(Modules)
	network = Modules.network
	network:create("attackInteractionAttackableAttacked", "RemoteEvent", "OnServerEvent", attackInteractionAttackableAttacked)
	network:create("attackInteractionSoundPlayed", "RemoteEvent", "OnServerEvent", attackInteractionSoundPlayed)
end

return module
