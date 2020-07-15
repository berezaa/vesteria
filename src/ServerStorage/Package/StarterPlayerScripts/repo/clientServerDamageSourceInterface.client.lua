
local _cb=script.Parent.Parent:WaitForChild("assets")local acb={}local bcb=game.Players.LocalPlayer
local ccb=game:GetService("UserInputService")local dcb=game:GetService("CollectionService")
local _db=game:GetService("HttpService")local adb=game:GetService("ReplicatedStorage")
local bdb=require(adb.modules)local cdb=bdb.load("network")local ddb=bdb.load("utilities")
local __c=bdb.load("placeSetup")local a_c=bdb.load("mapping")local b_c=bdb.load("detection")
local c_c=bdb.load("damage")local d_c=bdb.load("projectile")
local _ac=bdb.load("client_utilities")local aac=bdb.load("events")local bac=bdb.load("tween")
local cac=bdb.load("effects")local dac=bdb.load("ability_utilities")
local _bc=require(adb.itemData)local abc=require(adb.abilityLookup)
local bbc=require(script.Parent.Resources)local cbc=__c.awaitPlaceFolder("entityRenderCollection")
local dbc=__c.awaitPlaceFolder("entityManifestCollection")local _cc=__c.awaitPlaceFolder("items")
local acc=__c.awaitPlaceFolder("entities")local bcc;local ccc;local dcc;local _dc=true;local adc=false;local bdc=false;local function cdc(d__a)_dc=d__a
if not _dc and adc then if
bcc and bcc.release then adc=false;bcc:release()end end end
local function ddc()
local d__a=cdb:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","equipment")if d__a then
for _a_a,aa_a in pairs(d__a)do if aa_a.position==1 then return aa_a end end end;return nil end
local function __d(d__a,_a_a)local aa_a=d__a.equipmentType;if aa_a==_a_a then return true end;if _a_a=="sword"and aa_a==
"greatsword"then return true end;local ba_a=
(_a_a=="dagger")or(_a_a=="bow")
local ca_a=(aa_a=="dagger")or(aa_a=="bow")
if ba_a and ca_a then
local da_a=cdb:invoke("{7FE9D2B7-10FB-4012-8803-C5D8D5E8DFCA}")if not da_a then return false end
local _b_a=cdb:invoke("{CA61CBF0-3B04-4617-8D2D-50C80D51AB19}",da_a.entity)if not _b_a then return false end;local ab_a=_b_a["11"]if(not ab_a)or
(not ab_a.baseData)then return false end;if ab_a.baseData.equipmentType==
_a_a then
cdb:invokeServer("{56442647-1FBF-41E3-96CF-6908E65BE3DB}")return true end end;return false end
local function a_d(d__a)
if d__a.Parent:FindFirstChild("clientHitboxToServerHitboxReference")then return
d__a.Parent.clientHitboxToServerHitboxReference.Value end end
local function b_d(d__a)
for _a_a,aa_a in pairs(cbc:GetChildren())do
if

aa_a:FindFirstChild("clientHitboxToServerHitboxReference")and aa_a.clientHitboxToServerHitboxReference.Value==d__a then return aa_a.PrimaryPart end end end
local function c_d(d__a,_a_a,aa_a,ba_a,ca_a,da_a)
if c_c.canPlayerDamageTarget(bcb,d__a)then
cdb:fire("{E29E22FB-E00A-4D5C-924C-01172195752D}",_a_a)
cdb:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",d__a,_a_a,aa_a,ba_a,ca_a,da_a)end end;local d_d
local function _ad(d__a)local _a_a=_bc[d__a.id]
if

_a_a and _a_a.isEquippable and _a_a.equipmentType and _a_a.equipmentSlot==a_c.equipmentPosition.weapon then
if
not bcc and _cb.damageInterfaces:FindFirstChild(_a_a.equipmentType)then d_d=_a_a.equipmentType
if dcc and dcc:FindFirstChild("entity")then
local aa_a=cdb:invoke("{CA61CBF0-3B04-4617-8D2D-50C80D51AB19}",dcc.entity)
if aa_a["1"]and aa_a["11"]then
if

aa_a["1"].baseData.equipmentType=="sword"and aa_a["11"].baseData.equipmentType=="sword"then d_d="dual"elseif aa_a["1"].baseData.equipmentType=="sword"and
aa_a["11"].baseData.equipmentType=="shield"then
d_d="swordAndShield"end end end end;if d_d then bcc=require(_cb.damageInterfaces[d_d])
bcc:equip()end end end
local function aad()if bcc then bcc:unequip()bcc=nil;d_d=nil end end
local function bad(d__a)
if d__a then local _a_a
for aa_a,ba_a in pairs(d__a)do if ba_a.position==a_c.equipmentPosition.weapon then
_a_a=ba_a end end
if _a_a then if bcc then aad()end;_ad(_a_a)else if bcc then aad()end end else end end
local function cad(d__a,_a_a)if d__a=="equipment"then bad(_a_a)end end
local function dad(d__a)ccc=d__a;if d__a:IsA("BasePart")then
d__a.Touched:Connect(function()end)end end;local _bd={}local abd={}local bbd
local function cbd(d__a)dcc=d__a
local _a_a=d__a.entity:WaitForChild("AnimationController")
while not _a_a:IsDescendantOf(workspace)do wait()end;if bcc then bcc:equip()end
bbd=_a_a:LoadAnimation(game.ReplicatedStorage.abilityAnimations.rock_throw_upper_loop)end;local function dbd(d__a)
local _a_a=cdb:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","equipment")bad(_a_a)end
local _cd={dual=.15,dagger=.15,sword=.23,staff=.23,bow=0}local acd
local function bcd(d__a,_a_a)
if _dc and bcc and not _a_a and not
cdb:invoke("{CB505807-178C-4E8F-AE40-B0B823BF476E}")then
if



d__a.UserInputType==Enum.UserInputType.Touch or d__a.UserInputType==
Enum.UserInputType.MouseButton1 or d__a.KeyCode==Enum.KeyCode.LeftControl or d__a.KeyCode==Enum.KeyCode.ButtonR2 then
if cdb:invoke("{BF956380-404B-41BA-8742-E8FD573AD12E}")then return end;if acd then return end
cdb:invoke("{F9682973-5852-429E-9BAC-8EBECA22DD97}","isSprinting",false)aac:fireEventAll("playerWillUseBasicAttack",bcb)
bcc:attack(d__a)
cdb:fire("{CB527931-903D-443E-9010-9C92D87E9BE2}","attack")
cdb:fire("{E7FC437C-0080-4CDD-A9D5-BC1E7A0FE7BF}",true)
local aa_a=cdb:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","nonSerializeData").statistics_final;local ba_a=.25;if _cd[d_d]then
ba_a=_cd[d_d]/ (1 +aa_a.attackSpeed)end end end end
local function ccd(d__a,_a_a)
if adc and bcc and not _a_a and bcc.release then
if

d__a.UserInputType==
Enum.UserInputType.MouseButton1 or d__a.KeyCode==Enum.KeyCode.LeftControl or d__a.KeyCode==Enum.KeyCode.ButtonR2 then bcc:release()adc=false end elseif adc and bcc then
if

d__a.UserInputType==Enum.UserInputType.MouseButton1 or
d__a.KeyCode==Enum.KeyCode.LeftControl or d__a.KeyCode==Enum.KeyCode.ButtonR2 then adc=false
cdb:fire("{E7FC437C-0080-4CDD-A9D5-BC1E7A0FE7BF}",false)end end end
local function dcd(d__a,_a_a)
if not d__a then d__a=bcb.Character.PrimaryPart.Position end;ddb.playSound(_a_a,d__a)end
cdb:connect("{DE89E914-D0E2-44DA-BB30-C8D4CE035205}","OnClientEvent",dcd)
local function _dd(d__a,_a_a,aa_a)local ba_a=_a_a:FindFirstChild("attackableScript")
if not ba_a then return end
cdb:fire("{E29E22FB-E00A-4D5C-924C-01172195752D}",aa_a,d__a~=bcb)ba_a=require(ba_a)ba_a.onAttackedClient(d__a)end
cdb:connect("{9042BF38-39B3-490D-BF5E-1C0771CC5A55}","OnClientEvent",_dd)
local function add(d__a)
if d__a and d__a:IsA("Model")then
if d__a.PrimaryPart then
local _a_a=d__a:FindFirstChild("originalCFrame")
if _a_a==nil then _a_a=Instance.new("CFrameValue")
_a_a.Name="originalCFrame"_a_a.Value=d__a.PrimaryPart.CFrame;_a_a.Parent=d__a end;local aa_a=_a_a.Value;local ba_a=d__a.PrimaryPart
local ca_a=aa_a*
CFrame.new(0,-ba_a.Size.Y/2,0)*
CFrame.Angles(0,math.pi*2 *math.random(),0)local da_a=ca_a:ToObjectSpace(aa_a)
local _b_a=Instance.new("Part")_b_a.CFrame=ca_a;local ab_a=0.2;local bb_a=Enum.EasingStyle.Quad
bac(_b_a,{"CFrame"},
ca_a*CFrame.Angles(0.075,0,0),ab_a,bb_a,Enum.EasingDirection.Out)
delay(ab_a,function()
bac(_b_a,{"CFrame"},ca_a,ab_a,bb_a,Enum.EasingDirection.In)end)
cac.onHeartbeatFor(ab_a*2,function()
d__a:SetPrimaryPartCFrame(_b_a.CFrame:ToWorldSpace(da_a))end)end end end;local bdd={}
local function cdd(d__a,_a_a)local aa_a=_a_a.Name:lower()
if

(aa_a=="grass")or(aa_a=="leaf")or(aa_a=="bush")or(aa_a=="green")then
if not d__a["strikeFoliage"]then
local ba_a="bush"..math.random(1,3)dcd(_a_a.Position,ba_a)
cdb:fireServer("{DE89E914-D0E2-44DA-BB30-C8D4CE035205}",_a_a,ba_a)add(_a_a.Parent)end end;if(aa_a=="stump")or(aa_a=="log")or(aa_a=="wood")then
add(_a_a.Parent)end
if dcb:HasTag(_a_a,"attackable")then
if
_a_a:IsDescendantOf(__c.getPlaceFolder("resourceNodes"))then local ba_a=_a_a:FindFirstAncestorWhichIsA("Model")
add(ba_a)local ca_a=cdb:invokeServer("HarvestResource",ba_a)
bbc:DoEffect(ba_a,"Harvest")if ca_a then ca_a.Transparency=1 end else
local ba_a=b_c.projection_Box(_a_a.CFrame,_a_a.Size,ccc.Position)_dd(bcb,_a_a,ba_a)
cdb:fireServer("{9042BF38-39B3-490D-BF5E-1C0771CC5A55}",_a_a,ba_a)end end end
local function ddd(d__a)local _a_a=bdd[d__a]if not _a_a then _a_a={}bdd[d__a]=_a_a
delay(5,function()bdd[d__a]=nil end)end;for aa_a,ba_a in
pairs(ccc:GetTouchingParts())do
if not _a_a[ba_a]then _a_a[ba_a]=true;cdd(_a_a,ba_a)end end end;local ___a={}
local function a__a(d__a,_a_a,aa_a)
if(d__a=="equipment"and ccc)then
if not ___a[aa_a]then ___a[aa_a]={}delay(5,function()___a[aa_a]=
nil end)end;ddd(aa_a)
local ba_a=1 +
cdb:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","nonSerializeData").statistics_final.attackRangeIncrease
for ca_a,da_a in pairs(ddb.getEntities())do
if da_a~=bcb.Character.PrimaryPart then
if not
___a[aa_a][da_a]then local _b_a=ccc.CFrame
local ab_a=b_c.projection_Box(da_a.CFrame,da_a.Size,_b_a.p)
if
b_c.boxcast_singleTarget(_b_a,ccc.Size*Vector3.new(3 +ba_a,2 +ba_a,3 +ba_a),ab_a)then ___a[aa_a][da_a]=true
cdb:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",da_a,ab_a,d__a,_a_a,aa_a)end end end end else end end
local function b__a()local d__a=ddc()return _bc[d__a.id].equipmentType end
local function c__a()
cdb:create("{86F81874-E106-420D-B215-D322A8D18B96}","BindableFunction","OnInvoke",b__a)
cdb:create("{7312D87A-2CEB-427E-9FC9-78CB6711E469}","BindableFunction","OnInvoke",cdc)
cdb:create("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}","BindableEvent","Event",c_d)
cdb:create("{5F5D5BE5-27D1-4783-ABB2-4C83A1E617AE}","BindableFunction","OnInvoke",a__a)
cdb:connect("{B5BFDE4F-1C2E-4D65-ACB4-277DB309BF6D}","Event",cad)
ccc=cdb:invoke("{E1A443FB-62B9-4FA8-B0D1-0930199949A1}")
cdb:connect("{7C64A511-FF4D-4ADC-B9A2-2E5EDDB8E412}","Event",dad)
local d__a=cdb:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","equipment")
local _a_a=cdb:invoke("{7FE9D2B7-10FB-4012-8803-C5D8D5E8DFCA}")if _a_a then cbd(_a_a)end
cdb:connect("{8BABF769-4B51-49E3-9501-B715DD0790C7}","Event",cbd)if bcb.Character then dbd(bcb.Character)end
bcb.CharacterAdded:connect(dbd)ccb.InputBegan:connect(bcd)
ccb.InputEnded:connect(ccd)end;c__a()return acb