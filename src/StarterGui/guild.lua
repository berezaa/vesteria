local module = {}

-- Guild menu and local guild logic for inviting/other actions
-- Written by berezaa

local menu = script.Parent.gameUI.guild

function module.open()
	menu.Visible = true
end

local httpService = game:GetService("HttpService")

local guildRankValues = {
    member = 1;
    officer = 2;
    general = 3;
    leader = 4;
}


function module.init(Modules)
	local network = Modules.network

	function module.open()
		if not menu.Visible then
			menu.UIScale.Scale = (Modules.input.menuScale or 1) * 0.75
			Modules.tween(menu.UIScale, {"Scale"}, (Modules.input.menuScale or 1), 0.5, Enum.EasingStyle.Bounce)
		end
		Modules.focus.toggle(menu)
	end

	menu.close.Activated:connect(function()
		module.open()
	end)

	module.guildData = {}

	local function getGuildData(guid)
		if guid == "" then
			return nil
		end
		local guildDataFolder = game.ReplicatedStorage:FindFirstChild("guildDataFolder")
		if guildDataFolder then

			local guildDataValue = guildDataFolder:WaitForChild(guid, 3)
			if guildDataValue then
				local guildData = httpService:JSONDecode(guildDataValue.Value)
				return guildData
			end
		end
	end

	local function getGuildPlayerData(player, guid)
		local guildData = getGuildData(guid)
		if guildData == nil then
			return false, "Guild data not found."
		end
		local members = guildData.members
		local guildPlayerData = members[tostring(player.userId)]
		if guildPlayerData == nil then
			return false, "Not a member of guild."
		end
		return guildPlayerData
	end

	local function updatePlayerGuildData()
		local guid = game.Players.LocalPlayer.guildId.Value
		local guildData = getGuildData(guid)
		module.guildData = guildData
		local guildPlayerData = getGuildPlayerData(game.Players.LocalPlayer, guid)
		menu.Parent.inspectPlayer.content.buttons.guild.Visible = false
		if guildData and guildPlayerData then
			local canInvite = guildPlayerData.rank == "leader" or guildPlayerData.rank == "officer" or guildPlayerData.rank == "general"
			menu.Parent.inspectPlayer.content.buttons.guild.Visible = canInvite
			menu.curve.Visible = true
			menu.Parent.right.buttons.openGuild.Visible = true
			menu.curve.intro.title.Text = guildData.name
			menu.curve.intro.notice.value.Text = guildData.notice or "There is no notice at this time."

			local guildLeader = "no one!"
			for userIdString, playerInfo in pairs(guildData.members) do
				if playerInfo.rank == "leader" then
					guildLeader = playerInfo.name
				end
			end

			menu.curve.intro.leader.Text = "led by "..guildLeader

			for i,guildMemberButton in pairs(menu.curve.side.members.list:GetChildren()) do
				if guildMemberButton:IsA("GuiObject") then
					guildMemberButton:Destroy()
				end
			end
			local memberCount = 0
			for memberString, memberData in pairs(guildData.members) do
				local guildMemberButton = menu.curve.side.members.example:Clone()
				guildMemberButton.content.username.Text = memberData.name
				local level = guildMemberButton.content.level.value
				level.Text = "Lvl. "..memberData.level

				local xSize = game.TextService:GetTextSize(level.Text, level.TextSize, level.Font, Vector2.new()).X + 16
				level.Parent.Size = UDim2.new(0, xSize, 0, 20)

				local class = memberData.class
				if class:lower() == "adventurer" then
					guildMemberButton.content.level.emblem.Visible = false
				else
					guildMemberButton.content.level.emblem.Visible = true
					guildMemberButton.content.level.emblem.Image = "rbxgameasset://Images/emblem_"..class:lower()
				end


				local guildMemberRankValue = guildRankValues[memberData.rank] or 0
				guildMemberButton.LayoutOrder = 5-guildMemberRankValue

				guildMemberButton.content.rank.Image = "rbxgameasset://Images/rank_"..memberData.rank:lower()
				guildMemberButton.Parent = menu.curve.side.members.list
				guildMemberButton.Visible = true
				guildMemberButton.Name = memberString
				memberCount = memberCount + 1

				guildMemberButton.Activated:connect(function()
					if guildMemberButton.actions.Visible then
						guildMemberButton.actions.Visible = false
					else
						for i,otherButton in pairs(menu.curve.side.members.list:GetChildren()) do
							if otherButton:IsA("GuiObject") then
								otherButton.actions.Visible = false
								otherButton.ZIndex = 1
							end
						end
						guildMemberButton.actions.Visible = true
						guildMemberButton.ZIndex = 2
					end

				end)

				local exile = guildMemberButton.actions.exile

				local clientRankValue = guildRankValues[getGuildPlayerData(game.Players.LocalPlayer, guid).rank]
				if clientRankValue <= guildMemberRankValue then
					exile.ImageColor3 = Color3.new(0.3,0.3,0.3)
					exile.Active = false
				else
					exile.Activated:connect(function()
						if exile.Active then
							exile.Active = false
							if Modules.prompting_Fullscreen.prompt("Are you sure you wish to EXILE "..memberData.name.." from your guild?") then
								exile.icon.Visible = false
								exile.fail.Visible = false
								exile.success.Visible = false
								local success, reason = network:invokeServer("playerRequest_exileUserIdFromGuild", tonumber(guildMemberButton.Name))
								if not success then
									network:fire("alert", {text = reason; textColor3 = Color3.fromRGB(255, 100, 100);})
									exile.fail.Visible = true
									wait(0.3)
								end

							end
							if exile and exile.Parent then
								exile.Active = true
								exile.success.Visible = false
								exile.fail.Visible = false
								exile.icon.Visible = true
							end
						end
					end)
				end

				for rankName, rankValue in pairs(guildRankValues) do
					local button = guildMemberButton.actions:FindFirstChild(rankName)
					if button then
						if clientRankValue <= guildMemberRankValue or clientRankValue <= rankValue or rankValue == guildMemberRankValue then
							button.ImageColor3 = Color3.new(0.3, 0.3, 0.3)
							button.Active = false
						else
							local userId = tonumber(guildMemberButton.Name)
							button.Activated:connect(function()
								if button.Active then
									button.Active = false
									if Modules.prompting_Fullscreen.prompt("Are you sure you wish to rank "..memberData.name.." to "..rankName:upper().."?") then
										button.icon.Visible = false
										button.fail.Visible = false
										button.success.Visible = false
										local success, reason = network:invokeServer("playerRequest_changeUserIdRankValue", userId, rankValue)
										if not success then
											network:fire("alert", {text = reason; textColor3 = Color3.fromRGB(255, 100, 100);})
											button.fail.Visible = true
											wait(0.3)
										end
									end

									if button and button.Parent then
										button.Active = true
										button.success.Visible = false
										button.fail.Visible = false
										button.icon.Visible = true
									end

								end
							end)
						end
					end
				end



			end
			menu.curve.side.members.title.Text = memberCount .. " " .. (memberCount == 1 and "member" or "members")


		else
			menu.curve.Visible = false
			menu.Parent.right.buttons.openGuild.Visible = false
		end
	end
	spawn(updatePlayerGuildData)
	game.Players.LocalPlayer.guildId.Changed:connect(updatePlayerGuildData)
	network:connect("signal_guildDataUpdated", "OnClientEvent", updatePlayerGuildData)

	-- Invited to join a guild.
	network:connect("serverPrompt_playerInvitedToServer", "OnClientInvoke", function(invitingPlayer, guid)
		local guildDataFolder = game.ReplicatedStorage:FindFirstChild("guildDataFolder")
		if guildDataFolder then
			local guildDataValue = guildDataFolder:FindFirstChild(guid)
			if guildDataValue then
				local guildData = httpService:JSONDecode(guildDataValue.Value)
				if guildData.name then
					return Modules.prompting.prompt(invitingPlayer.Name.." has invited you to join their Guild, " .. guildData.name .. ".")
				end
			end
		end
		return false
	end)

	menu.curve.intro.leave.Activated:connect(function()
		if Modules.prompting_Fullscreen.prompt("Are you sure you wish to LEAVE the guild?") then
			local success, reason = network:invokeServer("playerRequest_leaveMyGuild", false)
			if not success then
				if reason == "confirmAbandon" then
					if Modules.prompting_Fullscreen.prompt("Will you ABANDON your guild? It will be dissolved PERMANENTLY, and you will get NO REFUND.") then
						success, reason = network:invokeServer("playerRequest_leaveMyGuild", true)
					end
				end

				if not success then
					network:fire("alert", {text = reason; textColor3 = Color3.fromRGB(255, 100, 100);})
				end
			end
		end
	end)

end


return module