-- main menu control script

return function()
local replicatedStorage = game:GetService("ReplicatedStorage")
	local modules 			= require(replicatedStorage:WaitForChild("modules"))
		local network 			= modules.load("network")
		local configuration 	= modules.load("configuration")

		
		
local banList = {"chrisinator66";"Guest40231";"pup115888";"inearthly";"ReferalKing";"Raqnaar";"ivorfy";
"Axdreid";"Avalian";"Silent_Karasu";"QuakeBeard";"Harder_Dude";"howdoisnarfsnarf";
"GusFront";"longrod247";"JokeChef";"A4lt";"FEIMZIGRON";"cmack4243";
"buttmanthecool";"in2dream";"Linqed";"Ascusis";"RandomUsername64x";"decaul";"Fluxxxx_222";
"SpiritedNoFace";"Yoclash";"WrongStarZ";"JosephCorozzo";"YouKindaCutee";"Triseria";"Chronicxz";
"winter_soldat";"ctjepkes";"Gmasterjkh";"aleccc";"caine_felix";"EchikaKurosaki";"goithefat1";"Kyene";"AddictBloxy";"Thyemium";"RandoOof";"Xena_SR";"ASecretNote";
"MGsha3883";"FlamingExpert";"Alex_itk";"Imperfectjosh";"firestoney";"certifiedkidfiddler";
"thebowmaster2345";"willow";"Dvcember";"Cozmicc";"insaisissable";"GodzLightning";"WhiiteBeard";"swamp";"TehChickenBoy";"Gamer1OderSoHD";"boobuu444";"zxZTHeDeMonZxz";"kerso";"Wen3698";"iRunBoYi";
"TrollLexBR2";"VesteriaFreak";"Storage_Magical6";"link2uu";
"TheTruSucc";"Dony164";"sourtings";"DevilsSoul";"TheDark_Mage";
"LittlePeep";"K4Kiva";"Alekx1235x";"Kain87";"RONKLEY";"I7906";"chino146";"lightdarksun";
"LokiCard";"Thistlerow";"4legitly";"MikeGarciaAGM";"teuwaiseuu";"x0iAlan";"Achillez";"Christmas_Awaits";"YoRHa_9S";"shadowrider101";"Zaharielekk";"Maserq";
"Impossibilities";"25nite";"SaxoMaxyy";"rayverberm24";"Athynasius";"Avalinity";"Chro11oLucifer";"Ansonabc";"bf_g50";"SpeedWolfBG";
"cghcgh25801";"superbaconplayer1020";"Gidein";"m4nil410";
"SquishyRockets";"kxlebs";"VesteriaReferrals";"YezzSirrr";"Ezmaster01";"Vesteriakills";"Zinszo";"0dd_1";"Xorias";"ViaDarkNessTH";"AeonixTheFiend";
"nex_s2";"Kain2212";"Jank_z";"ScroogeMcDuck3679";"HieiSan";"aleister90";"BoneChills";
"Ros_ilia";"darkghost110";"DisastrousTemptation";"overpath41";"LesRocket";"wraithies";"JameO1818";"Decryptional";"F_oop";"AltVaziec";"alphabeto2444";"decryptedMIRAGE";"ThatCriminal";"TurkiSD";"VesteriaStoranger";
"CaterBois";"GeeTeeArgh";"decipheredENIGMA";"theRGBKing";
"IIIIIlllllllIIllIIIl";"MemezzMachine";"BIGLIVERTHEMAX1212"; "xxxwomenbeater62"; "vsk_0"; "vsk_god"; "dad_killer69"; "EpicMetatableMoment";
"children_sniffer72"; "vsk_1"; "Legoracer", "X6M"; "Draco7898"}		
		
local banUserIdList = {}

spawn(function()
	for i, playerName in pairs(banList) do
		pcall(function()
			local userId = game.Players:GetUserIdFromNameAsync(playerName)
			if userId then
				table.insert(banUserIdList, userId)
			end
		end)
	end
end)		
		
local function checkBanList(player)
	for i, playerName in pairs(banList) do
		if player.Name == playerName then
			player:Kick("Banned")
			return false
		end
	end
	for i, userId in pairs(banUserIdList) do
		if player.userId == userId then
			player:Kick("Banned")
			return false
		end
	end
	return true
end

game.Players.PlayerAdded:Connect(checkBanList)
	
local playerGlobalDataContainer = {}

local paymentDataCache = {}
local playerAnalyticsId = {}

local transactionPendingHold = {}

local ProductCache = {d = "1"}

network:create("globalDataUpdated", "RemoteEvent")

game:GetService("MarketplaceService").ProcessReceipt = function(receiptInfo)
	
	local player = game.Players:GetPlayerByUserId(receiptInfo.PlayerId)
	if not player then
		-- no player, abort.
		warn("aborted purchase due to missing player")
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end
	
	if player:FindFirstChild("DataSaveFailed") then
		-- player data has failed to save, abort.
		warn("aborted purchase due to save failure")
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end
	

	local processingStartTime = tick()
	
	-- ensure the player data is loaded in
	repeat wait(0.1) until player == nil or player.Parent ~= game.Players or playerGlobalDataContainer[player] or tick() - processingStartTime > 15
	
	if player and player.Parent == game.Players and playerGlobalDataContainer[player] then
	
		local playerGlobalData = playerGlobalDataContainer[player]
	
		paymentDataCache[player] = paymentDataCache[player] or {}
		local playerPaymentDataCache = paymentDataCache[player]
		playerPaymentDataCache.payments = playerPaymentDataCache.payments or {}	
		
		local doFinishTransaction
		local modifiedGlobalPlayerData
		
		-- Do not modify data if payment has already been cached this session
		if playerPaymentDataCache.payments[receiptInfo.PurchaseId] then
			doFinishTransaction = true
		else
			doFinishTransaction, modifiedGlobalPlayerData = network:invoke("processPayment", player, receiptInfo, playerGlobalData)
		end
		
		-- Cache previously-accepted payments in case data doesn't save
		if doFinishTransaction and modifiedGlobalPlayerData then
			playerPaymentDataCache.payments[receiptInfo.PurchaseId] = true
			playerGlobalData = modifiedGlobalPlayerData
			playerGlobalDataContainer[player] = modifiedGlobalPlayerData
		end

		if doFinishTransaction then
			
			local transactionHoldTime = os.time()
			transactionPendingHold[player] = transactionHoldTime
			
			playerGlobalData.version = playerGlobalData.version + 1
			
			local success, status, version = network:invoke("setPlayerGlobalData", player, playerGlobalData)
			
			if transactionPendingHold[player] == transactionHoldTime then
				transactionPendingHold[player] = nil
			end
			
			if success then
				playerPaymentDataCache.globalDataVersion = version
				spawn(function()		
					local ProductName = ProductCache[receiptInfo.ProductId]
					if ProductName == nil then
						local Product = game.MarketplaceService:GetProductInfo(receiptInfo.ProductId,Enum.InfoType.Product)
						if Product then
							ProductName = Product.Name
							ProductCache[receiptInfo.ProductId] = ProductName
						else
							ProductName = "unknown"
						end
					end
					print("transaction recorded:", ProductName)
					network:invoke("purchaseMade", player, "Product", ProductName, receiptInfo.CurrencySpent)
				end)		
				
				
				network:fireClient("globalDataUpdated", player, playerGlobalData)
				print("Transaction success")
				return Enum.ProductPurchaseDecision.PurchaseGranted
				
			else
				warn("Transaction failed")
				return Enum.ProductPurchaseDecision.NotProcessedYet
			end			
		end
	
	
	end
	warn("no player global data found")
	
	return Enum.ProductPurchaseDecision.NotProcessedYet
end


network:create("loadGame", "RemoteFunction", "OnServerInvoke", function(player)
	
	if not checkBanList(player) then
		return false
	end
	
	print("starting new session")
	playerAnalyticsId[player] = network:invoke("newSession", player)	
	print(playerAnalyticsId[player])	
	
	
	local success, data, status = network:invoke("getPlayerGlobalData", player)
	if success then
		
		if data == nil then
			local newtag = Instance.new("BoolValue")
			newtag.Name = "newPlayerTag"
			newtag.Parent = player		
		end
		
		
		playerGlobalDataContainer[player] = data or {}
		

		
		return success, data, status
	end


	return false, nil, status
end)	

local referralStore = game:GetService("DataStoreService"):GetDataStore("Referrals2")

local referralConnection

local isMessagingEnabled, messagingError
spawn(function()
	repeat 
		isMessagingEnabled, messagingError = pcall(function()
			
			if referralConnection then
				referralConnection:Disconnect()
				referralConnection = nil
			end
			
			referralConnection = game:GetService("MessagingService"):SubscribeAsync("acceptedReferrals", function(message)
		
				local userId = message.Data
		
				local hasReferred 
					
				local success, fail = pcall(function()
					
					referralStore:UpdateAsync(tostring(userId), function(previouslyReferred)
						hasReferred = previouslyReferred
						return true
					end)
				
				end)		
				
				if not success then
					warn("oh no!", fail)
				end

				
				local player = game.Players:GetPlayerByUserId(userId)
				if player then
					
					
		

					
					if not hasReferred then
								
						
						local acceptedTag = Instance.new("BoolValue")
						acceptedTag.Name = "acceptedReferral"
						acceptedTag.Parent = player
					end
				end
			end)
		end)
		wait(10)
	until isMessagingEnabled
end)


network:create("sendReferral", "RemoteFunction", "OnServerInvoke", function(player, username)

	
	if not checkBanList(player) then
		return false
	end
	
	if not (isMessagingEnabled and referralConnection ~= nil)  then
		return false, "Roblox's MessagingService is offline. Please wait or rejoin to attempt a referral"
	end
	
	if player:FindFirstChild("acceptedReferral") then
		return false, "Already referred"
	end
	
	if not player:FindFirstChild("newPlayerTag") then
		return false, "Invalid - not a new player"
	end
	if player:FindFirstChild("messagePending") then
		return false, "Invalid - message is already sending"
	end	
	local hasReferred
	local success, err = pcall(function()
		hasReferred = referralStore:GetAsync(tostring(player.userId))
	end)
	if not success then
		return false, "DataStore error - "..(err or "unknown")
	end
	if hasReferred then
		return false, "You've already referred"
	end
	if username == player.Name then
		return false, "You're not funny"
	end

	local userId

	local idSuccess = pcall(function()
		userId = game.Players:GetUserIdFromNameAsync(username)
	end)
	if not idSuccess then
		return false, "Failed to find player userId, try again."
	end

	local tag = Instance.new("StringValue")
	tag.Name = "messagePending"
	tag.Value = username
	tag.Parent = player

	game.Debris:AddItem(tag, 10)

	local messageSuccess, errMsg = pcall(function()
		game:GetService("MessagingService"):PublishAsync("user-"..tostring(userId), {messageType = "referral"; referredUserId = player.userId; referredUsername = player.Name})
	end)
	
	if messageSuccess then

		return true, "Awaiting a response, please do not leave this page..."
	else
		tag:Destroy()
		return false, "Message error - "..(errMsg or "unknown")
	end	
end)




	
game.Players.PlayerRemoving:Connect(function(player)
	playerGlobalDataContainer[player] = nil
	paymentDataCache[player] = nil
	playerAnalyticsId[player] = nil
end)		

--[[
  {
  	"lastSave": {
  		"-slot1": 1549216535,
  		"-slot7": 11,
  		"-slot5": 13,
  		"-slot3": 1549242980,
  		"-slot9": 15,
  		"-slot8": 4,
  		"-slot6": 3,
  		"-slot2": 1549139589,
  		"-slot10": 2,
  		"-slot4": 74
  	},
  	"ethyr": 12100,
  	"itemStorage": [],
  	"saveSlotData": {
  		"-slot4": {
  			"customized": true,
  			"level": 8,
  			"lastLocation": 2093766642,
  			"class": "Adventurer",
  			"accessories": {
  				"hair": 12,
  				"face": 2,
  				"shirtColorId": 4,
  				"undershirt": 2,
  				"skinColorId": 9,
  				"underwear": 4,
  				"hairColorId": 1
  			},
  			"equipment": [{
  				"upgrades": 2,
  				"successfulUpgrades": 2,
  				"position": 1,
  				"id": 3,
  				"modifierData": [{
  					"baseDamage": 5,
  					"dex": 2
  				}, {
  					"baseDamage": 1
  				}],
  				"stacks": 1
  			}]
  		}
  	},
  	"version": 1091
  }	
--]]

local teleportService = game:GetService("TeleportService")


local function getReserveServerKeyForMirrorDestination(destination)
	local reserveServerKey
	local success, err = pcall(function()
		local mirrorWorldStore = game:GetService("DataStoreService"):GetDataStore("mirrorWorld"..configuration.getConfigurationValue("mirrorWorldVersion"))
		reserveServerKey = mirrorWorldStore:GetAsync(tostring(destination))
		if reserveServerKey == nil then
			reserveServerKey = teleportService:ReserveServer(destination) 
			mirrorWorldStore:SetAsync(tostring(destination), reserveServerKey)
		end
	end)
	return reserveServerKey, success, err
end
		
		
network:create("enterGame", "RemoteFunction", "OnServerInvoke", function(player, _, timestamp, slot, customize, realm)
	
	if not checkBanList(player) then
		return false
	end
	
	local rank = player:GetRankInGroup(4238824)
	local isAdmin = true -- rank >=20
	local isLegend = rank >= 2
	local allowedSlots = (isAdmin and 20) or (isLegend and 10) or 4
	
		-- todo remove this lmao
		if not isAdmin then
			player:Kick("Not authorized.")
			return false
		end	

	if slot > allowedSlots then
		player:Kick("Not authorized.")
		return false
	end
	
	if realm == "mirror" then
		-- teleport to the mirror world (admin only)
		if not isAdmin then
			player:Kick("Not authorized.")
			return false
		end		
		
		local destination = 3372071669
		print("Going to the mirror world")
		
		local teleportData = {
			destination 				= destination;
			dataTimestamp 				= timestamp;
			dataSlot					= slot;
			playerAccessories 			= customize;
			arrivingFrom				= game.PlaceId;	
			analyticsSessionId			= player:FindFirstChild("AnalyticsSessionId") and player.AnalyticsSessionId.Value;
			joinTime					= player:FindFirstChild("JoinTime") and player.JoinTime.Value;
		}		
		
		local reserveServerKey = getReserveServerKeyForMirrorDestination(destination)
		if reserveServerKey then
			teleportService:TeleportToPrivateServer(destination, reserveServerKey, {player}, nil, teleportData)
		else
			print("Mirror TP failed")
			return false, "Failed to find key for mirror world teleport"
		end
							
	else
		-- teleport to the normal world (everyone else)
		local realDestination
		
		local playerGlobalData =  playerGlobalDataContainer[player]
		if playerGlobalData and playerGlobalData.saveSlotData then
			local slotData = playerGlobalData.saveSlotData["-slot"..tostring(slot)]
			if slotData and slotData.lastLocation then
				realDestination = slotData.lastLocation
			else
				if game.GameId == 712031239 then
					realDestination = 4041449372
				else
					realDestination = 2064647391
				end
				
			end
		end
		
		if transactionPendingHold[player] then
			local startTime = os.time()
			repeat wait() until transactionPendingHold[player] == nil or player == nil or player.Parent ~= game.Players
			
			if player == nil or player.Parent ~= game.Players then
				return false
			end
		end
		
		local destination = realDestination or (game.GameId == 712031239 and 4041449372) or 2064647391
		
		local playerPaymentDataCache = paymentDataCache[player]
		if playerPaymentDataCache and playerPaymentDataCache.globalDataVersion then
			timestamp = playerPaymentDataCache.globalDataVersion
		end
		
		local wasReferred = player:FindFirstChild("acceptedReferral") and true
		local spawnLocation 
		if not realDestination then 
			spawnLocation = "newb" 
		end
		
		local teleportData = {
			destination = destination;
			dataTimestamp = timestamp;
			dataSlot = slot;
			playerAccessories = customize;
			arrivingFrom = game.PlaceId;	
			analyticsSessionId = player:FindFirstChild("AnalyticsSessionId") and player.AnalyticsSessionId.Value;
			joinTime = player:FindFirstChild("JoinTime") and player.JoinTime.Value;
			wasReferred	= wasReferred;
			spawnLocation = spawnLocation
		}
		network:fireClient("signal_teleport", player, destination)
	
		spawn(function()
			wait(0.5)
			game:GetService("TeleportService"):Teleport(destination, player, teleportData--[[, replicatedStorage:FindFirstChild("teleportUI")]])
		end)		
		
	end
	

end)			
local TeleportService = game:GetService("TeleportService")

local function isUserInSameGame(userId)
	local success, errorMessage, placeId, jobId

	for i=1,2 do
		local psuccess, perror = pcall(function()
			success, errorMessage, placeId, jobId = TeleportService:GetPlayerPlaceInstanceAsync(userId)
		end)
		if psuccess or success or jobId then
			break
		end
	end


	return success, errorMessage, placeId, jobId
end

local function fetchPlayerFriendsInfo(Player, friendInfo)
	print("!!start fetching")

	local onlineFriends = {}

	for i,friend in pairs(friendInfo) do
		if friend.IsOnline then
			if friend.PlaceId and friend.PlaceId > 0 then
				local success, err, placeId, jobId = isUserInSameGame(friend.VisitorId)
				local location = friend.LastLocation
				--[[
				location = string.gsub(location, "playing ", "In ")
				location = string.gsub(location, "Playing ", "In ")
				if string.find(location:lower(), "creating") then
					location = "Roblox Studio"
				end
				if string.find(location, "Vesteria") then
					location = "Main Menu"
				end
				]]
				

				if placeId or jobId then
					
					if placeId == 2376885433 then
						location = "Main Menu"
					else
						pcall(function()
							local info = game.MarketplaceService:GetProductInfo(placeId)
							if info then
								location = "In " .. info.Name
							end
						end)
					end
					
					friend.LastLocation = location					
					
					table.insert(onlineFriends, friend)
				end
			end
		end
	end
	
	print("!!done fetching")
	
	return onlineFriends

	
end

network:create("fetchPlayerFriendsInfo","RemoteFunction","OnServerInvoke",fetchPlayerFriendsInfo)	
	
end