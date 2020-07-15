for _, service in pairs{workspace, game.ServerStorage} do
	for i,part in pairs(service:GetDescendants()) do
		if part:IsA("BasePart") and part.Name == "seat" then
			part.Transparency = 1
			if part:FindFirstChild("Decal") then
				part.Decal:Destroy()
			end
		end
		-- F2P Only Components
		if part:FindFirstChild("F2POnly") then
			if game.GameId == 712031239 then
				part.Parent = game.Workspace
			else
				part.Parent = game.ServerStorage
			end
		end
		if part:FindFirstChild("PremiumOnly") then
			if game.GameId == 833209132 then
				part.Parent = game.Workspace
			else
				part.Parent = game.ServerStorage
			end			
		end		
	end
end