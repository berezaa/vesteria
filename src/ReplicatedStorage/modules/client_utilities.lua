local module = {}

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local network 		= modules.load("network")
	local placeSetup 	= modules.load("placeSetup")
	
local userInputService 	= game:GetService("UserInputService")
local IGNORE_LIST 		= {placeSetup.getPlaceFoldersFolder()}

function module.raycastFromCurrentScreenPoint(customIgnoreList, range)
	range = range or 2048
	local mouseLocation = userInputService:GetMouseLocation()
	
	local cameraRay = workspace.CurrentCamera:ScreenPointToRay(mouseLocation.X, mouseLocation.Y - 36)
	local ray 		= Ray.new(cameraRay.Origin, cameraRay.Direction.unit * range)
	
	local hitPart, hitPosition, hitNormal, hitMaterial = workspace:FindPartOnRayWithIgnoreList(ray, customIgnoreList or IGNORE_LIST)
	
	while hitPart and (not hitPart.CanCollide or hitPart.Transparency >= 0.95) do
		table.insert(customIgnoreList or IGNORE_LIST, hitPart)
		
		hitPart, hitPosition, hitNormal, hitMaterial = workspace:FindPartOnRayWithIgnoreList(ray, customIgnoreList or IGNORE_LIST)
	end
	
	return hitPart, hitPosition, hitNormal, hitMaterial, ray
end

local function main()
	
end

return module