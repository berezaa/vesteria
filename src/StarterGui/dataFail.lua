local module = {}

local player = game.Players.LocalPlayer

function module.init(Modules)
	
	local tween = Modules.tween
	
	script.Parent.Visible = false
	
	local function display(n)
		
		
		script.Parent.success.Visible = false
		script.Parent.fail.Visible = false
		script.Parent.queue.Visible = false
		script.Parent.Visible = true
		
		local frame = script.Parent.fail
		
		if n == 1 then
			frame = script.Parent.queue
		end
		
		frame.Visible = true
		
		for i=1,4 do
			local flare = script.Parent.flare:Clone()
			flare.Name = "flareCopy"
			flare.ImageColor3 = frame.spinner.ImageColor3
			flare.Parent = script.Parent
			flare.Visible = true
			flare.Size = UDim2.new(1,4,1,4)
			flare.Position = UDim2.new(0,-2,0.5,0)
			flare.AnchorPoint = Vector2.new(0,0.5)
			local x = (180 - 40*i)
			local y = (14 - 2*i)
			local EndPosition = UDim2.new(0,-y/2,0.5,0)
			local EndSize = UDim2.new(1,x,1,y)
			tween(flare,{"Position","Size","ImageTransparency"},{EndPosition, EndSize, 1},0.5*i)
		end				
	end
	
	local function hide()
		if script.Parent.Visible then
			script.Parent.fail.Visible = false
			script.Parent.success.Position = UDim2.new(0,0,0,0)
			script.Parent.success.Visible = true
			spawn(function()
				wait(10)
				if script.Parent.success.Visible then
					tween(script.Parent.success, {"Position"}, {UDim2.new(-1,-20,0,0)}, 0.5)
					wait(0.5)
					
					script.Parent.Visible = false					
				end
			end)
		end
	end

	if player:FindFirstChild("DataSaveFailed") then
		display(player.DataSaveFailed.Value)
	end
	
	player.ChildAdded:Connect(function(Child)
		if Child.Name == "DataSaveFailed" then
			display(Child.Value)
		end
	end)
	
	player.ChildRemoved:Connect(function(Child)
		if script.Parent.Visible and script.Parent.fail.Visible and player:FindFirstChild("DataSaveFailed") == nil then
			hide()
		end
	end)
	
end

return module