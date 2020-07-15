local module = {}


local replicatedStorage = game:GetService("ReplicatedStorage")
	local modules 	= require(replicatedStorage.modules)
		local network 			= modules.load("network")
		local utilities			= modules.load("utilities")

network:connect("signal_alertChatMessage", "OnClientEvent", function(messageTable)
	game.StarterGui:SetCore("ChatMakeSystemMessage", messageTable)
end)

network:connect("signal_playerKilledByPlayer", "OnClientEvent", function(deadPlayer, killer, damageInfo, verb)
						
	if killer and verb then
		

		-- you did this!
		if killer == game.Players.LocalPlayer then
			utilities.playSound("kill", deadPlayer.Character and deadPlayer.Character.PrimaryPart)
			network:fire("alert", {text = "You " .. verb ..  " " ..deadPlayer.Name.."!"; textColor3 = Color3.fromRGB(255, 93, 61);})
		end
				
	end	
end)

return module
