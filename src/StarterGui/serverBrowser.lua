local module = {}

local player = game:GetService("Players").LocalPlayer
local gui = player.PlayerGui.gameUI.serverBrowser

function module.open()

end

function module.init(Modules)
	local httpService = game:GetService("HttpService")
	local servers
	local serversDataValue
	local network = Modules.network

	gui.close.MouseButton1Click:connect(function()
		Modules.focus.toggle(gui)
	end)

	gui.header.serverId.Text = "This server's ID: "..string.sub(game.JobId, 1, 8)

	function module.open()
		if not gui.Visible then
			gui.UIScale.Scale = (Modules.input.menuScale or 1) * 0.75
			Modules.tween(gui.UIScale, {"Scale"}, (Modules.input.menuScale or 1), 0.5, Enum.EasingStyle.Bounce)
		end
		Modules.focus.toggle(gui)
	end

	local function updated()
		servers = serversDataValue.Value ~= "" and httpService:JSONDecode(serversDataValue.Value) or {}
		for i,child in pairs(gui.servers:GetChildren()) do
			if child:IsA("GuiObject") then
				child:Destroy()
			end
		end
		servers[game.JobId] = {
			players = #game.Players:GetChildren();
		}
		for jobId, serverData in pairs(servers) do
			local button = gui.sample:Clone()
			button.id.Text = string.sub(jobId, 1, 8)
			button.Name = jobId
			-- same place so same MaxPlayers?
			local serverFilled = serverData.players / game.Players.MaxPlayers
			button.players.progress.Size = UDim2.new(serverFilled, 0, 1, 0)
			if serverFilled >= 0.9 then
				button.players.progress.BackgroundColor3 = Color3.fromRGB(255, 0, 4)
			elseif serverFilled >= 0.75 then
				button.players.progress.BackgroundColor3 = Color3.fromRGB(255, 191, 0)
			else
				button.players.progress.BackgroundColor3 = Color3.fromRGB(12, 255, 0)
			end
			button.LayoutOrder = 100 - math.floor(serverFilled * 100)

			button.leave.Visible = true

			local mainColor = Color3.new(1,1,1)
			if jobId == game.JobId then
				button.LayoutOrder = -1
				mainColor = Color3.fromRGB(0, 255, 255)
				button.leave.Visible = false
			end
			button.id.TextColor3 = mainColor
			button.players.BorderColor3 = mainColor
			button.players.progress.BorderColor3 = mainColor

			local idString = string.gsub(jobId,"[^%d*]","")
			local seed = math.floor((tonumber(idString)^(1/2))) + 1
			local rand = Random.new(seed)
			button.ImageColor3 = Color3.new(
				rand:NextNumber(),
				rand:NextNumber(),
				rand:NextNumber()
			)

			button.leave.Activated:connect(function()
				local success, err = network:invokeServer("playerRequest_teleportToJobId", jobId)
			end)

			button.Parent = gui.servers
		end
	end

	local function main()
		serversDataValue = game.ReplicatedStorage:WaitForChild("serversData")
		updated()
		serversDataValue.Changed:connect(updated)
	end

	spawn(main)
end

return module
