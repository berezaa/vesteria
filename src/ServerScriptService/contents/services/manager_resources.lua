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
				HarvestsLeft = 6
			}
		}
	}

]]--



local ResourceManager = {Client = {}}

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SharedModules
local Network
local PlaceSetup
local Thread
local TableUtil

local HARVEST_RESOURCE_CLIENT_EVENT = "HarvestResource"
local RESOURCE_HARVESTED_CLIENT_EVENT = "ResourceHarvested"
local RESOURCE_DEPLETED_CLIENT_EVENT = "ResourceDepleted"
local RESOURCE_REPLENISHED_CLIENT_EVENT = "ResourceReplenished"

local nodesFolder

local resources = {}
local globalResourceNodeData = {}
local localResourceNodeData = {}



local function SetupBaseNodeDataForPlayer(player)
	local p = {}	
	localResourceNodeData[player] = p
	return p
end


local function NewNodeData(node)
	local n = {}
	local nodeMetadata = require(node.Parent.Parent.Parent.Metadata)
	local dropPoints = node:FindFirstChild("DropPoints")
	
	n.HarvestsLeft = nodeMetadata.Harvests
	n.Durability = nodeMetadata.Durability
	n.DropPoints = dropPoints and dropPoints:GetChildren() or {}
	return n
end


local function GetNodeDataForPlayer(node, player)		
	if localResourceNodeData[player] and localResourceNodeData[player][node] then
		return localResourceNodeData[player][node]
	end
	
	local n = NewNodeData(node)
	if not localResourceNodeData[player] then
		SetupBaseNodeDataForPlayer(player)[node] = n
	else
		localResourceNodeData[player][node] = n
	end
	
	return n
end


local function GetGlobalDataForNode(node)
	if globalResourceNodeData[node] then
		return globalResourceNodeData[node]
	end
	
	local n = NewNodeData(node)
	globalResourceNodeData[node] = n
	return n
end


local function SumLootTableWeights(lootTable)
	local s = 0
	for _, item in pairs (lootTable) do
		s = s + item.Chance
	end
	return s
end


local function RollLootTable(lootTable)
	local rng = Random.new()
	local roll = rng:NextNumber(0, 1)
	local remainingDistance = SumLootTableWeights(lootTable) * roll
	
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


local function ResourceNodeReplenished(node, player)
	local nodeMetadata = require(node.Parent.Parent.Parent.Metadata)
	local isNodeGlobal = nodeMetadata.IsGlobal
	local nodeData = isNodeGlobal and GetGlobalDataForNode(node) or GetNodeDataForPlayer(node, player)
	local dropPoints = node:FindFirstChild("DropPoints")
	
	nodeData.HarvestsLeft = nodeMetadata.Harvests
	nodeData.DropPoints = dropPoints and dropPoints:GetChildren() or {}
	
	if isNodeGlobal then
		if nodeMetadata.DestroyOnDeplete then
			for _, c in pairs (node:GetDescendants()) do
				if c:IsA("BasePart") then
					c.CanCollide = true
					c.Transparency = 0
				end
			end
		end
		CollectionService:AddTag(node.PrimaryPart, "attackable")
		Network:fireAllClients(RESOURCE_REPLENISHED_CLIENT_EVENT, node)
	else
		Network:fireClient(RESOURCE_REPLENISHED_CLIENT_EVENT, player, node)
	end
end


local function ResourceNodeDepleted(node, player)
	local nodeMetadata = require(node.Parent.Parent.Parent.Metadata)
	local isGlobal = nodeMetadata.IsGlobal
	local nodeData = isGlobal and GetGlobalDataForNode(node) or GetNodeDataForPlayer(node, player)
	
	if nodeMetadata.Replenish ~= 0 then
		Thread.Delay(nodeMetadata.Replenish, ResourceNodeReplenished, node, player)
	end
	
	if isGlobal then
		-- Disable node collision on server BEFORE spawning items otherwise items
		-- will get stuck and will not "fling" away from the node. Nodes that
		-- have exterior drop points WILL NOT have this problem.
		if nodeMetadata.DestroyOnDeplete then
			for _, c in pairs (node:GetDescendants()) do
				if c:IsA("BasePart") then
					c.CanCollide = false
					c.Transparency = 1
				end
			end
		end
		CollectionService:RemoveTag(node.PrimaryPart, "attackable")
		Network:fireAllClients(RESOURCE_DEPLETED_CLIENT_EVENT, node)
	else
		Network:fireClient(RESOURCE_DEPLETED_CLIENT_EVENT, player, node)
	end
	
	if nodeMetadata.Animations.OnDeplete then
		nodeMetadata.Animations.OnDeplete()
	end
end

-- this should really be a function of item manager
local function ApplyVelocityToItem(item, velocity)
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


function ResourceManager:HarvestResource(node, player)
	local char = player.Character
	
	if char then		
		if typeof(node) == "Instance" then
			if node:IsA("Model") and node.Parent.Name == "Nodes" and node:IsDescendantOf(nodesFolder) then
				local nodePosition = node:GetBoundingBox().Position
				local charPosition = char:GetPrimaryPartCFrame().Position
				local distance = (nodePosition - charPosition).Magnitude
				
				if distance < node:GetExtentsSize().Magnitude * 1.25 then
					local nodeMetadata = require(node.Parent.Parent.Parent.Metadata)
					local isNodeGlobal = nodeMetadata.IsGlobal
					local numDrops = nodeMetadata.LootTable.Drops
					
					local nodeData = isNodeGlobal and GetGlobalDataForNode(node) or GetNodeDataForPlayer(node, player)		
					local harvestsLeft = nodeData.HarvestsLeft
					local durability = nodeData.Durability
					
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
							nodeData.HarvestsLeft = harvestsLeft
							nodeData.Durability = nodeMetadata.Durability
							
							if isNodeGlobal then
								Network:fireAllClients(RESOURCE_HARVESTED_CLIENT_EVENT, node, dropPoint and dropPoint.Value or nil)
							else
								Network:fireClient(RESOURCE_HARVESTED_CLIENT_EVENT, player, node, dropPoint and dropPoint.Value or nil)
							end
							
							if harvestsLeft == 0 then
								ResourceNodeDepleted(node, player)
							end
							
							for i = 1, numDrops do
								local itemDrop = RollLootTable(nodeMetadata.LootTable.Items)
								local numToDrop = itemDrop:Amount()
								
								for i = 1, numToDrop do
									local itemModifiers = itemDrop:Modifiers()
									local velocity = dropPoint and CFrame.new(Vector3.new(node.PrimaryPart.Position.X, 0, node.PrimaryPart.Position.Z), Vector3.new(dropPosition.X, 5, dropPosition.Z)).LookVector * 32 or
													 CFrame.new(Vector3.new(0, 0, 0), Vector3.new(rng:NextNumber(-1, 1), 2, rng:NextNumber(-1, 1))).LookVector * 32
									
									itemModifiers.id = itemDrop.ID
									
									local item = Network:invoke(
										"spawnItemOnGround",
										itemModifiers,
										dropPosition,
										not isNodeGlobal and {player} or {}
									)
									
									ApplyVelocityToItem(item, velocity)
								end
							end
								
							return dropPoint and dropPoint.Value or nil
						else
							if isNodeGlobal then
								Network:fireAllClients(RESOURCE_HARVESTED_CLIENT_EVENT, node)
							else
								Network:fireClient(RESOURCE_HARVESTED_CLIENT_EVENT, player, node)
							end
							nodeData.Durability = durability - 1
						end
					end
				end
			end
		end
	end
end


function ResourceManager:Start()
	
	
	
end


function ResourceManager:Init()
	
	SharedModules = require(ReplicatedStorage.modules)
	Network = SharedModules.load("network")
	PlaceSetup = SharedModules.load("placeSetup")
	Thread = SharedModules.load("Thread")
	TableUtil = SharedModules.load("TableUtil")
	
	nodesFolder = PlaceSetup.getPlaceFolder("resourceNodes")
	
	Network:create(HARVEST_RESOURCE_CLIENT_EVENT, "RemoteFunction", "OnServerInvoke", function(player, node)
		return self:HarvestResource(node, player)
	end)
	
	Network:create(RESOURCE_HARVESTED_CLIENT_EVENT, "RemoteEvent")
	Network:create(RESOURCE_DEPLETED_CLIENT_EVENT, "RemoteEvent")
	Network:create(RESOURCE_REPLENISHED_CLIENT_EVENT, "RemoteEvent")
	
end


ResourceManager:Init()
ResourceManager:Start()

return ResourceManager