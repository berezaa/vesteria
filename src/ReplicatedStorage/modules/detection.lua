local module = {}

function module.boxcast_singleTarget(boundingBoxCFrame, boundingBoxSize, targetPosition)
	local cf = boundingBoxCFrame:pointToObjectSpace(targetPosition) / boundingBoxSize
	
	return
		cf.X <= 0.5 and cf.X >= -0.5
		and cf.Y <= 0.5 and cf.Y >= -0.5
		and cf.Z <= 0.5 and cf.Z >= -0.5
end

function module.boxcast_closest(targets, hitboxCFrame, hitboxSize, point)
	local closest = nil
	local closestDistanceSq = math.huge
	
	for _, target in pairs(targets) do
		local targetPosition = module.projection_Box(target.CFrame, target.Size, hitboxCFrame.Position)
		if module.boxcast_singleTarget(hitboxCFrame, hitboxSize, targetPosition) then
			local delta = targetPosition - point
			local distanceSq =
				delta.X * delta.X +
				delta.Y * delta.Y +
				delta.Z * delta.Z
			if distanceSq < closestDistanceSq then
				closest = target
				closestDistanceSq = distanceSq
			end
		end
	end
	
	return closest
end

function module.boxcast_all(targets, hitboxCFrame, hitboxSize)
	local hits = {}
	
	for _, target in pairs(targets) do
		local targetPosition = module.projection_Box(target.CFrame, target.Size, hitboxCFrame.Position)
		if module.boxcast_singleTarget(hitboxCFrame, hitboxSize, targetPosition) then
			table.insert(hits, target)
		end
	end
	
	return hits
end

local function sphereCastShow(boundingSpherePosition, boundingSphereRadius)
	local p = Instance.new("Part")
	p.Shape = Enum.PartType.Ball
	p.Anchored = true
	p.CanCollide = false
	p.Size = Vector3.new(2, 2, 2) * boundingSphereRadius
	p.Material = Enum.Material.Neon
	p.BrickColor = BrickColor.new("Hot pink")
	p.CFrame = CFrame.new(boundingSpherePosition)
	p.Parent = workspace
	
	game:GetService("Debris"):AddItem(p, 1.5)
end

function module.spherecast_singleTarget(boundingSpherePosition, boundingSphereRadius, targetPosition)
	return (boundingSpherePosition - targetPosition).magnitude <= boundingSphereRadius
end

function module.projection_Box(boxCFrame, boxSize, targetPosition)
	local offset = boxCFrame:pointToObjectSpace(targetPosition)

	return (boxCFrame * CFrame.new(
		math.clamp(offset.X, -boxSize.X / 2, boxSize.X / 2),
		math.clamp(offset.Y, -boxSize.Y / 2, boxSize.Y / 2),
		math.clamp(offset.Z, -boxSize.Z / 2, boxSize.Z / 2)
	)).p
end

function module.projection_Sphere(spherePosition, sphereRadius, targetPosition)
	return spherePosition + (targetPosition - spherePosition).unit * sphereRadius
end

return module