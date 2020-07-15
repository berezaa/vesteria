local module = {}

local activePlayer

function module.init(Modules)
	
	local network = Modules.network
	
	-- todo: fix
	local animationInterface = require(game.Players.LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("repo"):WaitForChild("animationInterface"))
	
	function module.show(player)
		
		activePlayer = player
		
		if Modules.input.mode.Value ~= "mobile" then		
			script.Parent.contents.username.Text = player.Name
			script.Parent.contents.level.Text = "Lvl. "..tostring(player:FindFirstChild("level") and player.level.Value or 0)
			script.Parent.interact.Visible = true
			script.Parent.options.Visible = false
			script.Parent.Size = UDim2.new(0, 700,0, 105)
			script.Parent.Visible = true
		end
	end
	
	function module.activate(player)
		Modules.inspectPlayer.open(player)
		animationInterface:replicatePlayerAnimationSequence("emoteAnimations", "interaction_greeting")
	end
	
	function module.hide()
		activePlayer = nil
		script.Parent.Visible = false
	end
	module.hide()
end

return module
