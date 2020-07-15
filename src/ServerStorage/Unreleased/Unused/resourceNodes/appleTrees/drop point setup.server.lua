for _, tree in pairs (workspace.placeFolders.resourceNodes.appleTrees:GetChildren()) do
	local dropPoints = Instance.new("Folder")
	dropPoints.Name = "DropPoints"
	dropPoints.Parent = tree
	
	for _, apple in pairs (tree.Apples:GetChildren()) do
		local attachment = Instance.new("Attachment")
		attachment.Name = "DropAttachment"
		attachment.Parent = apple
		
		local reference = Instance.new("ObjectValue")
		reference.Name = "Reference"
		reference.Value = apple
		reference.Parent = dropPoints
	end
end