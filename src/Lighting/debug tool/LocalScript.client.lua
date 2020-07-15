local player = game.Players.LocalPlayer
local humanoid
local animationTrack

local replicatedStorage = game:GetService("ReplicatedStorage")
	local modules = require(replicatedStorage.modules)
		local network 	= modules.load("network")
		local placeSetup = modules.load("placeSetup")

local monsterManifestCollection = placeSetup.awaitPlaceFolder("monsterManifestCollection")
local monsterRenderCollection = placeSetup.awaitPlaceFolder("monsterRenderCollection")

local function onEquipped(mouse)
	mouse.Button1Down:connect(function()
		if mouse.Target then
			if mouse.Target:IsDescendantOf(monsterManifestCollection) then
				network:fireServer("showDebugFor", mouse.Target)
			elseif mouse.Target:IsDescendantOf(monsterRenderCollection) then
				local part = mouse.Target
				
				while part and part.Parent ~= monsterRenderCollection do
					part = part.Parent
				end
				
				if part then
					network:fireServer("showDebugFor", part.clientHitboxToServerHitboxReference.Value)
				end
			end
		end
	end)
end

script.Parent.Equipped:connect(onEquipped)