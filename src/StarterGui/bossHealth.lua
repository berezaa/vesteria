local module = {}

local frame = script.Parent.gameUI.bossHealth
function module.init(Modules)
	
	local network = Modules.network
	frame.Visible = false
	
	network:create("prepareBossHealthUIForMonster", "BindableFunction", "OnInvoke", function(monsterData)
		if monsterData.portrait then
			frame.thumbnail.Image = monsterData.portrait
		end
		frame.Visible = true
		return frame
	end)
	
end

return module
