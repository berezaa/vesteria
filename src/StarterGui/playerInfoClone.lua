-- Player name, health, mana, etc. display
-- berezaa
local module = {}

local characterPrimaryPart
local ui = script.Parent.gameUI.playerInfo

local selected = false

-- todo
local Rand = Random.new(os.time())

function module.init(Modules)

	local network = Modules.network
	local fx = Modules.fx
	local oldxp = 0

	local ColorEffect = Instance.new("ColorCorrectionEffect")
	ColorEffect.Name = "DamageColor"
	ColorEffect.Parent = game.Lighting

	local BlurEffect = Instance.new("BlurEffect")
	BlurEffect.Name = "DamageBlur"
	BlurEffect.Parent = game.Lighting
	BlurEffect.Size = 0

	local tween = Modules.tween

	--ui.header.username.value.Text = game.Players.LocalPlayer.Name

	local function updateNameTag(class)
		local label = ui.header.username.value
		label.Text = game.Players.LocalPlayer.Name

		local xSize = game.TextService:GetTextSize(label.Text, label.TextSize, label.Font, Vector2.new()).X + 15

		class = string.lower(class or network:invoke("getCacheValueByNameTag", "class") or "Unknown")
		if class:lower() ~= "adventurer" then
			ui.header.username.icon.Image = "rbxgameasset://Images/emblem_"..class:lower()
			ui.header.username.icon.Visible = true
			label.Size = UDim2.new(1, -25,1, 0)
			xSize = xSize + 25
		else
			ui.header.username.icon.Visible = false
			label.Size = UDim2.new(1, 0,1, 0)
		end
		ui.header.username.Size = UDim2.new(0, xSize + 10, 0, 26 + 10)
	end
	spawn(updateNameTag)



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

	local function healthRefresh()
		local delta = math.clamp(characterPrimaryPart.health.Value - lastHealth, -characterPrimaryPart.maxHealth.Value * 0.25, characterPrimaryPart.maxHealth.Value * 0.25) / (characterPrimaryPart.maxHealth.Value * 0.25)
		lastHealth = characterPrimaryPart.health.Value

		local percent = math.clamp(characterPrimaryPart.health.Value / characterPrimaryPart.maxHealth.Value, 0, 1)
		local manaPercent = math.clamp(characterPrimaryPart.mana.Value / characterPrimaryPart.maxMana.Value, 0, 1)

		ui.content.healthBar.value.Size = UDim2.new(percent,0,1,0)
		ui.content.healthBar.title.Text = math.floor(characterPrimaryPart.health.Value + 0.5) .. "/" .. math.floor(characterPrimaryPart.maxHealth.Value + 0.5)

		ui.content.manaBar.value.Size = UDim2.new(manaPercent,0,1,0)
		ui.content.manaBar.title.Text = math.floor(characterPrimaryPart.mana.Value + 0.5) .. "/" .. math.floor(characterPrimaryPart.maxMana.Value + 0.5)

		if delta < 0 then
			local thresh = (0.9) * (math.abs(delta))
			local duration = 0.15 + thresh / 1.4

			tween(ColorEffect,{"TintColor","Contrast"},{Color3.fromRGB(255,255 - thresh * 150,255 - thresh * 150),thresh/3},duration/2)
			tween(BlurEffect,{"Size"},thresh * 5,duration/2)
			spawn(function()
				wait(duration/2)
				tween(ColorEffect,{"TintColor","Contrast"},{Color3.fromRGB(255,255,255),0},duration/2)
				tween(BlurEffect,{"Size"},0,duration/2)
			end)
			spawn(function()
				for i=1,3 do
					ui.content.healthBarUnder.Visible = true
					wait(0.08)
					ui.content.healthBarUnder.Visible = false
					wait(0.08)
				end
			end)
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

	healthRefresh()

	ui.header.xp.Visible = true

	local levels = Modules.levels

	local network = Modules.network

	local function setup()
		local value = network:invoke("getCacheValueByNameTag", "exp")
		local level = network:invoke("getCacheValueByNameTag", "level")

		local label = ui.header.level.value
		label.Text = "Lvl. "..level

		local xSize = game.TextService:GetTextSize(label.Text, label.TextSize, label.Font, Vector2.new()).X + 16
		ui.header.level.Size = UDim2.new(0, xSize + 10, 0, 26 + 10)

		local xp 						= value
		local needed 					= math.floor(levels.getEXPToNextLevel(level))
		oldxp 							= value
		ui.header.xp.title.Text 	= "XP: " .. xp .. "/" .. needed
		ui.header.xp.value.Size 	= UDim2.new(xp/needed,0,1,0)
		ui.header.xp.instant.Size = ui.header.xp.value.Size
		--[[
		local gold = network:invoke("getCacheValueByNameTag", "gold")
		ui.header.gold.Text = "$"..gold
		]]
	end

	local function onDataChange(key, value)
		if key == "class" then
			updateNameTag(value)
		elseif key == "gold" then

	--		if game.ReplicatedStorage:FindFirstChild("sounds") and game.ReplicatedStorage.sounds:FindFirstChild("coins") then
	--			game.ReplicatedStorage.sounds.coins:Play()
	--		end

		elseif key == "level" then
			local col = ui.header.xp.value.ImageColor3
			ui.header.xp.ImageColor3 = col
			tween(ui.header.xp, {"ImageColor3"},Color3.new(col.r + 0.2, col.g + 0.2, col.b + 0.2),0.4)
			ui.header.xp.pulse.ImageTransparency = 0
			ui.header.xp.pulse.ImageColor3 = col
			ui.header.xp.pulse.Size = UDim2.new(1,0,1,0)
			ui.header.xp.pulse.Visible = true
			tween(ui.header.xp.pulse,{"Size","ImageTransparency"},{UDim2.new(1,140,1,140),1},0.5)

			wait(0.4)
			tween(ui.header.xp,{"ImageColor3"},Color3.fromRGB(15, 15, 15),1)
		elseif key == "exp" then
			local level = network:invoke("getCacheValueByNameTag", "level")
			local label = ui.header.level.value
			label.Text = "Lvl. "..level

			local xSize = game.TextService:GetTextSize(label.Text, label.TextSize, label.Font, Vector2.new()).X + 16
			ui.header.level.Size = UDim2.new(0, xSize + 10, 0, 26 + 10)
			--local xp = math.floor(levels.getEXPPastCurrentLevel(value))
			local xp = value
			local needed = math.floor( levels.getEXPToNextLevel(level))
			ui.header.xp.title.Text = "XP: " .. math.floor(xp) .. "/" .. needed

			-- ahh crying internally

			local change = xp - oldxp
			--[[
			local notice = ui.content.noticeTemplate:Clone()
			notice.Name = "Notice"
			notice.TextTransparency = 1
			notice.TextStrokeTransparency = 1
			notice.Parent = ui.content
			notice.Visible = true
			notice.Text = "+"..math.floor(change).." EXP"
			notice.Position = UDim2.new(1,Rand:NextInteger(-10,50),0,Rand:NextInteger(30,70))
			Modules.tween(notice,{"Position"},notice.Position + UDim2.new(0,0,0,-100),3)
			Modules.tween(notice,{"TextTransparency","TextStrokeTransparency"},{0,0.7},1.5)
			]]

			local sampleParticle = ui.header.xp.value.tip.sample
			for i=1,10 do
				local particle = sampleParticle:Clone()
				particle.Rotation = math.random(1,90)
				particle.Parent = sampleParticle.Parent
				particle.Visible = true
				tween(particle,{"Rotation", "Position", "Size", "BackgroundTransparency"},
				{particle.Rotation + math.random(100,200), UDim2.new(0, math.random(3,25),0.5,math.random(-20,20)), UDim2.new(0,16,0,16), 1},math.random(60,130)/100)
				game.Debris:AddItem(particle,1.5)
			end

			if xp < oldxp then
				Modules.tween(ui.header.xp.value,{"Size"},{UDim2.new(1,0,1,0)},0.5)
				ui.header.xp.instant.Size = UDim2.new(1,0,1,0)
				spawn(function()
					wait(0.25)
					ui.header.xp.value.Size = UDim2.new(1,0,0,0)
					local goal = UDim2.new(xp/needed,0,1,0)
					Modules.tween(ui.header.xp.value,{"Size"},{goal},0.5)
					ui.header.xp.instant.Size = goal
				end)
			else
				Modules.tween(ui.header.xp.value,{"Size"},{UDim2.new(xp/needed,0,1,0)},1)
				ui.header.xp.instant.Size = UDim2.new(xp/needed,0,1,0)
			end

			ui.header.xp.Visible = true
			oldxp = value
			--[[
			spawn(function()
				wait(0.5)
				Modules.tween(notice,{"TextTransparency","TextStrokeTransparency"},{1,1},1.5)
				wait(3)
				if oldxp == value and not selected then
				--	ui.header.xp.Visible = false
				end
				end)
			]]
		end
	end

	ui.header.xp.MouseEnter:connect(function()
		ui.header.xp.title.Visible = true
		selected = true
	end)

	ui.header.xp.MouseLeave:connect(function()
		ui.header.xp.title.Visible = false
		selected = false
	end)


	network:connect("propogationRequestToSelf", "Event", onDataChange)
	spawn(setup)
end

return module