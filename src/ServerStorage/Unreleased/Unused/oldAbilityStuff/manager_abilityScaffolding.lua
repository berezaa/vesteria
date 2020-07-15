local module = {}

local httpService 		= game:GetService("HttpService")
local teleportService 	= game:GetService("TeleportService")
local messagingService 	= game:GetService("MessagingService")
local replicatedStorage = game:GetService("ReplicatedStorage")
	local modules 		= require(replicatedStorage.modules)
		local network 		= modules.load("network")

local abilityLookup = require(replicatedStorage.abilityLookup)

local function hook_summonSpell()
	local TIMEOUT_FOR_SUMMONING_CROSS_SERVER = 20
	
	local success, sig = pcall(function()
		messagingService:SubscribeAsync("summonSpell", function(message)
			
			local targetPlayerName = message.Data.playerName
			
			if game.Players:FindFirstChild(targetPlayerName) and message.Data.placeId and message.Data.instanceId then
				-- do something duh
					
				if game.Players[targetPlayerName] and game.Players[targetPlayerName].Character and game.Players[targetPlayerName].Character.PrimaryPart then
					game.Players[targetPlayerName].Character.PrimaryPart.Anchored = true
					
					pcall(function()
						abilityLookup[19].summonGate(
							game.Players[targetPlayerName].Character.PrimaryPart.CFrame - Vector3.new(0, game.Players[targetPlayerName].Character.PrimaryPart.Size.Y / 2 + 0.05, 0),
							4,
							nil,
							nil
						)
					end)
				end
				
				teleportService:TeleportToPlaceInstance(
					message.Data.placeId,
					message.Data.instanceId,
					game.Players[targetPlayerName],
					nil,
					{
						destination = message.Data.placeId;
						dataSlot 	= game.Players[targetPlayerName].dataSlot.Value;
						slot 		= game.Players[targetPlayerName].dataSlot.Value;
					}
				)
			end
		end)
	end)
	
	network:create("serverEchoForPlayerSummon", "BindableFunction", "OnInvoke", function(playerName, isAbilitySource)
		
		if isAbilitySource then
			local success2 = pcall(function()
				messagingService:PublishAsync("summonSpell", {
					playerName 	= playerName;
					placeId 	= game.PlaceId;
					instanceId 	= game.JobId;
				})
			end)
		end
		
		local bind = Instance.new("BindableEvent")
		
		delay(TIMEOUT_FOR_SUMMONING_CROSS_SERVER, function()
			bind:Fire()
		end)
		
		local connection = game.Players.PlayerAdded:connect(function(newPlayer)
			if newPlayer.Name == playerName then
				while wait() do
					if newPlayer.Parent == game.Players then
						if newPlayer.Character and newPlayer.Character.PrimaryPart then
							if newPlayer:FindFirstChild("isPlayerSpawning") then
								if newPlayer.isPlayerSpawning.Value == false then
									break
								end
							end
						end
					else
						break
					end
				end
				
				bind:Fire(newPlayer)
			end
		end)
		
		local targetPlayer = bind.Event:Wait()
		
		connection:disconnect()
		
		return targetPlayer
	end)
end

local function main()
	hook_summonSpell()
end

main()

return module