-- Communicates to other servers of the same place and allows players to teleport between them

local module = {}

local placeKey = "pl-"..tostring(game.PlaceId)

local httpService = game:GetService("HttpService")
local messaging = game:GetService("MessagingService")


local network


local success, err
local messagingConnection

local servers = {}

local serversDataValue = Instance.new("StringValue")
serversDataValue.Name = "serversData"
serversDataValue.Parent = game.ReplicatedStorage

local function serversDataUpdated()
	serversDataValue.Value = httpService:JSONEncode(servers)
end

local function registerMessage(message)
	local data = message.Data
	local timestamp = message.Sent
	local jobId = data.jobId
	if jobId ~= game.JobId then
		if data.status == "open" then
			servers[tostring(jobId)] = {
				players = data.players;
				updated = timestamp;
			}
		elseif data.status == "close" then
			servers[tostring(jobId)] = nil
		end
		serversDataUpdated()
	end
end

local function playerRequest_teleportToJobId(player, jobId)
	if servers[jobId] then
		if player.Character and player.Character.PrimaryPart then
			if player.Character.PrimaryPart.state.Value ~= "dead" and player.Character.PrimaryPart.health.Value > 0 then
				network:invoke("teleportPlayerToJobId", player, game.PlaceId, jobId)
			end
		end
		return true
	end
	return false
end

local function playerRequest_returnToMainMenu(player)
	if player.Character and player.Character.PrimaryPart then
		if player.Character.PrimaryPart.state.Value ~= "dead" and player.Character.PrimaryPart.health.Value > 0 then
			network:invoke("teleportPlayer", player, 2376885433)
		end
	end
end


local serverClosing

local function connect()
	if game.PrivateServerId == "" and game.PlaceId ~= 4561988219 and game.PlaceId ~= 4041427413 then
		local success, err
		repeat
			wait(1)
			success, err = pcall(function()
				messagingConnection = messaging:SubscribeAsync(
					placeKey,
					registerMessage
				)
			end)
		until success

		game:BindToClose(function()
			serverClosing = true
			if game:GetService("RunService"):IsStudio() then return end
			local message = {
				jobId = game.JobId;
				status = "close";
			}
			local success, err
			repeat
				success, err = pcall(function()
					messaging:PublishAsync(placeKey, message)
				end)
				wait(1)
			until success

		end)

		while not serverClosing do
			local message = {
				jobId = game.JobId;
				status = "open";
				players = #game.Players:GetPlayers();
			}
			local messageSent, err = pcall(function()
				messaging:PublishAsync(placeKey, message)
			end)
			wait(messageSent and 60 or 20)
		end
	end
end

function module.init(Modules)

	network = Modules.network

	network:create("playerRequest_teleportToJobId", "RemoteFunction", "OnServerInvoke", playerRequest_teleportToJobId)
	network:create("playerRequest_returnToMainMenu", "RemoteFunction", "OnServerInvoke", playerRequest_returnToMainMenu)

	spawn(connect)
end

return module
