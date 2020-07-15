return function(renderCharacter)
	if not renderCharacter:FindFirstChild("LowerTorso") then return false end
	if renderCharacter:FindFirstChild("LANTERN_TEMP_EQUIP") then return false end
	
	local lanternModel 	= script.Parent:Clone()
		lanternModel.application:Destroy()
	lanternModel.Name 	= "LANTERN_TEMP_EQUIP"
	
	for i, obj in pairs(lanternModel:GetChildren()) do
		if obj:IsA("BasePart") then
			obj.CanCollide 	= false
			obj.Anchored 	= false
		end
	end
	
	local attachmentMotor 	= Instance.new("Motor6D")
	attachmentMotor.Part0 	= renderCharacter.LowerTorso
	attachmentMotor.Part1 	= lanternModel.Main
	attachmentMotor.C1 		= CFrame.new(renderCharacter.LowerTorso.Size.X / 2 - 0.1, lanternModel.Main.Size.Y / 2, -0.15) * CFrame.Angles(0, 0, 0) * CFrame.Angles(0, 0, math.pi / 6) + Vector3.new(0, 0.5, 0)
	attachmentMotor.Parent 	= lanternModel.Main

--	lanternModel.Main.BallSocketConstraint.Attachment1 	= renderCharacter.LowerTorso.RightHipRigAttachment
--	lanternModel.Main.RopeConstraint.Attachment1 		= renderCharacter.LowerTorso.RightHipRigAttachment
	
	lanternModel.Parent = renderCharacter
	
	warn("applying temporary equipment :angrycry:")
end