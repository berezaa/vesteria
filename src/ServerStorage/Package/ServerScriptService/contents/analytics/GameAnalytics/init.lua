local ca="http://api.gameanalytics.com/v2/"
local da=game:GetService("ReplicatedStorage")local _b=require(da.modules)local ab=_b.load("network")
local bb=game:GetService("HttpService")
local function cb(_c)
_c=string.gsub(string.gsub(_c," ","_"),"[^a-zA-Z0-9 - _ :]","")if#_c>30 then _c=string.sub(_c,1,30)end;return _c end;local db="unknown"_G.placeName=db
spawn(function()
local _c=game.MarketplaceService:GetProductInfo(game.PlaceId,Enum.InfoType.Asset)if _c then db=cb(_c.Name)_G.placeName=db end end)
GA={PostFrequency=20,GameKey=nil,SecretKey=nil,SessionID=nil,Queue={},EncodingModules={},Ready=false}
function GA:Init(_c,ac)ca=ca.._c.."/"GA.GameKey=_c;GA.SecretKey=ac
GA.SessionID=bb:GenerateGUID(false):lower()GA.EncodingModules.lockbox=require(script.lockbox)
GA.EncodingModules.lockbox.bit=require(script.bit).bit
GA.EncodingModules.array=require(GA.EncodingModules.lockbox.util.array)
GA.EncodingModules.stream=require(GA.EncodingModules.lockbox.util.stream)
GA.EncodingModules.base64=require(GA.EncodingModules.lockbox.util.base64)
GA.EncodingModules.hmac=require(GA.EncodingModules.lockbox.mac.hmac)
GA.EncodingModules.sha256=require(GA.EncodingModules.lockbox.digest.sha2_256)
GA.Base={["device"]="unknown",["v"]=2,["user_id"]="unknown",["client_ts"]=os.time(),["sdk_version"]="roblox 1.0.1",["os_version"]="windows 10",["manufacturer"]="unknown",["platform"]="windows",["session_id"]=GA.SessionID,["session_num"]=1}
local bc=bb:JSONEncode({["platform"]="unknown",["os_version"]="unknown",["sdk_version"]="rest api v2"})local cc={Authorization=GA:Encode(bc)}
local dc=bb:PostAsync(ca.."init",bc,Enum.HttpContentType.ApplicationJson,false,cc)dc=bb:JSONDecode(dc)if not dc.enabled then
warn("GameAnalytics did not initialize properly!")return end;GA.Ready=true
spawn(function()while true do
wait(GA.PostFrequency)GA:Post()end end)end
game:BindToClose(function()if
game:GetService("RunService"):IsStudio()then return end;GA:Post()wait(1)GA:Post()end)
function GA:SendEvent(_c,ac)if not GA.Ready then
warn("GameAnalytics has not been initialized! Call :Init(GameKey, SecretKey) on the module before sending events!")end;for dc,_d in
pairs(_c)do
if type(_d)=="string"and dc~="message"then _c[dc]=cb(_d)end end;for dc,_d in pairs(GA.Base)do
_c[dc]=_c[dc]or _d end
if ac~=nil and ac.Parent==game.Players then
_c["user_id"]=tostring(ac.userId)
if ac:FindFirstChild("AnalyticsSessionId")then
_c["session_id"]=ac.AnalyticsSessionId.Value else
warn("failed to find analytics session for",ac.Name)end end;local bc="unknown"
local cc=ab:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",ac)
if cc then if cc.class then bc=cb(cc.class)end;if cc.sessionCount then
_c["session_num"]=cc.sessionCount end end;_c["client_ts"]=os.time()_c["custom_01"]=bc
_c["custom_02"]=db;table.insert(GA.Queue,_c)return true end
function GA:Post()
if not GA.Ready then
warn("GameAnalytics has not been initialized! Call :Init(GameKey, SecretKey) on the module before sending events!")return end
if#GA.Queue>0 then local _c=bb:JSONEncode(GA.Queue)GA.Queue={}
local ac={["Authorization"]=GA:Encode(_c),["Content-Type"]="application/json"}local bc={Url=ca.."events",Method="POST",Headers=ac,Body=_c}
local cc,dc=pcall(function()return
bb:RequestAsync(bc)end)
if not cc then
warn("GameAnalytics post failed without result!")elseif(dc.StatusCode and dc.StatusCode~=200)then
warn("GameAnalytics error!","HTTP",dc.StatusCode,bb:JSONEncode(dc))end end end
function GA:Encode(_c)local ac=GA.SecretKey
local bc=GA.EncodingModules.hmac().setBlockSize(64).setDigest(GA.EncodingModules.sha256).setKey(GA.EncodingModules.array.fromString(ac)).init().update(GA.EncodingModules.stream.fromString(_c)).finish()return
GA.EncodingModules.base64.fromArray(bc.asBytes())end;return GA