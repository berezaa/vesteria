


local module = {}

local player = game:GetService("Players").LocalPlayer
local gui = player.PlayerGui.gameUI.mobileButtons

function module.init(Modules)
	local network = Modules.network
	
	gui.jump.Activated:Connect(function()
		network:invoke("doJump")
	end)
	
	gui.pickup.InputBegan:Connect(function(Input)
		Modules.itemAcquistion.pickupInputGained(Input)
	end)
end

return module


