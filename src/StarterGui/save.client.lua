local resetUI = script.Parent:WaitForChild("resetUI")

resetUI.Enabled = false
resetUI.saveMe.Visible = false
game.Players.LocalPlayer:WaitForChild("DataLoaded", 60)

wait(5)
if (not resetUI.Parent.gameUI.Enabled) and (not resetUI.Parent.customize.Enabled) then
	resetUI.Enabled = true
	resetUI.saveMe.Visible = true


	local function showReport()
		local text = ""
		for _, entry in pairs(game.LogService:GetLogHistory()) do
			text = text .. "  [["..entry.message.."]]  "
		end
		resetUI.incident.contents.Text = text
		resetUI.incident.Visible = true
	end

	resetUI.incident.continue.Activated:connect(function()
		local modules = require(game.ReplicatedStorage:WaitForChild("modules"))
		local network = modules.load("network")
		network:invokeServer("playerRequest_returnToMainMenu")
		resetUI.incident.continue:Destroy()
	end)

	resetUI.saveMe.Activated:connect(function()
		resetUI.saveMe.Visible = false
		showReport()
	end)
end