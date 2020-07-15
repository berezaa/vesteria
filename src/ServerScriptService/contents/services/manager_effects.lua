local collectionService = game:GetService("CollectionService")

local modules = require(game.ReplicatedStorage.modules)
local network = modules.load("network")

network:create("effects_requestEffect", "RemoteEvent")

local function playMapSound(sound)
	assert(sound:IsA("Sound"), "Non-sound tagged as a mapSound: "..sound:GetFullName())
	
	sound:Play()
end
collectionService:GetInstanceAddedSignal("mapSound"):connect(playMapSound)
for _, sound in pairs(collectionService:GetTagged("mapSound")) do
	playMapSound(sound)
end

return {}