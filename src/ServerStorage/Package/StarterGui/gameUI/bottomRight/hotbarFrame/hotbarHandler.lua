local d=game:GetService("HttpService")local _a={}
_a.xboxHotbarKeys={{keyCode=Enum.KeyCode.ButtonX,image="rbxassetid://2528905407"},{keyCode=Enum.KeyCode.ButtonY,image="rbxassetid://2528905431"},{keyCode=Enum.KeyCode.ButtonB,image="rbxassetid://2528905016"},{keyCode=Enum.KeyCode.ButtonL1,image="rbxassetid://2528905196"},{keyCode=Enum.KeyCode.ButtonR1,image="rbxassetid://2528905316"},{keyCode=Enum.KeyCode.DPadUp,image="rbxassetid://2528905167"},{keyCode=Enum.KeyCode.DPadRight,image="rbxassetid://2528905134"},{keyCode=Enum.KeyCode.DPadDown,image="rbxassetid://2528905076"},{keyCode=Enum.KeyCode.DPadLeft,image="rbxassetid://2528905102"},{keyCode=Enum.KeyCode.ButtonSelect,image="rbxassetid://2528905387"}}local aa=false;_a.captureFocus=function()
warn("hotbarHandler.captureFocus not ready!")end;_a.releaseFocus=function()
warn("hotbarHandler.releaseFocus not ready!")end
function _a.postInit(ba)
local function ca()
local bbb=game.Lighting.OutdoorAmbient
local cbb,dbb,_cb=(bbb.r^2.4)*4,(bbb.g^2.4)*4,(bbb.b^2.4)*4;local acb=Color3.new(cbb,dbb,_cb)
script.Parent.Frame.ImageLabel.ImageColor3=acb;script.Parent.Parent.money.ImageColor3=Color3.fromRGB(85 *cbb,93 *dbb,104 *
_cb)end;ca()
game.Lighting:GetPropertyChangedSignal("OutdoorAmbient"):connect(ca)local da=ba.network;local _b=ba.utilities;local ab=ba.mapping;local bb=ba.uiCreator
local cb=ba.tween;local db=ba.projectile;local _c=ba.placeSetup
local ac=_c.awaitPlaceFolder("entities")local bc=game.ReplicatedStorage;local cc=require(bc.itemData)
local dc=require(bc.abilityLookup)local _d=game.Players.LocalPlayer
local ad=game:GetService("TweenService")local bd=nil;local cd=nil;local dd={}
for bbb,cbb in
pairs(script.Parent.content:GetChildren())do if cbb:IsA("ImageButton")then cbb:Destroy()end end
local function __a()local bbb={}for cbb,dbb in pairs(cd)do
if bbb[dbb.id]then
bbb[dbb.id]=bbb[dbb.id]+ (dbb.stacks or 1)else bbb[dbb.id]=dbb.stacks or 1 end end;return bbb end;local function a_a(bbb,cbb)
for dbb,_cb in pairs(bbb)do if _cb.id==cbb then return _cb.rank end end end
local b_a=Instance.new("BindableEvent")
local function c_a(bbb,cbb)if
not game:GetService("UserInputService").TouchEnabled then return true end;if not bbb then return false end
local dbb=da:invoke("{4947D6C0-3492-484E-8D54-243215910D55}")local _cb=dc[bbb](dbb)if not _cb then return false end
local acb=game.Players.LocalPlayer;if not acb then return false end;local bcb=acb.Character
if not bcb then return false end;local ccb=bcb.PrimaryPart;if not ccb then return false end
local dcb=da:invoke("{7FE9D2B7-10FB-4012-8803-C5D8D5E8DFCA}")if not dcb then return false end
local _db=a_a(da:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","abilities"),bbb)
local adb=ba.ability_utilities.getAbilityStatisticsForRank(_cb,_db)local bdb=_cb.targetingData;if not bdb then return true end;local cdb=false
local function ddb(d_c)
local _ac=bdb[d_c]
if typeof(_ac)=="string"then
if adb[_ac]then _ac=adb[_ac]elseif _cb[_ac]then _ac=_cb[_ac]end elseif typeof(_ac)=="function"then
_ac=_ac(da:invoke("{0659F187-209D-48FD-AE95-040A0C31DB94}",bbb))end;return _ac end
local function __c(d_c)local _ac=game:GetService("ContextActionService")
local aac=game:GetService("RunService").Heartbeat;local bac=true;local cac={}do
for _bc,abc in
pairs(da:invoke("{3BEE1289-FC66-41D7-A436-85EC9777345C}"))do if abc~=cbb then table.insert(cac,abc)end end end
_ac:BindAction("confirmTargeting",function(_bc,abc,bbc)if
abc~=Enum.UserInputState.Begin then return end
bac=false end,false,Enum.UserInputType.MouseButton1,Enum.UserInputType.Touch,unpack(cac))
_ac:BindAction("cancelTargeting",function(_bc,abc,bbc)
if abc~=Enum.UserInputState.Begin then return end;cdb=true;bac=false end,false,cbb or
Enum.KeyCode.Unknown)local dac
dac=b_a.Event:Connect(function()cdb=true;bac=false;dac:Disconnect()end)while bac do
d_c(da:invoke("{0659F187-209D-48FD-AE95-040A0C31DB94}",bbb))aac:Wait()end
_ac:UnbindAction("confirmTargeting")_ac:UnbindAction("cancelTargeting")
dac:Disconnect()end
local function a_c()local d_c=Instance.new("Part")d_c.Anchored=true
d_c.CanCollide=false;d_c.TopSurface=Enum.SurfaceType.Smooth
d_c.BottomSurface=Enum.SurfaceType.Smooth;d_c.Material=Enum.Material.ForceField
d_c.Color=Color3.new(0.75,0.75,0.75)d_c.Transparency=0.5;d_c.CastShadow=false;return d_c end;local b_c,c_c
if bdb.onStarted then c_c=d:GenerateGUID()
local d_c=da:invoke("{0659F187-209D-48FD-AE95-040A0C31DB94}",bbb)b_c=bdb.onStarted(dcb,d_c)
da:fireServer("{2581F2A9-703B-4F16-92AF-36663C1F5160}",bbb,c_c,ccb,d_c)end
if bdb.targetingType=="directSphere"then local d_c=ddb("range")local _ac=a_c()
_ac.Shape=Enum.PartType.Ball;_ac.Size=Vector3.new(2,2,2)*ddb("radius")
_ac.Parent=ac
__c(function(aac)local bac=aac["mouse-target-position"]local cac=ccb.Position
local dac=bac-cac;local _bc=dac.Magnitude
if _bc>d_c then bac=cac+ (dac/_bc)*d_c end;_ac.Position=bac end)_ac:Destroy()elseif bdb.targetingType=="directCylinder"then
local d_c=ddb("range")local _ac=a_c()_ac.Shape=Enum.PartType.Cylinder;_ac.Size=
Vector3.new(2,2,2)*ddb("radius")_ac.Parent=ac
__c(function(aac)
local bac=aac["mouse-target-position"]local cac=ccb.Position;local dac=bac-cac;local _bc=dac.Magnitude;if _bc>d_c then bac=cac+
(dac/_bc)*d_c end;_ac.CFrame=CFrame.new(bac)*CFrame.Angles(0,0,
math.pi/2)end)_ac:Destroy()elseif bdb.targetingType=="line"then local d_c=ddb("width")
local _ac=ddb("length")local aac=a_c()aac.Size=Vector3.new(d_c,d_c,_ac)aac.Parent=ac
__c(function(bac)
local cac=ccb.Position;local dac=bac["mouse-target-position"]
local _bc=(dac-cac)*Vector3.new(1,0,1)
aac.CFrame=CFrame.new(cac,cac+_bc)*CFrame.new(0,0,-_ac/2)end)aac:Destroy()elseif bdb.targetingType=="projectile"then
local d_c=dcb:FindFirstChild("entity")if not d_c then return false end;local _ac=(b_c and b_c.projectionPart)or
d_c:FindFirstChild("RightHand")if not _ac then
return false end;local aac=ddb("projectileSpeed")
local bac=ddb("projectileGravity")local function cac()
if _ac:IsA("Attachment")then return _ac.WorldPosition else return _ac.Position end end
local function dac(cbc)return
db.getUnitVelocityToImpact_predictive(cac(),aac,cbc,Vector3.new(),bac)end
local _bc,abc,bbc=db.showProjectilePath(cac(),Vector3.new(),3,bac)
__c(function(cbc)local dbc=dac(cbc["mouse-target-position"])
if dbc then db.updateProjectilePath(_bc,abc,bbc,cac(),
dbc*aac,3,bac)end end)_bc:Destroy()abc:Destroy()bbc:Destroy()end
if bdb.onEnded then
local d_c=da:invoke("{0659F187-209D-48FD-AE95-040A0C31DB94}",bbb)bdb.onEnded(dcb,d_c,b_c)
da:fireServer("{B9B957FF-963D-41E0-A64D-CF4DD5D07AC6}",bbb,c_c,ccb,d_c)end;if cdb then return false end;return true end;local d_a=false;local function _aa(...)if d_a then return false end;d_a=true;local bbb={c_a(...)}d_a=false;return
unpack(bbb)end;local aaa={}
local baa=true
local function caa(bbb,...)if not baa then return end;baa=false
delay(0.05,function()baa=true end)b_a:Fire()local cbb=dd[bbb]
if cbb then local dbb=dd[bbb]
if
dbb.dataType==ab.dataType.item then
local _cb=da:invoke("{6126742D-1497-4C61-B4A2-7787E1E36454}",dbb.id)
local acb=script.Parent.decor:FindFirstChild(bbb.Name:gsub("hotbarButton",""))if acb then acb.ImageColor3=Color3.fromRGB(0,255,255)
cb(acb,{"ImageColor3"},Color3.fromRGB(72,72,76),0.5)end;if _cb then
da:invoke("{A1D46A31-29BA-4A4A-BCE2-E06641926EF8}",_cb)end elseif dbb.dataType==ab.dataType.ability then
local _cb=script.Parent.decor:FindFirstChild(bbb.Name:gsub("hotbarButton",""))
if _cb then _cb.ImageColor3=Color3.fromRGB(0,255,255)end
local acb,bcb=da:invoke("{2AF94E4D-BAA6-4C38-9DB3-E0E8E3C71685}",dbb.id,bbb,...)
if acb then local ccb=_aa(dbb.id,dbb.keyCode)if ccb then
local dcb,_db=da:invoke("{7A60EE45-884C-4454-8518-F0B368D30D75}",dbb.id,bbb,...)end else
_b.playSound("error")
if _cb then _cb.ImageColor3=Color3.fromRGB(255,0,0)end
if bcb=="missing-mana"then ba.statusBars.manaWarning()end end;if _cb then
cb(_cb,{"ImageColor3"},Color3.fromRGB(72,72,76),0.5)end end end end;local daa
local function _ba(bbb)local cbb=tick()+bbb;daa=cbb;for dbb,_cb in pairs(dd)do
if _cb and
_cb.dataType==ab.dataType.item then if dbb:FindFirstChild("cooldown")then
dbb.cooldown.Visible=true end end end
spawn(function()
wait(bbb)
if daa==cbb then for dbb,_cb in pairs(dd)do
if _cb and _cb.dataType==ab.dataType.item then if
dbb:FindFirstChild("cooldown")then dbb.cooldown.Visible=false end end end end end)end
da:create("{128DE203-3671-40A9-9C56-D5E9534ABB5E}","BindableFunction","OnInvoke",_ba)
local aba={One="1",KeypadOne="1",Two="2",KeypadTwo="2",Three="3",KeypadThree="3",Four="4",KeypadFour="4",Five="5",KeypadFive="5",Six="6",KeypadSix="6",Seven="7",KeypadSeven="7",Eight="8",KeypadEight="8",Nine="9",KeypadNine="9",Zero="0",KeypadZero="0"}local bba={}local cba=game:GetService("RunService")local dba;local _ca="slow"
local function aca()end;local function bca()end
local function cca(bbb)if bbb then return dd[bbb]end;return nil end;script.Parent.xboxBinding.Visible=false
script.Parent.xboxBindPrompt.Visible=false;local function dca(bbb)if not bd then return end
for cbb,dbb in pairs(bd)do if dbb.position==bbb then return dbb end end;return nil end
local _da={}
local function ada(bbb,cbb,dbb)_da[bbb]=_da[bbb]or{}if _da[bbb][cbb]==nil then
_da[bbb][cbb]=bbb[cbb]end
if dbb then bbb[cbb]=dbb else bbb[cbb]=_da[bbb][cbb]end end;local function bda(bbb)
for cbb,dbb in pairs(bbb)do ada(dbb[1],dbb[2],dbb[3])end end
local function cda()script.Parent.selectedDecor.Visible=
ba.input.mode.Value=="xbox"
if
ba.input.mode.Value=="mobile"then
bda({{script.Parent.Parent.statusBars,"Position",UDim2.new(0.25,0,1,-70)},{script.Parent.Parent.Parent.statusEffects,"Position",UDim2.new(0,5,1,
-110)},{script.Parent.content,"Position",UDim2.new(1,
-220,1,-216)},{script.Parent.content,"Size",UDim2.new(0,200,0,190)},{script.Parent.decor,"Position",UDim2.new(1,
-220,1,-220)},{script.Parent.decor,"Size",UDim2.new(0,200,0,200)},{script.Parent,"Size",UDim2.new(1.2,0,0,60)},{script.Parent.decor.UIGridLayout,"StartCorner","BottomRight"},{script.Parent.content.UIGridLayout,"StartCorner","BottomRight"}})else
bda({{script.Parent.Parent.statusBars,"Position"},{script.Parent.Parent.Parent.statusEffects,"Position"},{script.Parent.content,"Position"},{script.Parent.content,"Size"},{script.Parent.decor,"Position"},{script.Parent.decor,"Size"},{script.Parent,"Size"},{script.Parent.decor.UIGridLayout,"StartCorner"},{script.Parent.content.UIGridLayout,"StartCorner"}})end end;ba.input.mode.changed:connect(cda)
cda()script.Parent.selectedDecor.ImageTransparency=1;for bbb,cbb in
pairs(script.Parent.selectedDecor:GetChildren())do cbb.ImageTransparency=1 end
_a.focused=false;local dda;local __b
function _a.showSelectionPrompt(bbb)__b=bbb
script.Parent.xboxBindPrompt.contents.itemIcon.Image=bbb.Image;script.Parent.xboxBindPrompt.Visible=true end
function _a.hideSelectionPrompt(bbb)if __b==bbb then
script.Parent.xboxBindPrompt.Visible=false end end;local a_b
_a.captureFocus=function()
if not _a.focused then _a.focused=true
script.Parent.xboxBinding.Visible=false;for cbb,dbb in
pairs(script.Parent.content:GetChildren())do
if dbb:FindFirstChild("xboxPrompt")then dbb.xboxPrompt.Visible=true end end
local bbb=game.GuiService.SelectedObject
if bbb and bbb:FindFirstChild("bindable")then dda=bbb
script.Parent.xboxBinding.contents.curveBG.itemIcon.Image=bbb.Image;script.Parent.xboxBinding.Visible=true
a_b=ba.focus.focused;game.GuiService.GuiNavigationEnabled=false;for cbb,dbb in
pairs(script.Parent.content:GetChildren())do
if dbb:FindFirstChild("xboxPrompt")then dbb.xboxPrompt.Visible=true end end else dda=nil
cb(script.Parent.selectedDecor,{"ImageTransparency"},0,0.3)
for cbb,dbb in
pairs(script.Parent.selectedDecor:GetChildren())do local _cb=tonumber(dbb.Name)if _cb then
cb(dbb,{"ImageTransparency"},_cb,1 -_cb)end end end end end
_a.releaseFocus=function(bbb)
local cbb=bbb==nil or bbb.KeyCode==Enum.KeyCode.ButtonL2
if bbb then
for dbb,_cb in
pairs(script.Parent.content:GetChildren())do
if _cb:FindFirstChild("xboxKeyCode")then
if
bbb.KeyCode.Name==_cb.xboxKeyCode.Value then
if script.Parent.xboxBinding.Visible and dda then
ba.uiCreator.processSwap(dda,_cb,false)cbb=true else caa(_cb)end end end end end
if cbb then script.Parent.xboxBinding.Visible=false
if
a_b==
ba.focus.focused or game.GuiService.GuiNavigationEnabled==dda then game.GuiService.GuiNavigationEnabled=true end;for dbb,_cb in
pairs(script.Parent.content:GetChildren())do
if _cb:FindFirstChild("xboxPrompt")then _cb.xboxPrompt.Visible=false end end
if _a.focused then
cb(script.Parent.selectedDecor,{"ImageTransparency"},1,0.3)
for dbb,_cb in
pairs(script.Parent.selectedDecor:GetChildren())do local acb=tonumber(_cb.Name)if acb then
cb(_cb,{"ImageTransparency"},1,1 -acb)end end end;_a.focused=false end end
da:create("{D25B262F-2680-4CB6-A98E-1A5A5E31DA12}","BindableFunction","OnInvoke",function()local bbb={}
for i=1,10 do local cbb=script.Parent.content:FindFirstChild(
"hotbarButton"..i)if cbb then
table.insert(bbb,{button=cbb,data=dd[cbb]})end end;return bbb end)local b_b={}
local function c_b(bbb,cbb,dbb)local _cb=cbb%10;if b_b[cbb]then
for _db,adb in pairs(b_b[cbb])do adb:Disconnect()end else b_b[cbb]={}end;local acb=b_b[cbb]
local bcb=dca(_cb)bbb.LayoutOrder=cbb;bbb.Name="hotbarButton"..cbb
bbb.ImageTransparency=1;bbb.Image=""local ccb=_a.xboxHotbarKeys[cbb]
bbb.xboxPrompt.key.Image=ccb.image;bbb.xboxKeyCode.Value=ccb.keyCode.Name
bbb.duplicateCount.Visible=false;bbb.level.Visible=false;local dcb=__a()
for _db,adb in pairs(bbb:GetChildren())do
if
adb:FindFirstChild("keyCode")then adb.ImageTransparency=0;adb.backdrop.ImageTransparency=0
adb.keyCode.TextTransparency=0;adb.keyCode.TextStrokeTransparency=0 end end
if bcb then dd[bbb]=bcb
local _db=script.Parent.decor:FindFirstChild(bbb.Name:gsub("hotbarButton",""))if _db then _db.ImageTransparency=0 end
if
bcb.dataType==ab.dataType.item then
bbb.duplicateCount.Text=tostring(dcb[bcb.id]or 0)local adb=cc[bcb.id]
if adb then bbb.Image=adb.image;bbb.inputKey.Text="["..
tostring(bcb.keyCode or _cb).."]"bbb.keyCode.Value=tostring(
bcb.keyCode or _cb)
bb.setIsDoubleClickFrame(bbb,0.2,caa)
acb.hovered=bbb.MouseEnter:connect(function()
da:invoke("{F2C470EF-8710-44BB-9203-C4357B8E4FA2}",adb,"equipment",bcb)end)
acb.unhovered=bbb.MouseLeave:connect(function()
da:invoke("{F2C470EF-8710-44BB-9203-C4357B8E4FA2}")end)table.insert(bba,bbb)end;bbb.duplicateCount.Visible=true;bbb.ImageTransparency=0 elseif bcb.dataType==
ab.dataType.ability then
local adb=da:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","abilities")local bdb=a_a(adb,bcb.id)
local cdb=da:invoke("{4947D6C0-3492-484E-8D54-243215910D55}")local ddb=dc[bcb.id](cdb,nil)
local __c=ba.ability_utilities.getAbilityStatisticsForRank(ddb,bdb)
if ddb and __c then
local a_c=game.TextService:GetTextSize(bbb.level.Text,bbb.level.TextSize,bbb.level.Font,Vector2.new())bbb.level.Size=UDim2.new(0,a_c.X+2,0,a_c.Y-2)
bbb.level.Text=_b.romanNumerals[bdb]local b_c=__c.tier or 1
bbb.level.TextColor3=ba.itemAcquistion.tierColors[b_c]bbb.Image=ddb.image;bbb.inputKey.Text="["..tostring(bcb.keyCode or _cb)..
"]"bbb.keyCode.Value=tostring(
bcb.keyCode or _cb)
bb.setIsDoubleClickFrame(bbb,0.2,caa)table.insert(bba,bbb)end;bbb.duplicateCount.Visible=false;bbb.ImageTransparency=0 else end else
for adb,bdb in pairs(bbb:GetChildren())do
if bdb:FindFirstChild("keyCode")then
bdb.ImageTransparency=1;bdb.backdrop.ImageTransparency=1
bdb.keyCode.TextTransparency=1;bdb.keyCode.TextStrokeTransparency=1 end end
local _db=script.Parent.decor:FindFirstChild(bbb.Name:gsub("hotbarButton",""))if _db then _db.ImageTransparency=0.5 end end end
local function d_b(bbb)if bbb then bd=bbb end
if bd then dd={}
for i=1,10 do
local cbb=
script.Parent.content:FindFirstChild("hotbarButton"..i)or script.hotbarButton:Clone()cbb.Name="hotbarButton"..i
cbb.Parent=script.Parent.content;c_b(cbb,i)bb.drag.setIsDragDropFrame(cbb)end end end;local _ab=ba.fx;local aab=Random.new()local bab=0
local function cab()
local bbb=da:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","exp")
local cbb=da:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","level")local dbb=bbb
local _cb=math.floor(ba.levels.getEXPToNextLevel(cbb))bab=bbb
script.Parent.Frame.xp.title.Text="XP: "..
_b.formatNumber(dbb).."/".._b.formatNumber(_cb)
script.Parent.Frame.xp.value.Size=UDim2.new(dbb/_cb,0,1,0)
script.Parent.Frame.xp.instant.Size=script.Parent.Frame.xp.value.Size end;cab()
script.Parent.Frame.xp.MouseEnter:connect(function()
script.Parent.Frame.xp.title.Visible=true;aa=true end)
script.Parent.Frame.xp.MouseLeave:connect(function()
script.Parent.Frame.xp.title.Visible=false;aa=false end)local dab
local function _bb(bbb,cbb)
if bbb=="hotbar"then d_b(cbb)elseif bbb=="inventory"then cd=cbb;d_b()elseif bbb=="abilities"then
d_b()elseif bbb=="nonSerializeData"then local dbb=cbb.statistics_final;if dab==nil then dab=dbb;d_b()else
for _cb,acb in
pairs(dab)do if dbb[_cb]~=acb then dab=dbb;d_b()break end end end elseif bbb=="exp"then local dbb=bbb
local _cb=cbb
local acb=da:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","level")local bcb=_cb
local ccb=math.floor(ba.levels.getEXPToNextLevel(acb))
script.Parent.Frame.xp.title.Text="XP: "..
_b.formatNumber(bcb).."/".._b.formatNumber(ccb)local dcb=bcb-bab
local _db=script.Parent.Frame.noticeTemplate:Clone()_db.Name="Notice"_db.TextTransparency=1;_db.TextStrokeTransparency=1
_db.Parent=script.Parent.Frame;_db.Visible=true
_db.Text="+".._b.formatNumber(dcb).." EXP"
_db.Position=UDim2.new(0.5,aab:NextInteger(-50,50),0,aab:NextInteger(-30,40))
ba.tween(_db,{"Position"},_db.Position+UDim2.new(0,0,0,-100),3)
ba.tween(_db,{"TextTransparency","TextStrokeTransparency"},{0,0.7},1.5)game.Debris:AddItem(_db,10)
local adb=script.Parent.Frame.xp.value.value.tip.sample
for i=1,6 do local bdb=adb:Clone()bdb.Rotation=math.random(1,90)
bdb.Parent=adb.Parent;bdb.Visible=true
cb(bdb,{"Rotation","Position","Size","BackgroundTransparency"},{
bdb.Rotation+math.random(100,200),UDim2.new(0,math.random(3,25),0.5,math.random(-20,20)),UDim2.new(0,16,0,16),1},
math.random(60,130)/100)game.Debris:AddItem(bdb,1.5)end
if bcb<bab then
ba.tween(script.Parent.Frame.xp.value,{"Size"},{UDim2.new(1,0,1,0)},0.5)
script.Parent.Frame.xp.instant.Size=UDim2.new(1,0,1,0)
spawn(function()wait(0.25)
script.Parent.Frame.xp.value.Size=UDim2.new(1,0,0,0)local bdb=UDim2.new(bcb/ccb,0,1,0)
ba.tween(script.Parent.Frame.xp.value,{"Size"},{bdb},0.5)
script.Parent.Frame.xp.instant.Size=bdb end)else
ba.tween(script.Parent.Frame.xp.value,{"Size"},{UDim2.new(bcb/ccb,0,1,0)},1)
script.Parent.Frame.xp.instant.Size=UDim2.new(bcb/ccb,0,1,0)end;script.Parent.Frame.xp.Visible=true;bab=_cb
spawn(function()
wait(0.5)
ba.tween(_db,{"TextTransparency","TextStrokeTransparency"},{1,1},1.5)wait(3)if bab==_cb and not aa then end end)end end
local function abb()
cd=da:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","inventory")local bbb={"1","2","3","4","5","6","7","8","9","0"}
for i=1,10 do local cbb=i%10
da:invoke("{7AE42210-0ED8-4379-800E-3C54632521A1}",
"hotbarButton"..i,function(dbb)
local _cb=script.Parent.content:FindFirstChild("hotbarButton"..i)
if _cb then local acb=dd[_cb]if acb then acb.keyCode=dbb.KeyCode end;caa(_cb)end end,bbb[i],10)end
d_b(da:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","hotbar"))
da:connect("{B5BFDE4F-1C2E-4D65-ACB4-277DB309BF6D}","Event",_bb)
da:create("{0DDCC4A0-F15A-41C7-BE2A-50C0EE574D2C}","BindableFunction","OnInvoke",cca)end;abb()_a.releaseFocus()end;return _a