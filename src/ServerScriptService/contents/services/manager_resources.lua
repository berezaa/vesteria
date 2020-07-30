-- Resource Manager
-- Rocky28447 (for Vesteria)
-- May 28, 2020


--[[

	Manages resource harvesting server-side.

	Internally tracks how many harvests each player
	has left on each resource node.	The structure
	looks like this:

	playerHarvestData = {
		[player] = {
			[exampleNodeInstance] = {
				harvestsLeft = 6
			}
		}
	}

]]--

local ResourceManager = {}

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Modules
local Thread
local TableUtil
local placeSetup
local network

local nodesFolder

local globalResourceNodeData = {}
local localResourceNodeData = {}



local function getNodeTypeMetadataFromNode(node)
	local containingFolder = node:FindFirstAncestorWhichIsA("Folder")
	local isNodeGroup = CollectionService:HasTag(containingFolder, "resourceNodeGroupFolder")
	local nodeTypeMetadata = isNodeGroup and containingFolder.Parent.Metadata or containingFolder.Metadata

	return nodeTypeMetadata
end

local function setupBaseNodeDataForPlayer(player)
	local p = {}
	localResourceNodeData[player] = p
	return p
end

local function newNodeData(node)
	local n = {}
	local nodeTypeMetadata = require(getNodeTypeMetadataFromNode(node))
	local dropPoints = node:FindFirstChild("DropPoints")

	n.owners = {}
	n.harvestsLeft = nodeTypeMetadata.Harvests
	-- n.durability = 0
	n.durability = nodeTypeMetadata.Durability
	n.DropPoints = dropPoints and dropPoints:GetChildren() or {}
	return n
end

local function getNodeDataForPlayer(node, player)
	if localResourceNodeData[player] and localResourceNodeData[player][node] then
		return localResourceNodeData[player][node]
	end

	local n = newNodeData(node)
	if not localResourceNodeData[player] then
		setupBaseNodeDataForPlayer(player)[node] = n
	else
		localResourceNodeData[player][node] = n
	end

	return n
end

local function getGlobalDataForNode(node)
	if globalResourceNodeData[node] then
		return globalResourceNodeData[node]
	end

	local n = newNodeData(node)
	globalResourceNodeData[node] = n
	return n
end

local function sumLootTableWeights(lootTable)
	local totalWeight = 0
	for _, item in pairs (lootTable) do
		totalWeight += item.Chance
	end
	return totalWeight
end

local function rollLootTable(lootTable)
	local rng = Random.new()
	local roll = rng:NextNumber(0, 1)
	local remainingDistance = sumLootTableWeights(lootTable) * roll

	-- https://blog.bruce-hill.com/a-faster-weighted-random-choice
	-- "Linear Scan" (since we probably aren't gonna be sorting through too many items)

	-- This implementation means that in a drop table with 1 item, the chance can be any
	-- positive non-zero number and it will still be picked 100% of the time.
	for _, item in pairs (lootTable) do
		remainingDistance = remainingDistance - item.Chance
		if remainingDistance < 0 then
			return item
		end
	end
end

local function calcDamageForNode(node, player)
	local nodeTypeMetadata = require(getNodeTypeMetadataFromNode(node))
	local playerData = network:invoke("getPlayerData", player)

	if nodeTypeMetadata.NodeCategory then
		return playerData.nonSerializeData.statistics_final[nodeTypeMetadata.NodeCategory]
	end

	return 1
end

local function getDepletedResourceNodes(player)
	local depleted = {}
	for node, data in pairs (globalResourceNodeData) do
		if data.Depleted then
			depleted[#depleted + 1] = node
		end
	end
	return depleted
end

local function calcNumHarvests(damage, node, nodeData)
	local nodeTypeMetadata = require(getNodeTypeMetadataFromNode(node))
	local maxdurability = nodeTypeMetadata.Durability
	local durability = nodeData.durability
	local harvestsLeft = nodeData.harvestsLeft
	local toHarvest = math.floor( (damage + durability) / maxdurability )

	if damage < durability then
		return 0, durability - damage
	elseif damage == durability then
		return 1, 0
	else
		return math.min(toHarvest, harvestsLeft), (damage + durability) % maxdurability
	end

	-- while damage >= maxdurability do
	-- 	damage -= maxdurability
	-- end

	-- 8 dmg, 3 max durability, 1 durability
	-- 5 dmg, 3 max dirability, 1 durability
	-- 2 dmg, 3 max dirability, 1 durability

	-- -7 durability
	-- math.abs( math.floor( (durability - damage) / maxdurability ) )
	-- i think that math is right???? maybe???

end

-- this should really be a function of item manager
local function applyVelocityToItem(item, velocity)
	local attachmentTarget

	if item:IsA("BasePart") then
		attachmentTarget = item
	elseif item:IsA("Model") and (item.PrimaryPart or item:FindFirstChild("HumanoidRootPart")) then
		local primaryPart = item.PrimaryPart or item:FindFirstChild("HumanoidRootPart")
		if primaryPart then
			attachmentTarget = primaryPart
		end
	end

	attachmentTarget.Velocity = velocity
end

local function resourceNodeReplenished(node, player)
	local nodeTypeMetadata = require(getNodeTypeMetadataFromNode(node))
	local isNodeGlobal = nodeTypeMetadata.IsGlobal
	local nodeData = isNodeGlobal and getGlobalDataForNode(node) or getNodeDataForPlayer(node, player)
	local dropPoints = node:FindFirstChild("DropPoints")

	nodeData.harvestsLeft = nodeTypeMetadata.Harvests
	-- nodeData.durability = 0
	nodeData.durability = nodeTypeMetadata.Durability
	nodeData.DropPoints = dropPoints and dropPoints:GetChildren() or {}
	nodeData.Depleted = false

	if isNodeGlobal then
		if nodeTypeMetadata.DestroyOnDeplete then
			for _, c in pairs (node:GetDescendants()) do
				if c:IsA("BasePart") then
					c.CanCollide = true
					c.Transparency = 0
				end
			end
		end
		CollectionService:AddTag(node.PrimaryPart, "attackable")
		network:fireAllClients("resourceReplenished", node)
	else
		network:fireClient("resourceReplenished", player, node)
	end
end

local function resourceNodeDepleted(node, player)
	local nodeTypeMetadata = require(getNodeTypeMetadataFromNode(node))
	local isGlobal = nodeTypeMetadata.IsGlobal
	local nodeData = isGlobal and getGlobalDataForNode(node) or getNodeDataForPlayer(node, player)

	if nodeTypeMetadata.Replenish ~= 0 then
		Thread.Delay(nodeTypeMetadata.Replenish, resourceNodeReplenished, node, player)
	end

	if isGlobal then
		-- Disable node collision on server BEFORE spawning items otherwise items
		-- will get stuck and will not "fling" away from the node. Nodes that
		-- have exterior drop points WILL NOT have this problem.
		if nodeTypeMetadata.DestroyOnDeplete then
			for _, c in pairs (node:GetDescendants()) do
				if c:IsA("BasePart") then
					c.CanCollide = false
					c.Transparency = 1
				end
			end
		end
		CollectionService:RemoveTag(node.PrimaryPart, "attackable")
		network:fireAllClients("resourceDepleted", node)
	else
		network:fireClient("resourceDepleted", player, node)
	end

	nodeData.Depleted = true

	if nodeTypeMetadata.Animations.OnDeplete then
		nodeTypeMetadata.Animations.OnDeplete()
	end
end

local function harvestResource(player, node)
	local playerManifest = player.Character and player.Character.PrimaryPart
	assert(playerManifest, "No character")

	if node:IsA("Model") and node:IsDescendantOf(nodesFolder) and node.Name ~= "Nodes" and node.Name ~= "Props" then
		local nodePosition = node:GetBoundingBox().Position
		local charPosition = playerManifest.Position
		local distance = (nodePosition - charPosition).Magnitude

		if distance < node:GetExtentsSize().Magnitude * 1.5 then
			local nodeTypeMetadata = require(getNodeTypeMetadataFromNode(node))
			local isNodeGlobal = nodeTypeMetadata.IsGlobal
			local numDrops = nodeTypeMetadata.LootTable.Drops

			local damage = calcDamageForNode(node, player)
			local nodeData = isNodeGlobal and getGlobalDataForNode(node) or getNodeDataForPlayer(node, player)
			local harvestsLeft = nodeData.harvestsLeft
			local durability = nodeData.durability

			durability = math.max(durability - damage, 0)
			nodeData.durability = durability

			if isNodeGlobal and not table.find(nodeData.owners, player) then
				table.insert(nodeData.owners, player)
			end

			if harvestsLeft > 0 then
				if durability == 0 then
					local rng = Random.new()

					-- Contingency: If harvest > num drop points we will run out of drop points
					-- If this happens, item will drop on node's primary part position
					local dropPointNum = rng:NextInteger(1, #nodeData.DropPoints)
					local dropPoint = nodeData.DropPoints[dropPointNum]
					local dropPosition = dropPoint and dropPoint.Value.DropAttachment.WorldPosition or
											node.PrimaryPart.Position + Vector3.new(0, node.PrimaryPart.Size.Y / 2 + 0.5, 0)

					TableUtil.FastRemove(nodeData.DropPoints, dropPointNum)
					harvestsLeft = harvestsLeft - 1
					nodeData.harvestsLeft = harvestsLeft
					nodeData.durability = nodeTypeMetadata.Durability

					if isNodeGlobal then
						if dropPoint then
							dropPoint.Value.Transparency = 1
							dropPoint.Value.CanCollide = false
						end
						network:fireAllClients("resourceHarvested", node, dropPoint and dropPoint.Value or nil)
					else
						network:fireClient("resourceHarvested", player, node, dropPoint and dropPoint.Value or nil)
					end

					if harvestsLeft == 0 then
						resourceNodeDepleted(node, player)
					end

					for _ = 1, numDrops do
						local itemDrop = rollLootTable(nodeTypeMetadata.LootTable.Items)
						local numToDrop = itemDrop:Amount()

						for _ = 1, numToDrop do
							local itemModifiers = itemDrop:Modifiers()
							local velocity = Vector3.new((rng:NextNumber() - 0.5) * 10, (2 + rng:NextNumber()) * 25, (rng:NextNumber() - 0.5) * 10)

							itemModifiers.id = itemDrop.ID
							local item = network:invoke("spawnItemOnGround",
								itemModifiers,
								dropPosition,
								isNodeGlobal and nodeData.owners or {player}
							)

							applyVelocityToItem(item, velocity)
						end
					end

					return dropPoint and dropPoint.Value or nil
				else
					if isNodeGlobal then
						network:fireAllClients("resourceHarvested", node)
					else
						network:fireClient("resourceHarvested", player, node)
					end
				end
			end
		end
	end


end


local function Init()

	Modules = require(ReplicatedStorage.modules)
	network = Modules.load("network")
	placeSetup = Modules.load("placeSetup")
	Thread = Modules.load("thread")
	TableUtil = Modules.load("tableUtil")

	nodesFolder = placeSetup.getPlaceFolder("resourceNodes")

	network:create("harvestResource", "RemoteFunction", "OnServerInvoke", harvestResource)

	network:create("getDepletedResourceNodes", "RemoteFunction", "OnServerInvoke", getDepletedResourceNodes)

	network:create("resourceHarvested", "RemoteEvent")
	network:create("resourceDepleted", "RemoteEvent")
	network:create("resourceReplenished", "RemoteEvent")

end

Init()

return ResourceManager