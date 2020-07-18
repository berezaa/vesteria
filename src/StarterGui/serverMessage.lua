local module = {}

local ui = script.Parent.gameUI.leftBar.serverMessage

function module.init(Modules)

	local network = Modules.network
	local configuration = Modules.configuration
	local tween = Modules.tween

	local currentMessage

	function module.displayMessage(message)

		ui.contents.ImageColor3 = Color3.fromRGB(18, 18, 18)

		ui.Visible = true

		currentMessage = message

		ui.contents.body.text.Text = currentMessage
		local textBounds = ui.contents.body.text.TextBounds

		ui.Size = UDim2.new(0, 280, 0, 62 + textBounds.Y)

		for i=1,4 do
			local flare = ui.flare:Clone()
			flare.Name = "flareCopy"
			flare.Parent = ui
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
		if ui.Visible then
			currentMessage = ""
			ui.Visible = false
		end
	end

	ui.contents.Activated:connect(module.hide)

	ui.contents.MouseEnter:connect(function()
		ui.contents.ImageColor3 = Color3.fromRGB(12, 0, 63)
	end)

	ui.contents.MouseLeave:connect(function()
		ui.contents.ImageColor3 = Color3.fromRGB(18, 18, 18)
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
