-- just a couple of things that should be run every time the player respawns
-- essentially, why should we ever start a live arrested or casting? I say no
-- this fixes a bug with Magic Bomb where if you die during it, the ability
-- just breaks entirely and you end up stuck for all eternity. Let's not.
--
-- Davidii

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
local network = modules.load("network")

spawn(function()
	--network:fire("setIsPlayerCastingAbility", false)
	network:invoke("setCharacterArrested", false)
end)

return {}