local module = {}

local player = game.Players.LocalPlayer

function module.init(Modules)
	
	script.Parent.BackgroundTransparency = 1
	script.Parent.value.BackgroundTransparency = 1
	script.Parent.Active = false
	script.Parent.Visible = true
	
	local function updateStamina()
		if player.Character and player.Character.PrimaryPart and player.Character.PrimaryPart:FindFirstChild("stamina") and player.Character.PrimaryPart:FindFirstChild("maxStamina") then
			if player.Character.PrimaryPart.stamina.Value < player.Character.PrimaryPart.maxStamina.Value then
				
				script.Parent.Size = UDim2.new(0, 10, 0, player.Character.PrimaryPart.maxStamina.Value * 10)
				
				Modules.tween(script.Parent.value,{"Size"},UDim2.new(1,0,player.Character.PrimaryPart.stamina.Value / player.Character.PrimaryPart.maxStamina.Value,0),0.1, Enum.EasingStyle.Linear)
				if not script.Parent.Active then
					script.Parent.Active = true
					Modules.tween(script.Parent.value,{"BackgroundTransparency"},0,0.5)
					Modules.tween(script.Parent,{"BackgroundTransparency"},0,0.5)
				end
				if player.Character.PrimaryPart.stamina.Value <= 0 then
					script.Parent.value.Visible = false
					spawn(function()
						for i=1,5 do
							script.Parent.BorderSizePixel = 2
							wait(0.1)
							script.Parent.BorderSizePixel = 0
							wait(0.1)
						end
						if player.Character.PrimaryPart.stamina.Value <= 0 and Modules.network:invoke("doesPlayerHaveStatusEffect", "heat exhausted") then
							script.Parent.BorderSizePixel = 2
						end
					end)
				else
					script.Parent.value.Visible = true
					script.Parent.BorderSizePixel = 0
					local color = Color3.fromRGB(46, 153, 46)
					if Modules.network:invoke("doesPlayerHaveStatusEffect", "empower", nil, "haste")  then
						color = Color3.fromRGB(45, 191, 162)
					elseif Modules.network:invoke("doesPlayerHaveStatusEffect", "heat exhausted") then
						color = Color3.fromRGB(255, 255, 127)
					end
					script.Parent.value.BackgroundColor3 = color
				end				
			else
				if script.Parent.Active then
					Modules.tween(script.Parent.value,{"Size"},UDim2.new(1,0,1,0),0.1, Enum.EasingStyle.Linear)
					script.Parent.Active = false
					Modules.tween(script.Parent.value,{"BackgroundTransparency"},1,0.5)
					Modules.tween(script.Parent,{"BackgroundTransparency"},1,0.5)
				end
			end
		end
	end
	
	spawn(function()
		local startTime = tick()
		repeat wait() until (player.Character and player.Character.PrimaryPart and player.Character.PrimaryPart:FindFirstChild("stamina") and player.Character.PrimaryPart:FindFirstChild("maxStamina")) or tick() - startTime > 10
		updateStamina()
		player.Character.PrimaryPart.stamina.Changed:connect(updateStamina)
	end)


end

return module
