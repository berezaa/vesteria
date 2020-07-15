local module = {}

function module.isPathValid(monster)
	return true
end

function module.isBetweenPathfindingNodes(previousPosition, currentPosition, nextPosition)
	local projection = (previousPosition - nextPosition):Dot((currentPosition - nextPosition))
	local magnitude = (previousPosition - nextPosition).magnitude
	return projection > 0 and magnitude ^ 2 > projection
end

function module.isPastNextPathfindingNodeNode(previousPosition, currentPosition, nextPosition)
	local adjustPreviousPosition = previousPosition - Vector3.new(0, previousPosition.Y, 0)
	local adjustCurrentPosition = currentPosition - Vector3.new(0, currentPosition.Y, 0)
	local adjustNextPosition = nextPosition - Vector3.new(0, nextPosition.Y, 0)
	
	return (adjustPreviousPosition - adjustNextPosition):Dot((adjustCurrentPosition - adjustNextPosition)) <= 2
end

function module.dropPosition(pos, IGNORE_LIST)
	local ray = Ray.new(
		pos + Vector3.new(0, 1, 0),
		Vector3.new(0, -999, 0)
	)
	
	local hitPart, hitPosition = workspace:FindPartOnRayWithIgnoreList(ray, IGNORE_LIST)
	
	return hitPosition
end

function module.didReachPosition(previousPosition, currentPosition, nextPosition)
	return (previousPosition - currentPosition):Dot(nextPosition - currentPosition) >= 0
end

function module.adjustPathForProjectors(path, IGNORE_LIST)
	local waypoints = path:GetWaypoints()
	local fixWaypoints = {}
	local doesNeedToJump = false
	
	for i, pathWaypoint in pairs(waypoints) do
		if pathWaypoint.Action == Enum.PathWaypointAction.Jump then
			doesNeedToJump = true
		end
		
		--table.insert(fixWaypoints, PathWaypoint.new(pathWaypoint.Position, pathWaypoint.Action))
	end
	
	return waypoints
end

return module