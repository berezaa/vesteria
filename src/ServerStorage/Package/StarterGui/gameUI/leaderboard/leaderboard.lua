local b={}
function b.init(c)local d=c.network;local _a=game:GetService("HttpService")
spawn(function()
local _b=game.ReplicatedStorage:WaitForChild("serversData")
local function ab()
local bb=_b.Value~=""and _a:JSONDecode(_b.Value)local cb=0;if bb then
for db,_c in pairs(bb)do if db~=game.JobId then cb=cb+1 end end end;script.Parent.top.leave.Visible=
bb and cb>0 end;ab()_b.Changed:connect(ab)
script.Parent.top.leave.Activated:Connect(function()
c.serverBrowser.open()end)end)
local function aa(_b,ab,bb)
if _b:FindFirstChild("entity")then _b.entity:Destroy()end
if _b:FindFirstChild("entity2")then _b.entity2:Destroy()end;local cb=_b.CurrentCamera;if cb==nil then cb=Instance.new("Camera")
cb.Parent=_b;_b.CurrentCamera=cb end;local db=ab
local _c=ab.Character;local ac=_b.characterMask;local bc={}bc.equipment=bb.equipment or{}bc.accessories=
bb.accessories or{}
local cc=d:invoke("{01474D9A-12D0-4C30-90B0-649477E2B77A}",ac,bc or{},db)cc.Parent=workspace.CurrentCamera
local dc=cc.entity:WaitForChild("AnimationController")
local _d=d:invoke("{CA61CBF0-3B04-4617-8D2D-50C80D51AB19}",cc.entity)local ad
local bd=d:invoke("{F22A757B-3CF2-4CEE-ACF2-466C636EF6BB}",dc,"idling",ad,nil)
if bd then if typeof(bd)=="Instance"then bd:Play()elseif typeof(bd)=="table"then for cd,dd in pairs(bd)do
dd:Play()end end
spawn(function()
while
true do wait()
if typeof(bd)=="Instance"then if bd.Length>0 then break end elseif
typeof(bd)=="table"then local cd=true
for dd,__a in pairs(bd)do if bd.Length==0 then cd=false end end;if cd then break end end end
if cc then
if _b:FindFirstChild("entity")then _b.entity:Destroy()end;local cd=cc.entity;cd.Parent=_b;cc:Destroy()
local dd=
CFrame.new(cd.PrimaryPart.Position+
cd.PrimaryPart.CFrame.lookVector*6.3,cd.PrimaryPart.Position)*CFrame.new(3,0,0)
cb.CFrame=CFrame.new(dd.p+Vector3.new(0,1.5,0),cd.PrimaryPart.Position+
Vector3.new(0,0.5,0))end end)else local cd=dc:LoadAnimation(ac.idle)cd.Looped=true
cd.Priority=Enum.AnimationPriority.Idle;cd:Play()end end
local ba=script.Parent.content.sample:Clone()
script.Parent.content.sample:Destroy()local ca
local function da()local _b=0
for ab,bb in pairs(game.Players:GetPlayers())do
if
bb:FindFirstChild("DataLoaded")then
if bb.Character and bb.Character.PrimaryPart and
bb.Character.PrimaryPart:FindFirstChild("appearance")then
local cb=bb.Character.PrimaryPart.appearance.Value
local db=game:GetService("HttpService"):JSONDecode(cb)
if db then
local _c=script.Parent.content:FindFirstChild(bb.Name)
if _c==nil then _c=ba:Clone()_c.Name=bb.Name
_c.Parent=script.Parent.content;_c.Visible=true
_c.Activated:connect(function()
c.inspectPlayer.open(bb)c.inspectPlayerPreview.close()end)
_c.MouseEnter:connect(function()ca=_c
c.inspectPlayerPreview.open(bb,_c)end)
_c.SelectionGained:connect(function()ca=_c
c.inspectPlayerPreview.open(bb,_c)end)
_c.MouseLeave:connect(function()if ca==_c then ca=nil
c.inspectPlayerPreview.close()end end)
_c.SelectionLost:connect(function()if ca==_c then ca=nil
c.inspectPlayerPreview.close()end end)_c.LayoutOrder=22 end
if _c.appearance.Value~=cb and c.loadingScreen.loaded then
_c.appearance.Value=cb;aa(_c.character.ViewportFrame,bb,db)end
local ac=bb:FindFirstChild("gold")and bb.gold.Value or 0;c.money.setLabelAmount(_c.content.money,ac)
local bc=
bb:FindFirstChild("level")and bb.level.Value or 0;_c.content.level.value.Text="Lvl."..bc
_c.content.icon.ImageLabel.Image=
"https://www.roblox.com/headshot-thumbnail/image?userId="..bb.userId.."&width=100&height=100&format=png"_c.content.username.Text=bb.Name
local cc=game.Players.LocalPlayer
local dc=cc.Character and cc.Character.PrimaryPart and
cc.Character.PrimaryPart.Position;dc=dc or Vector3.new()
local _d=bb:FindFirstChild("class")and
bb.class.Value:lower()or"unknown"local ad
if _d:lower()~="adventurer"then _c.content.emblem.Image="rbxgameasset://Images/emblem_"..
_d:lower()
_c.content.emblem.Visible=true;ad=true else _c.content.emblem.Visible=false end;local bd=Color3.fromRGB(208,208,208)local cd=(
bb.Character.PrimaryPart.Position-dc).magnitude
local dd=(ca==
nil)and math.clamp(math.ceil(math.sqrt(cd)),1,20)
if bb==cc then dd=-1;bd=Color3.fromRGB(255,206,89)else
local __a=d:invoke("{CEDFACDA-571C-466E-ABA0-F8C24326B4EF}")if __a and __a.members then
for a_a,b_a in pairs(__a.members)do if bb==b_a.player then dd=0
bd=Color3.fromRGB(87,255,255)break end end end end;_c.content.icon.BorderColor3=bd
_c.content.emblem.ImageColor3=bd;_c.content.username.TextColor3=bd
if dd then _c.LayoutOrder=dd end;_b=_b+1 end end end end
script.Parent.content.CanvasSize=UDim2.new(0,0,0,35 *_b)for ab,bb in
pairs(script.Parent.content:GetChildren())do
if bb:IsA("GuiObject")and
game.Players:FindFirstChild(bb.Name)==nil then bb:Destroy()end end end
spawn(function()while wait(1)do da()end end)end;return b