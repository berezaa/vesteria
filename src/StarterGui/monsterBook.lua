-- Monster book thingie by the honorable lord ber

local module = {}

local player = game:GetService("Players").LocalPlayer
local ui = player.PlayerGui.gameUI.monsterBook
function module.close()
	ui.Visible = false
end

function module.open(newBook)
	
end


local extentsSizeCache = {}

function module.init(Modules)
	
	spawn(function()
		
		local network = Modules.network
		
		if game.Players.LocalPlayer:FindFirstChild("bountyHunter") then
				
			
		
			local bountyBookButton = Modules.input.menuButtons["openMonsterBook"]
		
			local bookFrame = ui
			
			local currentTab
			
			local monsterBookData = {}
			
			local pages = ui.bookHolder.pages
			
			local monsterLookup = require(game.ReplicatedStorage.monsterLookup)
			local itemLookup = require(game.ReplicatedStorage.itemData)
			local levels = Modules.levels
		
			local currentMonsterName
			
			pages.monster.close.Activated:connect(function()
				pages.monster.Visible = false
				pages.main.Visible = true
			end)
			pages.monster.claim.Activated:connect(function()
				if currentMonsterName then
					local success, reason = network:invokeServer("playerRequest_claimBounty", currentMonsterName)
					if success then
						pages.monster.Visible = false
						Modules.utilities.playSound("questTurnedIn")
						pages.main.Visible = true
					end
				end
			end)
			
			local centerOfMassCache = {}
			
			local function getCenterOfMassOfModel(model)
				local totalVotedPosition = Vector3.new()
				local totalVotes = 0
				for i,part in pairs(model:GetDescendants()) do
					if part:IsA("BasePart") then
						local center = part.Position
						local mass = part:GetMass()
						totalVotedPosition = totalVotedPosition + (center * mass)
						totalVotes = totalVotes + mass
					end
				end
				return totalVotedPosition / totalVotes
			end
			
			local idolCaps = {
				["1"] = 5;
				["2"] = 10;
				["3"] = 15;
				["4"] = 20;
				["5"] = 25;
				["6"] = 30;
				["99"] = 15;
			}
			
			local existingMonsterViewports = {}
			
			local function getMonsterViewport(monsterName)
				
				if existingMonsterViewports[monsterName] then
					return existingMonsterViewports[monsterName]
				end
				
				local viewport = script.ViewportFrame:Clone()
				
				local monster = monsterLookup[monsterName]
				local monsterModule = monster.module
				
				
				local entity
				
				if monsterModule:FindFirstChild("displayEntity") then
					entity = monsterModule.displayEntity:Clone()
				else
					entity = monsterModule.entity:Clone()
				end
				
				
			
				if entity:FindFirstChild("animations") and entity.animations:FindFirstChild("idling") then
					entity.Parent = workspace
					entity.PrimaryPart.Anchored = true
					local entityController = entity:FindFirstChild("AnimationController")
					game.ContentProvider:PreloadAsync({entity.animations.idling})
					entityController:LoadAnimation(entity.animations.idling):Play()	
					wait(0.1)			
					local oldEntity = entity
					entity = entity:Clone()
					oldEntity:Destroy()
				end
		
				
				entity.Parent = viewport
				entity:SetPrimaryPartCFrame(CFrame.new())
				local extents = extentsSizeCache[monsterModule.Name]
				if extents == nil then
					extents = entity:GetExtentsSize() 
					extentsSizeCache[monsterModule.Name] = extents
				end		
				local centerOfMass = centerOfMassCache[monsterModule.Name]
				if centerOfMass == nil then
					centerOfMass = getCenterOfMassOfModel(entity)
					centerOfMassCache[monsterModule.Name] = centerOfMass
				end
				
				
					
				local camera = Instance.new("Camera")
				
				local min = math.min(extents.x, extents.z)
				local multi = Vector3.new(extents.z, extents.y, extents.x)/min
				
				local pos = ((centerOfMass + entity.PrimaryPart.Position)/2) + (extents * Vector3.new(0.5,0.1,-0.8) * multi)
				camera.CameraType = Enum.CameraType.Scriptable
				
				
				
				camera.CFrame = CFrame.new(pos, centerOfMass) * (monster.cameraOffset or CFrame.new())
				camera.Parent = viewport
				viewport.CurrentCamera = camera	
				
				existingMonsterViewports[monsterName] = viewport
				
				return viewport	
			end
			
			local function updateTabPage()
				-- clear existing children
				for i,child in pairs(pages.main:GetChildren()) do
					if child:IsA("GuiButton") then
						child:Destroy()
					end
				end
				-- populate with new buttons
				for i,monsterModule in pairs(game.ReplicatedStorage.monsterLookup:GetChildren()) do
					local monster = monsterLookup[monsterModule.Name]
					if monster and monster.monsterBookPage and monster.monsterBookPage == tonumber(currentTab.Name) then
						
						local idolCap = idolCaps[currentTab.Name]
						
						
						local monsterButton = script.monster:Clone()
						monsterButton.Name = monsterModule.Name
						monsterButton.LayoutOrder = monster.level or 999
						monsterButton.alert.Visible = false
						
						local viewport = getMonsterViewport(monsterModule.Name):Clone()
						if monsterButton:FindFirstChild("ViewportFrame") then
							monsterButton.ViewportFrame:Destroy()
						end
						viewport.Parent = monsterButton
						monsterButton.money.Visible = false
						monsterButton.progress.Visible = false
							
						local playerBountyData = monsterBookData[monsterModule.Name]
						
						local kills = playerBountyData and playerBountyData.kills or 0
						local lastBounty = playerBountyData and playerBountyData.lastBounty or 0
						if kills > 0 or lastBounty > 0 then
							
							
							local bountyPageInfo = levels.bountyPageInfo[tostring(monster.monsterBookPage)]
							
							local bountyInfo = bountyPageInfo[lastBounty + 1]	
							if bountyInfo then
								-- this line is duplicated in manager_player
								local goldReward = levels.getBountyGoldReward(bountyInfo, monster)
								Modules.money.setLabelAmount(
									monsterButton.money,
									goldReward
								)
								monsterButton.money.Visible = true
								monsterButton.progress.Visible = true
								monsterButton.progress.amount.Text = tostring(playerBountyData.kills) .. "/" .. tostring(bountyInfo.kills)
								monsterButton.progress.xp.value.Size = UDim2.new(math.clamp(playerBountyData.kills/bountyInfo.kills,0,1),0,1,0)
								
								if kills >= bountyInfo.kills then
								monsterButton.alert.Visible = true
								end
								
							end
							
							monsterButton.tooltip.Value = monsterModule.Name
							
							monsterButton.Activated:connect(function()
								
								-- display monster
								
								currentMonsterName = monsterModule.Name
								
								pages.monster.progress.Visible = false
								pages.monster.money.Visible = false
								pages.monster.claim.Visible = false
								if bountyInfo then
									local goldReward = levels.getBountyGoldReward(bountyInfo, monster)
									Modules.money.setLabelAmount(
										pages.monster.money,
										goldReward
									)
									pages.monster.money.Visible = true
									pages.monster.progress.Visible = true
									pages.monster.progress.xp.value.Size = UDim2.new(math.clamp(playerBountyData.kills/bountyInfo.kills,0,1),0,1,0)
									if playerBountyData.kills >= bountyInfo.kills then
										pages.monster.claim.Visible = true
									end
								end						
								
								if pages.monster.holder:FindFirstChild("ViewportFrame") then
									pages.monster.holder.ViewportFrame:Destroy()
								end
								monsterButton.ViewportFrame:Clone().Parent = pages.monster.holder
				--				pages.monster.progress.xp.value.Size = UDim2.new(math.clamp(idols/idolCap,0,1),0,1,0)
								pages.monster.title.Text = monsterModule.Name
								pages.monster.info.level.Text = "Lvl. "..tostring(monster.level or "?")
								pages.monster.info.health.Text = (monster.maxHealth or "???") .." HP"
								
				--				local bonus = 0.5 * math.clamp(idols / idolCap, 0, 1)
				--				pages.monster.info.bonus.title.Text = "+" .. tostring(math.ceil(bonus * 100)) .. "% EXP"
								
								pages.monster.Visible = true
								pages.main.Visible = false
								
								-- clear existing loot
								for i,lootObject in pairs(pages.monster.loot:GetChildren()) do
									if lootObject:isA("GuiObject") then
										lootObject:Destroy()
									end
								end
								
								local lootToShow = {}
								local addedLoot = {}
								
								-- remove duplicates
								if monster.lootDrops then
									for i,lootDropData in pairs(monster.lootDrops) do
										if lootDropData.id ~= 1 then
											local realItem = itemLookup[lootDropData.id or lootDropData.itemName]
											if realItem then
												if not addedLoot[realItem.name] then
													table.insert(lootToShow, lootDropData)
													addedLoot[realItem.name] = true
												end
											end
										end
									end
								end
								
								local rows = math.ceil(#lootToShow/4)
								pages.monster.loot.CanvasSize = UDim2.new(0,0,0,61 * rows)
								
								
								for i, loot in pairs(lootToShow) do
									local lootObject = script.inventoryItemTemplate:Clone()
									
									local realItem = itemLookup[loot.id or loot.itemName]
							
									lootObject.item.Image = realItem.image or "rbxassetid://2679574493"
									lootObject.locked.Visible = false
									lootObject.item.Visible = true
									
									local percentDropChance = "?%"
									if loot.spawnChance then
										if loot.spawnChance >= 0.1 then
											percentDropChance = tostring(math.floor(loot.spawnChance * 1000)/10).."%"
										elseif loot.spawnChance >= 0.01 then
											percentDropChance = tostring(math.floor(loot.spawnChance * 10000)/100).."%"
										elseif loot.spawnChance >= 0.001 then
											percentDropChance = tostring(math.floor(loot.spawnChance * 100000)/1000).."%"
										else
											percentDropChance = tostring(math.floor(loot.spawnChance * 1000000)/10000).."%"
										end
									end
		
									lootObject.item.tooltip.Value = realItem.name .. " - " .. percentDropChance
					
									
									lootObject.Parent = pages.monster.loot
								end
								
							end)
						else
					--		monsterButton.ViewportFrame.Visible = false
							monsterButton.ViewportFrame.ImageColor3 = Color3.new(0,0,0  )
							monsterButton.ViewportFrame.ImageTransparency = 0.7
							monsterButton.progress.Visible = false
							
					--		monsterButton.locked.Visible = true
							monsterButton.ImageColor3 = Color3.fromRGB(60, 60, 60)
							monsterButton.ImageTransparency = 0.5
							monsterButton.shadow.ImageTransparency = 0.5					
						end
						monsterButton.Parent = pages.main
						
					end
				end
			end
			
			function module.open()
				if not ui.Visible then
					ui.UIScale.Scale = (Modules.input.menuScale or 1) * 0.75
					Modules.tween(ui.UIScale, {"Scale"}, (Modules.input.menuScale or 1), 0.5, Enum.EasingStyle.Bounce)
				end
				if currentTab then
					updateTabPage()
				end						
				Modules.focus.toggle(ui)
				pages.main.Visible = true
				pages.monster.Visible = false		
			end		
			
			function module.close()
				if ui.Visible then
					Modules.focus.toggle(ui)	
				end	
			end
			ui.close.Activated:connect(module.close)
			
			function module.loadTab(tab)
				currentTab = tab
				local tabNumber = tonumber(tab.Name)
				for i,otherTab in pairs(tab.Parent:GetChildren()) do
					if otherTab:IsA("GuiObject") then
						otherTab.Size = UDim2.new(0, 50, 0, 40)
					end
				end
				tab.Size = UDim2.new(0, 60, 0, 40)
				local col = tab.ImageColor3
				bookFrame.bookCover.ImageColor3 = Color3.new((col.r + 0.15) * 0.6, (col.g + 0.15) * 0.6, (col.b + 0.15) * 0.6)
				script.inventoryItemTemplate.ImageColor3 = Color3.new((col.r + 0.15) * 0.3, (col.g + 0.15) * 0.3, (col.b + 0.15) * 0.3)
				
				script.monster.ImageColor3 = Color3.new((col.r + 0.15) * 0.9, (col.g + 0.15) * 0.9, (col.b + 0.15) * 0.9)
				pages.monster.holder.ImageColor3 = script.monster.ImageColor3
				script.inventoryItemTemplate.locked.ImageColor3 = Color3.new((col.r + 0.1) * 0.92, (col.g + 0.1) * 0.92, (col.b + 0.1) * 0.92)
		--		script.monster.ViewportFrame.BackgroundColor3 = script.monster.ImageColor3
				script.monster.progress.xp.value.ImageColor3 = col
				pages.monster.progress.xp.value.ImageColor3 = col
				pages.monster.info.bonus.title.TextColor3 = col
				pages.monster.holder.level.TextColor3 = col
				
				pages.main.Visible = true
				pages.monster.Visible = false
				updateTabPage()
			end
			
			
			
			for i,tabButton in pairs(bookFrame.tabs:GetChildren()) do
				if tabButton:IsA("GuiButton") then
					tabButton.Activated:connect(function()
						module.loadTab(tabButton)
					end)
				end
			end
			
			local existingAlertTotal
			
			local function monsterBookDataUpdated(monsterBookData)
				local alertTotal = 0	
				for monsterName, playerBountyData in pairs(monsterBookData) do
					local kills = playerBountyData and playerBountyData.kills or 0
					local lastBounty = playerBountyData and playerBountyData.lastBounty or 0
							
					local monster = monsterLookup[monsterName]
					if monster and monster.monsterBookPage then
						local bountyPageInfo = levels.bountyPageInfo[tostring(monster.monsterBookPage)]
						local bountyInfo = bountyPageInfo[lastBounty + 1]	
						if bountyInfo then	
							if kills >= bountyInfo.kills then
								alertTotal = alertTotal + 1
							end
						end				
					end
				end
				
				bountyBookButton.alert.value.Text = tostring(alertTotal)
				bountyBookButton.alert.Visible = alertTotal > 0
				
				if existingAlertTotal and alertTotal > existingAlertTotal then
					local textObject = {
						text = "You completed a monster bounty!";
						textColor3 = Color3.fromRGB(255, 85, 70);
						id = "newpoints";
					}
					Modules.notifications.alert(textObject,4, "idolPickup")
				end
				
				
				existingAlertTotal = alertTotal		
			end
			
			network:connect("propogationRequestToSelf", "Event", function(index, value)
				if index == "bountyBook" then
					local existingMonsterBookData = monsterBookData
					monsterBookData = value
						
					monsterBookDataUpdated(monsterBookData)
					
					if currentTab and ui.Visible then
						updateTabPage()
					end
				end
			end)
			
			
			
			spawn(function()
				for i, monster in pairs(game.ReplicatedStorage.monsterLookup:GetChildren()) do
					getMonsterViewport(monster.Name)
				end
				if not currentTab then
					module.loadTab(bookFrame.tabs["1"])
				end
				monsterBookData = network:invoke("getCacheValueByNameTag", "bountyBook")
				monsterBookDataUpdated(monsterBookData)
			end)			

			
		end
	end)
	
	

end









return module
