local db=require(script.GameAnalytics)
local _c=require(script.key)local ac=false;local bc=3;db:Init(_c.GameKey,_c.SecretKey)
local cc=game:GetService("ReplicatedStorage")local dc=require(cc.modules)local _d=dc.load("network")
function playerRemoving(b_a)
if
b_a:FindFirstChild("SessionEnded")==nil then
if b_a:FindFirstChild("teleporting")then return false end
if b_a:FindFirstChild("AnalyticsSessionId")then local d_a=0
if
b_a:FindFirstChild("JoinTime")then d_a=os.time()-b_a.JoinTime.Value end
db:SendEvent({["category"]="session_end",["length"]=math.floor(d_a)},b_a)end;local c_a=Instance.new("BoolValue")c_a.Name="SessionEnded"
c_a.Parent=b_a end end
game.Players.PlayerRemoving:connect(playerRemoving)
game:BindToClose(function()if
game:GetService("RunService"):IsStudio()then return end;for b_a,c_a in
pairs(game.Players:GetPlayers())do playerRemoving(c_a)end end)
function playerRequestNewSession(b_a)
if
b_a:FindFirstChild("AnalyticsSessionId")==nil then
local c_a=game:GetService("HttpService"):GenerateGUID(false):lower()local d_a=Instance.new("StringValue")
d_a.Name="AnalyticsSessionId"d_a.Value=c_a;d_a.Parent=b_a
local _aa=_d:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",b_a)if _aa then
_aa.nonSerializeData.incrementPlayerData("sessionCount",1)end
db:SendEvent({["category"]="user",["session_id"]=c_a,["user_id"]=tostring(b_a.userId)},b_a)local aaa=Instance.new("NumberValue")aaa.Value=os.time()
aaa.Name="JoinTime"aaa.Parent=b_a;return c_a end end
_d:create("{CE411E74-1334-428C-8E1A-9480BE291C52}","BindableFunction","OnInvoke",playerRequestNewSession)
_d:create("{C1A7A955-0F0C-4C2A-8248-35F563E8C99D}","RemoteFunction","OnServerInvoke",function()end)
function playerRequestContinueSessionFromTeleport(b_a,c_a,d_a)
if
b_a:FindFirstChild("AnalyticsSessionId")==nil then local _aa=Instance.new("StringValue")
_aa.Name="AnalyticsSessionId"_aa.Value=c_a;_aa.Parent=b_a;if os.time()-d_a<0 or
os.time()-d_a>250000 then d_a=os.time()end
local aaa=Instance.new("NumberValue")aaa.Value=d_a;aaa.Name="JoinTime"aaa.Parent=b_a
spawn(function()
b_a:WaitForChild("DataLoaded",30)
_d:invoke("{6A0193EE-9965-481B-BD03-C21883D9F0A2}",b_a,"teleport:arrived:".. (_G.placeName or"unknown"))end)return true end end
_d:create("{2622D1E7-1984-45B6-97E2-F64594348B36}","BindableFunction","OnInvoke",playerRequestContinueSessionFromTeleport)
_d:create("{401B0523-3B30-4CF3-B61C-B13B9DE5AED2}","RemoteFunction","OnServerInvoke",function()
warn("requestContinueSession has been moved to the server.")end)
local ad=(function(b_a,c_a,d_a,_aa)local aaa=math.floor(_aa*0.7)*0.35
d_a=d_a or"unspecified"d_a=tostring(d_a):gsub('%W','')
db:SendEvent({["category"]="business",["event_id"]=
tostring(c_a)..":"..d_a,["amount"]=math.floor(aaa),["currency"]="USD",["transaction_num"]=1},b_a)if ac then end end)
_d:create("{D6C785B6-5995-421C-8056-66CCDBA04C5C}","BindableFunction","OnInvoke",ad)
local bd=(function(b_a,c_a,d_a,_aa)local aaa="Source"if d_a<0 then aaa="Sink"d_a=math.abs(d_a)end;_aa=
_aa or"unknown:unknown"
db:SendEvent({["category"]="resource",["event_id"]=aaa..
":"..c_a..":".._aa,["amount"]=d_a},b_a)if ac then end end)
_d:create("{DC1AA741-408D-49CF-87F9-CD63B55E82D7}","BindableFunction","OnInvoke",bd)
local cd=function(b_a,c_a,d_a,_aa,aaa)local baa=c_a..":"..d_a
if c_a=="Start"then
db:SendEvent({["category"]="progression",["event_id"]=baa},b_a)elseif c_a=="Fail"or c_a=="Complete"then
db:SendEvent({["category"]="progression",["event_id"]=baa,["attempt_num"]=_aa,["score"]=aaa},b_a)end end
local dd=function(b_a,c_a,d_a)
db:SendEvent({["category"]="design",["event_id"]=c_a,["value"]=d_a},b_a)end
_d:create("{6A0193EE-9965-481B-BD03-C21883D9F0A2}","BindableFunction","OnInvoke",dd)
local __a=(function(b_a,c_a,d_a)if bc>0 then bc=bc-1
db:SendEvent({["category"]="error",["severity"]=c_a,["message"]=d_a},b_a)end end)
_d:create("{79598458-CED2-488B-A719-1E295449F68E}","BindableFunction","OnInvoke",__a)
local a_a=(function(b_a,c_a,d_a)if d_a then
db:SendEvent({["category"]="design",["event_id"]="vintagewin:"..string.lower(c_a),["value"]=1},b_a)end
db:SendEvent({["category"]="design",["event_id"]=
"box:"..string.lower(c_a),["value"]=1},b_a)if ac then end end)