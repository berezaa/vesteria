-- written by Davidii
-- utility functions to help out with making cool-looking effects
local runService = game:GetService("RunService")

local module = {}

function module.onHeartbeatFor(duration, callback)
	local connection
	local timer = 0
	
	local function onHeartbeat(dt)
		timer = timer + dt
		
		-- if we hit the timer ending disconnect
		if (duration > 0) and (timer >= duration) then
			connection:Disconnect()
		end
		
		-- ternary operation
		local progress = (duration > 0) and math.min(timer / duration, 1) or 0
		
		-- call the callback, if it returns true then we end early
		if callback(dt, timer, progress) then
			connection:Disconnect()
		end
	end
	
	connection = runService.Heartbeat:Connect(onHeartbeat)
	onHeartbeat(0)
	
	return connection
end

function module.hideWeapons(entity)
	local network = require(game.ReplicatedStorage.modules).load("network")
	
	local weapons = network:invoke("getCurrentlyEquippedForRenderCharacter", entity)
	if not weapons then return end
	
	local restores = {}
	
	for _, weapon in pairs(weapons) do
		local manifest = weapon.manifest
		if manifest:IsA("BasePart") then
			table.insert(restores, {
				part = manifest,
				transparency = manifest.Transparency
			})
			manifest.Transparency = 1
		end
		for _, object in pairs(manifest:GetDescendants()) do
			if object:IsA("BasePart") then
				table.insert(restores, {
					part = object,
					transparency = object.Transparency
				})
				object.Transparency = 1
			end
		end
	end
	
	local function callback()
		for _, restore in pairs(restores) do
			restore.part.Transparency = restore.Transparency
		end
	end
	
	return callback
end

return module
