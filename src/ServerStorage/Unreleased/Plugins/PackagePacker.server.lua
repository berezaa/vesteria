local plugin = plugin

local RunService = game:GetService("RunService")

local function printBorder()
	print("[[["..string.rep("-", 48).."]]]")
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
	
	local buttonPack = toolbar:CreateButton("pack", "Pack up Vesteria's data and upload it.", "", "Pack")
	buttonPack.Click:Connect(pack)
end

main()