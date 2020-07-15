--Variables
local baseURL = "http://api.gameanalytics.com/v2/"


local replicatedStorage 	= game:GetService("ReplicatedStorage")
	local modules = require(replicatedStorage.modules)
		local network 		= modules.load("network")

--Services
local HTTP = game:GetService("HttpService")

--Normalize strings for GameAnalytics processing
local function normify(str)

	str = string.gsub(string.gsub(str," ","_"),"[^a-zA-Z0-9 - _ :]","")

	
	
	if #str > 30 then
		str = string.sub(str,1,30)
	end
	return str
end

local placeName = "unknown"
_G.placeName = placeName

spawn(function()
	local placeInfo = game.MarketplaceService:GetProductInfo(game.PlaceId,Enum.InfoType.Asset)
	if placeInfo then
		placeName = normify(placeInfo.Name)
		_G.placeName = placeName
	end
end)

GA = {
	PostFrequency = 20,
	
	GameKey = nil,
	SecretKey = nil,
	SessionID = nil,
	Queue = {},
	
	EncodingModules = {},
	Ready = false,
}

function GA:Init(GameKey, SecretKey)
	baseURL = baseURL..GameKey.."/"
	
	GA.GameKey = GameKey
	GA.SecretKey = SecretKey
	GA.SessionID = HTTP:GenerateGUID(false):lower()
	
	--Encoding Modules
	GA.EncodingModules.lockbox = require(script.lockbox)
	GA.EncodingModules.lockbox.bit = require(script.bit).bit	
	GA.EncodingModules.array = require(GA.EncodingModules.lockbox.util.array)
	GA.EncodingModules.stream = require(GA.EncodingModules.lockbox.util.stream)
	GA.EncodingModules.base64 = require(GA.EncodingModules.lockbox.util.base64)
	GA.EncodingModules.hmac = require(GA.EncodingModules.lockbox.mac.hmac)
	GA.EncodingModules.sha256 = require(GA.EncodingModules.lockbox.digest.sha2_256)
	
	
	GA.Base = {
		["device"] = "unknown",
		["v"] = 2,
		["user_id"] = "unknown",
		["client_ts"] = os.time(),
--		["sdk_version"] = "rest api v2",
		["sdk_version"] = "roblox 1.0.1",
		["os_version"] = "windows 10",
		["manufacturer"] = "unknown",
		["platform"] = "windows",	
		["session_id"] = GA.SessionID,
		["session_num"] = 1,
	}
	
	local Data = HTTP:JSONEncode({
		["platform"] = "unknown",
		["os_version"] = "unknown",
		["sdk_version"] = "rest api v2",
	})

	local Headers = {
		Authorization = GA:Encode(Data)
	}



	local Response = HTTP:PostAsync(baseURL.."init", Data, Enum.HttpContentType.ApplicationJson, false, Headers)
	Response = HTTP:JSONDecode(Response)
	
	if not Response.enabled then
		warn("GameAnalytics did not initialize properly!")		
		return
	end
	
	GA.Ready = true
	
	spawn(function()
		while true do
			wait(GA.PostFrequency)
			GA:Post()
		end
	end)
end

game:BindToClose(function()
	if game:GetService("RunService"):IsStudio() then return end
	GA:Post()
	wait(1)
	GA:Post()
end)

function GA:SendEvent(Data, Player)
	
	
	if not GA.Ready then
		warn("GameAnalytics has not been initialized! Call :Init(GameKey, SecretKey) on the module before sending events!")
	end
	
	-- normify strings to comply with GameAnalytics
	
	for key,value in pairs(Data) do
		if type(value) == "string" and key ~= "message" then
			Data[key] = normify(value)
		end
	end
	-- do this BEFORE the base values are assigned	
	
	for i,v in pairs(GA.Base) do
		Data[i] = Data[i] or v
	end
	
	if Player ~= nil and Player.Parent == game.Players then -- Allow game to specify a player (mod by berezaa)
		Data["user_id"] = tostring(Player.userId)
		if Player:FindFirstChild("AnalyticsSessionId") then
			Data["session_id"] = Player.AnalyticsSessionId.Value
		else
			warn("failed to find analytics session for",Player.Name)
		end
	end
	
	local playerClass = "unknown"
	
	local playerData = network:invoke("getPlayerData", Player)
	if playerData then
		if playerData.class then
			playerClass = normify(playerData.class)
		end
		if playerData.sessionCount then
			Data["session_num"] = playerData.sessionCount
		end
	end
	
	Data["client_ts"] = os.time()

		
	-- CLASS
	Data["custom_01"] = playerClass
	-- LOCATION
	Data["custom_02"] = placeName
	
	
	table.insert(GA.Queue, Data)
	return true
end

function GA:Post()
	if not GA.Ready then
		warn("GameAnalytics has not been initialized! Call :Init(GameKey, SecretKey) on the module before sending events!")
		return	
	end
	
	if #GA.Queue > 0 then
		local Data = HTTP:JSONEncode(GA.Queue)
		GA.Queue = {}
		
		
		local Headers = {
			["Authorization"] = GA:Encode(Data);
			["Content-Type"] = "application/json";
		}
		
		local HttpRequest = {
			Url = baseURL.."events";
			Method = "POST";
			Headers = Headers;
			Body = Data;
		}
		local s,ret = pcall(function() return HTTP:RequestAsync(HttpRequest) end)
		
		if not s then
			warn("GameAnalytics post failed without result!")
		elseif (ret.StatusCode and ret.StatusCode ~= 200) then
			warn("GameAnalytics error!", "HTTP", ret.StatusCode, HTTP:JSONEncode(ret))
		end
	end
end

function GA:Encode(body)
	local secretKey = GA.SecretKey
	
	local hmacBuilder = GA.EncodingModules.hmac()
		.setBlockSize(64)
		.setDigest(GA.EncodingModules.sha256)
		.setKey(GA.EncodingModules.array.fromString(secretKey))
		.init()
		.update(GA.EncodingModules.stream.fromString(body))
		.finish()
	return GA.EncodingModules.base64.fromArray(hmacBuilder.asBytes())
end

return GA