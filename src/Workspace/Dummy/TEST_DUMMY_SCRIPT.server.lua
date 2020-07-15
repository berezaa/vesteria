local network = require(game.ReplicatedStorage.modules).load("network")

local function makeDummy(model)
	local cframe, size = model:GetBoundingBox()
	
	local dummy = network:invoke("spawnMonster", "Dummy", cframe.Position, nil, {dummyModel = model})
	
	local manifest = dummy.manifest
	manifest.Anchored = true
	manifest.Size = size
	manifest.CFrame = cframe
end

makeDummy(script.Parent)