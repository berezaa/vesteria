local d={}local _a;local aa={}
function d.init(ba)local ca=ba.tween;local da=ba.network;local _b=ba.configuration
local ab=game:GetService("ReplicatedStorage")local bb=require(ab:WaitForChild("itemData"))
local cb=require(ab:WaitForChild("itemAttributes"))local db={}local _c
local function ac(cc)if cc==nil then
cc=da:invokeServer("{D2B7113F-C646-40B1-A09E-2DB52FB5C4E7}")end
if cc then for dc,_d in pairs(cc.members)do local ad=_d.player
if ad==
game.Players.LocalPlayer then cc.isClientPartyLeader=_d.isLeader end end end;_c=cc end
local function bc(cc)if _c and _c.members then
for dc,_d in pairs(_c.members)do if _d.player==cc then return true end end end end
da:connect("{52175EBD-EE9F-41F5-A81F-8F6BC2A6E040}","OnClientEvent",function(cc)ac(cc)if
script.Parent.Visible and _a then d.open(_a,true)end end)spawn(function()ac()end)
for cc,dc in
pairs(script.Parent.content.equipment:GetChildren())do
if dc:IsA("ImageButton")or dc:IsA("ImageLabel")then
dc.item.Image=""dc.frame.Visible=false;dc.shine.Visible=false
dc.ImageTransparency=0.5;dc.LayoutOrder=99;aa[dc]={}table.insert(db,dc)local function _d()
da:invoke("{F2C470EF-8710-44BB-9203-C4357B8E4FA2}",bb[aa[dc].id],"inspect",aa[dc])end;local function ad()
da:invoke("{F2C470EF-8710-44BB-9203-C4357B8E4FA2}")end
dc.item.MouseEnter:connect(_d)dc.item.SelectionGained:connect(_d)
dc.item.MouseLeave:connect(ad)dc.item.SelectionLost:connect(ad)end end
function d.close()if script.Parent.Visible then
ba.focus.toggle(script.Parent)end
da:invoke("{F2C470EF-8710-44BB-9203-C4357B8E4FA2}")script.Parent.Visible=false;_a=nil end
script.Parent.close.Activated:connect(d.close)
function d.open(cc,dc)if script.Parent.Visible and cc==_a and not dc then
d.close()return end
for _aa,aaa in
pairs(script.Parent.content.buttons:GetChildren())do
if aaa:FindFirstChild("fail")then aaa.fail.Visible=false end
if aaa:FindFirstChild("success")then aaa.success.Visible=false end
if aaa:FindFirstChild("icon")then aaa.icon.Visible=true end end
local _d=script.Parent.content.buttons:FindFirstChild("request party")local ad=bc(cc)
if ad then
if cc==game.Players.LocalPlayer then
if _c then
_d.ImageColor3=Color3.fromRGB(247,0,4)_d.tooltip.Value="Leave Party"_d.Active=true else
_d.ImageColor3=Color3.fromRGB(95,95,95)_d.tooltip.Value="Not in Party"_d.Active=false end elseif _c and _c.isClientPartyLeader then
_d.ImageColor3=Color3.fromRGB(247,0,4)_d.tooltip.Value="Kick from Party"_d.Active=true else
_d.ImageColor3=Color3.fromRGB(95,95,95)_d.tooltip.Value="Already in Party"_d.Active=false end else _d.ImageColor3=Color3.fromRGB(80,247,222)
_d.tooltip.Value="Invite to Party"_d.Active=true end;if not script.Parent.Visible then
ba.focus.toggle(script.Parent)end;script.Parent.UIScale.Scale=(
ba.input.menuScale or 1)*0.75
ba.tween(script.Parent.UIScale,{"Scale"},(
ba.input.menuScale or 1),0.5,Enum.EasingStyle.Bounce)_a=cc
script.Parent.content.info.username.Text=cc.Name;local bd=
cc:FindFirstChild("class")and cc.class.Value:lower()or"unknown"
local cd
if bd:lower()~="adventurer"then
script.Parent.content.info.username.emblem.Image=
"rbxgameasset://Images/emblem_"..bd:lower()
script.Parent.content.info.username.emblem.Visible=true;cd=true else
script.Parent.content.info.username.emblem.Visible=false end
for _aa,aaa in
pairs(script.Parent.content.stats:GetChildren())do
if aaa:IsA("TextLabel")then local baa=cc:FindFirstChild(aaa.Name)
if baa then
aaa.Text=
aaa.Name:upper()..": "..tostring(baa.Value)else aaa.Text=aaa.Name:upper()..": ???"end
local caa=game:GetService("TextService"):GetTextSize(aaa.Text,aaa.TextSize,aaa.Font,Vector2.new()).X;aaa.Size=UDim2.new(0,caa+5,1,0)end end
local dd=cc:FindFirstChild("level")and cc.level.Value or 0
script.Parent.content.level.Text="Lvl. "..dd
local __a=script.Parent.content.info.level.value;__a.Text="Lvl. "..dd
local a_a=
game.TextService:GetTextSize(__a.Text,__a.TextSize,__a.Font,Vector2.new()).X+16
script.Parent.content.info.level.Size=UDim2.new(0,a_a,0,26)
local b_a=cc:FindFirstChild("referrals")and cc.referrals.Value or 0
if b_a>0 then
local _aa=script.Parent.content.info.referrals.value;_aa.Text=tostring(b_a)
local aaa=
game.TextService:GetTextSize(_aa.Text,_aa.TextSize,_aa.Font,Vector2.new()).X+41
script.Parent.content.info.referrals.Size=UDim2.new(0,aaa,0,26)
script.Parent.content.info.referrals.Visible=true else
script.Parent.content.info.referrals.Visible=false end;local c_a=(cd and 22)or 0
local d_a=game:GetService("TextService"):GetTextSize(cc.Name,script.Parent.content.info.username.TextSize,script.Parent.content.info.username.Font,Vector2.new()).X;script.Parent.content.info.username.Size=UDim2.new(0,
d_a+5 + (c_a),0,30)
for _aa,aaa in pairs(db)do
aaa.item.Image=""aaa.frame.Visible=false;aaa.shine.Visible=false
aaa.ImageTransparency=0.5;aaa.LayoutOrder=99;aaa.stars.Visible=false
aaa.attribute.Visible=false;ba.fx.setFlash(aaa.frame,false)end
if cc.Character and cc.Character.PrimaryPart and
cc.Character.PrimaryPart:FindFirstChild("appearance")then
local _aa=game:GetService("HttpService"):JSONDecode(cc.Character.PrimaryPart.appearance.Value)
if _aa then
if _aa.equipment then
for aca,bca in pairs(_aa.equipment)do local cca=db[aca]local dca=bb[bca.id]
cca.stars.Visible=false;cca.attribute.Visible=false
if dca then cca.item.Image=dca.image
cca.item.ImageColor3=Color3.new(1,1,1)cca.frame.Visible=true;cca.shine.Visible=true
cca.ImageTransparency=0;if bca.attribute then local cda=cb[bca.attribute]
if cda and cda.color then
cca.attribute.ImageColor3=cda.color;cca.attribute.Visible=true end end;if
bca.dye then
cca.item.ImageColor3=Color3.fromRGB(bca.dye.r,bca.dye.g,bca.dye.b)end
local _da,ada=ba.itemAcquistion.getTitleColorForInventorySlotData(bca)
cca.frame.ImageColor3=(ada and ada>1 and _da)or Color3.fromRGB(106,105,107)
cca.shine.ImageColor3=_da or Color3.fromRGB(179,178,185)cca.shine.Visible=_da~=nil and ada>1
ba.fx.setFlash(cca.frame,cca.shine.Visible)aa[cca]=bca;cca.LayoutOrder=bca.position;cca.stars.Visible=false
local bda=bca.successfulUpgrades
if bda then
for cda,dda in pairs(cca.stars:GetChildren())do
if dda:IsA("ImageLabel")then dda.ImageColor3=
_da or Color3.new(1,1,1)dda.Visible=false elseif
dda:IsA("TextLabel")then dda.TextColor3=_da or Color3.new(1,1,1)
dda.Visible=false end end
if bda<=3 then
for cda,dda in pairs(cca.stars:GetChildren())do
local __b=tonumber(dda.Name)if __b then dda.Visible=__b<=bda end end;cca.stars.exact.Visible=false else
cca.stars["1"].Visible=true;cca.stars.exact.Visible=true
cca.stars.exact.Text=bda end;cca.stars.Visible=true end end end end;if
script.Parent.character.ViewportFrame:FindFirstChild("entity")then
script.Parent.character.ViewportFrame.entity:Destroy()end;if
script.Parent.character.ViewportFrame:FindFirstChild("entity2")then
script.Parent.character.ViewportFrame.entity2:Destroy()end
local aaa=script.Parent.character.ViewportFrame.CurrentCamera
if aaa==nil then aaa=Instance.new("Camera")
aaa.Parent=script.Parent.character.ViewportFrame
script.Parent.character.ViewportFrame.CurrentCamera=aaa end;local baa=cc;local caa=cc.Character
local daa=script.Parent.character.ViewportFrame.characterMask;local _ba={}_ba.equipment=_aa.equipment or{}
_ba.accessories=_aa.accessories or{}
local aba=da:invoke("{01474D9A-12D0-4C30-90B0-649477E2B77A}",daa,_ba or{},baa)aba.Parent=workspace.CurrentCamera
local bba=aba.entity:WaitForChild("AnimationController")
local cba=da:invoke("{CA61CBF0-3B04-4617-8D2D-50C80D51AB19}",aba.entity)local dba;do
if cba["1"]then dba=cba["1"].baseData.equipmentType end end
local _ca=da:invoke("{F22A757B-3CF2-4CEE-ACF2-466C636EF6BB}",bba,"idling",dba,nil)
if _ca then
if typeof(_ca)=="Instance"then _ca:Play()elseif typeof(_ca)=="table"then for aca,bca in
pairs(_ca)do bca:Play()end end
spawn(function()
while true do wait()
if typeof(_ca)=="Instance"then if _ca.Length>0 then break end elseif
typeof(_ca)=="table"then local aca=true
for bca,cca in pairs(_ca)do if _ca.Length==0 then aca=false end end;if aca then break end end end
if aba then if
script.Parent.character.ViewportFrame:FindFirstChild("entity")then
script.Parent.character.ViewportFrame.entity:Destroy()end
local aca=aba.entity;aca.Parent=script.Parent.character.ViewportFrame
aba:Destroy()
local bca=
CFrame.new(aca.PrimaryPart.Position+
aca.PrimaryPart.CFrame.lookVector*6.3,aca.PrimaryPart.Position)*CFrame.new(3,0,0)
aaa.CFrame=CFrame.new(bca.p+Vector3.new(0,1.5,0),aca.PrimaryPart.Position+
Vector3.new(0,0.5,0))end end)else local aca=bba:LoadAnimation(daa.idle)aca.Looped=true
aca.Priority=Enum.AnimationPriority.Idle;aca:Play()end end end end
function d.tradeRequest()
if _a and script.Parent.Visible and
script.Parent.content.buttons["request trade"].icon.Visible then if not
_b.getConfigurationValue("isTradingEnabled")then
ba.notifications.alert({text="Trading is temporarily disabled."},2)end
local cc=script.Parent.content.buttons["request trade"]cc.icon.Visible=false
local dc=da:invokeServer("{07FFBB87-C6E5-447F-8E77-F41C936AF801}",_a)
if dc then cc.success.Visible=true
ba.notifications.alert({text="Sent "..
_a.Name.." a trade request."},2)else cc.fail.Visible=true end
spawn(function()wait(1)cc.fail.Visible=false;cc.success.Visible=false
cc.icon.Visible=true end)end end
script.Parent.content.buttons["request trade"].Activated:Connect(d.tradeRequest)
da:invoke("{7AE42210-0ED8-4379-800E-3C54632521A1}","request trade",d.tradeRequest,"T",6)
function d.guildRequest()
local cc=script.Parent.content.buttons["guild"]
if
_a and script.Parent.Visible and cc.Visible and cc.icon.Visible then local dc=_a.Name
ba.notifications.alert({text="Invited "..dc.." to your guild."},2)cc.icon.Visible=false;local _d=true;cc.loading.Visible=true
spawn(function()while _d do
cc.loading.Text="."wait(0.5)cc.loading.Text=".."wait(0.5)
cc.loading.Text="..."wait(0.5)end
cc.loading.Visible=false end)
local ad,bd=da:invokeServer("{E46E6401-03C7-4A5C-95E9-0E0CF6F1E0B4}",_a)cc.loading.Visible=false;_d=false
if ad then cc.success.Visible=true
ba.notifications.alert({text=
dc.." accepted your guild invite!"},2)else
ba.notifications.alert({text=bd or"The guild invite failed."},2)cc.fail.Visible=true end
spawn(function()wait(1)cc.fail.Visible=false;cc.success.Visible=false
cc.icon.Visible=true end)end end
script.Parent.content.buttons["guild"].Activated:connect(d.guildRequest)
function d.partyRequest()
if _a and script.Parent.Visible and
script.Parent.content.buttons["request party"].icon.Visible then
local cc=script.Parent.content.buttons["request party"]cc.icon.Visible=false;local dc=_a;local _d,ad
if
cc.tooltip.Value=="Kick from Party"then
pcall(function()
_d,ad=da:invokeServer("{8E8FADC7-1F67-4F9B-BD17-CD405776FEFC}",dc)end)elseif cc.tooltip.Value=="Leave Party"then
pcall(function()
_d,ad=da:invokeServer("{8E8FADC7-1F67-4F9B-BD17-CD405776FEFC}")end)
if _d then cc.success.Visible=true
ba.notifications.alert({text="Left the party."},2)elseif ad then cc.fail.Visible=true
ba.notifications.alert({text=ad or"Error occured"},2)end else
pcall(function()
_d,ad=da:invokeServer("{AB032646-DB09-4482-B67B-0F1EA25F97EF}",dc)end)
if _d then cc.success.Visible=true
ba.notifications.alert({text="Invited "..
dc.Name.." to the party."},2)elseif ad then cc.fail.Visible=true
ba.notifications.alert({text=ad or"Error occured"},2)end end;local bd=true;bd=false
spawn(function()wait(1)cc.fail.Visible=false
cc.success.Visible=false;cc.icon.Visible=true end)end end
script.Parent.content.buttons["request party"].Activated:Connect(d.partyRequest)
da:invoke("{7AE42210-0ED8-4379-800E-3C54632521A1}","request party",d.partyRequest,"P",6)
function d.duelRequest()
if _a and script.Parent.Visible and
script.Parent.content.buttons["request duel"].icon.Visible then
local cc=script.Parent.content.buttons["request duel"]cc.icon.Visible=false;local dc=_a
local _d=da:invokeServer("{673F5487-AA5C-490F-BF30-A7B6C949E215}",dc)
if _d then cc.success.Visible=true
ba.notifications.alert({text="Sent "..
dc.Name.." a duel challenge."},2)else cc.fail.Visible=true end
spawn(function()wait(1)cc.fail.Visible=false;cc.success.Visible=false
cc.icon.Visible=true end)end end
script.Parent.content.buttons["request duel"].Activated:Connect(d.duelRequest)
da:invoke("{7AE42210-0ED8-4379-800E-3C54632521A1}","request duel",d.duelRequest,"U",6)end;return d