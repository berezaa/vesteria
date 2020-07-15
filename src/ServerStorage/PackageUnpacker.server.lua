--[[
	The bread and butter of the Vesteria data package distribution pipeline.
	Loads and unpacks the Vesteria data package, setting up the game assets
	and running everything. Heavily inspired by the original PACKAGEHANDLER,
	but built in a more flexible pipeline for long-term maintenance in mind.
	
	- Davidii
--]]

local DataPackageIdProduction = 4392820921
local DataPackageIdFreeToPlay = 4786304777
local DataPackageIdStaging = 4392552992

local PlaceIdStart = 2376885433

local CollectionService = game:GetService("CollectionService")
local InsertService = game:GetService("InsertService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local StarterPlayer = game:GetService("StarterPlayer")
local StarterGui = game:GetService("StarterGui")


local function tagLoaded(object)
	local tag = Instance.new("BoolValue")
	tag.Name = "assetsLoaded"
	tag.Value = true
	tag.Parent = object
end

local function isLoaded(object)
	return object:FindFirstChild("assetsLoaded") ~= nil
end

local function isProtected(object)
	return
		(object:FindFirstChild("protected") ~= nil) or
		(object:FindFirstChild("Protected") ~= nil) or
		(CollectionService:HasTag(object, "BootstrapperProtected"))
end

local function prepStarterGui()
	local folder = Instance.new("Folder")
	folder.Name = "StarterGuiFolder"
	folder.Parent = game:GetService("ReplicatedStorage")
	
	if game.PlaceId == PlaceIdStart then
		tagLoaded(folder)
	else
		for _, child in pairs(StarterGui:GetChildren()) do
			child.Parent = folder
		end
	end
end

local function prepStarterPlayer()
	StarterPlayer.CameraMaxZoomDistance = 60
	StarterPlayer.CameraMinZoomDistance = 10
	
	-- player scripts setup
	local playerScripts = StarterPlayer:WaitForChild("StarterPlayerScripts")
	if not isLoaded(playerScripts) then
		for _, child in pairs(playerScripts:GetChildren()) do
			if (child.Name ~= "ChatScript") and (child.Name ~= "BubbleChat") and (not isProtected(child)) then
				if child:IsA("BaseScript") then
					child.Disabled = true
				end
				child:Destroy()
			end
		end
	end
	
	-- disable and remove problematic scripts in player scripts
	-- fairly certain these things are caught by the previous clause,
	-- but it is preserved here to ensure legacy behavior (just in case)
	do
		local cameraScript = playerScripts:FindFirstChild("CameraScript")
		if cameraScript then
			cameraScript.Disabled = true
			cameraScript:Destroy()
		end
		
		local playerScriptsLoader = playerScripts:FindFirstChild("PlayerScriptsLoader")
		if playerScriptsLoader then
			playerScriptsLoader.Disabled = true
			playerScriptsLoader:Destroy()
		end
		
		local playerModule = playerScripts:FindFirstChild("PlayerModule")
		if playerModule then
			playerModule:Destroy()
		end
	end
	
	-- character scripts setup
	local characterScripts = StarterPlayer:WaitForChild("StarterCharacterScripts")
	if not isLoaded(characterScripts) then
		characterScripts:ClearAllChildren()
	end
end

local function prepSoundService()
	local success, err = pcall(function()
		SoundService.RespectFilteringEnabled = true
	end)
	if not success then
		print("PackageUnpacker was unable to set SoundService.RespectFilteringEnabled. Reason:\n\n"..err)
	end
end

local function tagMirrorWorld()
	local tag = Instance.new("BoolValue")
	tag.Name = "mirrorWorld"
	tag.Value = true
	tag.Parent = ReplicatedStorage
end

local function isMirrorWorld()
	local isPrivateServer =
		(game.PrivateServerId ~= nil) and
		(game.PrivateServerId ~= 0) and
		(game.PrivateServerId ~= "")
	
	local excludesLatestVersion =
		(ReplicatedStorage:FindFirstChild("excludeLatestVersion") ~= nil)
	
	return isPrivateServer and (not excludesLatestVersion)
end

local function shouldUseStagingPackage()
	local usesLatestVersion =
		(ReplicatedStorage:FindFirstChild("useLatestVersion") ~= nil)
	
	return
		usesLatestVersion or
		isMirrorWorld() or
		RunService:IsStudio() or
		RunService:IsRunMode()
end

local function loadPackage()
	local packageId
	if shouldUseStagingPackage() then
		print("PackageUnpacker is loading the staging data package...")
		packageId = DataPackageIdStaging
	elseif game.GameId == 712031239 then
		print("PackageUnpacker is loading the free to play data package...")
		packageId = DataPackageIdFreeToPlay
	else
		print("PackageUnpacker is loading the production data package...")
		packageId = DataPackageIdProduction
	end
	
	local model
	repeat
		local success, err = pcall(function()
			model = InsertService:LoadAsset(packageId)
		end)
		if not success then
			print("PackageUnpacker failed to acquire the data package. Reason:\n\n"..err.."\n\nRetrying in one second...")
			wait(1)
		end
	until success
	
	local package = model:GetChildren()[1]
	return package
end

local function moveChildren(oldParent, newParent)
	for _, child in pairs(oldParent:GetChildren()) do
		-- if we find an existing child of that name, declare it and destroy it
		-- if it's a script, we have to disable it first so it doesn't make trouble
		local overriddenChild = newParent:FindFirstChild(child.Name)
		if overriddenChild then
			print("PackageUnpacker has overridden existing object "..overriddenChild:GetFullName())
			if overriddenChild:IsA("BaseScript") then
				overriddenChild.Disabled = true
			end
			overriddenChild:Destroy()
		end
		
		-- now we can put in the new version!
		child.Parent = newParent
	end
end

local function unpackPackage(package)
	local baseScripts = {}
	
	local function disableScripts(service)
		for _, desc in pairs(service:GetDescendants()) do
			if desc:IsA("BaseScript") and (not desc.Disabled) then
				if (desc.Name == "PACKAGEHANDLER") or (desc.Name == "TELEPORTATION") then
					desc:Destroy()
				else
					desc.Disabled = true
					table.insert(baseScripts, desc)
				end
			end
		end
	end
	
	local function unpackService(template, target)
		if not isLoaded(target) then
			disableScripts(template)
			moveChildren(template, target)
		end
	end
	
	for _, service in pairs(package:GetChildren()) do
		if service.Name == "StarterGui" then
			unpackService(service, ReplicatedStorage:WaitForChild("StarterGuiFolder"))
			
		elseif service.Name == "StarterPlayerScripts" then
			unpackService(service, StarterPlayer:WaitForChild("StarterPlayerScripts"))
			
		elseif service.Name == "StarterCharacterScripts" then
			unpackService(service, StarterPlayer:WaitForChild("StarterCharacterScripts"))
			
		else
			local target = game:GetService(service.Name)
			if target then
				unpackService(service, target)
			else
				print("PackageUnpacker attempted to unpack generic service \""..service.Name.."\" but could not find it. Was it supposed to be a special case?")
			end
		end
	end
	
	-- enable all the scripts simultaneously
	for _, baseScript in pairs(baseScripts) do
		baseScript.Disabled = false
	end
end

local function respawnAllPlayers()
	for _, player in pairs(Players:GetPlayers()) do
		player:LoadCharacter()
	end
end

local function main()
	prepStarterGui()
	prepStarterPlayer()
	prepSoundService()
	
	Players.CharacterAutoLoads = false
	
	if isMirrorWorld() then
		tagMirrorWorld()
	end
	
	unpackPackage(loadPackage())
	
	Players.CharacterAutoLoads = true
	respawnAllPlayers()
end

main()
