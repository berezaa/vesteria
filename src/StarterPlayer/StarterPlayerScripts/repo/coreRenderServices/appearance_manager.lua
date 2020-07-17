local appearence_manager = {}


local replicatedStorage = game:GetService("ReplicatedStorage")

local modules		= require(replicatedStorage:WaitForChild("modules"))
local mapping 		= modules.load("mapping")

local function isBodyPart(obj)
	return obj:IsA("BasePart") and replicatedStorage.playerBaseCharacter:FindFirstChild(obj.Name) and replicatedStorage.playerBaseCharacter[obj.Name]:IsA("BasePart")
end

function appearence_manager.ApplySkinColor(appearanceData,renderCharacter,accessoryLookup,assets)
    if appearanceData and appearanceData.accessories.skinColorId then
		for i, obj in pairs(renderCharacter:GetChildren()) do
			if obj:IsA("BasePart") and isBodyPart(obj) then
				obj.Color = assets.accessories.skinColor:FindFirstChild(tostring(appearanceData.accessories.skinColorId or 1)).Value
			end
		end
	else
		for i, obj in pairs(renderCharacter:GetChildren()) do
			if obj:IsA("BasePart") and isBodyPart(obj) then
				obj.Color = BrickColor.new("Light orange").Color
			end
		end
	end
end

function appearence_manager.LoadAppearence(accessoryLookup,appearanceData,hatEquipmentData,itemLookup,renderCharacter)
	--damien this took 5 min-=
	-- cry me a river
	local hairColor = accessoryLookup.hairColor:FindFirstChild(tostring(appearanceData.accessories.hairColorId or 1)).Value
	local shirtColor = accessoryLookup.shirtColor:FindFirstChild(tostring(appearanceData.accessories.shirtColorId or 1)).Value

	for accessoryType, id in pairs(appearanceData.accessories) do
		if accessoryType == "hair" and hatEquipmentData then
			local itemBaseData = itemLookup[hatEquipmentData.id]

			if itemBaseData then
				local equipmentHairType_accessory = itemBaseData.equipmentHairType or 1
				if equipmentHairType_accessory == mapping.equipmentHairType.partial then
					id = id .. "_clipped"

				elseif equipmentHairType_accessory == mapping.equipmentHairType.none then
					-- no hair
					id = ""
				end
			end
		end

		if replicatedStorage.accessoryLookup:FindFirstChild(accessoryType) then
			local accessoryToLookIn = replicatedStorage.hairClipped:FindFirstChild(tostring(id)) or replicatedStorage.accessoryLookup[accessoryType]:FindFirstChild(tostring(id))

			if accessoryToLookIn then
				for i, accessoryPartContainer in pairs(accessoryToLookIn:GetChildren()) do
					if renderCharacter:FindFirstChild(accessoryPartContainer.Name) then

						if accessoryPartContainer:FindFirstChild("shirtTag") then
							renderCharacter[accessoryPartContainer.Name].Color = shirtColor
						elseif accessoryPartContainer:FindFirstChild("colorOverride") then
							renderCharacter[accessoryPartContainer.Name].Color = accessoryPartContainer.Color
						end

						for i, accessoryPart in pairs(accessoryPartContainer:GetChildren()) do
							if accessoryPart:IsA("BasePart") then
								local accessory = accessoryPart:Clone()
									accessory.Anchored 		= false
									accessory.CanCollide 	= false

								if accessory.Name == "hair_Head" then
									accessory.Color = hairColor
								end

								if accessory.Name == "shirt" or accessory:FindFirstChild("shirtTag") then
									accessory.Color = shirtColor
								end


								local projectionWeld = Instance.new("Motor6D", accessory)
									projectionWeld.Name 	= "projectionWeld"
									projectionWeld.Part0 	= accessory
									projectionWeld.Part1 	= renderCharacter[accessoryPartContainer.Name]
									projectionWeld.C0 		= CFrame.new()
									projectionWeld.C1 		= accessoryPartContainer.CFrame:toObjectSpace(accessoryPart.CFrame)

								accessory.Name 		= "!! ACCESSORY !!"
								accessory.Parent 	= renderCharacter

							end
						end
					end
				end
			end
		end
    end
end


return appearence_manager