local module = {}

local player = game.Players.LocalPlayer
local ui = script.Parent.gameUI.stamina

function module.init(Modules)

	ui.BackgroundTransparency = 1
	ui.value.BackgroundTransparency = 1
	ui.Active = false
	ui.Visible = true

	local function updateStamina()
		if player.Character and player.Character.PrimaryPart and player.Character.PrimaryPart:FindFirstChild("stamina") and player.Character.PrimaryPart:FindFirstChild("maxStamina") then
			if player.Character.PrimaryPart.stamina.Value < player.Character.PrimaryPart.maxStamina.Value then

				ui.Size = UDim2.new(0, 10, 0, player.Character.PrimaryPart.maxStamina.Value * 10)

				Modules.tween(ui.value,{"Size"},UDim2.new(1,0,player.Character.PrimaryPart.stamina.Value / player.Character.PrimaryPart.maxStamina.Value,0),0.1, Enum.EasingStyle.Linear)
				if not ui.Active then
					ui.Active = true
					Modules.tween(ui.value,{"BackgroundTransparency"},0,0.5)
					Modules.tween(ui,{"BackgroundTransparency"},0,0.5)
				end
				if player.Character.PrimaryPart.stamina.Value <= 0 then
					ui.value.Visible = false
					spawn(function()
						for i=1,5 do
							ui.BorderSizePixel = 2
							wait(0.1)
							ui.BorderSizePixel = 0
							wait(0.1)
						end
						if player.Character.PrimaryPart.stamina.Value <= 0 and Modules.network:invoke("doesPlayerHaveStatusEffect", "heat exhausted") then
							ui.BorderSizePixel = 2
						end
					end)
				else
					ui.value.Visible = true
					ui.BorderSizePixel = 0
					local color = Color3.fromRGB(46, 153, 46)
					if Modules.network:invoke("doesPlayerHaveStatusEffect", "empower", nil, "haste")  then
						color = Color3.fromRGB(45, 191, 162)
					elseif Modules.network:invoke("doesPlayerHaveStatusEffect", "heat exhausted") then
						color = Color3.fromRGB(255, 255, 127)
					end
					ui.value.BackgroundColor3 = color
				end
			else
				if ui.Active then
					Modules.tween(ui.value,{"Size"},UDim2.new(1,0,1,0),0.1, Enum.EasingStyle.Linear)
					ui.Active = false
					Modules.tween(ui.value,{"BackgroundTransparency"},1,0.5)
					Modules.tween(ui,{"BackgroundTransparency"},1,0.5)
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
