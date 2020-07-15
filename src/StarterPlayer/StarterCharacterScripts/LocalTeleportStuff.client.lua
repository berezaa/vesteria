local Player = game.Players.LocalPlayer

-- populates player scripts in case the stuff expected to be there is not there

if Player.PlayerScripts:FindFirstChild("assetsLoaded") == nil then
	--Player.PlayerScripts:ClearAllChildren()
	for e,Script in pairs(game.StarterPlayer.StarterPlayerScripts:GetChildren()) do
		if Player.PlayerScripts:FindFirstChild(Script.Name) == nil then
			Script.Parent = Player.PlayerScripts
		end
	end		
	
end
