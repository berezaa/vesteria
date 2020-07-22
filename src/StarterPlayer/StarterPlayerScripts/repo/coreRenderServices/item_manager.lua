local item_manager = {}

local replicatedStorage = game:GetService("ReplicatedStorage")

local modules = require(replicatedStorage:WaitForChild("modules"))
local detection = modules.load("detection")
local network = modules.load("network")
local mapping = modules.load("mapping")

local itemDataLookup = require(replicatedStorage.itemData)
local itemLookup = replicatedStorage.assets.items

function item_manager.getCurrentlyEquippedForRenderCharacter(renderCharacter)
	local currentlyEquipped = {}

	for i, obj in pairs(renderCharacter:GetChildren()) do
		if obj:IsA("BasePart") or obj:IsA("Model") then
			local accessoryType, accessoryId, accessorySlot = string.match(obj.Name, "(%w+)_(%d+)_(%d+)")

			if accessoryType and accessoryId then
				accessoryId 	= tonumber(accessoryId)
				accessorySlot 	= tonumber(accessorySlot)

				if accessoryType == "EQUIPMENT" then
					local equipmentBaseData = itemDataLookup[tonumber(accessoryId)]

					currentlyEquipped[tostring(accessorySlot)] = {
						baseData 	= equipmentBaseData;
						manifest 	= obj;
					}
				end
			end
		end
	end

    return currentlyEquipped
end



local function isCurrentlyEquipped(currentlyEquipped, equipmentSlotData)
	local equipmentBaseData = itemDataLookup[equipmentSlotData.id]

	if currentlyEquipped[equipmentBaseData.equipmentSlot] then
		if equipmentSlotData.id == currentlyEquipped[tostring(equipmentBaseData.equipmentSlot)].baseData.id then
			return true
		end
	end

	return false
end

function item_manager.GetWeaponStateAppendment(renderEntityData)
    local weaponStateAppendment
    local currentlyEquipped = item_manager.getCurrentlyEquippedForRenderCharacter(renderEntityData.entityContainer.entity)

	if currentlyEquipped["1"] and currentlyEquipped["1"].baseData.equipmentType then
        -- weaponState weapons should never overlap with dual wielding (BOW IN PARTICULAR)
        if renderEntityData.weaponState then
            weaponStateAppendment = "_" .. renderEntityData.weaponState
        elseif currentlyEquipped["1"] and currentlyEquipped["11"] then
            if currentlyEquipped["11"].baseData.equipmentType == "sword" then
                weaponStateAppendment = "_dual"
            elseif currentlyEquipped["11"].baseData.equipmentType == "shield" then
                weaponStateAppendment = "AndShield"
            end
        end
    end


    return weaponStateAppendment
end

function item_manager.GetCurrentlyPlayingAnimation(animationNameToLookFor,weaponStateAppendment,characterEntityAnimationTracks,renderCharacter)
	local currentlyEquipped = item_manager.getCurrentlyEquippedForRenderCharacter(renderCharacter)
	local currentPlayingStateAnimation

	if weaponStateAppendment then
		if currentlyEquipped["1"] and currentlyEquipped["1"].baseData and currentlyEquipped["1"].baseData.equipmentType then
			local fullAnimationName = animationNameToLookFor.."_"..currentlyEquipped["1"].baseData.equipmentType..weaponStateAppendment

			currentPlayingStateAnimation =
				characterEntityAnimationTracks.movementAnimations[fullAnimationName] or
				characterEntityAnimationTracks.movementAnimations[animationNameToLookFor]
		else
			currentPlayingStateAnimation = characterEntityAnimationTracks.movementAnimations[animationNameToLookFor]
		end
	else
		currentPlayingStateAnimation = characterEntityAnimationTracks.movementAnimations[animationNameToLookFor]
	end

	return currentPlayingStateAnimation
end

function item_manager.RefreshStateAnimation(entityManifest,renderEntityData,weaponType)
    local needStateChange

    if entityManifest.entityType.Value == "character" then
        local currentlyEquipped = item_manager.getCurrentlyEquippedForRenderCharacter(renderEntityData.entityContainer.entity)
        if currentlyEquipped["1"] then
            if weaponType == currentlyEquipped["1"].baseData.equipmentType then
                needStateChange = true
            end
        end
    end

    return needStateChange
end

function item_manager.EquipNewItem(appearanceData,renderCharacter,_entityManifest,entitiesBeingRendered,animationInterface,associatePlayer,client,assetFolder)
    local rightGrip, leftGrip, backMount, hipMount, neckMount =
	renderCharacter["RightHand"]:FindFirstChild("Grip"),
	renderCharacter["LeftHand"]:FindFirstChild("Grip"),
	renderCharacter["UpperTorso"]:FindFirstChild("BackMount"),
	renderCharacter["LowerTorso"]:FindFirstChild("HipMount"),
	renderCharacter["UpperTorso"]:FindFirstChild("BackMount")

    local currentlyEquipped = item_manager.getCurrentlyEquippedForRenderCharacter(renderCharacter)

	for i, equipmentData in pairs(appearanceData.equipment) do

		if not isCurrentlyEquipped(currentlyEquipped, equipmentData) then
			if equipmentData.position == mapping.equipmentPosition.weapon or equipmentData.position == mapping.equipmentPosition["offhand"] then
				local weaponBaseData = itemDataLookup[equipmentData.id]
				local weaponVisualFolder = itemLookup[weaponBaseData.module.Name]


				if weaponBaseData and (weaponVisualFolder:FindFirstChild("manifest") or weaponVisualFolder:FindFirstChild("container")) then
					local weaponManifest
					local dye 							= equipmentData.dye
					local weaponGripType 				= weaponBaseData.gripType or 1
					local gripContainerOverrideCFrame 	= nil

					-- secondary weapons always left gripped
					if equipmentData.position == mapping.equipmentPosition["offhand"] then
						weaponGripType = mapping.gripType.left
					end

					local container = weaponVisualFolder:FindFirstChild("container")
					if container then
						container = container:FindFirstChild("RightHand") or container:FindFirstChild("LeftHand")
						container = container:Clone()

						local weaponToCopy = container:FindFirstChild("manifest") or container.PrimaryPart

						if weaponToCopy:IsA("BasePart") then
							for i,v in pairs(container:GetChildren()) do
								if v ~= weaponToCopy then
									v.Parent = weaponToCopy
									if v:IsA("BasePart") then
										if dye then
											v.Color =  Color3.new(v.Color.r * dye.r/255, v.Color.g * dye.g/255, v.Color.b * dye.b/255)
										end
									end
								end
							end

							if dye then
								-- yes im that lazy
								local v = weaponToCopy
								weaponToCopy.Color =  Color3.new(v.Color.r * dye.r/255, v.Color.g * dye.g/255, v.Color.b * dye.b/255)
							end

							weaponManifest = weaponToCopy
							gripContainerOverrideCFrame = weaponToCopy.CFrame:toObjectSpace(weaponManifest.Parent.CFrame)

						elseif weaponToCopy:IsA("Model") then
							-- render bow

							for i,v in pairs(weaponToCopy:GetDescendants()) do
								if v:IsA("BasePart") then
									if dye then
										v.Color = Color3.new(v.Color.r * dye.r/255, v.Color.g * dye.g/255, v.Color.b * dye.b/255)
									end
								end
							end

							weaponManifest 				= weaponToCopy
							gripContainerOverrideCFrame = weaponToCopy.PrimaryPart.CFrame:toObjectSpace(container.CFrame)
						end
					elseif weaponVisualFolder:FindFirstChild("manifest") then
						weaponManifest = weaponVisualFolder.manifest:Clone()
						if dye then
							-- yes im that lazy
							local v = weaponManifest
							weaponManifest.Color =  Color3.new(v.Color.r * dye.r/255, v.Color.g * dye.g/255, v.Color.b * dye.b/255)
						end
					end

					weaponManifest.Name 		= "EQUIPMENT_" .. weaponBaseData.id .. "_" .. equipmentData.position
					weaponManifest.Parent 		= renderCharacter

					if weaponManifest:IsA("BasePart") then
						weaponManifest.Anchored 	= false
						weaponManifest.CanCollide 	= false
					elseif weaponManifest:IsA("Model") then
						for i, obj in pairs(weaponManifest:GetChildren()) do
							if obj:IsA("BasePart") then
								obj.Anchored 	= false
								obj.CanCollide 	= false
							end
						end
					end

					if container then
						container:Destroy()
						container = nil
					end

					-- todo: very important
					-- only do this for the primary weapon
					local isMainHand = equipmentData.position == mapping.equipmentPosition.weapon
					if _entityManifest and isMainHand then
						local renderEntityData = entitiesBeingRendered[_entityManifest]

						renderEntityData.currentPlayerWeapon 	= weaponManifest
						renderEntityData.weaponBaseData 		= weaponBaseData

						if weaponBaseData.equipmentType == "bow" then
							if weaponManifest:FindFirstChild("AnimationController") then
								local bowTool_Animations = animationInterface:registerAnimationsForAnimationController(weaponManifest.AnimationController, "bowToolAnimations_noChar").bowToolAnimations_noChar

								renderEntityData.currentPlayerWeaponAnimations = bowTool_Animations
							else
								renderEntityData.currentPlayerWeaponAnimations = nil
							end
						else
							renderEntityData.currentPlayerWeaponAnimations = nil
						end

						if associatePlayer == client then
							network:fire("myClientCharacterWeaponChanged", weaponManifest)
						end
					end

					-- attach weaponManifest
					local isOffhand = equipmentData.position == mapping.equipmentPosition["offhand"]
					local backMounted, hipMounted, neckMounted = false, false, false

					if isOffhand then
						local t = weaponBaseData.equipmentType

						if t == "sword" or t == "shield" then
							-- do nothing

						elseif t == "dagger" then
							hipMounted = true

						elseif t == "amulet" then
							neckMounted = true

						else
							backMounted = true
						end
					end

					local gripCFrame = gripContainerOverrideCFrame or weaponBaseData.gripCFrame or weaponBaseData.attachmentOffset or CFrame.new()
					gripCFrame = gripCFrame - gripCFrame.Position

					if backMounted then
						backMount.Part1 = weaponManifest:IsA("Model") and weaponManifest.PrimaryPart or weaponManifest
						backMount.C0 = CFrame.new(-0.25, 0.25, 0.75) * CFrame.Angles(math.pi / 2, math.pi * 0.75, math.pi / 2)
						backMount.C1 = gripCFrame
					elseif hipMounted then
						hipMount.Part1 = weaponManifest:IsA("Model") and weaponManifest.PrimaryPart or weaponManifest
						hipMount.C0 = CFrame.new(-1, 0, 0) * CFrame.Angles(math.pi * 0.25, 0, 0)
						hipMount.C1 = gripCFrame
					elseif neckMounted then
						neckMount.Part1 = weaponManifest:IsA("Model") and weaponManifest.PrimaryPart or weaponManifest
						neckMount.C0 = CFrame.new(0, 0.75, 0)
						neckMount.C1 = gripCFrame
					else
						local gripToAttachTo = weaponGripType == mapping.gripType.right and rightGrip or leftGrip

						gripToAttachTo.Part1 	= weaponManifest:IsA("Model") and weaponManifest.PrimaryPart or weaponManifest
						gripToAttachTo.C0 		= CFrame.new()
						gripToAttachTo.C1 		= gripContainerOverrideCFrame or weaponBaseData.gripCFrame or weaponBaseData.attachmentOffset or CFrame.new()

						if weaponManifest:IsA("BasePart") then
							if weaponBaseData.equipmentType == "dagger" or weaponBaseData.equipmentType == "sword" or weaponBaseData.equipmentType == "staff" or weaponBaseData.equipmentType == "greatsword" then
								if not weaponManifest:FindFirstChild("topAttachment") then
									local topAttachment 	= Instance.new("Attachment", gripToAttachTo.Part1)
									topAttachment.Name 		= "topAttachment"

									local part = gripToAttachTo.Part1
									local size = part.Size
									local points = {
										Vector3.new(size.X / 2, 0, 0),
										Vector3.new(0, size.Y / 2, 0),
										Vector3.new(0, 0, size.Z / 2),
										Vector3.new(-size.X / 2, 0, 0),
										Vector3.new(0, -size.Y / 2, 0),
										Vector3.new(0, 0, -size.Z / 2)
									}

									local gripPoint = (gripToAttachTo.C1 * gripToAttachTo.C0:Inverse()).Position

									local bestPoint = nil
									local bestDistance = 0
									for _, point in pairs(points) do
										local distance = (point - gripPoint).Magnitude
										if distance > bestDistance then
											bestPoint = point
											bestDistance = distance
										end
									end

									topAttachment.Position = bestPoint

								end

								if not weaponManifest:FindFirstChild("bottomAttachment") then
									local projectionPosition 	= detection.projection_Box(gripToAttachTo.Part1.CFrame, gripToAttachTo.Part1.Size, gripToAttachTo.Part0.CFrame.p)
									local bottomAttachment 		= Instance.new("Attachment", gripToAttachTo.Part1)
									bottomAttachment.Name 		= "bottomAttachment"

									bottomAttachment.Position 	= gripToAttachTo.Part1.CFrame:pointToObjectSpace(projectionPosition)
								end

								if not weaponManifest:FindFirstChild("Trail") then
									local trail 		= assetFolder.Trail:Clone()
									trail.Parent 		= gripToAttachTo.Part1
									trail.Attachment0 	= gripToAttachTo.Part1.topAttachment
									trail.Attachment1 	= gripToAttachTo.Part1.bottomAttachment
									trail.Enabled 		= false
								end
							end
						end
					end
				end
			end
		end
	end
end

function item_manager.IterateThroughItems(renderCharacter,appearanceData)
    local rightGrip, leftGrip, backMount, hipMount, neckMount =
	renderCharacter["RightHand"]:FindFirstChild("Grip"),
	renderCharacter["LeftHand"]:FindFirstChild("Grip"),
	renderCharacter["UpperTorso"]:FindFirstChild("BackMount"),
	renderCharacter["LowerTorso"]:FindFirstChild("HipMount"),
	renderCharacter["UpperTorso"]:FindFirstChild("BackMount")

    local currentlyEquipped = item_manager.getCurrentlyEquippedForRenderCharacter(renderCharacter)
	for equipmentPosition, equipmentContainerData in pairs(currentlyEquipped) do
		local isStillEquipped = false

		for i, equipmentSlotData in pairs(appearanceData.equipment) do
			if isCurrentlyEquipped(currentlyEquipped, equipmentSlotData) then
				isStillEquipped = true
			end
		end

		if not isStillEquipped then
			if rightGrip.Part1 == equipmentContainerData.manifest then
				rightGrip.Part1 = nil
			elseif leftGrip.Part1 == equipmentContainerData.manifest then
				leftGrip.Part1 = nil
			elseif hipMount.Part1 == equipmentContainerData.manifest then
				hipMount.Part1 = nil
			elseif backMount.Part1 == equipmentContainerData.manifest then
                backMount.Part1 = nil
            elseif neckMount.Part1 == equipmentContainerData.manifest then
                neckMount.Part1 = nil
			end

			currentlyEquipped[tostring(equipmentPosition)] = nil
			equipmentContainerData.manifest:Destroy()
		end
	end
end

function item_manager.iterateThroughappearanceData(appearanceData,renderCharacter,bow_manager,hatEquipmentData,inventoryCountLookup)
    for _, equipmentSlotData in pairs(appearanceData.equipment) do
        if equipmentSlotData.position == mapping.equipmentPosition.upper or equipmentSlotData.position == mapping.equipmentPosition.lower or equipmentSlotData.position == mapping.equipmentPosition.head then

            local dye = equipmentSlotData.dye

            if equipmentSlotData.position == mapping.equipmentPosition.head then
                hatEquipmentData = equipmentSlotData
            end
			local equipmentData = itemDataLookup[equipmentSlotData.id]
			local equipmentFolder = itemLookup[equipmentData.module.Name]
            if equipmentFolder:FindFirstChild("container") then
                for _, accessoryPartContainer in pairs(equipmentFolder.container:GetChildren()) do
                    if renderCharacter:FindFirstChild(accessoryPartContainer.Name) then

                        if accessoryPartContainer:FindFirstChild("colorOverride") then
                            renderCharacter[accessoryPartContainer.Name].Color = accessoryPartContainer.Color
                        end

                        for _, accessoryPart in pairs(accessoryPartContainer:GetChildren()) do
                            if accessoryPart:IsA("BasePart") then
                                local accessory = accessoryPart:Clone()
                                    accessory.Anchored 		= false
                                    accessory.CanCollide 	= false

                                if dye then
                                    local v = accessory
                                    accessory.Color =  Color3.new(v.Color.r * dye.r/255, v.Color.g * dye.g/255, v.Color.b * dye.b/255)
                                end

                                local projectionWeld = Instance.new("Motor6D", accessory)
                                    projectionWeld.Name 	= "projectionWeld"
                                    projectionWeld.Part0 	= accessory
                                    projectionWeld.Part1 	= renderCharacter[accessoryPartContainer.Name]
                                    projectionWeld.C0 		= CFrame.new()
                                    projectionWeld.C1 		= accessoryPartContainer.CFrame:toObjectSpace(accessoryPart.CFrame)

                                accessory.Name 		= "!! EQUIPMENT !!"
                                accessory.Parent 	= renderCharacter
                            end
                        end
                    end
                end
            end
        elseif equipmentSlotData.position == mapping.equipmentPosition.arrow then
            local isBowEquipped = false do
                for i, equip in pairs(appearanceData.equipment) do
                    if equip.position == mapping.equipmentPosition.weapon then
                        if itemDataLookup[equip.id].equipmentType == "bow" then
                            isBowEquipped = true
                        end
                    end
                end
            end

            if isBowEquipped then
                bow_manager.int__updateRenderCharacter(renderCharacter,inventoryCountLookup,equipmentSlotData,configuration,itemLookup)
            end
        end
    end
end

function item_manager.createNetworkConnections(client,entitiesBeingRendered)
    network:create("getCurrentlyEquippedForRenderCharacter", "BindableFunction", "OnInvoke", function(renderCharacter)
		return item_manager.getCurrentlyEquippedForRenderCharacter(renderCharacter)
    end)

    network:create("getCurrentWeaponManifest", "BindableFunction", "OnInvoke", function(entityManifest)
		entityManifest = entityManifest or (client.Character and client.Character.PrimaryPart)

		if entityManifest and entitiesBeingRendered[entityManifest] then
			local currentlyEquipped = item_manager.getCurrentlyEquippedForRenderCharacter(entitiesBeingRendered[entityManifest].entityContainer.entity)

			return currentlyEquipped["1"] and currentlyEquipped["1"].manifest
		end
    end)

    network:create("getRenderPlayerWeaponManifestEquipped", "BindableFunction", "OnInvoke", function(player)
		local entityManifest = player.Character and player.Character.PrimaryPart

		if entityManifest and entitiesBeingRendered[entityManifest] then
			local currentlyEquipped = item_manager.getCurrentlyEquippedForRenderCharacter(entitiesBeingRendered[entityManifest].entityContainer.entity)

			return currentlyEquipped["1"] and currentlyEquipped["1"].manifest
		end
    end)

    network:create("hideWeapons", "BindableFunction", "OnInvoke", function(entity)
		local equipment = item_manager.getCurrentlyEquippedForRenderCharacter(entity)
		local partData = {}

		local checks = {
			equipment["1"] and equipment["1"].manifest,
			equipment["11"] and equipment["11"].manifest
		}

		local function hidePart(part)
			table.insert(partData, {part = part, transparency = part.Transparency})
			part.Transparency = 1
		end

		for _, check in pairs(checks) do
			if check:IsA("BasePart") then
				hidePart(check)
			end

			for _, desc in pairs(check:GetDescendants()) do
				if desc:IsA("BasePart") then
					hidePart(desc)
				end
			end
		end

		return function()
			for _, partDatum in pairs(partData) do
				partDatum.part.Transparency = partDatum.transparency
			end
		end
    end)


end

return item_manager