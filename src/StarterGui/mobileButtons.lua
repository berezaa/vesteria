


local module = {}


function module.init(Modules)
	local network = Modules.network
	
	script.Parent.jump.Activated:Connect(function()
		network:invoke("doJump")
	end)
	
	script.Parent.pickup.InputBegan:Connect(function(Input)
		Modules.itemAcquistion.pickupInputGained(Input)
	end)
end

return module


