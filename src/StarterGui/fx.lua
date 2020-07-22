-- module for displaying cool effects xD
-- author: the right, honorable just lord andrew alexander bereza

-- was going to make a cool "bought!" and "sold!" and "error!" display for shop
-- then i figured that might apply to more frames
-- now here we are xD

-- goal: eventually do cool stuff like fireworks here

local module = {}

function module.displayAbilityCooldown()

end

function module.statusRibbon()

end

function module.setFlash()

end

local effects = script.Parent.effects

module.colorTypes = {
	success = Color3.fromRGB(97, 180, 79);
	fail = Color3.fromRGB(180, 58, 60);
	default = Color3.fromRGB(180,180,0);
	gold = Color3.fromRGB(255, 188, 52);
}
local colorTypes = module.colorTypes

function module.init(Modules)

	local tween = Modules.tween
	-- oh tween module, no one gets me quite like you do
	local network = Modules.network

	function module.setFlash(frame, value)
		if frame:FindFirstChild("flash") then
			frame.flash:Destroy()
		end
		if value then
			local flash = effects.flash:Clone()
			flash.Parent = frame
			flash.Visible = true

			local duration = 0.6
--			duration = duration * (frame.AbsoluteSize.X/60)
			local max = math.max(frame.AbsoluteSize.X, frame.AbsoluteSize.Y)
			flash.ImageLabel.Size = UDim2.new(1, 16, 1, 16) --UDim2.new(0, 100 * max/60, 0, 100 * max/60)

			spawn(function()

				while frame.Parent and flash.Parent do

					flash.ImageLabel.Position = UDim2.new(0,0,0,0)
					flash.ImageLabel.ImageTransparency = 1

					tween(flash.ImageLabel,{"Position"},{UDim2.new(1,0,1,0)},duration, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
					tween(flash.ImageLabel,{"ImageTransparency"},{0}, duration/2, nil, Enum.EasingDirection.Out )

					wait(duration/2)
					if frame.Parent and flash.Parent then
						tween(flash.ImageLabel,{"ImageTransparency"},{1},duration/2, nil, Enum.EasingDirection.In )
					end

					wait(4-duration)

				end
			end)
		end


	end

	function module.displayAbilityCooldown(abilityFrame, cooldown)
		if abilityFrame then
			if abilityFrame:FindFirstChild("cooldown") then
				abilityFrame.cooldown:Destroy()
			end
			local indicator = effects.cooldown:Clone()
			indicator.Parent = abilityFrame
			indicator.bar.value.Size = UDim2.new(1,0,1,0)
			tween(indicator.bar.value,{"Size"}, UDim2.new(1,0,0,0), cooldown, Enum.EasingStyle.Linear)
			game.Debris:AddItem(indicator, cooldown)
		end
	end

	function module.ring(ringInfo, absolutePosition)
		local ring = ringInfo or {}
		local color = ring.color or Color3.new(1,1,1)
		local duration = ring.duration or 0.5
		local scale = ring.scale or 5

		local ringObject = effects.ring:Clone()
		ringObject.Parent = script.Parent.gameUI
		ringObject.ImageTransparency = 0
		ringObject.AnchorPoint = Vector2.new(0.5,0.5)
		ringObject.Position = UDim2.new(0,absolutePosition.X,0,absolutePosition.Y - game.GuiService:GetGuiInset().Y)
		ringObject.Visible = true

		ringObject.ImageColor3 = color

		local sizeGoal = ringObject.AbsoluteSize * scale
		tween(ringObject,{"Size","ImageTransparency"},{UDim2.new(0,sizeGoal.X,0,sizeGoal.Y),1},duration)
		game.Debris:AddItem(ringObject,duration)
	end

	network:create("displayAbilityCooldown","BindableFunction","OnInvoke",module.displayAbilityCooldown)

	local endtime

	function module.consumableCooldown(duration)
		local durationEndTime = tick() + duration
		endtime = durationEndTime
	end

	function module.statusRibbon(parent, text, colorType, duration, target)
		colorType = colorType or "default"
		local color = colorTypes[colorType]
		duration = duration or 3

		-- someone told me instancing is better than cloning
		local ribbon = Instance.new("Frame")
		ribbon.BorderSizePixel = 0
		ribbon.BackgroundTransparency = 1

		ribbon.ZIndex = 7



		local ysize = parent.AbsoluteSize.Y
		ysize = ysize > 30 and 30 or ysize

		ribbon.Size = UDim2.new(1,0,0,ysize)
		ribbon.Name = "fxStatusRibbon"
		ribbon.ClipsDescendants = true
		-- took me two tries to spell this property right

		-- todo maybe make this better
		target = target or UDim2.new(0,0,0,28)
		ribbon.Position = target

		if target.Y.Scale >= 0.49 and target.Y.Scale <= 0.51 then
			ribbon.AnchorPoint = Vector2.new(0,0.5)
		end

		local textLabel = Instance.new("TextLabel")
		textLabel.BackgroundTransparency = 1
		textLabel.Size = UDim2.new(1,0,0.8,0)
		textLabel.AnchorPoint = Vector2.new(0,0.5)
		textLabel.Position = UDim2.new(1,0,0.5,0)
		textLabel.TextColor3 = Color3.new(1,1,1)
		textLabel.TextScaled = true
		textLabel.Font = Enum.Font.SourceSans
		textLabel.Parent = ribbon

		textLabel.Text = text
		ribbon.BackgroundColor3 = color

		ribbon.Parent = parent
		game.Debris:AddItem(ribbon, duration + 1)

		-- dont ask about the fractions. I like it this way
		spawn(function()
			tween(ribbon,{"BackgroundTransparency"},0.1,duration * 1/8)
			tween(textLabel,{"Position"},UDim2.new(0,0,0.5,0),duration * 2/8)
			wait(duration * 6/8)
			tween(textLabel,{"Position"},UDim2.new(-1,0,0.5,0),duration * 2/8)
			wait(duration * 1/8)
			tween(ribbon,{"BackgroundTransparency"},1,duration * 1/8)
			wait(duration * 1/8)
			if ribbon then
				ribbon.Visible = false
			end
		end)

		return ribbon
	end

end

return module
