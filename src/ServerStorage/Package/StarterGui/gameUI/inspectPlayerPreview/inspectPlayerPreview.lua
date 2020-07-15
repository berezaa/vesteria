local d={}local _a;local aa={}
function d.init(ba)local ca=ba.tween;local da=ba.network;local _b=ba.configuration
local ab=game:GetService("ReplicatedStorage")local bb=require(ab:WaitForChild("itemData"))
local cb=require(ab:WaitForChild("itemAttributes"))local db={}
for dc,_d in
pairs(script.Parent.content.equipment:GetChildren())do
if _d:IsA("ImageButton")or _d:IsA("ImageLabel")then
_d.item.Image=""_d.frame.Visible=false;_d.shine.Visible=false
_d.ImageTransparency=0.5;_d.LayoutOrder=99;aa[_d]={}table.insert(db,_d)local function ad()
da:invoke("{F2C470EF-8710-44BB-9203-C4357B8E4FA2}",bb[aa[_d].id],"inspect",aa[_d])end;local function bd()
da:invoke("{F2C470EF-8710-44BB-9203-C4357B8E4FA2}")end
_d.item.MouseEnter:connect(ad)_d.item.SelectionGained:connect(ad)
_d.item.MouseLeave:connect(bd)_d.item.SelectionLost:connect(bd)end end;local _c
function d.close()script.Parent.Visible=false;_a=nil end
function d.open(dc,_d)_c=_d;_a=dc
script.Parent.content.info.username.Text=dc.Name;local ad=
dc:FindFirstChild("class")and dc.class.Value:lower()or"unknown"
local bd
if ad:lower()~="adventurer"then
script.Parent.content.info.username.emblem.Image=
"rbxgameasset://Images/emblem_"..ad:lower()
script.Parent.content.info.username.emblem.Visible=true;bd=true else
script.Parent.content.info.username.emblem.Visible=false end
local cd=dc:FindFirstChild("level")and dc.level.Value or 0
local dd=script.Parent.content.info.level.value;dd.Text="Lvl. "..cd
local __a=
game.TextService:GetTextSize(dd.Text,dd.TextSize,dd.Font,Vector2.new()).X+16
script.Parent.content.info.level.Size=UDim2.new(0,__a,0,26)
local a_a=dc:FindFirstChild("referrals")and dc.referrals.Value or 0
if a_a>0 then
local d_a=script.Parent.content.info.referrals.value;d_a.Text=tostring(a_a)
local _aa=
game.TextService:GetTextSize(d_a.Text,d_a.TextSize,d_a.Font,Vector2.new()).X+41
script.Parent.content.info.referrals.Size=UDim2.new(0,_aa,0,26)
script.Parent.content.info.referrals.Visible=true else
script.Parent.content.info.referrals.Visible=false end;local b_a=(bd and 22)or 0
local c_a=game:GetService("TextService"):GetTextSize(dc.Name,script.Parent.content.info.username.TextSize,script.Parent.content.info.username.Font,Vector2.new()).X;script.Parent.content.info.username.Size=UDim2.new(0,
c_a+5 + (b_a),0,30)
for d_a,_aa in pairs(db)do
_aa.item.Image=""_aa.frame.Visible=false;_aa.shine.Visible=false
_aa.ImageTransparency=0.5;_aa.LayoutOrder=99;_aa.stars.Visible=false
_aa.attribute.Visible=false;ba.fx.setFlash(_aa.frame,false)end
if dc.Character and dc.Character.PrimaryPart and
dc.Character.PrimaryPart:FindFirstChild("appearance")then
local d_a=game:GetService("HttpService"):JSONDecode(dc.Character.PrimaryPart.appearance.Value)
if d_a then
if d_a.equipment then
for _aa,aaa in pairs(d_a.equipment)do local baa=db[_aa]local caa=bb[aaa.id]
baa.stars.Visible=false;baa.attribute.Visible=false
if caa then baa.item.Image=caa.image
baa.item.ImageColor3=Color3.new(1,1,1)baa.frame.Visible=true;baa.shine.Visible=true
baa.ImageTransparency=0;if aaa.attribute then local bba=cb[aaa.attribute]
if bba and bba.color then
baa.attribute.ImageColor3=bba.color;baa.attribute.Visible=true end end;if
aaa.dye then
baa.item.ImageColor3=Color3.fromRGB(aaa.dye.r,aaa.dye.g,aaa.dye.b)end
local daa,_ba=ba.itemAcquistion.getTitleColorForInventorySlotData(aaa)
baa.frame.ImageColor3=(_ba and _ba>1 and daa)or Color3.fromRGB(106,105,107)
baa.shine.ImageColor3=daa or Color3.fromRGB(179,178,185)baa.shine.Visible=daa~=nil and _ba>1;ba.fx.setFlash(baa.frame,
daa~=nil and _ba>1)aa[baa]=aaa
baa.LayoutOrder=aaa.position;baa.stars.Visible=false;local aba=aaa.successfulUpgrades
if aba then
for bba,cba in
pairs(baa.stars:GetChildren())do
if cba:IsA("ImageLabel")then
cba.ImageColor3=daa or Color3.new(1,1,1)cba.Visible=false elseif cba:IsA("TextLabel")then
cba.TextColor3=daa or Color3.new(1,1,1)cba.Visible=false end end
if aba<=3 then
for bba,cba in pairs(baa.stars:GetChildren())do
local dba=tonumber(cba.Name)if dba then cba.Visible=dba<=aba end end;baa.stars.exact.Visible=false else
baa.stars["1"].Visible=true;baa.stars.exact.Visible=true
baa.stars.exact.Text=aba end;baa.stars.Visible=true end end end end end end;script.Parent.Visible=true end;local ac=game.Players.LocalPlayer;local bc=ac:GetMouse()
local function cc()
if
script.Parent.Visible then local dc=workspace.CurrentCamera.ViewportSize;local _d,ad
if
ba.input.mode.Value=="pc"then local bd=bc.X+15;local cd=bc.Y-5
if bd+
script.Parent.AbsoluteSize.X>dc.X then bd=bc.X-15 -
script.Parent.AbsoluteSize.X end
local dd=(cd+script.Parent.AbsoluteSize.Y)- (dc.Y-36)if dd>0 then cd=cd-dd end;local __a=UDim2.new(0,bd,0,cd)
script.Parent.Position=__a elseif ba.input.mode.Value=="xbox"then
local bd=game.GuiService.SelectedObject
local cd=bd.AbsolutePosition.X+bd.AbsoluteSize.X+10
if cd>dc.X then cd=
bd.AbsolutePosition.X-script.Parent.AbsoluteSize.X-10 end
local dd=bd.AbsolutePosition.Y+bd.AbsoluteSize.Y/2 -
script.Parent.AbsoluteSize.Y/2;local __a=UDim2.new(0,cd,0,dd)script.Parent.Position=__a end end end
game:GetService("RunService").RenderStepped:connect(cc)end;return d