local module = {}
local alerts = {}

function module.alert()

end

function module.init(Modules)
	
	if game.ReplicatedStorage:FindFirstChild("alertsOffset") then
		script.Parent.Position = UDim2.new(0.5, 0, 0, script.Parent.Position.Y.Offset + game.ReplicatedStorage.alertsOffset.Value)
	end
	
	local tween = Modules.tween
	local network = Modules.network
	local utilities = Modules.utilities
	
	function module.alert(textObject, duration, soundeffect)
		duration = duration or 4
		
		if soundeffect and game.ReplicatedStorage.assets.sounds:FindFirstChild(soundeffect) then
			utilities.playSound(soundeffect)
			--game.ReplicatedStorage.sounds[soundeffect]:Play()
		end
		
		local isNewAlert = false
	
		local alert
		if textObject.id and alerts[textObject.id] then
			alert 						= alerts[textObject.id].alert
			alerts[textObject.id].start = tick()
		else
			alert 		= script.Parent:WaitForChild("alert"):clone()
			isNewAlert 	= true
			
			if textObject.id then
				alerts[textObject.id] = {alert = alert; start = tick()}
			end
		end
		
		alert.TextLabel.Text 				= textObject.text or textObject.Text or ""
		alert.TextLabel.TextColor3 			= textObject.textColor3 or textObject.Color or Color3.new(1,1,1)
		alert.TextLabel.TextStrokeColor3 	= textObject.textStrokeColor3 or Color3.new(0,0,0)
		alert.TextLabel.Font				= textObject.font or textObject.Font or Enum.Font.SourceSansBold
		alert.TextLabel.BackgroundColor3	= textObject.backgroundColor3 or Color3.new(1,1,1)
		
		local textBounds = game.TextService:GetTextSize(alert.TextLabel.Text,alert.TextLabel.TextSize,alert.TextLabel.Font,Vector2.new())
		alert.TextLabel.Size = UDim2.new(0,textBounds.X + 20,1,0)
		
		alert.Parent = script.Parent
		alert.Visible = true
		
		if isNewAlert then
			local textTransparency  		= textObject.textTransparency or 0
			local textStrokeTransparency 	= textObject.textStrokeTransparency or 0
			
			local backgroundTransparency 	= textObject.backgroundTransparency or 1
			
			alert.TextLabel.TextTransparency 		= 1
			alert.TextLabel.BackgroundTransparency	= 1
			alert.TextLabel.TextStrokeTransparency 	= 1
		
			tween(alert.TextLabel, {"TextTransparency", "TextStrokeTransparency", "BackgroundTransparency"}, {textTransparency, textStrokeTransparency, backgroundTransparency}, 0.5)
		else
			alert.TextLabel.TextTransparency  		= textObject.textTransparency or 0
			alert.TextLabel.TextStrokeTransparency 	= textObject.textStrokeTransparency or 0
			alert.TextLabel.BackgroundTransparency 	= textObject.backgroundTransparency or 1			
		end
		
		spawn(function()
			wait(duration)
			
			if textObject.id and alerts[textObject.id] then
				if alerts[textObject.id].alert == alert then

					alerts[textObject.id] = nil					
					tween(alert.TextLabel,{"TextTransparency", "TextStrokeTransparency", "BackgroundTransparency"}, {1, 1, 1}, 0.5)
					game.Debris:AddItem(alert, 0.5)
				end
			elseif alert and alert.Parent == script.Parent then
				tween(alert.TextLabel,{"TextTransparency", "TextStrokeTransparency", "BackgroundTransparency"}, {1, 1, 1}, 0.5)
				game.Debris:AddItem(alert, 0.5)				
			end
			
		end)
	end	
	
	network:create("alert","BindableEvent", "Event", module.alert)
	network:connect("alertPlayerNotification", "OnClientEvent", module.alert)
end

return module
