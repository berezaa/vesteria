-- leaderboard module by berezaa

local module = {}

function module.init(Modules)
	
	local network = Modules.network
	local httpService = game:GetService("HttpService")
	
	-- server browser hookup
	spawn(function()
		local serversDataValue = game.ReplicatedStorage:WaitForChild("serversData")
		local function update()
			local servers = serversDataValue.Value ~= "" and httpService:JSONDecode(serversDataValue.Value)
			local serverCount = 0
			if servers then
				for serverId, serverData in pairs(servers) do
					if serverId ~= game.JobId then
						serverCount = serverCount + 1
					end
				end
			end
			script.Parent.top.leave.Visible = servers and serverCount > 0
		end
		update()
		serversDataValue.Changed:connect(update)
		-- can't direct ref .open bc of init race condition
		script.Parent.top.leave.Activated:Connect(function()
			Modules.serverBrowser.open()
		end)
	end)
	
	local function repareRender(viewport, player, data)
		
		if viewport:FindFirstChild("entity") then
			viewport.entity:Destroy()
		end
		
		if viewport:FindFirstChild("entity2") then
			viewport.entity2:Destroy()
		end		
		
		local camera = viewport.CurrentCamera
		if camera == nil then
			camera = Instance.new("Camera")
			camera.Parent = viewport
			viewport.CurrentCamera = camera
		end
		
		local client = player	
		local character = player.Character	
		local mask = viewport.characterMask
		
		local characterAppearanceData = {}
		characterAppearanceData.equipment 	= data.equipment or {}
		characterAppearanceData.accessories = data.accessories or {}
				
		local characterRender = network:invoke("createRenderCharacterContainerFromCharacterAppearanceData",mask, characterAppearanceData or {}, client)
		characterRender.Parent = workspace.CurrentCamera
		
		local animationController = characterRender.entity:WaitForChild("AnimationController")
		--[[
		local track = animationController:LoadAnimation(mask.idle)
		track.Looped = true
		track.Priority = Enum.AnimationPriority.Idle
		track:Play()		
		]]


		local currentEquipment = network:invoke("getCurrentlyEquippedForRenderCharacter", characterRender.entity)

		--[[
		local weaponType do
			if currentEquipment["1"] then
				weaponType = currentEquipment["1"].baseData.equipmentType
			end
		end		
		]]	
		
		local weaponType
				
		local track = network:invoke("getMovementAnimationForCharacter", animationController, "idling", weaponType, nil)
		
		if track then
			if typeof(track) == "Instance" then
				track:Play()
			elseif typeof(track) == "table" then
				for ii, obj in pairs(track) do
					obj:Play()
				end
			end
			
			spawn(function()
				while true do
					wait()
					
					if typeof(track) == "Instance" then
						if track.Length > 0 then
							break
						end
					elseif typeof(track) == "table" then
						local isGood = true
						for ii, obj in pairs(track) do
							if track.Length == 0 then
								isGood = false
							end
						end
						
						if isGood then
							break
						end
					end
				end
				
				if characterRender then
					
					if viewport:FindFirstChild("entity") then
						viewport.entity:Destroy()
					end							
					
					local entity 	= characterRender.entity
					entity.Parent 	= viewport
					
					characterRender:Destroy()
					local focus 	= CFrame.new(entity.PrimaryPart.Position + entity.PrimaryPart.CFrame.lookVector * 6.3, entity.PrimaryPart.Position) * CFrame.new(3,0,0)
					camera.CFrame 	= CFrame.new(focus.p + Vector3.new(0,1.5,0), entity.PrimaryPart.Position + Vector3.new(0,0.5,0))
				end
			end)
		else
			local track = animationController:LoadAnimation(mask.idle)
			track.Looped = true
			track.Priority = Enum.AnimationPriority.Idle
			track:Play()	
		end			
	end	
	
	
	local playerCardTemplate = script.Parent.content.sample:Clone()
	script.Parent.content.sample:Destroy()
	
	local selectedPlayerCard
	
	local function update()
		-- update player cards
		local playerCardCount = 0
		
		for i, player in pairs(game.Players:GetPlayers()) do
			if player:FindFirstChild("DataLoaded") then
				if player.Character and player.Character.PrimaryPart and player.Character.PrimaryPart:FindFirstChild("appearance") then
					local appearance = player.Character.PrimaryPart.appearance.Value
					local data = game:GetService("HttpService"):JSONDecode(appearance)
					if data then
						
						local playerCard = script.Parent.content:FindFirstChild(player.Name)
						if playerCard == nil then
							playerCard = playerCardTemplate:Clone()
							playerCard.Name = player.Name
							playerCard.Parent = script.Parent.content
							playerCard.Visible = true
							playerCard.Activated:connect(function()
								Modules.inspectPlayer.open(player)
								Modules.inspectPlayerPreview.close()
							end)
							playerCard.MouseEnter:connect(function()
								selectedPlayerCard = playerCard
								Modules.inspectPlayerPreview.open(player, playerCard)
							end)
							playerCard.SelectionGained:connect(function()
								selectedPlayerCard = playerCard
								Modules.inspectPlayerPreview.open(player, playerCard)
							end)
							playerCard.MouseLeave:connect(function()
								if selectedPlayerCard == playerCard then
									selectedPlayerCard = nil
									Modules.inspectPlayerPreview.close()
								end
							end)
							playerCard.SelectionLost:connect(function()
								if selectedPlayerCard == playerCard then
									selectedPlayerCard = nil
									Modules.inspectPlayerPreview.close()
								end							
							end)
							playerCard.LayoutOrder = 22
						end
						
						if playerCard.appearance.Value ~= appearance and Modules.loadingScreen.loaded then
							playerCard.appearance.Value = appearance
							repareRender(playerCard.character.ViewportFrame, player, data)
						end
						local gold = player:FindFirstChild("gold") and player.gold.Value or 0
						Modules.money.setLabelAmount(playerCard.content.money, gold)
						
						local level = player:FindFirstChild("level") and player.level.Value or 0
						playerCard.content.level.value.Text = "Lvl." .. level
						
						playerCard.content.icon.ImageLabel.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. player.userId .. "&width=100&height=100&format=png"
						playerCard.content.username.Text = player.Name
						
						local localPlayer = game.Players.LocalPlayer
						local origin = localPlayer.Character and localPlayer.Character.PrimaryPart and localPlayer.Character.PrimaryPart.Position
						origin = origin or Vector3.new()
						
						local class = player:FindFirstChild("class") and player.class.Value:lower() or "unknown"
						local emblemVisible
						if class:lower() ~= "adventurer" then
							playerCard.content.emblem.Image = "rbxgameasset://Images/emblem_"..class:lower()
							playerCard.content.emblem.Visible = true
							emblemVisible = true
						else
							playerCard.content.emblem.Visible = false
						end							
						
						local playerColor = Color3.fromRGB(208, 208, 208)
						
						local distance = (player.Character.PrimaryPart.Position - origin).magnitude
						-- do not update layoutOrder based on distance when leaderboard is selected
						local layoutOrder = (selectedPlayerCard == nil) and math.clamp(math.ceil(math.sqrt(distance)), 1, 20)
						
						if player == localPlayer then
							layoutOrder = -1
							playerColor = Color3.fromRGB(255, 206, 89)
						else
							local partyInfo = network:invoke("getCurrentPartyInfo")
							if partyInfo and partyInfo.members then
								for i,partyMemberInfo in pairs(partyInfo.members) do
									if player == partyMemberInfo.player then
										layoutOrder = 0
										playerColor = Color3.fromRGB(87, 255, 255)
										break
									end
								end	
							end								
						end

						playerCard.content.icon.BorderColor3 = playerColor
						playerCard.content.emblem.ImageColor3 = playerColor
						playerCard.content.username.TextColor3 = playerColor
						--playerCard.premium.ImageColor3 = playerColor
						--playerCard.premium.Visible = player.MembershipType == Enum.MembershipType.Premium					
						if layoutOrder then
							playerCard.LayoutOrder = layoutOrder
						end
						
						playerCardCount = playerCardCount + 1
					end
				end			
			end
		end
			
		script.Parent.content.CanvasSize = UDim2.new(0, 0, 0, 35 * playerCardCount)	
			
		-- remove un-used cards
		for i, card in pairs(script.Parent.content:GetChildren()) do
			if card:IsA("GuiObject") and game.Players:FindFirstChild(card.Name) == nil then
				card:Destroy()
			end
		end
	
	end
	
	spawn(function()
		while wait(1) do
			update()
		end
	end)
	
end

return module
