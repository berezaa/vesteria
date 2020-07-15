local module = {}

-- wait for the server to create placeFolders
local placeFoldersFolder 	= workspace:WaitForChild("placeFolders", 60)
local lookupCache 			= {}

local runService = game:GetService("RunService")

-- waits for placeFolder by name placeFolder to be created
function module.awaitPlaceFolder(placeFolderName)
	if not lookupCache[placeFolderName] then
		local placeFolder = placeFoldersFolder:WaitForChild(placeFolderName)
		if placeFolder then
			lookupCache[placeFolderName] = placeFolder
		end
	end
	
	return lookupCache[placeFolderName]
end


-- returns placeFolder placeFolderName and creates it if it does not exist
function module.getPlaceFolder(placeFolderName, doNotCreate)
	if not lookupCache[placeFolderName] then
		
		if runService:IsClient() then
			module.awaitPlaceFolder(placeFolderName)
		else
			local placeFolder = placeFoldersFolder:FindFirstChild(placeFolderName)
			if not placeFolder and not doNotCreate then
				placeFolder 	= Instance.new("Folder", placeFoldersFolder)
				placeFolder.Name = placeFolderName
			end
			
			lookupCache[placeFolderName] = placeFolder						
		end
		

	end
	
	return lookupCache[placeFolderName]
end


function module.getPlaceFoldersFolder()
	return placeFoldersFolder
end

return module