-- // Chest Conversion Tool //--
-- This tool converts old chests to the new attackable chest system.

function convertToNewChest(chestModel)
	local oldChestBottom = chestModel:FindFirstChild("Bottom")
	if not oldChestBottom then 
		warn("Chest ["..chestModel:GetFullName().."] does not have a bottom! Is it already converted?")
		return chestModel
	end
	
	local oldChestBottomCFrame = oldChestBottom.CFrame * CFrame.new(0, -oldChestBottom.Size.Y/2, 0)
	
	local newChest = Instance.new("Model")
	local rootPart = Instance.new("Part")
	
	rootPart.BrickColor = BrickColor.new("Bright orange")
	rootPart.Anchored = true
	rootPart.CanCollide = false
	rootPart.RightSurface = Enum.SurfaceType.Weld
	rootPart.Size = Vector3.new(3.5, 4, 6)
	rootPart.CFrame = oldChestBottomCFrame * CFrame.new(0, rootPart.Size.Y/2, 0)
	rootPart.Name = "RootPart"
	rootPart.Parent = newChest
	
	newChest.PrimaryPart = rootPart
	
	local inventory = 
		chestModel:FindFirstChild("inventory") or
		chestModel:FindFirstChild("ironChest") or
		chestModel:FindFirstChild("goldChest")
	
	if inventory then
		if inventory.Name == "goldChest" then
			local newChestProps = Instance.new("ModuleScript")
			newChestProps.Source = "return { chestModel = \"goldChest\" }"
			newChestProps.Name = "chestProps"
			newChestProps.Parent = newChest
			
			rootPart.BrickColor = BrickColor.new("Gold")
		elseif inventory.Name == "ironChest" then
			local newChestProps = Instance.new("ModuleScript")
			newChestProps.Source = "return { chestModel = \"ironChest\" }"
			newChestProps.Name = "chestProps"
			newChestProps.Parent = newChest
			
			rootPart.BrickColor = BrickColor.new("Fossil")
		end
		inventory.Parent = newChest
	end
	
	if chestModel:FindFirstChild("chestLevel") then
		chestModel.chestLevel.Parent = newChest
	end
	
	if chestModel:FindFirstChild("minLevel") then
		chestModel.minLevel.Parent = newChest
	end
	
	newChest.Parent = chestModel.Parent
	newChest.Name = chestModel.Name
	
	game:GetService("CollectionService"):AddTag(newChest, "treasureChest")
	
	chestModel:Destroy()
	
	return newChest
end

function fixGoldAndIronChests(chestModel)
	local rootPart = chestModel.PrimaryPart
	if not rootPart then 
		warn("Chest ["..chestModel:GetFullName().."] does not have a PrimaryPart! Check on it!")
		return
	end
	local inventory = 
		chestModel:FindFirstChild("inventory") or
		chestModel:FindFirstChild("ironChest") or
		chestModel:FindFirstChild("goldChest")
	local chestProps = chestModel:FindFirstChild("chestProps")
	
	if inventory and not chestProps then
		if inventory.Name == "goldChest" then
			local newChestProps = Instance.new("ModuleScript")
			newChestProps.Source = "return { chestModel = \"goldChest\" }"
			newChestProps.Name = "chestProps"
			newChestProps.Parent = chestModel
			
			rootPart.BrickColor = BrickColor.new("Gold")
		elseif inventory.Name == "ironChest" then
			local newChestProps = Instance.new("ModuleScript")
			newChestProps.Source = "return { chestModel = \"ironChest\" }"
			newChestProps.Name = "chestProps"
			newChestProps.Parent = chestModel
			
			rootPart.BrickColor = BrickColor.new("Fossil")
		end
	end
end

for _, instance in pairs(workspace:GetChildren()) do
	if instance:FindFirstChild("chestLevel") then
		print("Converting ["..instance:GetFullName().."] ...")
		local newChest = convertToNewChest(instance)
		fixGoldAndIronChests(newChest)
	end
end