local d={}local _a=script.Parent;function d.close()_a.Visible=false end
function d.open(ba)end;local aa={}
function d.init(ba)
spawn(function()local ca=ba.network
if
game.Players.LocalPlayer:FindFirstChild("bountyHunter")then local da=ba.input.menuButtons["openMonsterBook"]
local _b=script.Parent;local ab;local bb={}local cb=script.Parent.bookHolder.pages
local db=require(game.ReplicatedStorage.monsterLookup)
local _c=require(game.ReplicatedStorage.itemData)local ac=ba.levels;local bc
cb.monster.close.Activated:connect(function()
cb.monster.Visible=false;cb.main.Visible=true end)
cb.monster.claim.Activated:connect(function()
if bc then
local a_a,b_a=ca:invokeServer("{F4710E12-07F5-4EAB-9644-5F83D5057E54}",bc)if a_a then cb.monster.Visible=false
ba.utilities.playSound("questTurnedIn")cb.main.Visible=true end end end)local cc={}
local function dc(a_a)local b_a=Vector3.new()local c_a=0
for d_a,_aa in
pairs(a_a:GetDescendants())do if _aa:IsA("BasePart")then local aaa=_aa.Position;local baa=_aa:GetMass()
b_a=b_a+ (aaa*baa)c_a=c_a+baa end end;return b_a/c_a end
local _d={["1"]=5,["2"]=10,["3"]=15,["4"]=20,["5"]=25,["6"]=30,["99"]=15}local ad={}
local function bd(a_a)if ad[a_a]then return ad[a_a]end
local b_a=script.ViewportFrame:Clone()local c_a=db[a_a]local d_a=c_a.module;local _aa
if d_a:FindFirstChild("displayEntity")then
_aa=d_a.displayEntity:Clone()else _aa=d_a.entity:Clone()end
if _aa:FindFirstChild("animations")and
_aa.animations:FindFirstChild("idling")then _aa.Parent=workspace
_aa.PrimaryPart.Anchored=true;local bba=_aa:FindFirstChild("AnimationController")
game.ContentProvider:PreloadAsync({_aa.animations.idling})
bba:LoadAnimation(_aa.animations.idling):Play()wait(0.1)local cba=_aa;_aa=_aa:Clone()cba:Destroy()end;_aa.Parent=b_a
_aa:SetPrimaryPartCFrame(CFrame.new())local aaa=aa[d_a.Name]if aaa==nil then aaa=_aa:GetExtentsSize()
aa[d_a.Name]=aaa end;local baa=cc[d_a.Name]if baa==nil then baa=dc(_aa)
cc[d_a.Name]=baa end;local caa=Instance.new("Camera")
local daa=math.min(aaa.x,aaa.z)
local _ba=Vector3.new(aaa.z,aaa.y,aaa.x)/daa
local aba=( (baa+_aa.PrimaryPart.Position)/2)+ (aaa*
Vector3.new(0.5,0.1,-0.8)*_ba)caa.CameraType=Enum.CameraType.Scriptable
caa.CFrame=
CFrame.new(aba,baa)* (c_a.cameraOffset or CFrame.new())caa.Parent=b_a;b_a.CurrentCamera=caa;ad[a_a]=b_a;return b_a end
local function cd()for a_a,b_a in pairs(cb.main:GetChildren())do if b_a:IsA("GuiButton")then
b_a:Destroy()end end
for a_a,b_a in
pairs(game.ReplicatedStorage.monsterLookup:GetChildren())do local c_a=db[b_a.Name]
if c_a and c_a.monsterBookPage and c_a.monsterBookPage==
tonumber(ab.Name)then
local d_a=_d[ab.Name]local _aa=script.monster:Clone()_aa.Name=b_a.Name;_aa.LayoutOrder=
c_a.level or 999;_aa.alert.Visible=false
local aaa=bd(b_a.Name):Clone()if _aa:FindFirstChild("ViewportFrame")then
_aa.ViewportFrame:Destroy()end;aaa.Parent=_aa
_aa.money.Visible=false;_aa.progress.Visible=false;local baa=bb[b_a.Name]
local caa=baa and baa.kills or 0;local daa=baa and baa.lastBounty or 0
if caa>0 or daa>0 then
local _ba=ac.bountyPageInfo[tostring(c_a.monsterBookPage)]local aba=_ba[daa+1]
if aba then local bba=ac.getBountyGoldReward(aba,c_a)
ba.money.setLabelAmount(_aa.money,bba)_aa.money.Visible=true;_aa.progress.Visible=true
_aa.progress.amount.Text=
tostring(baa.kills).."/"..tostring(aba.kills)
_aa.progress.xp.value.Size=UDim2.new(math.clamp(baa.kills/aba.kills,0,1),0,1,0)if caa>=aba.kills then _aa.alert.Visible=true end end;_aa.tooltip.Value=b_a.Name
_aa.Activated:connect(function()bc=b_a.Name
cb.monster.progress.Visible=false;cb.monster.money.Visible=false
cb.monster.claim.Visible=false
if aba then local _ca=ac.getBountyGoldReward(aba,c_a)
ba.money.setLabelAmount(cb.monster.money,_ca)cb.monster.money.Visible=true
cb.monster.progress.Visible=true
cb.monster.progress.xp.value.Size=UDim2.new(math.clamp(
baa.kills/aba.kills,0,1),0,1,0)
if baa.kills>=aba.kills then cb.monster.claim.Visible=true end end;if cb.monster.holder:FindFirstChild("ViewportFrame")then
cb.monster.holder.ViewportFrame:Destroy()end
_aa.ViewportFrame:Clone().Parent=cb.monster.holder;cb.monster.title.Text=b_a.Name
cb.monster.info.level.Text=
"Lvl. "..tostring(c_a.level or"?")
cb.monster.info.health.Text=(c_a.maxHealth or"???").." HP"cb.monster.Visible=true;cb.main.Visible=false
for _ca,aca in
pairs(cb.monster.loot:GetChildren())do if aca:isA("GuiObject")then aca:Destroy()end end;local bba={}local cba={}
if c_a.lootDrops then
for _ca,aca in pairs(c_a.lootDrops)do if aca.id~=1 then
local bca=_c[aca.id or aca.itemName]
if bca then if not cba[bca.name]then table.insert(bba,aca)
cba[bca.name]=true end end end end end;local dba=math.ceil(#bba/4)
cb.monster.loot.CanvasSize=UDim2.new(0,0,0,61 *dba)
for _ca,aca in pairs(bba)do
local bca=script.inventoryItemTemplate:Clone()local cca=_c[aca.id or aca.itemName]bca.item.Image=cca.image or
"rbxassetid://2679574493"
bca.locked.Visible=false;bca.item.Visible=true;local dca="?%"
if aca.spawnChance then
if aca.spawnChance>=0.1 then
dca=tostring(math.floor(
aca.spawnChance*1000)/10).."%"elseif aca.spawnChance>=0.01 then dca=
tostring(math.floor(aca.spawnChance*10000)/100).."%"elseif
aca.spawnChance>=0.001 then dca=
tostring(math.floor(aca.spawnChance*100000)/1000).."%"else dca=
tostring(math.floor(
aca.spawnChance*1000000)/10000).."%"end end;bca.item.tooltip.Value=cca.name.." - "..dca
bca.Parent=cb.monster.loot end end)else _aa.ViewportFrame.ImageColor3=Color3.new(0,0,0)
_aa.ViewportFrame.ImageTransparency=0.7;_aa.progress.Visible=false
_aa.ImageColor3=Color3.fromRGB(60,60,60)_aa.ImageTransparency=0.5;_aa.shadow.ImageTransparency=0.5 end;_aa.Parent=cb.main end end end
function d.open()
if not script.Parent.Visible then script.Parent.UIScale.Scale=(
ba.input.menuScale or 1)*0.75
ba.tween(script.Parent.UIScale,{"Scale"},(
ba.input.menuScale or 1),0.5,Enum.EasingStyle.Bounce)end;if ab then cd()end;ba.focus.toggle(script.Parent)
cb.main.Visible=true;cb.monster.Visible=false end;function d.close()if script.Parent.Visible then
ba.focus.toggle(script.Parent)end end
_a.close.Activated:connect(d.close)
function d.loadTab(a_a)ab=a_a;local b_a=tonumber(a_a.Name)for d_a,_aa in
pairs(a_a.Parent:GetChildren())do
if _aa:IsA("GuiObject")then _aa.Size=UDim2.new(0,50,0,40)end end
a_a.Size=UDim2.new(0,60,0,40)local c_a=a_a.ImageColor3
_b.bookCover.ImageColor3=Color3.new((c_a.r+0.15)*0.6,(c_a.g+
0.15)*0.6,(c_a.b+0.15)*0.6)
script.inventoryItemTemplate.ImageColor3=Color3.new((c_a.r+0.15)*0.3,
(c_a.g+0.15)*0.3,(c_a.b+0.15)*0.3)
script.monster.ImageColor3=Color3.new((c_a.r+0.15)*0.9,(c_a.g+0.15)*0.9,(
c_a.b+0.15)*0.9)
cb.monster.holder.ImageColor3=script.monster.ImageColor3
script.inventoryItemTemplate.locked.ImageColor3=Color3.new(
(c_a.r+0.1)*0.92,(c_a.g+0.1)*0.92,(c_a.b+0.1)*0.92)
script.monster.progress.xp.value.ImageColor3=c_a
cb.monster.progress.xp.value.ImageColor3=c_a
cb.monster.info.bonus.title.TextColor3=c_a;cb.monster.holder.level.TextColor3=c_a
cb.main.Visible=true;cb.monster.Visible=false;cd()end;for a_a,b_a in pairs(_b.tabs:GetChildren())do
if b_a:IsA("GuiButton")then b_a.Activated:connect(function()
d.loadTab(b_a)end)end end;local dd
local function __a(a_a)
local b_a=0
for c_a,d_a in pairs(a_a)do local _aa=d_a and d_a.kills or 0
local aaa=d_a and d_a.lastBounty or 0;local baa=db[c_a]
if baa and baa.monsterBookPage then
local caa=ac.bountyPageInfo[tostring(baa.monsterBookPage)]local daa=caa[aaa+1]
if daa then if _aa>=daa.kills then b_a=b_a+1 end end end end;da.alert.value.Text=tostring(b_a)
da.alert.Visible=b_a>0
if dd and b_a>dd then
local c_a={text="You completed a monster bounty!",textColor3=Color3.fromRGB(255,85,70),id="newpoints"}ba.notifications.alert(c_a,4,"idolPickup")end;dd=b_a end
ca:connect("{B5BFDE4F-1C2E-4D65-ACB4-277DB309BF6D}","Event",function(a_a,b_a)
if a_a=="bountyBook"then local c_a=bb;bb=b_a;__a(bb)if ab and
script.Parent.Visible then cd()end end end)
spawn(function()for a_a,b_a in
pairs(game.ReplicatedStorage.monsterLookup:GetChildren())do bd(b_a.Name)end;if not ab then
d.loadTab(_b.tabs["1"])end
bb=ca:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","bountyBook")__a(bb)end)end end)end;return d