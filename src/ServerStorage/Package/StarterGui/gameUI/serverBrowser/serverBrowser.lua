local b={}function b.open()end
function b.init(c)local d=game:GetService("HttpService")
local _a;local aa;local ba=c.network
script.Parent.close.MouseButton1Click:connect(function()
c.focus.toggle(script.Parent)end)script.Parent.header.serverId.Text="This server's ID: "..
string.sub(game.JobId,1,8)
function b.open()
if not
script.Parent.Visible then
script.Parent.UIScale.Scale=(c.input.menuScale or 1)*0.75
c.tween(script.Parent.UIScale,{"Scale"},(c.input.menuScale or 1),0.5,Enum.EasingStyle.Bounce)end;c.focus.toggle(script.Parent)end
local function ca()
_a=aa.Value~=""and d:JSONDecode(aa.Value)or{}
for _b,ab in
pairs(script.Parent.servers:GetChildren())do if ab:IsA("GuiObject")then ab:Destroy()end end
_a[game.JobId]={players=#game.Players:GetChildren()}
for _b,ab in pairs(_a)do local bb=script.sample:Clone()
bb.id.Text=string.sub(_b,1,8)bb.Name=_b;local cb=ab.players/game.Players.MaxPlayers
bb.players.progress.Size=UDim2.new(cb,0,1,0)
if cb>=0.9 then
bb.players.progress.BackgroundColor3=Color3.fromRGB(255,0,4)elseif cb>=0.75 then
bb.players.progress.BackgroundColor3=Color3.fromRGB(255,191,0)else
bb.players.progress.BackgroundColor3=Color3.fromRGB(12,255,0)end;bb.LayoutOrder=100 -math.floor(cb*100)
bb.leave.Visible=true;local db=Color3.new(1,1,1)if _b==game.JobId then bb.LayoutOrder=-1
db=Color3.fromRGB(0,255,255)bb.leave.Visible=false end
bb.id.TextColor3=db;bb.players.BorderColor3=db
bb.players.progress.BorderColor3=db;local _c=string.gsub(_b,"[^%d*]","")local ac=
math.floor((tonumber(_c)^ (1 /2)))+1;local bc=Random.new(ac)
bb.ImageColor3=Color3.new(bc:NextNumber(),bc:NextNumber(),bc:NextNumber())
bb.leave.Activated:connect(function()
local cc,dc=ba:invokeServer("{6EB8C76D-9475-40CA-AEAF-08F75FF38E67}",_b)end)bb.Parent=script.Parent.servers end end
local function da()
aa=game.ReplicatedStorage:WaitForChild("serversData")ca()aa.Changed:connect(ca)end;spawn(da)end;return b