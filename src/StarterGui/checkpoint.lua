local module = {}

function module.init(Modules)
	local tween = Modules.tween
	local events = Modules.events
	
	local currentSpawnPoint
	
	local textLabel = script.Parent
	
	events:registerForEvent("playerRespawnPointChanged", function(spawnPoint)
		if spawnPoint:FindFirstChild("description") then
			currentSpawnPoint = spawnPoint
			textLabel.Text = spawnPoint.description.Value
			textLabel.TextStrokeTransparency = 1
			textLabel.TextTransparency = 1
			textLabel.Visible = true
			tween(textLabel, {"TextTransparency", "TextStrokeTransparency"}, 0, 1)
			delay(3, function()
				if currentSpawnPoint == spawnPoint then
					tween(textLabel, {"TextTransparency", "TextStrokeTransparency"}, 1, 1)
				end
			end)
		end
	end)
	
end

return module
