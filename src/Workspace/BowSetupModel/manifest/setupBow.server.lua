local function setupBow(bowModel)
	local referenceModel = workspace.bowImposeModel
	
	if not bowModel:FindFirstChild("AnimationController") then
		Instance.new("AnimationController", bowModel)
	end
	
	local bottomImpose = bowModel.bottomCorner.CFrame:toObjectSpace(bowModel.slackRopeRepresentation.CFrame)
	local bottomCornerAttachment 	= Instance.new("Attachment")
	bottomCornerAttachment.Position = Vector3.new(bottomImpose.X, bowModel.bottomCorner.Size.Y / 2, bottomImpose.Z)
	bottomCornerAttachment.Parent 	= bowModel.bottomCorner
	
	local topImpose = bowModel.topCorner.CFrame:toObjectSpace(bowModel.slackRopeRepresentation.CFrame)
	local topCornerAttachment 		= Instance.new("Attachment")
	topCornerAttachment.Position 	= Vector3.new(topImpose.X, -bowModel.topCorner.Size.Y / 2, topImpose.Z)
	topCornerAttachment.Parent 		= bowModel.topCorner
	
	local slackRopeRepresentationAttachment = Instance.new("Attachment", bowModel.slackRopeRepresentation)
	
	for i, obj in pairs(referenceModel:GetChildren()) do
		if obj:IsA("BasePart") then
			for i, joint in pairs(obj:GetChildren()) do
				if joint:IsA("Motor6D") then
					print("copying Motor6D from", obj.Name)
					
					local copy 	= joint:Clone()
					copy.Parent = bowModel[obj.Name]
					copy.Part0 	= joint.Part0 and bowModel[joint.Part0.Name]
					copy.Part1 	= joint.Part1 and bowModel[joint.Part1.Name]
				end
			end
		elseif obj:IsA("RopeConstraint") then
			print("rigging RopeConstraint", obj.Name)
			
			bowModel[obj.Name].Attachment0 = bowModel[obj.Attachment0.Parent.Name].Attachment
			bowModel[obj.Name].Attachment1 = bowModel[obj.Attachment1.Parent.Name].Attachment
		end
	end
end

game:GetService("ChangeHistoryService"):SetWaypoint("willSetupBow")
setupBow(game.Selection:Get()[1])
game:GetService("ChangeHistoryService"):SetWaypoint("didSetupBow")