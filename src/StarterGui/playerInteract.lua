local module = {}

local activePlayer
local ui = script.Parent.gameUI.interactFrame.interact

function module.init(Modules)

	local network = Modules.network

	-- todo: fix
	local animationInterface = Modules.animationInterface

	function module.show(player)

		activePlayer = player

		if Modules.input.mode.Value ~= "mobile" then
			ui.contents.username.Text = player.Name
			ui.contents.level.Text = "Lvl. "..tostring(player:FindFirstChild("level") and player.level.Value or 0)
			ui.interact.Visible = true
			ui.options.Visible = false
			ui.Size = UDim2.new(0, 700,0, 105)
			ui.Visible = true
		end
	end

	function module.activate(player)
		Modules.inspectPlayer.open(player)
		animationInterface:replicatePlayerAnimationSequence("emoteAnimations", "interaction_greeting")
	end

	function module.hide()
		activePlayer = nil
		ui.Visible = false
	end
	module.hide()
end

return module
