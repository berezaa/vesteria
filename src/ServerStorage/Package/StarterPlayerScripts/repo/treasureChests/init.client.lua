local _c=game:GetService("ReplicatedStorage")
local ac=require(_c:WaitForChild("modules"))local bc=ac.load("network")local cc=ac.load("tween")
local dc=ac.load("utilities")
game.Players.LocalPlayer:WaitForChild("dataLoaded",60)local _d={}local ad={}
local bd=script.Parent.Parent:WaitForChild("assets")local cd=bd:WaitForChild("chestBillboard")
local function dd(d_a)
if
d_a:FindFirstChild("progressUi")==nil then local _aa=cd:Clone()
_aa.ImageLabel.ImageTransparency=1;_aa.TextLabel.TextTransparency=1
_aa.TextLabel.TextStrokeTransparency=1;_aa.Adornee=d_a.PrimaryPart;local aaa=0;local baa=0;for caa,daa in pairs(_d)do aaa=aaa+1;if daa.open then
baa=baa+1 end end;_aa.TextLabel.Text=
tostring(baa).."/"..tostring(aaa)
_aa.Enabled=true;_aa.Parent=d_a
cc(_aa.ImageLabel,{"ImageTransparency"},0,1)
cc(_aa.TextLabel,{"TextTransparency","TextStrokeTransparency"},0,1)table.insert(ad,_aa)end end
local __a=bc:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","treasure")
local function a_a()local d_a=__a["place-"..game.PlaceId]
if d_a then
for baa,caa in
pairs(d_a.chests)do local daa=_d[baa]
if daa then
if caa.open and not daa.open then daa.open=true
delay(0.2,function()
daa.openLoopTrack:Play()local _ba=daa.chestModel
if _ba:FindFirstChild("Glow")then _ba.Glow.Transparency=1 end;dd(_ba)end)end end end end;local _aa=0;local aaa=0
for baa,caa in pairs(_d)do _aa=_aa+1;if caa.open then aaa=aaa+1 end end;for baa,caa in pairs(ad)do
caa.TextLabel.Text=tostring(aaa).."/"..tostring(_aa)end end
bc:connect("{B5BFDE4F-1C2E-4D65-ACB4-277DB309BF6D}","Event",function(d_a,_aa)
if d_a=="treasure"then __a=_aa;a_a()end end)a_a()
local function b_a(d_a)
local _aa=game.CollectionService:HasTag(d_a.PrimaryPart,"interact")
local aaa=d_a:FindFirstChild("chestProps")or script.defaultChestProps;local baa=require(aaa)
local caa=require(script.defaultChestProps)
local daa=
script.chests:FindFirstChild(baa.chestModel or caa.chestModel)or script.chests:FindFirstChild("defaultChest")if _aa then daa=d_a else daa=daa:Clone()daa.Parent=d_a end
local _ba=daa:WaitForChild("AnimationController")local aba=daa:WaitForChild("chestOpen")
local bba=daa:WaitForChild("chestOpenLoop")local cba=Instance.new("Animation",daa)cba.Name="chestLocked"
cba.AnimationId="rbxassetid://3916391981"local dba=_ba:LoadAnimation(aba)
local _ca=_ba:LoadAnimation(bba)local aca=_ba:LoadAnimation(cba)dba.Looped=false
dba.Priority=Enum.AnimationPriority.Action;aca.Looped=false;aca.Priority=Enum.AnimationPriority.Action
_ca.Looped=true;_ca.Priority=Enum.AnimationPriority.Core
local bca=d_a.PrimaryPart;local cca=daa.PrimaryPart
daa:SetPrimaryPartCFrame(bca.CFrame*CFrame.new(0,(-bca.Size.Y/2)+ (
cca.Size.Y/2),0))bca.Transparency=1;if not _aa then
local _da=script.attackableScript:Clone()_da.Parent=cca
game.CollectionService:AddTag(cca,"attackable")end
local dca={chestRoot=d_a,chestModel=daa,controller=_ba,openTrack=dba,lockedTrack=aca,openLoopTrack=_ca,open=false}_d[d_a.Name]=dca;a_a()end;for d_a,_aa in
pairs(game.CollectionService:GetTagged("treasureChest"))do
coroutine.wrap(function()b_a(_aa)end)()end
game.CollectionService:GetInstanceAddedSignal("treasureChest"):connect(b_a)
local function c_a(d_a)local _aa=_d[d_a.Name]
if _aa and not _aa.open then local aaa=_aa.chestModel
local baa=aaa:FindFirstChild("Glow")
if
game.ReplicatedStorage.sounds:FindFirstChild("chest_unlock")then dc.playSound("chest_unlock",aaa.PrimaryPart)end;local caa=aaa:FindFirstChild("Lock")if caa then
cc(caa,{"Transparency"},1,1)end
local daa,_ba=bc:invokeServer("{413B4AFE-5864-4F47-9061-FB1D80CD5478}",d_a)if _ba then return nil,_ba end;_aa.open=true;local aba;if daa then aba=_aa.openTrack else
aba=_aa.lockedTrack end
if daa then aba:Play()
aba.KeyframeReached:connect(function(bba)
if bba==
"opened"then _aa.openLoopTrack:Play()
if baa then baa.Transparency=0
cc(baa,{"Transparency"},1,1)
if baa:FindFirstChild("ParticleEmitter")then
baa.ParticleEmitter.Color=ColorSequence.new(baa.Color)baa.ParticleEmitter:Emit(50)end end
bc:invoke("{0E75A1BF-C1A5-4731-8782-314C09378114}",daa)
if
game.ReplicatedStorage.sounds:FindFirstChild("chest_reward")then dc.playSound("chest_reward",script.Parent)end end end)dd(aaa)elseif _ba and typeof(_ba)=="number"then baa.Transparency=1
aba:Play()
aba.KeyframeReached:connect(function(bba)if bba=="opened"then
_aa.openLoopTrack:Play()end end)
if script.Parent.Parent:FindFirstChild("goldChest")or
script.Parent.Parent:FindFirstChild("ironChest")then
local bba={text="You've already opened this chest.",textColor3=Color3.new(1,1,1),backgroundColor3=Color3.new(0.9,0.3,0.2),backgroundTransparency=0,textStrokeTransparency=1,id=
"goldchest"..script.Parent.Parent.Name}
bc:fire("{97822377-6CF7-4275-B2B8-3E4E2E50F11C}",{text=bba},2)else
for i=0,2 do
local cba={text="Chest can be opened again in "..dc.timeToString(_ba-i),textColor3=Color3.new(1,1,1),backgroundColor3=Color3.new(0.9,0.75,0.2),backgroundTransparency=0,textStrokeTransparency=1,id=
"chest"..script.Parent.Parent.Name}
bc:fire("{97822377-6CF7-4275-B2B8-3E4E2E50F11C}",{text=cba},1)wait(1)end
local bba={text="Chest can be opened again in "..dc.timeToString(_ba-3),textColor3=Color3.new(1,1,1),backgroundColor3=Color3.new(0.9,0.75,0.2),backgroundTransparency=0,textStrokeTransparency=1,id=
"chest"..script.Parent.Parent.Name}
bc:fire("{97822377-6CF7-4275-B2B8-3E4E2E50F11C}",bba,0.5)end end;return daa,_ba end;return nil,"You cant open that."end
bc:create("{52EA54C2-60BA-461B-8A07-678C59CAD99F}","BindableFunction","OnInvoke",c_a)