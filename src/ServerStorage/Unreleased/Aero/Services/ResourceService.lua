-- Resource Service
-- Rocky28447 (for Vesteria)
-- May 28, 2020

--[[
	
	Manages resource harvesting server-side.
	
	Internally tracks how many harvests each player 
	has left on each resource node.
	
	
	Server:
		
		ResourceService:HarvestResource(player, node)
		ResourceService:ResourceDepleted(player, node)
		ResourceService:ResourceReplenished(player, node)
	


	Client:
		
	
		ResourceService.HarvestResource()
		ResourceService.ResourceDepleted()
		ResourceService.ResourceReplenished()

--]]



local ResourceService = {Client = {}}
local GameServices
local InventoryService
local PlaceSetup
local TableUtil
local Thread

local HARVEST_RESOURCE_CLIENT_EVENT = "HarvestResource"
local RESOURCE_DEPLETED_CLIENT_EVENT = "ResourceDepleted"
local RESOURCE_REPLENISHED_CLIENT_EVENT = "ResourceReplenished"

local NODES_FOLDER

local resources = {}
local playerHarvestData = {}



local function SetupHarvestDataForPlayer(player)
	local p = {}
	playerHarvestData[player] = p
	return p
end


local function SetupNodeHarvestDataForPlayer(player, node)
	local n = {}
	n.HarvestsLeft = node.Metadata.Harvests.Value
	n.DropPoints = node.Metadata.DropPoints:GetChildren()
	playerHarvestData[player][node] = n
	return n
end


local function SumWeights(weights)
	local s = 0
	for _, weight in pairs (weights) do
		s = s + weight.Value
	end
	return s
end


local function RollDropTable(dropTable)
	local rng = Random.new()
	local roll = rng:NextNumber(0, 1)
	local remainingDistance = SumWeights(dropTable) * roll
	
	-- https://blog.bruce-hill.com/a-faster-weighted-random-choice
	-- "Linear Scan" (since we probably aren't gonna be sorting through too many items)
	
	-- This implementation means that in a drop table with 1 item, the chance can be any
	-- positive non-zero number and it will still be picked 100% of the time.
	for _, weight in pairs (dropTable) do
		remainingDistance = remainingDistance - weight.Value
		if remainingDistance < 0 then
			return weight.Item
		end
	end
end


function ResourceService:ResourceNodeDepleted(player, node)
	local harvestData = playerHarvestData[player]
	local nodeHarvestData = harvestData[node]
	local nodeMetadata = node.Metadata
	
	if (nodeMetadata.Replenish.Value) then
		Thread.Delay(nodeMetadata.Replenish.Time.Value, self.ResourceNodeReplenished, self, player, node)
	end
	
	self:FireClient(RESOURCE_DEPLETED_CLIENT_EVENT, player, node)
end


function ResourceService:ResourceNodeReplenished(player, node)
	local harvestData = playerHarvestData[player]
	local nodeHarvestData = harvestData[node]
	local nodeMetadata = node.Metadata
	
	nodeHarvestData.HarvestsLeft = nodeMetadata.Harvests.Value
	nodeHarvestData.DropPoints = nodeMetadata.DropPoints:GetChildren()
	
	self:FireClient(RESOURCE_REPLENISHED_CLIENT_EVENT, player, node)
end


function ResourceService:HarvestResource(player, node)
	local char = player.Character
	
	if char then		
		if typeof(node) == "Instance" then
			if node:IsA("Folder") and node.Parent.Parent == NODES_FOLDER then
				local nodePosition = node.Model:GetBoundingBox().Position
				local charPosition = char:GetPrimaryPartCFrame().Position
				local distance = (nodePosition - charPosition).Magnitude
				
				if distance < node.Model:GetExtentsSize().Magnitude * 1.25 then
					local harvestData = playerHarvestData[player] or SetupHarvestDataForPlayer(player)
					local nodeHarvestData = harvestData[node] or SetupNodeHarvestDataForPlayer(player, node)
					local harvestsLeft = nodeHarvestData.HarvestsLeft
					
					if harvestsLeft > 0 then
						local rng = Random.new()
						local nodeMetadata = node.Metadata
						local itemDrop = RollDropTable(nodeMetadata.Drops:GetChildren())
						local amountToGive = rng:NextInteger(itemDrop.Min.Value, itemDrop.Max.Value)
						
						-- Contingency: If harvest > num drop points we will run out of drop points
						-- If this happens, item will drop on node's primary part position
						local dropPointNum = rng:NextInteger(1, #nodeHarvestData.DropPoints)
						local dropPoint = nodeHarvestData.DropPoints[dropPointNum]
						local dropPosition = dropPoint and dropPoint.Value.DropAttachment.WorldPosition or
											 node.Model.PrimaryPart.Position + Vector3.new(0, node.Model.PrimaryPart.Size.Y / 2 + 0.1, 0)
						
						local velocity = dropPoint and (CFrame.new(Vector3.new(node.Model.PrimaryPart.Position.X, 0, node.Model.PrimaryPart.Position.Z), Vector3.new(dropPosition.X, 0, dropPosition.Z)) * CFrame.Angles(math.rad(45), 0, 0)).LookVector * 32 or
										 (CFrame.new(0, math.pi * 2 * math.random(), 0) * CFrame.new(-math.pi / 4, 0, 0)).LookVector * 32
						local item = InventoryService:SpawnItemOnGround(
							{id = itemDrop.Value},
							dropPosition,
							{player}
						)
						
						item.Velocity = (CFrame.new(0, math.pi * 2 * math.random(), 0) * CFrame.new(-math.pi / 4, 0, 0)).LookVector * 32
						TableUtil.FastRemove(nodeHarvestData.DropPoints, dropPointNum)
						harvestsLeft = harvestsLeft - 1
						nodeHarvestData.HarvestsLeft = harvestsLeft
						
						if harvestsLeft == 0 then
							self:ResourceNodeDepleted(player, node)
						end
						
						return dropPoint and dropPoint.Value or nil
					end
				end
			end
		end
	end
end


function ResourceService:Start()
	
	NODES_FOLDER = PlaceSetup:GetPlaceFolder("ResourceNodes")
	
	self:ConnectClientEvent(HARVEST_RESOURCE_CLIENT_EVENT, function(player, node)
		self:HarvestResource(player, node)
	end)
	
end


function ResourceService:Init()
	
	GameServices = self.Modules.GameServices
	InventoryService = self.Services.InventoryService
	PlaceSetup = self.Shared.PlaceSetup
	TableUtil = self.Shared.TableUtil
	Thread = self.Shared.Thread
	
	self:RegisterClientEvent(HARVEST_RESOURCE_CLIENT_EVENT)
	self:RegisterClientEvent(RESOURCE_DEPLETED_CLIENT_EVENT)
	self:RegisterClientEvent(RESOURCE_REPLENISHED_CLIENT_EVENT)
	
end


return ResourceService