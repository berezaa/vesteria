local module = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local network
local levels

local professionLookup = require(ReplicatedStorage:WaitForChild("professionLookup"))

local function getProfessionLevel(player, profession)
	local playerData = network:invoke("getPlayerData", player)
	if playerData then
		if professionLookup[profession] then
			playerData.professions[profession] = playerData.professions[profession] or {level = 1, exp = 0}
			return playerData.professions[profession].level
		end
	end
end

local function grantProfessionExp(player, profession, exp)
	local playerData = network:invoke("getPlayerData", player)
	if playerData then
		-- professions are not hard-coded, can be added at any time.
		playerData.professions[profession] = playerData.professions[profession] or {level = 1, exp = 0}
		local professionData = playerData.professions[profession]

		local expForNextLevel = levels.getEXPToNextLevel(professionData.level)
		if professionData.exp >= expForNextLevel then
			-- profession level up!

			professionData.exp = professionData.exp - expForNextLevel
			professionData.level = professionData.level + 1

			local professionTag = player.professions:FindFirstChild(profession)
			if professionTag then
				professionTag.Value = professionData.level
			end

			if player.Character and player.Character.PrimaryPart then
				--[[
				local Sound = Instance.new("Sound")
				Sound.Volume = 0.7
				Sound.MaxDistance = 500
				Sound.SoundId = "rbxassetid://2066645345"
				Sound.Parent = player.Character.PrimaryPart
				Sound:Play()
				game.Debris:AddItem(Sound,10)
				]]
				local Attach = Instance.new("Attachment")
				Attach.Parent = player.Character.PrimaryPart
				Attach.Orientation = Vector3.new(0,0,0)
				Attach.Axis = Vector3.new(1,0,0)
				Attach.SecondaryAxis = Vector3.new(0,1,0)

				local particle = script.particles.Wave:Clone()
				particle.Parent = Attach
				particle.Color = ColorSequence.new(professionData.color)
				particle:Emit(1)

				game.Debris:AddItem(Attach, 5)
			end
		end

		playerData.nonSerializeData.playerDataChanged:Fire("professions")
	end
end

function module.init(Modules)
	network = Modules.network
	levels = Modules.levels

	network:create("getProfessionLevel", "BindableFunction", "OnInvoke", getProfessionLevel)
	network:create("grantProfessionExp", "BindableFunction", "OnInvoke", grantProfessionExp)
end

return module