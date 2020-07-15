-- local party menu 
-- berezaa
local module = {}


local localPlayer = game.Players.LocalPlayer

function module.init(Modules)
	
	local network = Modules.network
	local tween = Modules.tween
	local fx = Modules.fx
	local utilities = Modules.utilities
	
	local isPartyLeader = false
	local playerCards = {}
	
	module.currentPartyInfo = nil
	
	network:create("getCurrentPartyInfo","BindableFunction","OnInvoke",function()
		if module.currentPartyInfo then
			module.currentPartyInfo.isClientPartyLeader = isPartyLeader
		end
		return module.currentPartyInfo
	end)

	local function setInviteFrameSize()
		-- script.Parent.contents.invite.Size = UDim2.new(0,250,0,50)
		local xSize = 100
		
		if script.Parent.contents.invite.textBox.Visible then
			xSize = xSize + 150
		end
		if script.Parent.contents.invite.leave.Visible then
			xSize = xSize + 50
		end
		
		script.Parent.contents.invite.Size = UDim2.new(0,xSize,0,60)
	end	

	local function updateInviteButton()
		if script.Parent.contents.invite.textBox.Visible then
			script.Parent.contents.invite.button.Active = true
			if game.Players:FindFirstChild(script.Parent.contents.invite.textBox.Text) then
				script.Parent.contents.invite.button.ImageColor3 = Color3.fromRGB(82, 255, 71)
				script.Parent.contents.invite.button.detail.Text = ">"
			else
				script.Parent.contents.invite.button.ImageColor3 = Color3.fromRGB(247, 138, 64)
				script.Parent.contents.invite.button.detail.Text = "-"		
			end					
		else
			script.Parent.contents.invite.button.detail.Text = "+"
			if module.currentPartyInfo == nil or #module.currentPartyInfo.members < 6 then
				script.Parent.contents.invite.button.ImageColor3 = Color3.fromRGB(93, 249, 249)
				script.Parent.contents.invite.button.Active = true
			else
				script.Parent.contents.invite.button.ImageColor3 = Color3.fromRGB(180,180,180)
				script.Parent.contents.invite.button.Active = false
			end	
		end
		setInviteFrameSize()

	end
	
	updateInviteButton()
	
	local lastSelectedPartyManifest
	
	script.Parent.contents.invite.textBox.Changed:connect(updateInviteButton)
	

	
	script.Parent.contents.invite.leave.MouseButton1Click:connect(function()
		script.Parent.contents.invite.leave.ImageColor3 = Color3.new(0.7,0.7,0.7)
		network:invokeServer("playerRequest_leaveParty")
		script.Parent.contents.invite.leave.ImageColor3 = Color3.fromRGB(246, 58, 63)
	end)
	
	local function closeInviteWindow()
		Modules.focus.cleanup()
		
		local invite = script.Parent.contents.invite
		invite.button.Visible = true
		invite.ImageLabel.Visible = true
		
		script.Parent.contents.invite.textBox.Visible = false
		tween(script.Parent.contents.invite,{"ImageTransparency"},0.7,0.3)
		
		if lastSelectedPartyManifest then
			if lastSelectedPartyManifest and lastSelectedPartyManifest.Parent then
				tween(lastSelectedPartyManifest,{"ImageTransparency","ImageColor3"},{0.5,Color3.new(0,0,0)},0.5)
				lastSelectedPartyManifest.details.Visible = false
			end	
			lastSelectedPartyManifest = nil		
		end
		
		updateInviteButton()
	end
	
	local function openInviteWindow()
		if module.currentPartyInfo == nil or #module.currentPartyInfo.members < 6 then
			script.Parent.contents.invite.textBox.Text = ""
			script.Parent.contents.invite.textBox.Visible = true
			tween(script.Parent.contents.invite,{"ImageTransparency"},0,0.3)
		end
		if Modules.input.mode.Value == "xbox" then
			if game.GuiService.SelectedObject and game.GuiService.SelectedObject:IsDescendantOf(script.Parent) then
				closeInviteWindow()
			else
				Modules.focus.change(script.Parent)
				game.GuiService.SelectedObject = script.Parent.contents.invite				
			end
		end
		updateInviteButton()
	end
	
	script.Parent.contents.invite.button.MouseButton1Click:connect(function()
		if script.Parent.contents.invite.button.Active then
			local buttonText = script.Parent.contents.invite.button.detail.Text
			if buttonText == ">" then
				local success, reason = false, "Could not find player"
				local targetPlayer = game.Players:FindFirstChild(script.Parent.contents.invite.textBox.Text)
				if targetPlayer then
					success, reason = network:invokeServer("playerRequest_invitePlayerToMyParty", targetPlayer)
				end
				local invite = script.Parent.contents.invite
				local duration = 1
				if success then
					Modules.notifications.alert({text = "Invited "..targetPlayer.Name.." to the party."}, 2)
					
					invite.button.Visible = false
					invite.leave.Visible = false
					invite.textBox.Visible = false

					invite.ImageLabel.Visible = false
					local ribben = fx.statusRibbon(invite, "Party invite sent!", "success", duration, UDim2.new(0,0,0.5,0))
					ribben.Size = UDim2.new(0,150,0,30)
					invite.Size = UDim2.new(0,200,0,60)
					--script.Parent.contents.invite.textBox.Text = ""
					
				elseif reason then
					duration = 2
					invite.button.Visible = false
					invite.leave.Visible = false
					invite.textBox.Visible = false
	
					invite.ImageLabel.Visible = false					
					local ribben = fx.statusRibbon(invite, reason, "fail", duration, UDim2.new(0,0,0.5,0))
					ribben.Size = UDim2.new(0,150,0,30)
					invite.Size = UDim2.new(0,200,0,60)
				end
				wait(duration)
				closeInviteWindow()
				--
			elseif buttonText == "-" then
				closeInviteWindow()
			elseif buttonText == "+" then
				openInviteWindow()
			end
		end
	end)
	
	
	local function clearPlayerCard(card, i)
		if i == nil then
			for e, playerCard in pairs(playerCards) do
				if playerCard == card then
					i = e
					break
				end
			end
		end
		
		if i then	
			if card.manifest then
				card.manifest:Destroy()
			end
			if card.connections then
				for e,connection in pairs(card.connections) do
					connection:disconnect()
				end
			end
			playerCards[i] = nil
		end	
	end
	
	local function clearParty()
		for i,card in pairs(playerCards) do
			clearPlayerCard(card, i)
		end		
		playerCards = {}
	end
	
	local teleporting = false
	
	local function applyNameTag(manifest, player)
		local playerCharacter = player.Character and player.Character.PrimaryPart and player.Character
		local partyInfo = module.currentPartyInfo
		if partyInfo.teleportState == "pending" and partyInfo.teleportPosition and playerCharacter and utilities.magnitude(playerCharacter.PrimaryPart.Position - partyInfo.teleportPosition) <= 20 then
			manifest.header.class.Image = "rbxassetid://2528902744"
			manifest.header.class.Visible = true
			manifest.header.class.ImageColor3 = Color3.new(0.1,1,0.1)
			manifest.header.username.TextColor3 = Color3.new(0.1,1,0.1)
		else
			local class = player:FindFirstChild("class") and player.class.Value:lower() or "unknown"
			if class:lower() ~= "adventurer" then
				manifest.header.class.Image = "rbxgameasset://Images/emblem_"..class:lower()
				manifest.header.class.Visible = true
			else
				manifest.header.class.Visible = false
			end			
			manifest.header.class.ImageColor3 = Color3.new(1,1,1)
			manifest.header.username.TextColor3 = Color3.new(1,1,1)										
		end						
	end	
	
	local function updatePartyInfo(partyInfo)
		
		local isOldPartyInfo = false
		
		if partyInfo == nil then
			isOldPartyInfo = true
			partyInfo = network:invokeServer("playerRequest_getMyPartyData")
		end
		
		module.currentPartyInfo = partyInfo
		script.Parent.contents.invite.leave.Visible = partyInfo ~= nil
		
		updateInviteButton()
		
		if partyInfo then
			
			if not isOldPartyInfo then

				if partyInfo.status then
					Modules.notifications.alert(partyInfo.status, 3)
					game.StarterGui:SetCore("ChatMakeSystemMessage", {Text = partyInfo.status.text; Color = partyInfo.status.textColor3 or Color3.new(0.7,0.7,0.7)})
				end
			
			end
			
			script.partyTeleportBeacon.Enabled = false
			script.partyTeleportBeacon.Adornee = nil
			
			if partyInfo.teleportState == "pending" then
				if not teleporting then
					teleporting = true
					local alert = {
						text = "The party leader has initiated a teleport. Group up!";
						textColor3 = Color3.new(1,1,1);
						backgroundColor3 = Color3.new(0,1,0.2);
						backgroundTransparency = 0;
						textStrokeTransparency = 1;
					}
					Modules.notifications.alert(alert, 4)
					-- update dat name tag to account for people entering/leaving the teleport zone
					spawn(function()
						while module.currentPartyInfo and module.currentPartyInfo.teleportState == "pending" do
							for i,partyMemberInfo in pairs(module.currentPartyInfo.members) do
								local player = partyMemberInfo.player
								local playerCard = playerCards[player]
								if playerCard and playerCard.manifest then
									applyNameTag(playerCard.manifest, player)
								end
							end
							wait(1/10)
						end
					end)					
				end
			elseif partyInfo.teleportState == nil or partyInfo.teleportState == "none" then
				if teleporting then
					teleporting = false
					local alert = {
						text = "The party leader canceled the teleport.";
						textColor3 = Color3.new(1,1,1);
						backgroundColor3 = Color3.new(0.9,0.1,0.1);
						backgroundTransparency = 0;
						textStrokeTransparency = 1;
					}
					Modules.notifications.alert(alert, 3)					
				end
			end

			local partyMembers = {}
			
			-- Make sure every member of the party has a card
			for i,partyMemberInfo in pairs(partyInfo.members) do
				
				local player = partyMemberInfo.player
				
				if player == localPlayer then
					isPartyLeader = partyMemberInfo.isLeader
				end			
				
				partyMembers[player] = true	

				
				if player ~= localPlayer and not playerCards[player] then
					
					local playerCard = {}
					playerCard.player = player
					
					local manifest = script.playerInfo:Clone()
					manifest.Name = player.Name
					manifest.header.username.Text = player.Name
					
					applyNameTag(manifest, player)
					
					manifest.header.leader.Visible = partyMemberInfo.isLeader
					
					local connections = {}
					

					
					local function onMouseEnter()
						if lastSelectedPartyManifest and lastSelectedPartyManifest.Parent and lastSelectedPartyManifest ~= manifest then
							tween(lastSelectedPartyManifest,{"ImageTransparency","ImageColor3"},{0.5,Color3.new(0,0,0)},0.5)
							lastSelectedPartyManifest.details.Visible = false
						end	
						lastSelectedPartyManifest = manifest
						if not manifest.details.Visible then
							tween(manifest,{"ImageTransparency","ImageColor3"},{0.5,Color3.new(0,0,0.7)},0.5)
						end
					end
					
					local function onMouseLeave()
						if not manifest.details.Visible then
							tween(manifest,{"ImageTransparency","ImageColor3"},{0.5,Color3.new(81, 81, 81)},0.5)
						end
					end
				
					local function onActivated()
						if manifest.details.Visible then
							manifest.details.Visible = false
							onMouseLeave()
						else
							if lastSelectedPartyManifest and lastSelectedPartyManifest.Parent and lastSelectedPartyManifest ~= manifest then
								tween(lastSelectedPartyManifest,{"ImageTransparency","ImageColor3"},{0.5,Color3.new(81, 81, 81)},0.5)
								lastSelectedPartyManifest.details.Visible = false
							end	
							lastSelectedPartyManifest = manifest
							manifest.details.Visible = true
							manifest.details.kick.Visible = isPartyLeader
							tween(manifest,{"ImageTransparency","ImageColor3"},{0,Color3.new(0,0,0.85)},0.5)								
						end			
					end					
					
					manifest.MouseEnter:connect(onMouseEnter)
					manifest.SelectionGained:connect(onMouseEnter)
					
					manifest.MouseLeave:connect(onMouseLeave)
					manifest.SelectionLost:connect(onMouseLeave)
					
					manifest.Activated:connect(onActivated)
					
					manifest.details.kick.Activated:connect(function()
						if player then
							local success, reason = network:invokeServer("playerRequest_leaveParty", player)
						end
					end)
					
					manifest.details.friendRequest.Activated:connect(function()
						if player then
							game.StarterGui:SetCore("PromptSendFriendRequest", player)
						end
					end)

					local function updatePlayerHealthDisplay()
						if player and player.Character and player.Character.PrimaryPart and player.Character.PrimaryPart:FindFirstChild("health") and player.Character.PrimaryPart:FindFirstChild("maxHealth") then
							manifest.healthBar.value.Size = UDim2.new(player.Character.PrimaryPart.health.Value/player.Character.PrimaryPart.maxHealth.Value,0,1,0)
							manifest.healthBar.value.bar.ImageColor3 = Color3.fromRGB(255, 0, 4)
							manifest.healthBar.title.Text = tostring(math.ceil(player.Character.PrimaryPart.health.Value)) .. "/" .. tostring(player.Character.PrimaryPart.maxHealth.Value)
						else
							manifest.healthBar.value.Size = UDim2.new(1,0,1,0)
							manifest.healthBar.value.bar.ImageColor3 = Color3.fromRGB(130, 130, 130)
							manifest.healthBar.title.Text = "???"
						end
					end
					
					local function characterAdded(character)
						updatePlayerHealthDisplay()
						local startTime = tick()
						repeat wait() until player.Character.PrimaryPart or tick - startTime > 5 
						if player.Character.PrimaryPart then
							local healthValue = player.Character.PrimaryPart:WaitForChild("health",5)
							local maxHealthValue = player.Character.PrimaryPart:WaitForChild("maxHealth",5)
							
							table.insert(connections, healthValue.Changed:connect(updatePlayerHealthDisplay)) 
							table.insert(connections, maxHealthValue.Changed:connect(updatePlayerHealthDisplay))
						end
					end
					
					if player.Character then
						characterAdded(player.Character)
					end
					
					table.insert(connections, player.CharacterAdded:connect(characterAdded))
					

					
					playerCard.manifest = manifest
					playerCard.connections = connections
					--table.insert(playerCards, playerCard)
					
					playerCards[player] = playerCard
					
					manifest.Parent = script.Parent.contents
					manifest.Visible = true
				end
				

				
			end
			
			-- clear any cards that are no longer party members
			for i,playerCard in pairs(playerCards) do
				if not partyMembers[playerCard.player] then
					clearPlayerCard(playerCard, i)
				end
			end
			
			-- other gui stuff
			if #module.currentPartyInfo.members >= 6 then
				
				closeInviteWindow()
			end
			
		else -- not in a party
			clearParty()
		end
	end
	
	updatePartyInfo()
	network:connect("signal_myPartyDataChanged", "OnClientEvent", updatePartyInfo)
	
	-- handle party requests
	
	network:connect("signal_playerInvitedToParty", "OnClientEvent", function(playerInviting, inviteId)
		if playerInviting then
			local accepted = Modules.prompting.prompt(playerInviting.Name.." wants you to join their party.")
			if accepted then
				local success, reason = network:invokeServer("playerRequest_acceptMyPartyInvitation", inviteId)
			end
		end
	end)
	
end

return module
