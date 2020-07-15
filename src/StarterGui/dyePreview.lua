-- Input prompt by Locard, modified by berezaa
-- Imported from Miner's Haven
local module = {}

local runService = game:GetService("RunService")

local promptOut
local promptFrame = script.Parent
local buttonCons = {}
local currentDecision

function module.forceClose()
	if promptOut then
		currentDecision = false
	end
end

function module.isPrompting()
	return promptOut
end

-- moved under module.init
function module.prompt(headerText)
	
end

module.PROMPT_EXPIRE_TIME = 30

function module.init(Modules)

	local tween = Modules.tween

	promptFrame.Visible = false
	
	local promptQueue = {}
	
	local currentPrompt


	local function getCenterOfMassOfModel(model)
		
		local validParts = {}
		
		if model:FindFirstChild("manifest") then
			table.insert(validParts, model.manifest)
		end
		for i,child in pairs(model:GetChildren()) do
			if child:IsA("BasePart") then
				child.Color = Color3.new(1,1,1)
				child.Transparency = 0.5
			end
			for e,childchild in pairs(child:GetChildren()) do
				
				if childchild:IsA("BasePart") then
					table.insert(validParts, childchild)
				end
			end
		end
		
		local totalVotedPosition = Vector3.new()
		local totalVotes = 0
		for i,part in pairs(validParts) do
			if part:IsA("BasePart") then
				local center = part.Position
				local mass = part:GetMass()
				totalVotedPosition = totalVotedPosition + (center * mass)
				totalVotes = totalVotes + mass
			end
		end
		return totalVotedPosition / totalVotes
	end	
	
	local function displayPrompt(prompt)
		currentPrompt = prompt

		promptFrame.curve.ImageColor3 = Color3.fromRGB(30, 30, 30)
		promptFrame.Visible = true
		
		promptFrame.curve.yes.Visible = true
		promptFrame.curve.no.Visible = true		
		
		promptFrame.curve.Visible = true
		

		
		promptFrame.curve.title.Text = prompt.text
		
--		promptFrame.curve.Position = UDim2.new(-1,0,0,0)		
--		tween(promptFrame.curve, {"Position"}, UDim2.new(0,0,0,0), 0.6)	


		
		local itemBaseData = prompt.itemBaseData
		local dyeItemData = prompt.dyeItemData
		
		
		promptFrame.curve.before:ClearAllChildren()
		promptFrame.curve.after:ClearAllChildren()
		
		local module = itemBaseData.module
		
		
		local container
		if module:FindFirstChild("manifest") then
			container = Instance.new("Model")
			local primaryPart = module.manifest:Clone() 
			primaryPart.Parent = container
			container.PrimaryPart = primaryPart
		elseif module:FindFirstChild("container") then
			container = module.container:Clone()	
		end
		container.Parent = promptFrame.curve.before
		
		
		local modelExtents = container:GetExtentsSize()
		
		local centerOfMass = getCenterOfMassOfModel(container)
		
		local camera = Instance.new("Camera")
		camera.CFrame = CFrame.new( centerOfMass + modelExtents * Vector3.new(0.7,0,-0.7), centerOfMass)
		camera.Parent = promptFrame.curve.before
		promptFrame.curve.before.CurrentCamera = camera
		
		
		local afterContainer = container:Clone()
		afterContainer.Parent = promptFrame.curve.after
		
		
		local itemInventorySlotData = {id = itemBaseData.id}
		if dyeItemData.applyScroll(game.Players.LocalPlayer, itemInventorySlotData, true) then
			local dyeColor = itemInventorySlotData.dye
			if dyeColor then
				for i,child in pairs(afterContainer:GetDescendants()) do
					if child:IsA("BasePart") then
						-- Color3.new(v.Color.r * dye.r/255, v.Color.g * dye.g/255, v.Color.b * dye.b/255)
						child.Color = Color3.new(child.Color.r * dyeColor.r/255, child.Color.g * dyeColor.g/255, child.Color.b * dyeColor.b/255)
					end
				end
			end
		end
		
		local camera = Instance.new("Camera")
		camera.CFrame = CFrame.new( centerOfMass + modelExtents * Vector3.new(0.7,0,-0.7), centerOfMass)
		camera.Parent = promptFrame.curve.after
		promptFrame.curve.after.CurrentCamera = camera		
		
		
--[[

	applyScroll = function(player, itemInventorySlotData, successfullyScrolled)
		local itemLookup = require(game:GetService("ReplicatedStorage"):WaitForChild("itemData"))
		local itemBaseData = itemLookup[itemInventorySlotData.id]
		
		if itemBaseData.category == "equipment" then
			if successfullyScrolled then
				--85, 85, 85
				itemInventorySlotData.dye = {r=85, g=85, b=85}
				return true
			end
		end
		
		return false, "Only equipment can be dyed"
	end;	
	
--]]		
		
	
	end
	
	local function addPrompt(prompt)
		table.insert(promptQueue, prompt)
		
		if #promptQueue == 1 or promptQueue[1] == prompt then
			displayPrompt(prompt)
		end
		--[[
		for i=1,3 do
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
		]]	
	end
	
	local function makeUserResponse(userResponse)
		if currentPrompt then
			-- register the user's response
			currentPrompt.userResponse = userResponse
			-- remove the response from queue
			for i,prompt in pairs(promptQueue) do
				if prompt == currentPrompt then
					table.remove(promptQueue, i)
					break
				end
			end
			
			currentPrompt = nil	

			-- fancy transition out			
			local transitionCurve = promptFrame.curve:Clone()
			transitionCurve.Name = "transition"
			transitionCurve.ZIndex = transitionCurve.ZIndex + 1
			transitionCurve.Parent = promptFrame
			
			tween(transitionCurve, {"Position"}, UDim2.new(-1,-10,0,0), 0.6) 
			
			game.Debris:AddItem(transitionCurve, 0.6)
			spawn(function()
				wait(0.6)
				if not currentPrompt then
					promptFrame.Visible = false
				end
			end)
			
			promptFrame.curve.Visible = false
			
			-- show the next response if applicable
			local nextPrompt = promptQueue[1]
			if nextPrompt then
				displayPrompt(nextPrompt)
			end			
					
		end
	end	
	
	function module.prompt(dyeItemData, itemBaseData)
		
		local promptStartTime = tick()
		local prompt = {text = "Are you sure you want to apply "..dyeItemData.name.."?"; timestamp = promptStartTime;dyeItemData = dyeItemData; itemBaseData = itemBaseData;}
		addPrompt(prompt)
		
		
		repeat wait() until prompt.userResponse ~= nil or tick() - promptStartTime >= module.PROMPT_EXPIRE_TIME
		
		-- remove the response from queue (if expired)
		if tick() - promptStartTime >= module.PROMPT_EXPIRE_TIME then
			if prompt == currentPrompt then
				makeUserResponse(false)
			else			
				for i,prompt in pairs(promptQueue) do
					if prompt == currentPrompt then
						table.remove(promptQueue, i)
						break
					end
				end					
			end
		end
		
		return prompt.userResponse or false
		
	end
	


	promptFrame.curve.no.MouseButton1Click:Connect(function()
		promptFrame.curve.ImageColor3 = Color3.fromRGB(30, 7, 8)
		promptFrame.curve.yes.Visible = false
		promptFrame.curve.no.Visible = false
		makeUserResponse(false)
	end)
	promptFrame.curve.yes.MouseButton1Click:Connect(function()
		promptFrame.curve.ImageColor3 = Color3.fromRGB(8, 30, 10)
		promptFrame.curve.yes.Visible = false
		promptFrame.curve.no.Visible = false				
		makeUserResponse(true)	
	end)	
	
	
	
	
	-- old stuff no one cares about:
	
	function module.prompt_old(headerText)
			
		
		if promptOut then
			return false
		end


		promptFrame.Position = UDim2.new(0.5,0,0.5,0)
		
		
		-- temp measure
		
		local function selfIsSelected()
			local obj = game:GetService("GuiService").SelectedObject
			
			if obj then
				return obj:IsDescendantOf(promptFrame)
			else
				return false
			end
		end	
		
		promptOut = true
		
		local transitionOut 
		
		--First we initiate the prompt

		promptFrame.curve.title.Text = headerText
		
		local con0 = promptFrame.curve.no.MouseButton1Click:Connect(function()
			--Modules.Menu.sounds.Click:Play()
			if promptOut then
				promptFrame.curve.ImageColor3 = Color3.fromRGB(30, 7, 8)
				promptFrame.curve.yes.Visible = false
				promptFrame.curve.no.Visible = false
				currentDecision = false
			end
		end)
		local con1 = promptFrame.curve.yes.MouseButton1Click:Connect(function()
			--Modules.Menu.sounds.Click:Play()
			if promptOut then
				promptFrame.curve.ImageColor3 = Color3.fromRGB(8, 30, 10)
				promptFrame.curve.yes.Visible = false
				promptFrame.curve.no.Visible = false				
				currentDecision = true
			end
		end)
		
		tween(promptFrame.curve, {"Position"}, UDim2.new(0,0,0,0), 0)
		promptFrame.curve.ImageColor3 = Color3.fromRGB(30, 30, 30)
		promptFrame.Visible = true
		promptFrame.curve.yes.Visible = true
		promptFrame.curve.no.Visible = true		
		for i=1,3 do
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

		--Transition the stuff into the screen
		--spawn(function()
			-- use my tween function nerd
			


		--promptFrame.Absorb.Visible = true
		--Modules.Menu.tween(promptFrame,{"BackgroundTransparency"}, .5, 0.7, Enum.EasingStyle.Quint)
		--Modules.Menu.tween(promptFrame.InputPrompt, {"Position"}, UDim2.new(0.5,0,0.5,0), 0.7, Enum.EasingStyle.Quint)
			
			--[[
			
			local startT = tick()
			for i = 1,60*deltaT do
				if transitionOut then
					break
				end
				local now = tick() - startT
				local a = now/deltaT
				local inputFrameY = quint(-.5,.5,a)
				local bgTransparency = quint(1,.6,a)
				promptFrame.BackgroundTransparency = bgTransparency
				promptFrame.InputPrompt.Position = UDim2.new(0,0,inputFrameY,0)
				runService.Heartbeat:Wait()
			end
			]]

		--end)
		
		
		--Yield the thread until an answer pops up	
		repeat
			--[[
			local Xbox = Modules.Input.mode.Value == "Xbox"
			if Xbox and not selfIsSelected() then
				Modules.Focus.stealFocus(promptFrame.InputPrompt)
			end
			]]
			runService.Heartbeat:Wait()
		until currentDecision ~= nil
		
		local thisDecision = currentDecision
		currentDecision = nil	
			
		--Disconnect the buttons
		con0:Disconnect()
		con1:Disconnect()
		
		--make prompt ready
		promptOut = false
		tween(promptFrame.curve, {"Position"}, UDim2.new(-1,-10,0,0), 0.6)
		spawn(function()
			wait(0.6)
			if not promptOut then
				promptFrame.Visible = false	
			end
		end)
	--	spawn(function()
		
	--	promptFrame.Absorb.Visible = false
	--	Modules.Menu.tween(promptFrame,{"BackgroundTransparency"}, 1, 0.7, Enum.EasingStyle.Quint)
	--	Modules.Menu.tween(promptFrame.InputPrompt, {"Position"}, UDim2.new(0.5,0,0,-250), 0.7, Enum.EasingStyle.Quint)			
		--[[
		local startT = tick()
		for i = 1,60*deltaT do
			if promptOut then
				break
			end
			local now = tick() - startT
			local a = now/deltaT
			local inputFrameY = quint(.5,-.5,a)
			local bgTransparency = quint(.6,1,a)
			promptFrame.BackgroundTransparency = bgTransparency
			promptFrame.InputPrompt.Position = UDim2.new(0,0,inputFrameY,0)
			runService.Heartbeat:Wait()
		end
		]]
	--	end)
	
		

		return thisDecision
	end	
	
	

end


return module