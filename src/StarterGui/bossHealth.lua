local module = {}


function module.init(Modules)
	
	local network = Modules.network
	script.Parent.Visible = false
	
	network:create("prepareBossHealthUIForMonster", "BindableFunction", "OnInvoke", function(monsterData)
		if monsterData.portrait then
			script.Parent.thumbnail.Image = monsterData.portrait
		end
		script.Parent.Visible = true
		return script.Parent
	end)
	
end

return module
