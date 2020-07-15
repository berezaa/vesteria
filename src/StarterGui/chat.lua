local module = {}

function module.init()
	
	local function main()
		game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
		spawn(function()
			wait()
			
			

--			game.StarterGui:SetCore("ChatWindowPosition", UDim2.new(0,0,0,0))
			
			game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
			game.StarterGui:SetCore("ChatBarDisabled", false)
			game.StarterGui:SetCore("ChatActive", true)
			

		end)
	end
	
	main()	
	
end

return module