
local module = {}

local httpService 		= game:GetService("HttpService")
local replicatedStorage = game:GetService("ReplicatedStorage")
	local modules 		= require(replicatedStorage.modules)
		local network 		= modules.load("network")
		local utilities 	= modules.load("utilities")


local messagingConnections = {}

local runService = game:GetService("RunService")

local function reportError(player, Type, Error)
	if not runService:IsRunMode() then
		network:invoke("reportError", player, Type, Error)
	end
end

local function onPlayerAdded(player)
	
	local iniSuccess, iniErr = pcall(function()
		
		local referrals = Instance.new("IntValue")
		referrals.Name = "referrals"
		
		
		local data = network:invoke("getPlayerData", player)
		if data and data.globalData and data.globalData.referrals then
			referrals.Value = data.globalData.referrals 
		end
		
		referrals.Parent = player
		
		local success, err
		
		repeat		
			success, err = pcall(function()
				
				if messagingConnections[player.Name] then
					messagingConnections[player.Name]:Disconnect()
					messagingConnections[player.Name] = nil
				end
				
				messagingConnections[player.Name] = game:GetService("MessagingService"):SubscribeAsync("user-"..tostring(player.userId), function(message)
					
					local msgSuccess, msgError = pcall(function()
				
					
						-- REFERRAL!!!
						local data = message.Data
						local referredUserId = data.referredUserId
						local referredUsername = data.referredUsername
						
						if referredUserId then	
							
							local playerData = network:invoke("getPlayerData", player)
							if playerData then
								local globalData = playerData.globalData
								if globalData then				
							
									if globalData.referredUserIds then
										for i,existingReferral in pairs(globalData.referredUserIds) do
											if existingReferral == referredUserId then
											
												local Error = "A user ("..player.Name..") attempted to double refer."
												network:invoke("reportError", player, "debug", Error)										
												
												player:Kick("Attempt to refer an already-referred user")
												return false
											end
										end
									end
									
									local msuccess, merr = pcall(function()
										game:GetService("MessagingService"):PublishAsync("acceptedReferrals", data.referredUserId)
									end)		
									if msuccess then		
										network:fireAllClients("signal_alertChatMessage", {Text = "✉️ " .. player.Name .. " just referred ".. (referredUsername or "???") .. "!"; Font = Enum.Font.SourceSansBold; Color = Color3.fromRGB(23, 234, 118)} )	
							
										local rewards = {
					
											-- megaphones
											{id = 166; stacks = 1};
									
										}
										
										
										spawn(function()
											game.BadgeService:AwardBadge(player.userId,2124469284)
										end)					
												
										local success = network:invoke("tradeItemsBetweenPlayerAndNPC", player, {}, 0, rewards, 0, "gift:referral", {}) 					
										if not success then
											if player.Character and player.Character.PrimaryPart then
												local gift = network:invoke("spawnItemOnGround", {id = 166}, player.Character.PrimaryPart.Position + player.Character.PrimaryPart.CFrame.lookVector * 2, {player})
											end
										end
										
										network:invoke("reportAnalyticsEvent",player,"referral:accepted")
										
					
										globalData.referrals = (globalData.referrals or 0) + 1
										
										globalData.referredUserIds = globalData.referredUserIds or {}
										table.insert(globalData.referredUserIds, referredUserId)
										
										playerData.nonSerializeData.setPlayerData("globalData", globalData)
										referrals.Value = globalData.referrals 
								
											
										network:fireClient("alertPlayerNotification", player,{
											text 					= "You referred "..(referredUsername or "???").." to Vesteria!";
											textColor3 				= Color3.new(0,0,0);
											backgroundColor3 		= Color3.fromRGB(23, 234, 118);
											backgroundTransparency 	= 0;
											textStrokeTransparency 	= 1;
											font 					= Enum.Font.SourceSansBold;
										}, 6, "ethyr1" )
									end
								end
								
							end	
						end
	
					end)
					
					if not msgSuccess then
						reportError(player, "error", "messagingService subscription error: "..msgError)
						warn("Subscription error:",msgError)
					end
				end)	
			end)
		
			if not success then
				reportError(player, "error", "messagingService subscription failed: "..err)
			end	
			
			wait(15)
		
		until success or player.Parent ~= game.Players
		
	end)
	if not iniSuccess then
		reportError(player, "error", "Error setting up messagingService: "..iniErr)
	end	
end

local function onPlayerRemoving(player)
	local connections = 0
	local removedConnections = 0
	for playerName, connection in pairs(messagingConnections) do
		connections = connections + 1
		if connection and (playerName == player.Name or game.Players:FindFirstChild(playerName) == nil) then
			connection:Disconnect()
			messagingConnections[playerName] = nil
			removedConnections = removedConnections + 1
		end
	end
end

game.Players.PlayerRemoving:connect(onPlayerRemoving)

network:connect("playerDataLoaded", "Event", onPlayerAdded)


		
return module
