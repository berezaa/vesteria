local collectionService = game:GetService("CollectionService")
--
local modules = require(game.ReplicatedStorage.modules)
local network = modules.load("network")

local assetsFolder = game.ReplicatedStorage:WaitForChild("assets")

local placeIdList do
	-- main game
	if game.GameId == 833209132 then
		placeIdList = {
			2119298605, -- nilgarf
		}

	-- free to play
	elseif game.GameId == 712031239 then
		placeIdList = {
			4787415375, -- crabby den
			4042431927, -- enchanted forest
			4041618739, -- great crossroads
			4042399045, -- lost corridor
			4041616995, -- mushroom forest
			4041642879, -- mushroom grotto
			4041449372, -- mushtown
			4042577479, -- nilgarf
			4042595899, -- nilgarf sewers
			4042356215, -- port fidelio
			4042533453, -- redwood pass
			4042327457, -- scallop shores
			4784800626, -- seaside path
			4787417227, -- shiprock bottom
			4786263828, -- spider queen's lair
			4784798551, -- the clearing
			4042381342, -- colosseum
			4042493740, -- tree of life
			4042553675, -- warrior stronghold
		}
	end
end

local orbSpawn do
	local orbSpawnParts = collectionService:GetTagged("orbSpawn")
	assert(#orbSpawnParts == 1, "There must be only one part in the game tagged \"orbSpawn\"")

	orbSpawn = Instance.new("Vector3Value")
	orbSpawn.Name = "orbSpawn"
	orbSpawn.Value = orbSpawnParts[1].Position
	orbSpawn.Parent = game:GetService("ReplicatedStorage")

	orbSpawnParts[1]:Destroy()
end

local orb = assetsFolder.entities.orb
local checkForOrbSpawn = true

local function onPlayerAdded(player)
	if orb.Parent == workspace then
		network:fireClient("effects_requestEffect", player, "orbAnnoucement")
	end
end
game.Players.PlayerAdded:Connect(onPlayerAdded)

local function spawnOrb()
	orb:SetPrimaryPartCFrame(CFrame.new(orbSpawn.Value))
	orb.Parent = workspace
	orb.PrimaryPart.loop:Play()
	network:fireAllClients("effects_requestEffect", "orbArrival", {orb = orb})
end

local function despawnOrb()
	network:fireAllClients("effects_requestEffect", "orbDeparture", {orb = orb})
	delay(5, function()
		orb.Parent = script
	end)
end

local function getCurrentDay()
	local vesterianDay = game:GetService("ReplicatedStorage"):FindFirstChild("vesterianDay")
	if not vesterianDay then
		return 0
	end

	return math.floor(vesterianDay.Value + 0.5)
end

local function update()
	local clockTime = game.Lighting.ClockTime
	local isNight = (clockTime < 5.9) or (clockTime > 18.6) -- keep synchronized with day night cycle

	if isNight then
		if checkForOrbSpawn then
			checkForOrbSpawn = false

			local day = getCurrentDay()
			local rand = Random.new(day)

			local placeId = placeIdList[rand:NextInteger(1, #placeIdList)]
			if game.PlaceId == placeId then
				spawnOrb()
			end

			print("manager_orb chose "..placeId.." as the spawn location. This place is "..game.PlaceId..".")
		end
	else
		if not checkForOrbSpawn then
			checkForOrbSpawn = true

			if orb.Parent ~= script then
				despawnOrb()
			end
		end
	end
end

local function startUpdating()
	while true do
		update()
		wait(1)
	end
end

spawn(startUpdating)
spawn(function()
	if game.PlaceId == 2061558182 then
		spawnOrb()
		wait(30)
		despawnOrb()
	end
end)

local function playerRequest_enchantAbility(player, orb, requestData)
	local playerData = playerDataContainer[player]
	if playerData then
		if typeof(orb) == "Instance" and orb:FindFirstChild("itemEnchanted") and orb:IsDescendantOf(workspace) then
			if player.Character and player.Character.PrimaryPart and (player.Character.PrimaryPart.Position - orb.Position).magnitude <= 100 then
				local abilitySlotData
				for i, abilityData in pairs(playerData.abilities) do
					if abilityData.id == requestData.id then
						abilitySlotData = abilityData
						break
					end
				end

				local abilityBaseData = abilityLookup[abilitySlotData.id](playerData)
				if abilitySlotData and abilityBaseData then
					local metadata = abilityBaseData.metadata
					if metadata then
						local AP = playerData.level - 1
						local availablePoints = AP - getPlayerDataSpentAP(playerData)
						if requestData.request == "upgrade" then
							if metadata.upgradeCost and metadata.maxRank and availablePoints >= metadata.upgradeCost then
								if abilitySlotData.rank > 0 and abilitySlotData.rank < metadata.maxRank then
									abilitySlotData.rank = abilitySlotData.rank + 1
									playerData.nonSerializeData.playerDataChanged:Fire("abilities")
									orb.itemEnchanted:Play()
									if orb:FindFirstChild("steady") then
										orb.steady:Emit(50)
									end

									return true, "upgrade applied"
								end
							end
						elseif requestData.request == "variant" then
							if abilitySlotData.variant == nil or metadata.variants[abilitySlotData.variant].default then
								local variantData = metadata.variants[requestData.variant]
								if variantData and variantData.cost and availablePoints >= variantData.cost then
									if variantData.requirement and variantData.requirement(playerData) then
										abilitySlotData.variant = requestData.variant
										playerData.nonSerializeData.playerDataChanged:Fire("abilities")
										orb.itemEnchanted:Play()
										if orb:FindFirstChild("steady") then
											orb.steady:Emit(50)
										end

										return true, "variant applied"
									end
									return false, "requirements not fufilled"
								end
								return false, "not enough points"
							end
							return false, "ability already has variant"
						end
						return false, "invalid request"
					end
					return false, "unsupported ability"
				end
				return false, "no data for ability"
			end
			return false, "too far from orb"
		end
		return false, "invalid orb"
	end
end

network:create("playerRequest_enchantAbility", "RemoteFunction", "OnServerInvoke", playerRequest_enchantAbility)

return {}