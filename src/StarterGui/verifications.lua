local module = {}

function module.init(Modules)
	
	local network = Modules.network
	
	game.Players.LocalPlayer.Chatted:Connect(function(text)
		if text == "/verify" then
			Modules.focus.toggle(script.Parent)
		end
	end)
	script.Parent.Frame.send.Activated:connect(function()
		local success = network:invokeServer("playerRequest_redeemcode", script.Parent.Frame.code.TextBox.Text)
		if success then
			local textObject = {
				text = "You have been verified!";
				textColor3 = Color3.new(0,0,0);
				backgroundColor3 = Color3.fromRGB(0,255,150);
				backgroundTransparency = 0;
				textStrokeTransparency = 1;
			}
			Modules.notifications.alert(textObject, 3)
		else
			local textObject = {
				text = "Invalid verification code.";
				textColor3 = Color3.new(0,0,0);
				backgroundColor3 = Color3.fromRGB(255,100,0);
				backgroundTransparency = 0;
				textStrokeTransparency = 1;
			}
			Modules.notifications.alert(textObject, 3)			
		end
		Modules.focus.toggle(script.Parent)
	end)
	script.Parent.Frame.close.Activated:connect(function()
		Modules.focus.toggle(script.Parent)
	end)
end

return module