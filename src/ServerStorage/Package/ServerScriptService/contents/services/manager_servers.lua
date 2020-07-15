local dc={}local _d="pl-"..tostring(game.PlaceId)
local ad=game:GetService("HttpService")local bd=game:GetService("MessagingService")
local cd=game:GetService("RunService")local dd=game:GetService("ReplicatedStorage")
local __a=require(dd.modules)local a_a=__a.load("network")local b_a=__a.load("utilities")
local c_a,d_a;local _aa;local aaa={}local baa=Instance.new("StringValue")
baa.Name="serversData"baa.Parent=game.ReplicatedStorage
local function caa()baa.Value=ad:JSONEncode(aaa)end
local function daa(bba)local cba=bba.Data;local dba=bba.Sent;local _ca=cba.jobId
if _ca~=game.JobId then
if
cba.status=="open"then aaa[tostring(_ca)]={players=cba.players,updated=dba}elseif
cba.status=="close"then aaa[tostring(_ca)]=nil end;caa()end end;local _ba
local function aba()
if
game.PrivateServerId==""and game.PlaceId~=4561988219 and game.PlaceId~=4041427413 then local bba,cba;repeat
wait(1)
bba,cba=pcall(function()_aa=bd:SubscribeAsync(_d,daa)end)until bba
game:BindToClose(function()_ba=true;if
game:GetService("RunService"):IsStudio()then return end
local dba={jobId=game.JobId,status="close"}local _ca,aca;repeat
_ca,aca=pcall(function()bd:PublishAsync(_d,dba)end)wait(1)until _ca end)
while not _ba do
local dba={jobId=game.JobId,status="open",players=#game.Players:GetPlayers()}
local _ca,aca=pcall(function()bd:PublishAsync(_d,dba)end)wait(_ca and 60 or 20)end end end;spawn(aba)
a_a:create("{6EB8C76D-9475-40CA-AEAF-08F75FF38E67}","RemoteFunction","OnServerInvoke",function(bba,cba)
if aaa[cba]then
if bba.Character and
bba.Character.PrimaryPart then
if
bba.Character.PrimaryPart.state.Value~="dead"and
bba.Character.PrimaryPart.health.Value>0 then
a_a:invoke("{BFC58A69-50E2-4B4A-B15A-FB2B9E21BB21}",bba,game.PlaceId,cba)end end;return true end;return false end)
a_a:create("{2A007D14-8D6B-4DF7-96F6-A6F3A0B71EFC}","RemoteFunction","OnServerInvoke",function(bba)
if
bba.Character and bba.Character.PrimaryPart then
if
bba.Character.PrimaryPart.state.Value~="dead"and
bba.Character.PrimaryPart.health.Value>0 then
a_a:invoke("{B8DB181F-39DB-4695-BAAB-5AF049CC046D}",bba,2376885433)end end end)return dc