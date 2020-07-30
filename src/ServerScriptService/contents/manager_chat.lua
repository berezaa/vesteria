local module = {}
local textService = game:GetService("TextService")

local modules = require(game.ReplicatedStorage.modules)
	local network = modules.load("network")

local function onPlayerChatted(player, message)
	if message == "" then
		return
	end
	
	local successForTextFilterResult, textFilterResult = pcall(function() textService:FilterStringAsync(message, player.userId) end)
	if successForTextFilterResult then
		for i, oPlayer in pairs(game.Players:GetPlayers()) do
			if oPlayer ~= player then
				local success, filterMessage = pcall(function() textFilterResult:GetChatForUserAsync(oPlayer.userId) end)
				if success then
					network:fireClient("playerChatted", oPlayer, player.Name, filterMessage)
				else
					network:fireClient("playerChatted", oPlayer, nil, "A message from " .. player.Name .. " failed to send.")
				end
			end
		end
	end
end

local function main()
	network:create("playerChatted", "RemoteEvent", "OnServerEvent", onPlayerChatted)
end

main()

return module