local plugin = plugin

local RunService = game:GetService("RunService")
local httpService = game:GetService("HttpService")
local minify = require(plugin.PackageScrambler.minify)

local guidsByRemoteName = {}

local function printBorder()
	print("[[["..string.rep("-", 48).."]]]")
end

local function findRemoteNamesInSource(source)
	local remoteNamePattern = [[network:create%(".-"]]
	
	while true do --breaks
		local patternStart, patternEnd = source:find(remoteNamePattern)
		if not patternStart then break end
	
		local patternMatch = source:sub(patternStart, patternEnd)
		local nameInQuotes = patternMatch:match([[".-"]])
		local name = nameInQuotes:sub(2, -2)
		guidsByRemoteName[name] = httpService:GenerateGUID()
	
		source = source:sub(patternEnd + 1)
	end
end

local function replaceRemotesInScript(replacedScript)
	local source = replacedScript.Source
	local replacementCount
	
	print("In script "..replacedScript:GetFullName()..":")
	for remoteName, guid in pairs(guidsByRemoteName) do
		source, replacementCount = source:gsub("\""..remoteName.."\"", "\""..guid.."\"")
		if replacementCount > 0 then
			print("\tReplaced "..replacementCount.." instance"..(replacementCount > 1 and "s" or "").." of \""..remoteName.."\"")
		end
	end
	
	return source
end

local function pack()
	printBorder()
	print()
	print("Preparing package. Please wait, this takes a minute...")
	print()
	
	wait(1)
	
	local folder = Instance.new("Folder")
	folder.Name = "Package"
	
	local services = {
		game:GetService("ReplicatedStorage"),
		game:GetService("ServerStorage"),
		game:GetService("ServerScriptService"),
		game:GetService("StarterGui"),
		game:GetService("StarterPlayer").StarterPlayerScripts,
		game:GetService("StarterPlayer").StarterCharacterScripts,
		game:GetService("StarterPack"),
		game:GetService("Chat"),
	}
	
	for _, service in pairs(services) do
		local subfolder = Instance.new("Folder")
		subfolder.Name = service.Name
		subfolder.Parent = folder
		for _, child in pairs(service:GetChildren()) do
			child:Clone().Parent = subfolder
		end
	end
	
	-- special case: StarterPlayer because don't
	do
		local subfolder = Instance.new("Folder")
		subfolder.Name = "StarterPlayer"
		subfolder.Parent = folder
		for _, child in pairs(game:GetService("StarterPlayer"):GetChildren()) do
			if (not child:IsA("StarterPlayerScripts")) and (not child:IsA("StarterCharacterScripts")) then
				child:Clone().Parent = subfolder
			end
		end
	end
	
	-- scramble all the scripts!
	local scripts = {}
	for _, desc in pairs(folder:GetDescendants()) do
		if desc:IsA("LuaSourceContainer") then
			table.insert(scripts, desc)
		end
	end
	print("Found "..#scripts.." scripts. Scrambling...")
	
	for _, scr in pairs(scripts) do
		findRemoteNamesInSource(scr.Source)
	end
	
	for _, scr in pairs(scripts) do
		local newSource = replaceRemotesInScript(scr)
		local success, minSource = minify(newSource)
		if success then
			scr.Source = minSource
		else
			print("Failed to minify script "..scr:GetFullName())
		end
	end
	
	-- ok, we're done, save it up
	folder.Parent = game.ServerStorage
	game.Selection:Set{folder}
	
	plugin:SaveSelectedToRoblox()
	
	print("Package prepped for upload. Don't forget to delete the package from ServerStorage when you're done with it!")
	print()
	printBorder()
end

local function main()
	if not RunService:IsStudio() then return end
	
	local toolbar = plugin:CreateToolbar("Vesteria Utilities")
	
	local buttonPack = toolbar:CreateButton("pack", "Pack up Vesteria's data, scramble it, and upload it.", "", "Pack + Scramble")
	buttonPack.Click:Connect(pack)
end

main()