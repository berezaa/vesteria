local ab=game:GetService("RunService")local bb={}
local cb=Instance.new("RemoteEvent")local db=Instance.new("RemoteFunction")
local _c=Instance.new("BindableEvent")local ac=Instance.new("BindableFunction")local bc={}bb.log=bc
local cc={fireServer=cb.FireServer,fireClient=cb.FireClient,fireAllClients=cb.FireAllClients,invokeClient=db.InvokeClient,fire=_c.Fire,invoke=ac.Invoke,fireClients=function(ad,bd,...)for cd,dd in
pairs(bd)do ad:FireClient(dd,...)end end,fireAllClientsExcludingPlayer=function(ad,bd,...)
for cd,dd in
pairs(game.Players:GetPlayers())do if dd~=bd then ad:FireClient(dd,...)end end end,fireAllClientsCustomCheck=function(ad,bd,...)
for cd,dd in
pairs(game.Players:GetPlayers())do if bd(dd)==true then ad:FireClient(dd,...)end end end,invokeClients=function(ad,bd,...)local cd={}for dd,__a in pairs(bd)do
cd[__a]=ad:InvokeClient(__a,...)end;return cd end,invokeAllClients=function(ad,...)
local bd={}for cd,dd in pairs(game.Players:GetPlayers())do
bd[dd]=ad:InvokeClient(dd,...)end;return bd end,invokeAllClientsExcludingPlayer=function(ad,bd,...)
local cd={}
for dd,__a in pairs(game.Players:GetPlayers())do if __a~=bd then
cd[__a]=ad:InvokeClient(__a,...)end end;return cd end,invokeAllClientsCustomCheck=function(ad,bd,...)
local cd={}
for dd,__a in pairs(game.Players:GetPlayers())do if bd(__a)==true then
cd[__a]=ad:InvokeClient(__a,...)end end;return cd end}
function bb:create(ad,bd,cd,dd)local __a=script
if ab:IsServer()then
if
bd=="RemoteFunction"and cd=="OnServerInvoke"then bd="BindableFunction"cd="OnInvoke"
__a=game.ServerStorage.serverNetwork elseif bd=="BindableEvent"then __a=game.ServerStorage.serverNetwork elseif
bd=="BindableFunction"then __a=game.ServerStorage.serverNetwork end end
if __a:FindFirstChild(ad)==nil then local a_a=Instance.new(bd)
a_a.Name=ad
if cd and dd then
if bd=="BindableEvent"or bd=="RemoteEvent"then
local b_a=a_a[cd]:connect(dd)a_a.Parent=__a;return a_a,b_a elseif
bd=="BindableFunction"or bd=="RemoteFunction"then a_a[cd]=dd;a_a.Parent=__a;return a_a end end;a_a.Parent=__a else local a_a=__a[ad]
if cd~=nil and dd~=nil then
if bd=="BindableEvent"or bd==
"RemoteEvent"then local b_a=a_a[cd]:connect(dd)
a_a.Parent=__a;return a_a,b_a elseif bd=="BindableFunction"or bd=="RemoteFunction"then
a_a[cd]=dd;a_a.Parent=__a;return a_a end end;return a_a end end
function bb:connect(ad,bd,cd)local dd
if ab:IsServer()then
if bd=="OnServerInvoke"then bd="OnInvoke"
dd=game.ServerStorage.serverNetwork:WaitForChild(ad)elseif bd=="Event"or bd=="OnInvoke"then
dd=game.ServerStorage.serverNetwork:WaitForChild(ad)else dd=script:WaitForChild(ad)end else dd=script:WaitForChild(ad)end
if
dd.ClassName=="BindableEvent"or dd.ClassName=="RemoteEvent"then local __a=dd[bd]:connect(cd)return dd,__a elseif
dd.ClassName=="BindableFunction"or dd.ClassName=="RemoteFunction"then dd[bd]=cd
return dd end end;local function dc(ad,bd)bc[bd]=bc[bd]or{}
bc[bd][ad]=(bc[bd][ad]or 0)+1 end
function bb:invokeServer(ad,...)
dc(ad,"invokeServer")
local bd=game.ReplicatedStorage:WaitForChild("playerRequest")if bd then return bd:InvokeServer(ad,...)else
error("playerRequest not found")end end
local function _d()
setmetatable(bb,{__index=function(ad,bd)
return
function(cd,dd,...)local __a=script
if
ab:IsServer()and(bd=="invoke"or bd=="fire")then __a=game.ServerStorage.serverNetwork end;__a:WaitForChild(dd,60)dc(dd,bd)
return cc[bd](__a[dd],...)end end})end;_d()return bb