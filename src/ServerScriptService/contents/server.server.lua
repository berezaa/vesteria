local placeFolders 	= workspace:FindFirstChild("placeFolders") or Instance.new("Folder", workspace)
placeFolders.Name 	= "placeFolders"

local rootServices 	= script.Parent:WaitForChild("rootServices")
local coreServices 	= script.Parent:WaitForChild("coreServices")
local services 		= script.Parent:WaitForChild("services")
local httpService 		= game:GetService("HttpService")
local replicatedStorage = game:GetService("ReplicatedStorage")
	local modules = require(replicatedStorage.modules)
		local placeSetup 	= modules.load("placeSetup")
		local network 		= modules.load("network")


		local itemsFolder = placeSetup.getPlaceFolder("items")

local function main()
	-- initiate all root services in server folder
	for i, module in pairs(rootServices:GetChildren()) do
		local Success, Error = pcall(function()
			require(module)
		end)

		if not Success then
			warn("root server service "..module.Name.." failed to load!")
			warn(Error)
		end
	end

	-- initiate all core services in server folder
	for i, module in pairs(coreServices:GetChildren()) do
		local Success, Error = pcall(function()
			require(module)
		end)

		if not Success then
			warn("core server service "..module.Name.." failed to load!")
			warn(Error)
		end
	end

	-- initiate all regular services in server folder
	for i, module in pairs(services:GetChildren()) do
		local Success, Error = pcall(function()
			require(module)
		end)

		if not Success then
			warn("server service "..module.Name.." failed to load!")
			warn(Error)
		end
	end

	network:create("propogateCacheDataRequest", "RemoteEvent")

	-- not sure where else to put this... turn sounds into values BC Roblox sound memory is weird -ber
	-- utilities.playSound should fix this for us
	local soundFolder = game.ReplicatedStorage.assets.sounds

	for _, sound in pairs(soundFolder:GetChildren()) do
		if sound:IsA("Sound") then
			local mirror = Instance.new("StringValue")
			mirror.Name = sound.Name
			local soundData = {
				EmitterSize = sound.EmitterSize;
				Looped = sound.Looped;
				MaxDistance = sound.MaxDistance;
				PlaybackSpeed = sound.PlaybackSpeed;
				SoundId = sound.SoundId;
				Volume = sound.Volume;
				PlayOnRemove = sound.PlayOnRemove;
			}
			mirror.Value = httpService:JSONEncode(soundData)
			for _, child in pairs(sound:GetChildren()) do
				child.Parent = mirror
			end
			sound:Destroy()
			mirror.Parent = soundFolder
		end
	end
end

main()