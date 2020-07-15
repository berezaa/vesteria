local list = {}

for i,item in pairs(game.ReplicatedStorage.itemData:GetChildren()) do
	if item:IsA("ModuleScript") then
		local data = require(item)
		table.insert(list, {item.Name, data.id})
	end
end

table.sort(list, function(a, b)
	return a[2] > b[2]
end)

local items = {}
for _, data in pairs(list) do
	table.insert(items, data[1])
end

return items