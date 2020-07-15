-- running this script moves the clothes from one npc (un-rigged) to another (properly rigged)
-- must have the same orientation, and body parts must have the same names

local old = workspace.container
local new = workspace["City Guard"]
--[[[
local news = {}
for i,child in pairs(workspace:GetChildren()) do
	if child.Name == "hatTest" then
		table.insert(news,child)
	end
end
]]

for i,bodyPart in pairs(old:GetChildren()) do
	if bodyPart:IsA("BasePart") then
		
		--for e,new in pairs(news) do
		
			local newParent = new:FindFirstChild(bodyPart.Name)
			if newParent and newParent:IsA("BasePart") then
				newParent.Color = bodyPart.Color
				
				for e,clothing in pairs(bodyPart:GetChildren()) do
					
					if clothing:IsA("BasePart") then
						local clothing = clothing:Clone()
						clothing.CFrame = clothing.CFrame - bodyPart.position + newParent.position 
						clothing.Parent = newParent
					
						
					end
				end
			end
		
--		end
	end
end
