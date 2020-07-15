-- piggyback off monsters hehe!

local replicatedStorage = game:GetService("ReplicatedStorage")
	local modules = require(replicatedStorage.modules)
		local pathfinding 	= modules.load("pathfinding")
		local utilities		= modules.load("utilities")
		local projectile	= modules.load("projectile")
		local detection		= modules.load("detection")
		local network		= modules.load("network")
		local placeSetup	= modules.load("placeSetup")
			local placeFolders = placeSetup.getPlaceFoldersFolder()
			
local itemLookup do
	spawn(function()
		-- unfortunately there's a circular reference 
		-- here if we don't do this.. yucky
		itemLookup = require(replicatedStorage.itemData)
	end)
end

local playerHeight 			= 2
local petAcquisitionRange 	= 6
local petScanRange 			= 20
local petIgnoreList 		= {placeFolders}

local function getClosestItemWithinRange(monster, doForceRefresh)
	if not monster.__LAST_NEARBY_ITEM_CHECK then
		monster.__LAST_NEARBY_ITEM_CHECK = 0
	end
	
	if not monster.owner then
		return nil
	end
	
	if not itemLookup then
		return nil
	end
	
	if doForceRefresh or tick() - monster.__LAST_NEARBY_ITEM_CHECK >= 2 then
		monster.__LAST_NEARBY_ITEM_CHECK = tick()
		
		local closestItem, closestItemDistane = nil, petScanRange
		for i, itemPart in pairs(placeFolders.items:GetChildren()) do
			local distanceAway = (itemPart.Position - monster.manifest.Position).magnitude
			if distanceAway <= closestItemDistane and utilities.playerCanPickUpItem(monster.owner, itemPart, true) and (not itemPart:FindFirstChild("playerDropSource") or itemPart.playerDropSource.Value ~= monster.owner.userId) then
				local ray = Ray.new(monster.manifest.Position, itemPart.Position - monster.manifest.Position)
				local hitPart = projectile.raycastForProjectile(ray, petIgnoreList)
				
				if not hitPart then
					if itemLookup[itemPart.Name] then
						if network:invoke("doesPlayerHaveInventorySpaceForTrade", monster.owner, {}, {{id = itemLookup[itemPart.Name].id}}) then
							-- good, nothing between
							closestItem 		= itemPart
							closestItemDistane 	= distanceAway
						end
					end
				end
			end
		end
		
		monster.__CLOSEST_ITEM = closestItem
	end
	
	return monster.__CLOSEST_ITEM
end

return {
	default = "setup",
	states 	= {
		["setup"] = {
			animationEquivalent = "idle";
			transitionLevel 	= 0;
			step 				= function(monster)
				if monster.owner then
					if monster.owner.Character and monster.owner.Character.PrimaryPart then
						local targetCFrame = monster.owner.Character.PrimaryPart.CFrame * CFrame.new(0, 0, 3) * CFrame.new(2, 0, 0)
						monster.manifest.CFrame = targetCFrame
						
						return "idle"
					end
				end
			end;
		}; ["idle"] = {
			animationEquivalent = "idle";
			transitionLevel 	= 1;
			step 				= function(monster, canSwitchState)
				if monster.owner then
					if monster.owner.Character and monster.owner.Character.PrimaryPart then
						local closestItem = getClosestItemWithinRange(monster)
						
						if not closestItem then
--							local targetCFrame = monster.owner.Character.PrimaryPart.CFrame * CFrame.new(0, 0, 3) * CFrame.new(2, 0, 0)
--							local correct_manifestPosition = Vector3.new(monster.manifest.Position.X, targetCFrame.Y, monster.manifest.Position.Z)
--							if (correct_manifestPosition - targetCFrame.p).magnitude >= 3 then
--								return "follow"
--							else
--								monster.manifest.BodyGyro.CFrame = CFrame.new(monster.manifest.Position, monster.manifest.Position + targetCFrame.lookVector)
--								monster.manifest.BodyVelocity.Velocity = Vector3.new()
--							end

							local distanceFromOwner = ((monster.owner.Character.PrimaryPart.Position - monster.manifest.Position) * Vector3.new(1, 0, 1)).magnitude
							
							if distanceFromOwner > 7 then
								return "follow"
							else
--								monster.manifest.BodyGyro.CFrame 		= CFrame.new(monster.manifest.Position, monster.manifest.Position + monster.owner.Character.PrimaryPart.CFrame.lookVector)
								monster.manifest.BodyVelocity.Velocity 	= Vector3.new()
							end
						else
							-- close item!
							monster.timeSwitchToFetching = tick()
					
							return "fetching-item"
						end
					end
				end
			end;
		}; ["follow"] = {
			animationEquivalent = "movement";
			transitionLevel 	= 2;
			step 				= function(monster, canSwitchState)
				local closestItem = getClosestItemWithinRange(monster)
						
				if not closestItem then
--					local targetCFrame = monster.owner.Character.PrimaryPart.CFrame * CFrame.new(0, 0, 3) * CFrame.new(2, 0, 0)
--					local correct_manifestPosition = Vector3.new(monster.manifest.Position.X, targetCFrame.Y, monster.manifest.Position.Z)
					local targetMovementDirection = ((monster.owner.Character.PrimaryPart.Position - monster.manifest.Position) * Vector3.new(1, 0, 1))
					monster.manifest.BodyVelocity.Velocity = targetMovementDirection.unit * 20
					monster.manifest.BodyGyro.CFrame = CFrame.new(monster.manifest.Position, monster.manifest.Position + targetMovementDirection)
					
					if targetMovementDirection.magnitude < 7 then
						return "idle"
					elseif targetMovementDirection.magnitude >= 40 then
						return "setup"
					end
				else
					monster.timeSwitchToFetching = tick()
					
					return "fetching-item"
				end
			end;
		}; ["fetching-item"] = {
			animationEquivalent = "movement";
			transitionLevel 	= 3;
			step 				= function(monster, canSwitchState)
				local closestItem = getClosestItemWithinRange(monster)
				
				if closestItem then
					local targetCFrame = closestItem.CFrame
					local correct_manifestPosition = Vector3.new(monster.manifest.Position.X, targetCFrame.Y, monster.manifest.Position.Z)
					
					monster.manifest.BodyGyro.CFrame = CFrame.new(correct_manifestPosition, targetCFrame.p)
					
					if monster.timeSwitchToFetching and tick() - monster.timeSwitchToFetching <= 6 then
						if (correct_manifestPosition - targetCFrame.p).magnitude < 3 then
							monster.manifest.BodyVelocity.Velocity = Vector3.new()
							
							local success, errmsg = network:invoke("pickUpItemForPlayer_server", monster.owner, closestItem, true)
							
							if success then
								getClosestItemWithinRange(monster, true)
							end
						else
							monster.manifest.BodyVelocity.Velocity = (targetCFrame.p - correct_manifestPosition).unit * 20
						end
					else
						return "setup"
					end
				else
					return "follow"
				end
			end;
		};
	};
}
	