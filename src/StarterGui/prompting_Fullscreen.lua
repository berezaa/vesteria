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

	
	local function displayPrompt(prompt)
		currentPrompt = prompt

		promptFrame.curve.ImageColor3 = Color3.fromRGB(30, 30, 30)
		promptFrame.Visible = true
		
		promptFrame.curve.yes.Visible = true
		promptFrame.curve.no.Visible = true		
		
		promptFrame.curve.Visible = true
		

		
		promptFrame.curve.title.Text = prompt.text
		
	
	end
	
	local function addPrompt(prompt)
		table.insert(promptQueue, prompt)
		
		if #promptQueue == 1 or promptQueue[1] == prompt then
			displayPrompt(prompt)
		end
			
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

			spawn(function()
				wait()
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
	
	function module.prompt(headerText)
		
		local promptStartTime = tick()
		local prompt = {text = headerText; timestamp = promptStartTime}
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
		

		promptFrame.curve.ImageColor3 = Color3.fromRGB(30, 30, 30)
		promptFrame.Visible = true
		promptFrame.curve.yes.Visible = true
		promptFrame.curve.no.Visible = true		
	

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


		promptFrame.Visible = false	

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
	
	
	Modules.network:create("promptActionFullscreen","BindableFunction","OnInvoke",module.prompt)
end


return module