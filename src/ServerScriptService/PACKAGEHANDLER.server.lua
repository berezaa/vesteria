-- Vesteria package handler by berezaa

local Scripts = {}

local StarterPlayerScripts = 2043195291
local StarterCharacterScripts = 2043195763


local Services = {
	StarterGui = 2043190255;
	ServerStorage = 2043190872;
	ServerScriptService = 2043191391;
	ReplicatedStorage = 2043191868;	
	StarterPlayer = 2043196240;
	StarterPack = 2043196774;	
}

local Insert = game:GetService("InsertService")

-- do not override existing files
for Service,ContentId in pairs(Services) do
	if game[Service] and game[Service]:FindFirstChild("assetsLoaded") == nil then
		local Success, Error = pcall(function()
			local Contents = Insert:LoadAssetVersion(Insert:GetLatestAssetVersionAsync(ContentId))
			if Contents then
				for i,Object in pairs(Contents:GetDescendants()) do
					if Object:IsA("Script") or Object:IsA("LocalScript") and not Object.Disabled then
						if Object.Name == "PACKAGEHANDLER" then
							Object:Destroy()
						else
							Object.Disabled = true
							table.insert(Scripts,Object)							
						end
					end
				end
				for i,Child in pairs(Contents:GetChildren()) do
					Child.Parent = game[Service]
				end
				Contents:Destroy()
			end
		end)
		if not Success then
			warn(Service," failed to load contents from InsertService!")
		end
	end
end
-- Enable scripts
for i,Script in pairs(Scripts) do
	Script.Disabled = false
end

-- Respawn any players around for that mess
for i,Player in pairs(game.Players:GetPlayers()) do
	Player:LoadCharacter()
end