print("LOADED CLIENT DEBUG SCRIPT")

local entities = workspace.placeFolders.entities
local entitiesChildren = entities:GetChildren()
for _, entity in pairs(entitiesChildren) do
	print(entity)
end
print("There are", #entitiesChildren, "entities active.")