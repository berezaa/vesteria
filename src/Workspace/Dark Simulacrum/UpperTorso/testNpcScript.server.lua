local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local network 			= modules.load("network")

local function teleportToTest(player)
	local char = player.Character
	if not char then return false end
	local manifest = char.PrimaryPart
	if not manifest then return false end
	local distance = (manifest.Position - script.Parent.Position).Magnitude
	if distance > 16 then return false end
	
	network:invoke("teleportPlayer", player, 3372071669)
	return true
end
network:create("testNpcTeleportToTest", "RemoteFunction", "OnServerInvoke", teleportToTest)