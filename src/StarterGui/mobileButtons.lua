
local module = {}

local player = game:GetService("Players").LocalPlayer
local gui = player.PlayerGui.gameUI.mobileButtons

function module.init(Modules)
	local control = Modules.control
	local itemAcquistion = Modules.itemAcquistion

	gui.jump.Activated:Connect(function()
		control.doJump()
	end)

	gui.pickup.InputBegan:Connect(function(Input)
		itemAcquistion.pickupInputGained(Input)
	end)
end

return module


