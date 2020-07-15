

local Analytics = require(script.GameAnalytics)

local key = require(script.key)

local DEBUG = false

local errorchache = 3

Analytics:Init(key.GameKey, key.SecretKey)

local replicatedStorage 	= game:GetService("ReplicatedStorage")
	local modules = require(replicatedStorage.modules)
		local network 		= modules.load("network")


function playerRemoving(Player)
	if Player:FindFirstChild("SessionEnded") == nil then
		if Player:FindFirstChild("teleporting") then
			return false
		end
		if Player:FindFirstChild("AnalyticsSessionId") then
			local Length = 0
			if Player:FindFirstChild("JoinTime") then
				Length = os.time() - Player.JoinTime.Value
			end	
			Analytics:SendEvent({
				["category"] = "session_end",
				["length"] = math.floor(Length),
			}, Player)
		end	
		local Tag = Instance.new("BoolValue")
		Tag.Name = "SessionEnded"
		Tag.Parent = Player				
	end

end

game.Players.PlayerRemoving:connect(playerRemoving)
game:BindToClose(function()
	if game:GetService("RunService"):IsStudio() then return end

	for i,Player in pairs(game.Players:GetPlayers()) do
		playerRemoving(Player)
	end

end)

function playerRequestNewSession(Player)
	
	if Player:FindFirstChild("AnalyticsSessionId") == nil then
		local SessionId = game:GetService("HttpService"):GenerateGUID(false):lower()
		local Tag = Instance.new("StringValue")
		Tag.Name = "AnalyticsSessionId"
		Tag.Value = SessionId
		Tag.Parent = Player	
		

		
		local playerData = network:invoke("getPlayerData", Player)
		if playerData then
			playerData.nonSerializeData.incrementPlayerData("sessionCount", 1)
		end

		
		Analytics:SendEvent({
			["category"] = "user",
			["session_id"] = SessionId,
			["user_id"] = tostring(Player.userId),
		}, Player)
		local TimeStamp = Instance.new("NumberValue")
		TimeStamp.Value = os.time()
		TimeStamp.Name = "JoinTime"
		TimeStamp.Parent = Player	
		return SessionId
	end
end
network:create("newSession","BindableFunction","OnInvoke",playerRequestNewSession)
network:create("requestNewSession","RemoteFunction","OnServerInvoke",function() end)

function playerRequestContinueSessionFromTeleport(Player, SessionId, JoinTimeStamp)
	if Player:FindFirstChild("AnalyticsSessionId") == nil then
		local Tag = Instance.new("StringValue")
		Tag.Name = "AnalyticsSessionId"
		Tag.Value = SessionId
		Tag.Parent = Player	
		
		-- TimeStamp sanity check
		if os.time() - JoinTimeStamp < 0 or os.time() - JoinTimeStamp > 250000 then
			JoinTimeStamp = os.time()
		end
		
		local TimeStamp = Instance.new("NumberValue")
		TimeStamp.Value = JoinTimeStamp
		TimeStamp.Name = "JoinTime"
		TimeStamp.Parent = Player			
		spawn(function()
			Player:WaitForChild("DataLoaded",30)
			network:invoke("reportAnalyticsEvent",Player,"teleport:arrived:"..(_G.placeName or "unknown"))

		end)
		return true
	end	
end
network:create("continueSession", "BindableFunction", "OnInvoke", playerRequestContinueSessionFromTeleport)
network:create("requestContinueSession","RemoteFunction","OnServerInvoke",function() warn("requestContinueSession has been moved to the server.") end)

local PurchaseMade = (function(Player, Category, Product, Amount)
	local Cents = math.floor(Amount * 0.7) * 0.35
	Product = Product or "unspecified"
	Product = tostring(Product):gsub('%W','')
	Analytics:SendEvent({
		
		
		["category"] = "business",
		["event_id"] = tostring(Category)..":"..Product,
		["amount"] = math.floor(Cents),
		["currency"] = "USD",
		["transaction_num"] = 1,

	}, Player)
	
	if DEBUG then

	end	
end)
network:create("purchaseMade", "BindableFunction", "OnInvoke", PurchaseMade)

local CurrencyEvent = (function(Player, Currency, Amount, Source)
	local flowType = "Source"
	
	if Amount < 0 then
		flowType = "Sink"
		Amount = math.abs(Amount)
	end
	
	Source = Source or "unknown:unknown"
	
	Analytics:SendEvent({
		["category"] = "resource",
		["event_id"] = flowType..":"..Currency..":"..Source,
		["amount"] = Amount,

	}, Player)	
	if DEBUG then

	end			
end)
network:create("reportCurrency", "BindableFunction", "OnInvoke", CurrencyEvent)

local ReportProgression = function(Player, Status, EventId, Attempt, Score)
	local EventId = Status..":"..EventId
	if Status == "Start" then
		Analytics:SendEvent({
			["category"] = "progression",
			["event_id"] = EventId,
		}, Player)		
	elseif Status == "Fail" or Status == "Complete" then
		Analytics:SendEvent({
			["category"] = "progression",
			["event_id"] = EventId,
			["attempt_num"] = Attempt,
			["score"] = Score
		}, Player)			
	end
end

local ReportEvent = function(Player, EventId, Value)
	Analytics:SendEvent({
		["category"] = "design",
		["event_id"] = EventId,
		["value"] = Value,
	}, Player)
end
network:create("reportAnalyticsEvent","BindableFunction","OnInvoke",ReportEvent)

local ReportError = (function(Player, Severity, Message)
	if errorchache > 0 then
		errorchache = errorchache - 1
		Analytics:SendEvent({
			["category"] = "error",
			["severity"] = Severity,
			["message"] = Message,
		}, Player)		
	end
end)

network:create("reportError","BindableFunction","OnInvoke",ReportError)

local PlayerOpenBox = (function(Player, Box, VintageWin)

	if VintageWin then
		Analytics:SendEvent({
			["category"] = "design",
			["event_id"] = "vintagewin:"..string.lower(Box),
			["value"] = 1
		}, Player)		
	end
	Analytics:SendEvent({
		["category"] = "design",
		["event_id"] = "box:"..string.lower(Box),
		["value"] = 1
	}, Player)	
	if DEBUG then

	end			
end)
--[[
local ErrorCache = {}

function ErrorExists(Error)
	for i,Err in pairs(ErrorCache) do
		if Err == Error then
			return true
		end
	end
	return false
end

game:GetService("ScriptContext").Error:connect(function (message, stack)
	local Error = tostring(message).." : "..tostring(stack)	
	if not ErrorExists(Error) then
		Analytics:SendEvent({
			["category"] = "error",
			["severity"] = "error",
			["message"] = "Server: "..Error
		})
	end
end)
]]
--[[
game.ReplicatedStorage.ClientError.OnServerEvent:connect(function(Player, message, stack)
	Analytics:SendEvent({
		["category"] = "error",
		["severity"] = "error",
		["message"] = tostring(Player.userId)..": "..tostring(message).." : "..tostring(stack)	
	})	
end)
]]