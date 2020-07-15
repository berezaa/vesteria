local module = {}
local physicsService = game:GetService("PhysicsService")

local valid = {}

-- returns a valid group id (int) or nil
function module:getCollisionGroup(name)
	local ok, groupId = pcall(physicsService.GetCollisionGroupId, physicsService, name)
	
	if not ok then
		-- Create may fail if we have hit the maximum of 32 different groups
		ok, groupId = pcall(physicsService.CreateCollisionGroup, physicsService, name)
	end
	
	if ok and not valid[name] then
		valid[name] = true
	end
	
	return ok and groupId or nil
end

function module:setWholeCollisionGroup(obj, name)
--	if valid[name] then
		if obj:IsA("BasePart") then
			physicsService:SetPartCollisionGroup(obj, name)
		end
		
		for i, v in pairs(obj:GetChildren()) do
			self:setWholeCollisionGroup(v, name)
		end
--	else
--		error("invalid collision group")
--	end
end

function module:removeWholeCollisionGroup(obj, name)
--	if valid[name] then
		if obj:IsA("BasePart") then
			physicsService:RemoveCollisionGroup(obj, name)
		end
		
		for i, v in pairs(obj:GetChildren()) do
			self:removeWholeCollisionGroup(v, name)
		end
--	else
--		error("invalid collision group")
--	end
end

local function main()
	
	if game:GetService("RunService"):IsClient() then
		return 
	end
	
	module:getCollisionGroup("passthrough")
	module:getCollisionGroup("items")
	module:getCollisionGroup("characters")
	module:getCollisionGroup("pvpCharacters")
	module:getCollisionGroup("monsters")
	module:getCollisionGroup("monstersLocal")
	module:getCollisionGroup("npcs")
	module:getCollisionGroup("antiJumpHitbox")
	module:getCollisionGroup("fishingSpots")
	
	physicsService:CollisionGroupSetCollidable("items", "items", false)
	physicsService:CollisionGroupSetCollidable("items", "characters", false)
	physicsService:CollisionGroupSetCollidable("items", "monsters", false)
	physicsService:CollisionGroupSetCollidable("items", "npcs", false)
	physicsService:CollisionGroupSetCollidable("items", "fishingSpots", false)
	physicsService:CollisionGroupSetCollidable("antiJumpHitbox", "antiJumpHitbox", true)
	
	physicsService:CollisionGroupSetCollidable("characters", "Default", true)
	physicsService:CollisionGroupSetCollidable("characters", "monsters", false)
	physicsService:CollisionGroupSetCollidable("characters", "characters", true)
	physicsService:CollisionGroupSetCollidable("characters", "fishingSpots", false)
	
	physicsService:CollisionGroupSetCollidable("pvpCharacters", "Default", true)
	physicsService:CollisionGroupSetCollidable("pvpCharacters", "monsters", false)
	physicsService:CollisionGroupSetCollidable("pvpCharacters", "pvpCharacters", true)
	
	physicsService:CollisionGroupSetCollidable("passthrough", "items", false)
	physicsService:CollisionGroupSetCollidable("passthrough", "npcs", false)
	physicsService:CollisionGroupSetCollidable("passthrough", "monsters", false)
	physicsService:CollisionGroupSetCollidable("passthrough", "monstersLocal", false)
	physicsService:CollisionGroupSetCollidable("passthrough", "characters", false)
end

main()

return module