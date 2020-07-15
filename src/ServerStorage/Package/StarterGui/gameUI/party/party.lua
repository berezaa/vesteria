local c={}local d=game.Players.LocalPlayer
function c.init(_a)local aa=_a.network;local ba=_a.tween
local ca=_a.fx;local da=_a.utilities;local _b=false;local ab={}c.currentPartyInfo=nil
aa:create("{CEDFACDA-571C-466E-ABA0-F8C24326B4EF}","BindableFunction","OnInvoke",function()
if
c.currentPartyInfo then c.currentPartyInfo.isClientPartyLeader=_b end;return c.currentPartyInfo end)
local function bb()local bd=100;if
script.Parent.contents.invite.textBox.Visible then bd=bd+150 end;if
script.Parent.contents.invite.leave.Visible then bd=bd+50 end
script.Parent.contents.invite.Size=UDim2.new(0,bd,0,60)end
local function cb()
if
script.Parent.contents.invite.textBox.Visible then
script.Parent.contents.invite.button.Active=true
if
game.Players:FindFirstChild(script.Parent.contents.invite.textBox.Text)then
script.Parent.contents.invite.button.ImageColor3=Color3.fromRGB(82,255,71)
script.Parent.contents.invite.button.detail.Text=">"else
script.Parent.contents.invite.button.ImageColor3=Color3.fromRGB(247,138,64)
script.Parent.contents.invite.button.detail.Text="-"end else
script.Parent.contents.invite.button.detail.Text="+"
if
c.currentPartyInfo==nil or#c.currentPartyInfo.members<6 then
script.Parent.contents.invite.button.ImageColor3=Color3.fromRGB(93,249,249)
script.Parent.contents.invite.button.Active=true else
script.Parent.contents.invite.button.ImageColor3=Color3.fromRGB(180,180,180)
script.Parent.contents.invite.button.Active=false end end;bb()end;cb()local db
script.Parent.contents.invite.textBox.Changed:connect(cb)
script.Parent.contents.invite.leave.MouseButton1Click:connect(function()
script.Parent.contents.invite.leave.ImageColor3=Color3.new(0.7,0.7,0.7)
aa:invokeServer("{8E8FADC7-1F67-4F9B-BD17-CD405776FEFC}")
script.Parent.contents.invite.leave.ImageColor3=Color3.fromRGB(246,58,63)end)
local function _c()_a.focus.cleanup()
local bd=script.Parent.contents.invite;bd.button.Visible=true;bd.ImageLabel.Visible=true
script.Parent.contents.invite.textBox.Visible=false
ba(script.Parent.contents.invite,{"ImageTransparency"},0.7,0.3)
if db then
if db and db.Parent then
ba(db,{"ImageTransparency","ImageColor3"},{0.5,Color3.new(0,0,0)},0.5)db.details.Visible=false end;db=nil end;cb()end
local function ac()
if
c.currentPartyInfo==nil or#c.currentPartyInfo.members<6 then
script.Parent.contents.invite.textBox.Text=""
script.Parent.contents.invite.textBox.Visible=true
ba(script.Parent.contents.invite,{"ImageTransparency"},0,0.3)end
if _a.input.mode.Value=="xbox"then
if game.GuiService.SelectedObject and
game.GuiService.SelectedObject:IsDescendantOf(script.Parent)then _c()else
_a.focus.change(script.Parent)
game.GuiService.SelectedObject=script.Parent.contents.invite end end;cb()end
script.Parent.contents.invite.button.MouseButton1Click:connect(function()
if
script.Parent.contents.invite.button.Active then
local bd=script.Parent.contents.invite.button.detail.Text
if bd==">"then local cd,dd=false,"Could not find player"
local __a=game.Players:FindFirstChild(script.Parent.contents.invite.textBox.Text)if __a then
cd,dd=aa:invokeServer("{AB032646-DB09-4482-B67B-0F1EA25F97EF}",__a)end
local a_a=script.Parent.contents.invite;local b_a=1
if cd then
_a.notifications.alert({text="Invited "..__a.Name.." to the party."},2)a_a.button.Visible=false;a_a.leave.Visible=false
a_a.textBox.Visible=false;a_a.ImageLabel.Visible=false
local c_a=ca.statusRibbon(a_a,"Party invite sent!","success",b_a,UDim2.new(0,0,0.5,0))c_a.Size=UDim2.new(0,150,0,30)
a_a.Size=UDim2.new(0,200,0,60)elseif dd then b_a=2;a_a.button.Visible=false;a_a.leave.Visible=false
a_a.textBox.Visible=false;a_a.ImageLabel.Visible=false
local c_a=ca.statusRibbon(a_a,dd,"fail",b_a,UDim2.new(0,0,0.5,0))c_a.Size=UDim2.new(0,150,0,30)
a_a.Size=UDim2.new(0,200,0,60)end;wait(b_a)_c()elseif bd=="-"then _c()elseif bd=="+"then ac()end end end)
local function bc(bd,cd)
if cd==nil then for dd,__a in pairs(ab)do if __a==bd then cd=dd;break end end end
if cd then if bd.manifest then bd.manifest:Destroy()end
if bd.connections then for dd,__a in
pairs(bd.connections)do __a:disconnect()end end;ab[cd]=nil end end
local function cc()for bd,cd in pairs(ab)do bc(cd,bd)end;ab={}end;local dc=false
local function _d(bd,cd)
local dd=cd.Character and cd.Character.PrimaryPart and cd.Character;local __a=c.currentPartyInfo
if

__a.teleportState=="pending"and __a.teleportPosition and dd and
da.magnitude(dd.PrimaryPart.Position-__a.teleportPosition)<=20 then bd.header.class.Image="rbxassetid://2528902744"
bd.header.class.Visible=true;bd.header.class.ImageColor3=Color3.new(0.1,1,0.1)
bd.header.username.TextColor3=Color3.new(0.1,1,0.1)else local a_a=
cd:FindFirstChild("class")and cd.class.Value:lower()or"unknown"
if
a_a:lower()~="adventurer"then
bd.header.class.Image="rbxgameasset://Images/emblem_"..a_a:lower()bd.header.class.Visible=true else
bd.header.class.Visible=false end;bd.header.class.ImageColor3=Color3.new(1,1,1)
bd.header.username.TextColor3=Color3.new(1,1,1)end end
local function ad(bd)local cd=false;if bd==nil then cd=true
bd=aa:invokeServer("{D2B7113F-C646-40B1-A09E-2DB52FB5C4E7}")end;c.currentPartyInfo=bd;script.Parent.contents.invite.leave.Visible=
bd~=nil;cb()
if bd then
if not cd then
if bd.status then
_a.notifications.alert(bd.status,3)
game.StarterGui:SetCore("ChatMakeSystemMessage",{Text=bd.status.text,Color=bd.status.textColor3 or
Color3.new(0.7,0.7,0.7)})end end;script.partyTeleportBeacon.Enabled=false;script.partyTeleportBeacon.Adornee=
nil
if bd.teleportState=="pending"then
if not dc then dc=true
local __a={text="The party leader has initiated a teleport. Group up!",textColor3=Color3.new(1,1,1),backgroundColor3=Color3.new(0,1,0.2),backgroundTransparency=0,textStrokeTransparency=1}_a.notifications.alert(__a,4)
spawn(function()
while c.currentPartyInfo and
c.currentPartyInfo.teleportState=="pending"do
for a_a,b_a in
pairs(c.currentPartyInfo.members)do local c_a=b_a.player;local d_a=ab[c_a]if d_a and d_a.manifest then
_d(d_a.manifest,c_a)end end;wait(1 /10)end end)end elseif bd.teleportState==nil or bd.teleportState=="none"then
if dc then
dc=false
local __a={text="The party leader canceled the teleport.",textColor3=Color3.new(1,1,1),backgroundColor3=Color3.new(0.9,0.1,0.1),backgroundTransparency=0,textStrokeTransparency=1}_a.notifications.alert(__a,3)end end;local dd={}
for __a,a_a in pairs(bd.members)do local b_a=a_a.player
if b_a==d then _b=a_a.isLeader end;dd[b_a]=true
if b_a~=d and not ab[b_a]then local c_a={}c_a.player=b_a
local d_a=script.playerInfo:Clone()d_a.Name=b_a.Name;d_a.header.username.Text=b_a.Name
_d(d_a,b_a)d_a.header.leader.Visible=a_a.isLeader;local _aa={}
local function aaa()
if
db and db.Parent and db~=d_a then
ba(db,{"ImageTransparency","ImageColor3"},{0.5,Color3.new(0,0,0)},0.5)db.details.Visible=false end;db=d_a;if not d_a.details.Visible then
ba(d_a,{"ImageTransparency","ImageColor3"},{0.5,Color3.new(0,0,0.7)},0.5)end end
local function baa()if not d_a.details.Visible then
ba(d_a,{"ImageTransparency","ImageColor3"},{0.5,Color3.new(81,81,81)},0.5)end end
local function caa()
if d_a.details.Visible then d_a.details.Visible=false;baa()else
if
db and db.Parent and db~=d_a then
ba(db,{"ImageTransparency","ImageColor3"},{0.5,Color3.new(81,81,81)},0.5)db.details.Visible=false end;db=d_a;d_a.details.Visible=true
d_a.details.kick.Visible=_b
ba(d_a,{"ImageTransparency","ImageColor3"},{0,Color3.new(0,0,0.85)},0.5)end end;d_a.MouseEnter:connect(aaa)
d_a.SelectionGained:connect(aaa)d_a.MouseLeave:connect(baa)
d_a.SelectionLost:connect(baa)d_a.Activated:connect(caa)
d_a.details.kick.Activated:connect(function()if
b_a then
local aba,bba=aa:invokeServer("{8E8FADC7-1F67-4F9B-BD17-CD405776FEFC}",b_a)end end)
d_a.details.friendRequest.Activated:connect(function()if b_a then
game.StarterGui:SetCore("PromptSendFriendRequest",b_a)end end)
local function daa()
if
b_a and b_a.Character and b_a.Character.PrimaryPart and
b_a.Character.PrimaryPart:FindFirstChild("health")and
b_a.Character.PrimaryPart:FindFirstChild("maxHealth")then
d_a.healthBar.value.Size=UDim2.new(
b_a.Character.PrimaryPart.health.Value/b_a.Character.PrimaryPart.maxHealth.Value,0,1,0)
d_a.healthBar.value.bar.ImageColor3=Color3.fromRGB(255,0,4)
d_a.healthBar.title.Text=
tostring(math.ceil(b_a.Character.PrimaryPart.health.Value)).."/"..
tostring(b_a.Character.PrimaryPart.maxHealth.Value)else d_a.healthBar.value.Size=UDim2.new(1,0,1,0)
d_a.healthBar.value.bar.ImageColor3=Color3.fromRGB(130,130,130)d_a.healthBar.title.Text="???"end end
local function _ba(aba)daa()local bba=tick()repeat wait()until
b_a.Character.PrimaryPart or tick-bba>5
if b_a.Character.PrimaryPart then
local cba=b_a.Character.PrimaryPart:WaitForChild("health",5)
local dba=b_a.Character.PrimaryPart:WaitForChild("maxHealth",5)
table.insert(_aa,cba.Changed:connect(daa))
table.insert(_aa,dba.Changed:connect(daa))end end;if b_a.Character then _ba(b_a.Character)end
table.insert(_aa,b_a.CharacterAdded:connect(_ba))c_a.manifest=d_a;c_a.connections=_aa;ab[b_a]=c_a
d_a.Parent=script.Parent.contents;d_a.Visible=true end end
for __a,a_a in pairs(ab)do if not dd[a_a.player]then bc(a_a,__a)end end
if#c.currentPartyInfo.members>=6 then _c()end else cc()end end;ad()
aa:connect("{52175EBD-EE9F-41F5-A81F-8F6BC2A6E040}","OnClientEvent",ad)
aa:connect("{CCBCB53C-5971-4DAB-B1C7-DA15F8D4C8C9}","OnClientEvent",function(bd,cd)
if bd then
local dd=_a.prompting.prompt(bd.Name.." wants you to join their party.")if dd then
local __a,a_a=aa:invokeServer("{936CA026-12FD-4855-A76F-072C1F16E9AD}",cd)end end end)end;return c