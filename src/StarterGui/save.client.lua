script.Parent.Enabled = false
script.Parent.saveMe.Visible = false
game.Players.LocalPlayer:WaitForChild("DataLoaded", 60)

wait(5)
if (not script.Parent.Parent.gameUI.Enabled) and (not script.Parent.Parent.customize.Enabled) then
	script.Parent.Enabled = true
	script.Parent.saveMe.Visible = true
	
	
	local function showReport()
		local text = "" 
		for i,entry in pairs(game.LogService:GetLogHistory()) do
			text = text .. "  [["..entry.message.."]]  " 
		end 
		script.Parent.incident.contents.Text = text
		script.Parent.incident.Visible = true 
	end
	
	script.Parent.incident.continue.Activated:connect(function()
		local modules = require(game.ReplicatedStorage:WaitForChild("modules"))
		local network = modules.load("network")
		network:invokeServer("playerRequest_returnToMainMenu")
		script.Parent.incident.continue:Destroy()
	end)
	
	script.Parent.saveMe.Activated:connect(function()
		script.Parent.saveMe.Visible = false
		showReport()
	end)
end