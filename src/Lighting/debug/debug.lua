local module = {}

function module.init(Modules)
	
	local network = Modules.network
	local placeSetup = Modules.placeSetup
	
	local selectedPlayer
	
	local playerManifestCollectionFolder 	= placeSetup.awaitPlaceFolder("playerManifestCollection")
	local playerRenderCollectionFolder 		= placeSetup.awaitPlaceFolder("playerRenderCollection")	
	
	game:GetService("UserInputService").InputBegan:connect(function(input, absorbed)
		if game.Players.LocalPlayer:FindFirstChild("QA") and not absorbed then
			if input.KeyCode == Enum.KeyCode.BackSlash then
				script.Parent.Visible = not script.Parent.Visible
			end
		end
	end)
	
	local function selectPlayer(player)
		local manifest = playerManifestCollectionFolder:FindFirstChild(player.Name)
		local foundstate = " (manifest not found)"
		if manifest then
			foundstate = " (manifest all good)"
		elseif player.Character then
			manifest = player.Character
			foundstate = " (manifest misplaced: "..manifest:GetFullName()..")"
		end
		local state = network:invoke("getPlayerRenderStateByPlayerName", manifest and manifest.Name or player.Name)
		
		local render = playerRenderCollectionFolder:FindFirstChild(player.Name)
		local postState = " (render not found)"
		if render then
			postState = " (render all good)"
		else
			local backup = network:invoke("getPlayerRenderFromManifest", player.Character) 
			if backup then
				postState = " (render misplaced: "..backup:GetFullName()..")"
			end
		end
		
		script.Parent.contents.playertext.Text = "[" .. player.Name .. "] " .. (state or "none") .. foundstate .. postState
	end
		
	local function playerAdded(player)
		local button = script.Parent.contents.sample:Clone()
		button.Name = player.Name
		button.Text = player.Name
		button.Activated:connect(function()
			selectPlayer(player)
		end)
		button.Parent = script.Parent.contents.playerList
		button.Visible = true
	end
	
	game.Players.PlayerAdded:connect(playerAdded)
	for i,player in pairs(game.Players:GetPlayers()) do
		playerAdded(player)
	end
	
	local function playerRemoving(player)
		local button = script.Parent.contents:FindFirstChild(player.Name)
		if button then
			button:destroy()
		end
	end
	
	game.Players.PlayerRemoving:Connect(playerRemoving)
	
	local function update()
		for i,button in pairs(script.Parent.Frame.playerList:GetChildren()) do
			if button:IsA("GuiButton") then
				button:Destroy()
			end
		end
		for i,player in pairs(game.Players:GetPlayers()) do
			local button = script.Parent.contents.sample:Clone()
			button.Text = player.Name
			
			
		end
	end
	
	
	script.Parent.buttons.testing.Activated:connect(function()
		if script.Parent.Visible and game.Players.LocalPlayer:FindFirstChild("QA") then
			if Modules.prompting.prompt("You are strictly prohibited from sharing unreleased information from testing servers, including screenshots or videos. Travel to the testing environment?") then
				network:invoke("teleportPlayerTo", 2061558182)
			end
		end
	end)
end

return module
