local module = {}

module.loaded = false

function module.init(Modules)
	
	-- disabled
	module.loaded = true
	if true then
		return
	end
	
	local contentProvider 	= game:GetService("ContentProvider")
	local runService 		= game:GetService("RunService")
	local teleService		= game:GetService("TeleportService")
	
	local teleportData = teleService:GetLocalPlayerTeleportData() or {}
	
	local arrivingFrom = teleportData.arrivingFrom

	
	-- no need to load assets if you are arriving from a teleport

	if arrivingFrom and arrivingFrom ~= 2015602902 and arrivingFrom ~= 2376885433 and arrivingFrom ~= 2015602902 then
		module.loaded = true
		return false
	end
	
	local tween 			= Modules.tween
	
	local contentList = {}
	
	local loading = true
	
	table.insert(contentList, game.ReplicatedStorage:WaitForChild("characterAnimations"))
	table.insert(contentList, game.ReplicatedStorage:WaitForChild("abilityAnimations"))
	table.insert(contentList, game.ReplicatedStorage:WaitForChild("sounds"))
	table.insert(contentList, game:GetService("StarterGui"))
	table.insert(contentList, game.ReplicatedStorage:WaitForChild("itemData"))
	table.insert(contentList, game.ReplicatedStorage:WaitForChild("abilityLookup"))
	table.insert(contentList, game.ReplicatedStorage:WaitForChild("accessoryLookup"))
	
	
	local contents = script.Parent.contents
	
	spawn(function()
		local maxQueueSize = contentProvider.RequestQueueSize
		while loading do
			local queueSize = contentProvider.RequestQueueSize
			if queueSize > maxQueueSize then
				maxQueueSize = queueSize
			end
			
			local loadedAssetCount = maxQueueSize - queueSize
			
			contents.value.Text = tostring(loadedAssetCount) .. "/" .. tostring(maxQueueSize)
			
			contents.spinner.Rotation = contents.spinner.Rotation + 1
			runService.Heartbeat:wait()
		end
	end)
	
	
	spawn(function()
		-- make sure the loading UI is loaded in
		contentProvider:PreloadAsync({script.Parent})
		script.Parent.Visible = true
		contentProvider:PreloadAsync(contentList)
		module.loaded = true
		loading = false
		contents.spinner.Image = "rbxassetid://2528903599"
--		contents.spinner.ImageColor3 = Color3.fromRGB(132, 255, 98)
		contents.spinner.Rotation = 0
		contents.value.Text = "All done!"
--		contents.value.TextColor3 = Color3.fromRGB(132, 255, 98)

		tween(contents.spinner,{"ImageColor3"},{Color3.fromRGB(132, 255, 98)}, 0.5)
		tween(contents.value,{"TextColor3"},{Color3.fromRGB(132, 255, 98)}, 0.5)
		

		for i=1,4 do
			local flare = script.Parent.flare:Clone()
			flare.Name = "flareCopy"
			flare.Parent = script.Parent
			flare.Visible = true
			flare.Size = UDim2.new(1,4,1,4)
			flare.Position = UDim2.new(0,-2,0.5,0)
			flare.AnchorPoint = Vector2.new(0,0.5)
			local x = (180 - 40*i)
			local y = (14 - 2*i)
			local EndPosition = UDim2.new(0,-y/2,0.5,0)
			local EndSize = UDim2.new(1,x,1,y)
			tween(flare,{"Position","Size","ImageTransparency"},{EndPosition, EndSize, 1},0.5*i)
		end		
		
		wait(2)
		tween(contents, {"Position"}, {UDim2.new(-1,-20,0,0)}, 0.5)
		wait(0.5)
		
		script.Parent.Visible = false
	end)
end

return module
