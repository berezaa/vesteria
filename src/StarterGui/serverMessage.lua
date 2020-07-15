local module = {}

function module.init(Modules)
	
	local network = Modules.network
	local configuration = Modules.configuration
	local tween = Modules.tween
	
	local currentMessage
	
	function module.displayMessage(message)
		
		script.Parent.contents.ImageColor3 = Color3.fromRGB(18, 18, 18)
		
		script.Parent.Visible = true
		
		currentMessage = message
		
		script.Parent.contents.body.text.Text = currentMessage
		local textBounds = script.Parent.contents.body.text.TextBounds
		
		script.Parent.Size = UDim2.new(0, 280, 0, 62 + textBounds.Y)
		
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
	end
	
	function module.hide()
		if script.Parent.Visible then
			currentMessage = ""
			script.Parent.Visible = false
		end
	end
	
	script.Parent.contents.Activated:connect(module.hide)
	
	script.Parent.contents.MouseEnter:connect(function()
		script.Parent.contents.ImageColor3 = Color3.fromRGB(12, 0, 63)
	end)
	
	script.Parent.contents.MouseLeave:connect(function()
		script.Parent.contents.ImageColor3 = Color3.fromRGB(18, 18, 18)
	end)
	
	spawn(function()
		network:connect("gameConfigurationUpdated", "Event", function(playerConfiguration)
			local gameMessage = playerConfiguration.gameDisplayMessage 
			if gameMessage and #gameMessage > 0 then
				module.displayMessage(gameMessage)
			else
				module.hide()
			end
		end)
	
	
		local gameMessage = configuration.getConfigurationValue("gameDisplayMessage")
		if gameMessage and #gameMessage > 0 then
			module.displayMessage(gameMessage)
		else
			module.hide()
		end
	end)
end



--playerConfiguration.gameDisplayMessage


return module
