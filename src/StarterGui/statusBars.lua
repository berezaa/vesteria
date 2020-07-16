-- Player name, health, mana, etc. display
-- berezaa
local module = {}

local characterPrimaryPart

local frame = script.Parent.gameUI.bottomRight.statusBars

local healthUI  = frame.healthBar.value
local damageUI 		= frame.healthBar.damageValue
local tweenService 	= game:GetService("TweenService")

local damageHealthTween

-- the higher this number the more 'bursty' damage looks
local healthBurstFactor = 1

function module.init(Modules)
	for _, child in pairs(game.Lighting:GetChildren()) do
		if child.Name == "DamageColor" or child.Name == "DamageBlur" then
			child:Destroy()
		end
	end

	local ColorEffect = Instance.new("ColorCorrectionEffect")
	ColorEffect.Name = "DamageColor"
	ColorEffect.Parent = game.Lighting

	local BlurEffect = Instance.new("BlurEffect")
	BlurEffect.Name = "DamageBlur"
	BlurEffect.Parent = game.Lighting
	BlurEffect.Size = 0

	local tween = Modules.tween

	local damagedScreen = frame.Parent.Parent.vin_low_health

	--frame.header.username.value.Text = game.Players.LocalPlayer.Name


	function module.manaWarning()
		spawn(function()
			for _ = 1, 3 do
--				frame.manaBar.frame.Visible = true
				frame.manaBar.ImageColor3 = Color3.fromRGB(134, 17, 17)
				wait()
--				frame.manaBar.frame.Visible = false
				frame.manaBar.ImageColor3 = Color3.fromRGB(16, 16, 16)
				wait()
			end
		end)
	end


	repeat wait() until game.Players.LocalPlayer.Character
	local character = game.Players.LocalPlayer.Character
	while not character.PrimaryPart and character.Parent and character:IsDescendantOf(workspace) do
		local primaryPart = character:WaitForChild("hitbox", 1)

		if primaryPart then
			character.PrimaryPart = primaryPart
			break
		end
	end

	characterPrimaryPart = character.PrimaryPart

	characterPrimaryPart:WaitForChild("health")

	local lastHealth = characterPrimaryPart.health.Value

	local function healthRefresh(ini)
		local delta = characterPrimaryPart.health.Value - lastHealth
		local change = characterPrimaryPart.health.Value - lastHealth
		lastHealth = characterPrimaryPart.health.Value

		local humanoidHealth 	= characterPrimaryPart.health.Value
		local humanoidMaxHealth = characterPrimaryPart.maxHealth.Value

		local percent = math.clamp(characterPrimaryPart.health.Value / characterPrimaryPart.maxHealth.Value, 0, 1)
		local manaPercent = math.clamp(characterPrimaryPart.mana.Value / characterPrimaryPart.maxMana.Value, 0, 1)


		local percentDelta = delta/humanoidMaxHealth
		local healthPercent = humanoidHealth/humanoidMaxHealth


		damagedScreen.Visible = healthPercent < 0.4 and healthPercent > 0
		if damagedScreen.Visible then
			damagedScreen.UIScale.Scale = 1 + healthPercent * 10
		end

		if ini then
			frame.healthBar.value.Size = UDim2.new(math.max(percent,0),0,1,0)
			frame.manaBar.value.Size = UDim2.new(math.max(manaPercent,0),0,1,0)
		else
			tween(frame.healthBar.value, {"Size"}, UDim2.new(math.max(percent,0),0,1,0), 0.3)
			tween(frame.manaBar.value, {"Size"}, UDim2.new(math.max(manaPercent,0),0,1,0), 0.3)
		end
		frame.healthBar.title.Text = math.floor(characterPrimaryPart.health.Value + 0.5) .. "/" .. math.floor(characterPrimaryPart.maxHealth.Value + 0.5)


		frame.manaBar.title.Text = math.floor(characterPrimaryPart.mana.Value + 0.5) .. "/" .. math.floor(characterPrimaryPart.maxMana.Value + 0.5)

		if delta < 0 then
			local thresh = percentDelta^2 + math.clamp(1-healthPercent, 0, 1)^3
			local duration = 0.15 + thresh^3

			tween(ColorEffect,{"TintColor","Contrast","Saturation"},{Color3.fromRGB(255,255 - thresh * 150,255 - thresh * 150),thresh*2, thresh},duration/3)
			tween(BlurEffect,{"Size"},thresh * 5,duration/3)
			spawn(function()
				wait(duration/2)
				tween(ColorEffect,{"TintColor","Contrast","Saturation"},{Color3.fromRGB(255,255,255),0, 0},duration/2)
				tween(BlurEffect,{"Size"},0,duration/2)
			end)
			spawn(function()


				local healthpercent = characterPrimaryPart.health.Value/characterPrimaryPart.maxHealth.Value
				local changepercent = math.abs(change/characterPrimaryPart.maxHealth.Value)

				local repre = frame.healthBar.instant:Clone()
				repre.Name = "instantClone"
				repre.Size = UDim2.new(changepercent, 5, 1, 0)
				repre.Position = UDim2.new(healthpercent, -5, 0.5, 0)
				repre.Parent = frame.healthBar
				repre.Visible = true

				tween(repre, {"Size", "ImageTransparency"}, {UDim2.new(changepercent, 5, 1 + changepercent * 30, 0), 1}, 0.25 + changepercent * 2)
				game.Debris:AddItem(repre, 0.25 + changepercent * 2)

				--[[
				for i=1,3 do
					frame.healthBar.ImageColor3 = Color3.new(1,1,1)
					wait(0.08)
					frame.healthBar.ImageColor3 = Color3.fromRGB(16, 16, 16)
					wait(0.08)
				end
				]]

			end)

			local healthDelta = -change


			if healthDelta > 0 then
				if damageHealthTween and damageHealthTween.PlaybackState == Enum.PlaybackState.Playing then
					damageHealthTween:Cancel()
				end

				healthUI.Size = UDim2.new(humanoidHealth / humanoidMaxHealth, 0, 1, 0)

				damageUI.Position 				= UDim2.new(math.clamp(humanoidHealth / humanoidMaxHealth - 0.1, 0, 1), 0, 0, 0)
				damageUI.Size 					= UDim2.new(math.clamp(healthDelta / humanoidMaxHealth + 0.1, 0, 1), 0, 1, 0)
				damageUI.bar.ImageColor3 		= Color3.fromRGB(255, 255, 150 + 50 * (healthDelta / humanoidMaxHealth))
				--damageUI.bar.ImageTransparency 	= 1

				local tweenInfo = TweenInfo.new(
					0.5 * (healthDelta / humanoidMaxHealth) ^ (1 / 3) * healthBurstFactor,
					Enum.EasingStyle.Quart,
					Enum.EasingDirection.Out,
					0,
					false,
					0
				)

				damageHealthTween = tweenService:Create(
					damageUI.bar,
					tweenInfo,
					{ImageColor3 = Color3.fromRGB(255, 44, 44)}
					--{ImageColor3 = Color3.fromRGB(255, 44, 44); ImageTransparency = 0}
				)

				local connection
				connection = damageHealthTween.Completed:connect(function(playbackState)
					connection:disconnect()

					if playbackState == Enum.PlaybackState.Completed then
						tweenInfo = TweenInfo.new(
							0.5 * (1 - healthDelta / humanoidMaxHealth) ^ (1 / 3) * healthBurstFactor,
							Enum.EasingStyle.Quad,
							Enum.EasingDirection.Out,
							0,
							false,
							0
						)

						damageHealthTween = tweenService:Create(
							damageUI,
							tweenInfo,
							{Size = UDim2.new(0, 0, 1, 0)}
						)

						damageHealthTween:Play()
					end
				end)

				damageHealthTween:Play()
			end


		else
			if characterPrimaryPart.health.Value - lastHealth > 5 and delta > 0.01 then
				local thresh = 0.3 + math.abs(delta)
				local duration = thresh / 1.4
				tween(ColorEffect,{"TintColor","Contrast"},{Color3.fromRGB(255 - thresh * 150,255,255 - thresh * 150),-thresh/3},duration/2)
				spawn(function()
					wait(duration/1.5)
					tween(ColorEffect,{"TintColor","Contrast"},{Color3.fromRGB(255,255,255),0},duration/2)
				end)
			end
		end
	end

	characterPrimaryPart.health.Changed:connect(healthRefresh)
	characterPrimaryPart.mana.Changed:connect(healthRefresh)
	characterPrimaryPart.maxHealth.Changed:connect(healthRefresh)
	characterPrimaryPart.maxMana.Changed:connect(healthRefresh)

	healthRefresh(true)

	local function inputUpdate()
		--[[
		if Modules.input.mode.Value == "mobile" then
			frame.UIListLayout.FillDirection = Enum.FillDirection.Vertical
			frame.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
			frame.Position = UDim2.new(1, -295,1, -74)
			frame.AnchorPoint = Vector2.new(1,0)
		else
			frame.UIListLayout.FillDirection = Enum.FillDirection.Horizontal
			frame.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			frame.Size = UDim2.new(0.65,0,0,50)
			frame.Position = UDim2.new(0.5, 0, 1, -120)
			frame.AnchorPoint = Vector2.new(0.5,0)
		end
		]]

	end

	Modules.input.mode.changed:connect(inputUpdate)
	inputUpdate()

end

return module