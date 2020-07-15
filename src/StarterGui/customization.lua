-- character customization module 
-- berezaa

local module = {}

	local connection

	local targetTableTop
	
	local currentDesiredAppearance
	
	function module.display()
		
	end
	
	function module.hide()
		
	end

	local runService = game:GetService("RunService")

	function module.init(Modules)
	
		local network = Modules.network
		local tween = Modules.tween
		local input = Modules.input
		local utilities = Modules.utilities
		
		local lookup = game.ReplicatedStorage:WaitForChild("accessoryLookup")
		
		
		local renderedItems = Instance.new("Folder")
		renderedItems.Name = "renderedOptions"
		renderedItems.Parent = workspace
		
		local characterRender
		local rand = Random.new(os.time())
		
		local characterTable = {}
		
		renderedItems.DescendantAdded:connect(function(object)
			if object.Name == "bodyPart" then
				local part = object.Parent
				part.Color = lookup:FindFirstChild("skinColor"):FindFirstChild(tostring(characterTable.accessories.skinColorId or 1)).Value
			elseif object.Name == "hair_Head" and object:IsA("BasePart") then
				object.Color = lookup:FindFirstChild("hairColor"):FindFirstChild(tostring(characterTable.accessories.hairColorId or 1)).Value
			elseif object.Name == "shirt" or object.Name == "shirtTag" then
				if object.Name == "shirtTag" then
					object = object.Parent
				end
				if object:IsA("BasePart") then
					object.Color = lookup:FindFirstChild("shirtColor"):FindFirstChild(tostring(characterTable.accessories.shirtColorId or 1)).Value
				end
			end	
		end)

		
		local pastLanding = true
		
		local function getItemFromHitpart(hitpart)
			for i,renderItem in pairs(renderedItems:GetChildren()) do
				if hitpart:IsDescendantOf(renderItem) then
					return renderItem
				end
			end
		end
		
		local selectedItem
		
		local function selectItem(item)
			if selectedItem and selectedItem.Parent then
				selectedItem.PrimaryPart.Transparency = 1
				selectedItem = nil
			end
			if item then
				selectedItem = item
				item.PrimaryPart.Transparency = 0.3
			end
		end
		
		
		local inputModule = input

	
		
		
		local mouseDownTime = 0
		
		
		
		
		
		game:GetService("UserInputService").InputBegan:connect(function(input, absorbed)
			if not absorbed and input.UserInputType == Enum.UserInputType.MouseButton1 then
				mouseDownTime = tick()
			end 
		end)
		
		local currentCategory
		
		game:GetService("UserInputService").InputEnded:connect(function(input, absorbed)
			if not absorbed and input.UserInputType == Enum.UserInputType.MouseButton1 and tick() - mouseDownTime <= 2 then
				if selectedItem then
					
					local currentDisplayCategory = currentCategory
					if currentDisplayCategory == "skinColor" then
						currentDisplayCategory = "skinColorId"
					end				
					
					characterTable.accessories[currentDisplayCategory] = tonumber(selectedItem.Name)
					
					network:invoke("applyCharacterAppearanceToRenderCharacter", characterRender.entity, characterTable)
				end
			end 
		end)
		
		
		
		local function reset()
			for i,oslot in pairs(script.Parent.Frame.DataSlots:GetChildren()) do
				if oslot:IsA("ImageButton") then
					oslot.ImageColor3 = Color3.fromRGB(126, 126, 126)
				end
			end		
		end

		
				
		local debounce = false	
		
		local function getModelAveragePosition(model)
			local preavg = Vector3.new()
			local totalcount = 0
			for i,part in pairs(model:GetChildren()) do
				if part:IsA("BasePart") then
					preavg = preavg + part.Position
					totalcount = totalcount + 1
				end
			end
			return preavg / totalcount
		end
		
		
		
		local function updateColors()
			for i,object in pairs(renderedItems:GetDescendants()) do	
				if object.Name == "bodyPart" then
					local part = object.Parent
					part.Color = lookup:FindFirstChild("skinColor"):FindFirstChild(tostring(characterTable.accessories.skinColorId or 1)).Value
				elseif object.Name == "hair_Head" and object:IsA("BasePart") then
					object.Color = lookup:FindFirstChild("hairColor"):FindFirstChild(tostring(characterTable.accessories.hairColorId or 1)).Value
				elseif object.Name == "shirt" or object:FindFirstChild("shirtTag") then
					object.Color = lookup:FindFirstChild("shirtColor"):FindFirstChild(tostring(characterTable.accessories.shirtColorId or 1)).Value
				end
			end	
			network:invoke("applyCharacterAppearanceToRenderCharacter", characterRender.entity, characterTable)		
		end
		
		
		local function createRepresentationOfItem(item)
			
			local repre
			
			if item:IsA("Color3Value") then
				repre = script.colorRepre:Clone()
				repre.value.Color = item.Value
				repre.Name = item.Name
			else
				repre = item:Clone()
			end
			
			
			local avgpos = getModelAveragePosition(repre)
			-- reparent everything to root
			for i,part in pairs(repre:GetDescendants()) do
				if part:IsA("BasePart") then
					if part.Parent == repre and part:FindFirstChild("colorOverride") == nil then
						local bodyPartTag = Instance.new("BoolValue")
						bodyPartTag.Name = "bodyPart"
						bodyPartTag.Parent = part
					else
						part.Parent = repre				
					end
					part.Anchored = true
				end
			end
			-- create a PrimaryPart using the avgPos
			local primaryPart = Instance.new("Part")
			primaryPart.Size = Vector3.new(2,0.5,2)
			primaryPart.CFrame = CFrame.new(avgpos - Vector3.new(0,2,0))
			primaryPart.Parent = repre
			primaryPart.Anchored = true
			primaryPart.TopSurface = Enum.SurfaceType.Smooth
			primaryPart.Material = Enum.Material.Neon
			primaryPart.Transparency = 1
			
			local immuneTag = Instance.new("BoolValue")
			immuneTag.Name = "colorOverride"
			immuneTag.Parent = primaryPart
			
			repre.PrimaryPart = primaryPart
			return repre
		end
		
		local displayConnection 
		
		local lastXboxSelected
		
		local function generateCoolButtons()
			script.Parent.xboxButtons:ClearAllChildren()
			for i,item in pairs(renderedItems:GetChildren()) do
				if item and item.PrimaryPart then
					local vector, onScreen = workspace.CurrentCamera:WorldToScreenPoint(item.PrimaryPart.Position)
					if onScreen then
						local button = script.Parent.sampleXboxButton:Clone()
						button.Name = item.Name
						button.Parent = script.Parent.xboxButtons
						button.Visible = input.mode.Value == "xbox"
						button.Position = UDim2.new(0, vector.X, 0, vector.Y + game.GuiService:GetGuiInset().Y)
						button.Activated:connect(function()
							if input.mode.Value == "xbox" then
								characterTable.accessories[currentCategory] = tonumber(button.Name)
								network:invoke("applyCharacterAppearanceToRenderCharacter", characterRender.entity, characterTable)	
							end				
						end)
						button.SelectionGained:connect(function()
							lastXboxSelected = item
							selectItem(item)
						end)
						button.SelectionLost:connect(function()
							if lastXboxSelected == item then
								selectItem(nil)
							end
						end)
					end
				end
			end
		end
		
		
		input.mode.Changed:connect(function()
		
			for i,button in pairs(script.Parent.xboxButtons:GetChildren()) do
				if button:IsA("GuiObject") then
					button.Visible = input.mode.Value == "xbox" 
				end
			end
			
		end)
		
		local function displayCategory(categoryName)
			renderedItems:ClearAllChildren()
			lookup = game.ReplicatedStorage:WaitForChild("accessoryLookup")
			local items = lookup:FindFirstChild(categoryName)
			if items then
				local x = 0
				local z = 0
				
				local target = targetTableTop
				
				
				for i,item in pairs(items:GetChildren()) do
					
					local repre = createRepresentationOfItem(item)
					local cf = target.CFrame * CFrame.new((z * 6) - target.Size.X/2 + 1.1, target.Size.Y/2 + (z * 3.2), (x * 2.5) - target.Size.Z/2 + 1.1)
					repre:SetPrimaryPartCFrame(cf)
					repre.Parent = renderedItems
					
					x = x + 1
					if x > 4 then
						x = 0
						z = z + 1
					end
					
				end
			end
			for i,button in pairs(script.Parent.buttons:GetChildren()) do
				if button:IsA("ImageButton") then
					button.ImageColor3 = Color3.fromRGB(103, 255, 212)
				end
			end
			local newbutton = script.Parent.buttons:FindFirstChild(categoryName)
			if newbutton then
				newbutton.ImageColor3 = Color3.fromRGB(255, 255, 255)
			end
			currentCategory = categoryName
			
			script.Parent.hairColor.Visible = false
			script.Parent.shirtColor.Visible = false
			if categoryName == "hair" then
				script.Parent.hairColor.Visible = true
			elseif categoryName == "undershirt" then
				script.Parent.shirtColor.Visible = true
			end
			generateCoolButtons()
		end
		
		for i,button in pairs(script.Parent.buttons:GetChildren()) do
			if button:IsA("ImageButton") then
				button.Activated:connect(function()
					displayCategory(button.Name)
				end)
			end
		end
		
		for i,color in pairs(lookup:WaitForChild("hairColor"):GetChildren()) do
			if color:IsA("Color3Value") then
				local buttonRepre = script.Parent.colorButtonSample:Clone()
				buttonRepre.ImageColor3 = color.value
				buttonRepre.Name = color.Name
				buttonRepre.Parent = script.Parent.hairColor
				buttonRepre.Visible = true
				-- change hairColor
				buttonRepre.Activated:connect(function()
					characterTable.accessories["hairColorId"] = tonumber(buttonRepre.Name)
--					characterTable.accessories["hairColor"] = tonumber(buttonRepre.Name)
					updateColors()
										
				end)
			end
		end	
		
		for i,color in pairs(lookup:WaitForChild("shirtColor"):GetChildren()) do
			if color:IsA("Color3Value") then
				local buttonRepre = script.Parent.colorButtonSample:Clone()
				buttonRepre.ImageColor3 = color.value
				buttonRepre.Name = color.Name
				buttonRepre.Parent = script.Parent.shirtColor
				buttonRepre.Visible = true
				-- change shirtColor
				buttonRepre.Activated:connect(function()
					characterTable.accessories["shirtColorId"] = tonumber(buttonRepre.Name)
--					characterTable.accessories["shirtColor"] = tonumber(buttonRepre.Name)
					updateColors()
										
				end)
			end
		end				
		
		function module.hide()
			
			network:invoke("lockCameraPosition", false)
			script.Parent.Enabled = false
			script.Parent.Parent.gameUI.Enabled = true
			if connection then
				connection:disconnect()
				connection = nil
			end
			
			if characterRender then
				characterRender:Destroy()
			end			
		end
		
		script.Parent.options.cancel.Activated:connect(module.hide)
		script.Parent.options.done.Activated:connect(function()
			currentDesiredAppearance = characterTable
			module.hide()
		end)
		
		
		function module.display(tableTop)
			
			currentDesiredAppearance = nil
			
			script.Parent.Enabled = true
			script.Parent.Parent.gameUI.Enabled = false
			
			targetTableTop = tableTop
			

	
			if input.mode.Value == "xbox" then
				game.GuiService.GuiNavigationEnabled = true
				game.GuiService.SelectedObject = input.getBestButton(script.Parent)
			end
			
			
			characterTable.accessories = {}
			
			-- default values
			for i,category in pairs(lookup:GetChildren()) do
				local children = category:GetChildren()
				if #children > 0 then
					characterTable.accessories[category.Name] = 1;
				end
			end
			
			-- real from player appearance
			local player = game.Players.LocalPlayer
			if player.Character and player.Character.PrimaryPart and player.Character.PrimaryPart:FindFirstChild("appearance") then
				local success, playerAppearance = utilities.safeJSONDecode(player.Character.PrimaryPart.appearance.Value)
				if success and playerAppearance.accessories then
					for accessory, value in pairs(playerAppearance.accessories) do
						characterTable.accessories[accessory] = value
					end
				end
			end
			
			displayCategory("hair")
		
	
			if characterRender then
				characterRender:Destroy()
			end
	
			characterRender = network:invoke("createRenderCharacterContainerFromCharacterAppearanceData", workspace:WaitForChild("characterMask"), characterTable)
			characterRender.Parent = workspace
			local animationController = characterRender.entity:WaitForChild("AnimationController")
			local track = animationController:LoadAnimation(workspace.characterMask:WaitForChild("idle"))
			track.Looped = true
			track.Priority = Enum.AnimationPriority.Idle
			track:Play()
			
			local cameraTarget = CFrame.new(targetTableTop.Position + Vector3.new(0,4.4,0) + targetTableTop.CFrame.rightVector * -28, targetTableTop.Position + Vector3.new(0,2.9,0)) * CFrame.new(-4,0,0)
			
			network:invoke("lockCameraPosition", cameraTarget, 0.7)
			tween(workspace.CurrentCamera,{"FieldOfView"},30,0.5)

			utilities.playSound("swoosh")		
	
			wait(0.7)

			generateCoolButtons()
			if connection then
				connection:disconnect()
			end

			local connection = game:GetService("UserInputService").InputChanged:connect(function(input, processed)
				if input.UserInputType == Enum.UserInputType.MouseMovement then
					
					local camSway = 0
					
					local hitpart, hitpos
					if pastLanding and renderedItems and script.Parent.Enabled then
						camSway = 70

						local ray = workspace.CurrentCamera:ScreenPointToRay(input.Position.X,input.Position.Y,1)
						local renderedChildren = renderedItems:GetChildren()
						if #renderedChildren > 0 and inputModule.mode.Value == "pc" then
							local hitpart, hitpos = workspace:FindPartOnRayWithWhitelist(Ray.new(ray.Origin, ray.Direction * 100), renderedChildren, true)
							if hitpart then
								local item = getItemFromHitpart(hitpart)
								selectItem(item)
							else
								selectItem()
							end
						end
						-- add camera sway effect, to a lessor extent
					elseif not pastLanding then
						camSway = 100
					end
					
					if camSway > 0 then
						local ray = workspace.CurrentCamera:ScreenPointToRay(input.Position.X,input.Position.Y,camSway)
						hitpart, hitpos = workspace:FindPartOnRay(ray)
						if hitpos then		
							local lookat = cameraTarget.Position + cameraTarget.lookVector * 50
							lookat = Vector3.new(hitpos.x + lookat.x * 25, hitpos.y + lookat.y * 25, hitpos.z + lookat.z * 25)/26
							--workspace.CurrentCamera.CFrame = CFrame.new(cameraTarget.Position, lookat)
							network:invoke("lockCameraPosition",CFrame.new(cameraTarget.Position, lookat),0.2)
						end		
					end
					
				end
			end)			
		end
			
		network:create("displayCharacterCustomizationScreen", "BindableFunction", "OnInvoke", module.display)
		network:create("hideCharacterCustomizationScreen", "BindableFunction", "OnInvoke", module.hide)			
			
			
		-- yield until the player makes a selection	
		function module.yieldDesiredAppearance(tableTop)
			
			if script.Parent.Enabled then
				return false, "Appearance picker is already active"
			end
			
			module.display(tableTop)
			
			repeat runService.Heartbeat:wait() until not script.Parent.Enabled
			
			return currentDesiredAppearance
		end
		
		network:create("yieldCharacterCustomizationScreen", "BindableFunction", "OnInvoke", module.yieldDesiredAppearance)
		

	
	end

return module
