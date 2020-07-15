local __c={}local a_c=game.Players.LocalPlayer
local b_c=script.Parent.Parent:WaitForChild("assets")local c_c=game:GetService("RunService")
local d_c=game:GetService("HttpService")local _ac=game:GetService("ReplicatedStorage")
local aac=require(_ac:WaitForChild("modules"))local bac=aac.load("network")local cac=aac.load("tween")
local dac=aac.load("detection")local _bc=aac.load("utilities")local abc=aac.load("physics")
local bbc=aac.load("placeSetup")
local cbc=bbc.awaitPlaceFolder("entityManifestCollection")local dbc=bbc.awaitPlaceFolder("entityRenderCollection")
local _cc=bbc.awaitPlaceFolder("entities")local acc=aac.load("mapping")local bcc=aac.load("levels")
local ccc=aac.load("projectile")local dcc=aac.load("damage")
local _dc=aac.load("configuration")local adc=aac.load("events")
local bdc=require(_ac:WaitForChild("defaultCharacterAppearance"))local cdc=_ac:WaitForChild("playerBaseCharacter")
local ddc=require(_ac.defaultMonsterState).states;local __d;local a_d=_ac.accessoryLookup;local b_d=require(_ac.itemData)
local c_d=require(_ac.monsterLookup)local d_d=require(_ac.abilityLookup)
local _ad=require(_ac.statusEffectLookup)local aad={}
local function bad(dd_a,__aa)local a_aa=Instance.new("Motor6D")a_aa.Part0=dd_a
a_aa.Part1=__aa;a_aa.C0=CFrame.new()
a_aa.C1=__aa.CFrame:toObjectSpace(dd_a.CFrame)a_aa.Name=__aa.Name;a_aa.Parent=dd_a end
local function cad(dd_a)
return dd_a:IsA("BasePart")and
_ac.playerBaseCharacter:FindFirstChild(dd_a.Name)and
_ac.playerBaseCharacter[dd_a.Name]:IsA("BasePart")end
local function dad(dd_a)local __aa={}
for a_aa,b_aa in pairs(dd_a:GetChildren())do
if b_aa:IsA("BasePart")or
b_aa:IsA("Model")then
local c_aa,d_aa,_aaa=string.match(b_aa.Name,"(%w+)_(%d+)_(%d+)")
if c_aa and d_aa then d_aa=tonumber(d_aa)_aaa=tonumber(_aaa)if
c_aa=="EQUIPMENT"then local aaaa=b_d[tonumber(d_aa)]
__aa[tostring(_aaa)]={baseData=aaaa,manifest=b_aa}end end end end;return __aa end
local function _bd(dd_a,__aa)local a_aa=b_d[__aa.id]if dd_a[a_aa.equipmentSlot]then
if __aa.id==
dd_a[tostring(a_aa.equipmentSlot)].baseData.id then return true end end;return false end
local function abd()local dd_a={}
local __aa=bac:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","inventory")
if __aa then for a_aa,b_aa in pairs(__aa)do
if dd_a[b_aa.id]then
dd_a[b_aa.id]=dd_a[b_aa.id]+ (b_aa.stacks or 1)else dd_a[b_aa.id]=b_aa.stacks or 1 end end end;return dd_a end
local function bbd(dd_a,__aa,a_aa)local b_aa;do if a_aa then
b_aa=game.Players:GetPlayerFromCharacter(a_aa.Parent)end end;__aa=
__aa or bdc
__aa.equipment=__aa.equipment or bdc.equipment;__aa.accessories=__aa.accessories or bdc.accessories
for abaa,bbaa in
pairs(dd_a:GetChildren())do
if



bbaa.Name=="!! ACCESSORY !!"or bbaa.Name=="!! EQUIPMENT-UPPER !!"or bbaa.Name=="!! EQUIPMENT !!"or bbaa.Name=="!! WEAPON !!"or bbaa.Name=="!! ARROW !!"then bbaa:Destroy()end end
if __aa and __aa.accessories.skinColorId then
for abaa,bbaa in
pairs(dd_a:GetChildren())do if bbaa:IsA("BasePart")and cad(bbaa)then
bbaa.Color=a_d.skinColor:FindFirstChild(tostring(
__aa.accessories.skinColorId or 1)).Value end end else
for abaa,bbaa in pairs(dd_a:GetChildren())do if
bbaa:IsA("BasePart")and cad(bbaa)then
bbaa.Color=BrickColor.new("Light orange").Color end end end;local c_aa;local d_aa=abd()
if __aa and __aa.equipment then
for abaa,bbaa in pairs(__aa.equipment)do
if
bbaa.position==
acc.equipmentPosition.upper or
bbaa.position==acc.equipmentPosition.lower or bbaa.position==
acc.equipmentPosition.head then local cbaa=bbaa.dye;if bbaa.position==acc.equipmentPosition.head then
c_aa=bbaa end
if
b_d[bbaa.id].module:FindFirstChild("container")then
for dbaa,_caa in
pairs(b_d[bbaa.id].module.container:GetChildren())do
if dd_a:FindFirstChild(_caa.Name)then if _caa:FindFirstChild("colorOverride")then
dd_a[_caa.Name].Color=_caa.Color end
for acaa,bcaa in pairs(_caa:GetChildren())do
if
bcaa:IsA("BasePart")then local ccaa=bcaa:Clone()ccaa.Anchored=false;ccaa.CanCollide=false;if cbaa then
local _daa=ccaa
ccaa.Color=Color3.new(_daa.Color.r*cbaa.r/255,
_daa.Color.g*cbaa.g/255,_daa.Color.b*cbaa.b/255)end
local dcaa=Instance.new("Motor6D",ccaa)dcaa.Name="projectionWeld"dcaa.Part0=ccaa
dcaa.Part1=dd_a[_caa.Name]dcaa.C0=CFrame.new()
dcaa.C1=_caa.CFrame:toObjectSpace(bcaa.CFrame)ccaa.Name="!! EQUIPMENT !!"ccaa.Parent=dd_a end end end end end elseif bbaa.position==acc.equipmentPosition.arrow then local cbaa=false
do
for dbaa,_caa in
pairs(__aa.equipment)do
if _caa.position==acc.equipmentPosition.weapon then if
b_d[_caa.id].equipmentType=="bow"then cbaa=true end end end end
if cbaa then
local dbaa=game.ReplicatedStorage.entities.ArrowUpperTorso2.strap:Clone()dbaa.Anchored=false;dbaa.CanCollide=false
local _caa=Instance.new("Motor6D",dbaa)_caa.Name="projectionWeld"_caa.Part0=dbaa;_caa.Part1=dd_a.UpperTorso
_caa.C0=CFrame.new()
_caa.C1=game.ReplicatedStorage.entities.ArrowUpperTorso2.CFrame:toObjectSpace(game.ReplicatedStorage.entities.ArrowUpperTorso2.strap.CFrame)dbaa.Name="!! ARROW !!"dbaa.Parent=dd_a
local acaa=game.ReplicatedStorage.entities.ArrowUpperTorso2.quiver:Clone()acaa.Anchored=false;acaa.CanCollide=false
local bcaa=Instance.new("Motor6D",acaa)bcaa.Name="projectionWeld"bcaa.Part0=acaa;bcaa.Part1=dd_a.UpperTorso
bcaa.C0=CFrame.new()
bcaa.C1=game.ReplicatedStorage.entities.ArrowUpperTorso2.CFrame:toObjectSpace(game.ReplicatedStorage.entities.ArrowUpperTorso2.quiver.CFrame)acaa.Name="!! ARROW !!"acaa.Parent=dd_a
local ccaa=d_aa[bbaa.id]or 0
local dcaa=math.clamp(math.floor(ccaa/
_dc.getConfigurationValue("arrowsPerArrowPartVisualization"))+1,0,_dc.getConfigurationValue("maxArrowPartsVisualization"))
local _daa=360 /_dc.getConfigurationValue("maxArrowPartsVisualization")
for ai=1,dcaa do
local adaa=b_d[bbaa.id].module.manifest:Clone()adaa.CanCollide=false;adaa.Anchored=false;adaa.Parent=acaa;local bdaa,cdaa=
math.random()*2 -1,math.random()*2 -1
local ddaa=Instance.new("Motor6D",acaa)ddaa.Name="projectionWeld"ddaa.Part0=acaa;ddaa.Part1=adaa
ddaa.C0=acaa.Attachment.CFrame
ddaa.C1=CFrame.Angles(bdaa*math.rad(15),0,cdaa*math.rad(15))end end end end else end
local _aaa=dd_a["RightHand"]:FindFirstChild("Grip")
local aaaa=dd_a["LeftHand"]:FindFirstChild("Grip")
local baaa=dd_a["UpperTorso"]:FindFirstChild("BackMount")
local caaa=dd_a["LowerTorso"]:FindFirstChild("HipMount")
local daaa=dd_a["UpperTorso"]:FindFirstChild("BackMount")local _baa=dad(dd_a)
for abaa,bbaa in pairs(_baa)do local cbaa=false;for dbaa,_caa in pairs(__aa.equipment)do if _bd(_baa,_caa)then
cbaa=true end end
if not cbaa then
if _aaa.Part1 ==
bbaa.manifest then _aaa.Part1=nil elseif aaaa.Part1 ==bbaa.manifest then aaaa.Part1=nil elseif
baaa.Part1 ==bbaa.manifest then baaa.Part1=nil elseif caaa.Part1 ==bbaa.manifest then
caaa.Part1=nil elseif baaa.Part1 ==bbaa.manifest then baaa.Part1=nil end;_baa[tostring(abaa)]=nil
bbaa.manifest:Destroy()end end
for abaa,bbaa in pairs(__aa.equipment)do
if not _bd(_baa,bbaa)then
if bbaa.position==
acc.equipmentPosition.weapon or
bbaa.position==acc.equipmentPosition["offhand"]then local cbaa=b_d[bbaa.id]
if cbaa and
(
cbaa.module:FindFirstChild("manifest")or cbaa.module:FindFirstChild("container"))then local dbaa;local _caa=bbaa.dye;local acaa=cbaa.gripType or
1;local bcaa=nil;if
bbaa.position==acc.equipmentPosition["offhand"]then acaa=acc.gripType.left end
local ccaa=cbaa.module:FindFirstChild("container")
if ccaa then
ccaa=ccaa:FindFirstChild("RightHand")or ccaa:FindFirstChild("LeftHand")ccaa=ccaa:Clone()
local __ba=ccaa:FindFirstChild("manifest")or ccaa.PrimaryPart
if __ba:IsA("BasePart")then
for a_ba,b_ba in pairs(ccaa:GetChildren())do
if b_ba~=__ba then
b_ba.Parent=__ba
if b_ba:IsA("BasePart")then if _caa then
b_ba.Color=Color3.new(b_ba.Color.r*_caa.r/255,
b_ba.Color.g*_caa.g/255,b_ba.Color.b*_caa.b/255)end end end end;if _caa then local a_ba=__ba
__ba.Color=Color3.new(a_ba.Color.r*_caa.r/255,
a_ba.Color.g*_caa.g/255,a_ba.Color.b*_caa.b/255)end;dbaa=__ba
bcaa=__ba.CFrame:toObjectSpace(dbaa.Parent.CFrame)elseif __ba:IsA("Model")then
for a_ba,b_ba in pairs(__ba:GetDescendants())do
if
b_ba:IsA("BasePart")then if _caa then
b_ba.Color=Color3.new(b_ba.Color.r*_caa.r/255,b_ba.Color.g*
_caa.g/255,b_ba.Color.b*_caa.b/255)end end end;dbaa=__ba
bcaa=__ba.PrimaryPart.CFrame:toObjectSpace(ccaa.CFrame)end elseif cbaa.module:FindFirstChild("manifest")then
dbaa=cbaa.module.manifest:Clone()if _caa then local __ba=dbaa
dbaa.Color=Color3.new(__ba.Color.r*_caa.r/255,
__ba.Color.g*_caa.g/255,__ba.Color.b*_caa.b/255)end end
dbaa.Name="EQUIPMENT_"..cbaa.id.."_"..bbaa.position;dbaa.Parent=dd_a
if dbaa:IsA("BasePart")then dbaa.Anchored=false
dbaa.CanCollide=false elseif dbaa:IsA("Model")then
for __ba,a_ba in pairs(dbaa:GetChildren())do if a_ba:IsA("BasePart")then
a_ba.Anchored=false;a_ba.CanCollide=false end end end;if ccaa then ccaa:Destroy()ccaa=nil end;local dcaa=bbaa.position==
acc.equipmentPosition.weapon
if a_aa and dcaa then
local __ba=aad[a_aa]__ba.currentPlayerWeapon=dbaa;__ba.weaponBaseData=cbaa
if
cbaa.equipmentType=="bow"then
if dbaa:FindFirstChild("AnimationController")then
local a_ba=__d:registerAnimationsForAnimationController(dbaa.AnimationController,"bowToolAnimations_noChar").bowToolAnimations_noChar;__ba.currentPlayerWeaponAnimations=a_ba else
__ba.currentPlayerWeaponAnimations=nil end else __ba.currentPlayerWeaponAnimations=nil end;if b_aa==a_c then
bac:fire("{7C64A511-FF4D-4ADC-B9A2-2E5EDDB8E412}",dbaa)end end
local _daa=bbaa.position==acc.equipmentPosition["offhand"]local adaa=false;local bdaa=false;local cdaa=false
if _daa then local __ba=cbaa.equipmentType
if __ba=="sword"or __ba==
"shield"then elseif __ba=="dagger"then bdaa=true elseif __ba=="amulet"then cdaa=true else adaa=true end end
local ddaa=bcaa or cbaa.gripCFrame or cbaa.attachmentOffset or CFrame.new()ddaa=ddaa-ddaa.Position
if adaa then baaa.Part1=
dbaa:IsA("Model")and dbaa.PrimaryPart or dbaa
baaa.C0=
CFrame.new(-0.25,0.25,0.75)*CFrame.Angles(math.pi/2,math.pi*0.75,math.pi/2)baaa.C1=ddaa elseif bdaa then
caaa.Part1=dbaa:IsA("Model")and dbaa.PrimaryPart or dbaa
caaa.C0=CFrame.new(-1,0,0)*CFrame.Angles(math.pi*0.25,0,0)caaa.C1=ddaa elseif cdaa then
daaa.Part1=dbaa:IsA("Model")and dbaa.PrimaryPart or dbaa;daaa.C0=CFrame.new(0,0.75,0)daaa.C1=ddaa else local __ba=
acaa==acc.gripType.right and _aaa or aaaa
__ba.Part1=
dbaa:IsA("Model")and dbaa.PrimaryPart or dbaa;__ba.C0=CFrame.new()
__ba.C1=
bcaa or cbaa.gripCFrame or cbaa.attachmentOffset or CFrame.new()
if dbaa:IsA("BasePart")then
if

cbaa.equipmentType=="dagger"or
cbaa.equipmentType=="sword"or cbaa.equipmentType=="staff"or cbaa.equipmentType=="greatsword"then
if not dbaa:FindFirstChild("topAttachment")then
local a_ba=Instance.new("Attachment",__ba.Part1)a_ba.Name="topAttachment"local b_ba=__ba.Part1;local c_ba=b_ba.Size
local d_ba={Vector3.new(
b_ba.Size.X/2,0,0),Vector3.new(0,b_ba.Size.Y/2,0),Vector3.new(0,0,
b_ba.Size.Z/2),Vector3.new(-b_ba.Size.X/2,0,0),Vector3.new(0,
-b_ba.Size.Y/2,0),Vector3.new(0,0,-b_ba.Size.Z/2)}
local _aba=(__ba.C1 *__ba.C0:Inverse()).Position;local aaba=nil;local baba=0
for caba,daba in pairs(d_ba)do local _bba=(daba-_aba).Magnitude;if _bba>baba then
aaba=daba;baba=_bba end end;a_ba.Position=aaba end
if not dbaa:FindFirstChild("bottomAttachment")then
local a_ba=dac.projection_Box(__ba.Part1.CFrame,__ba.Part1.Size,__ba.Part0.CFrame.p)local b_ba=Instance.new("Attachment",__ba.Part1)
b_ba.Name="bottomAttachment"
b_ba.Position=__ba.Part1.CFrame:pointToObjectSpace(a_ba)end
if not dbaa:FindFirstChild("Trail")then
local a_ba=b_c.Trail:Clone()a_ba.Parent=__ba.Part1;a_ba.Attachment0=__ba.Part1.topAttachment
a_ba.Attachment1=__ba.Part1.bottomAttachment;a_ba.Enabled=false end end elseif dbaa:IsA("Model")then end end end elseif bbaa.position==acc.equipmentPosition.head then end end end
if __aa and __aa.accessories then
local abaa=a_d.hairColor:FindFirstChild(tostring(__aa.accessories.hairColorId or 1)).Value
local bbaa=a_d.shirtColor:FindFirstChild(tostring(__aa.accessories.shirtColorId or 1)).Value
for cbaa,dbaa in pairs(__aa.accessories)do
if cbaa=="hair"and c_aa then local _caa=b_d[c_aa.id]
if _caa then local acaa=
_caa.equipmentHairType or 1;if
acaa==acc.equipmentHairType.partial then dbaa=dbaa.."_clipped"elseif acaa==acc.equipmentHairType.none then
dbaa=""end end end
if _ac.accessoryLookup:FindFirstChild(cbaa)then
local _caa=
_ac.hairClipped:FindFirstChild(tostring(dbaa))or
_ac.accessoryLookup[cbaa]:FindFirstChild(tostring(dbaa))
if _caa then
for acaa,bcaa in pairs(_caa:GetChildren())do
if dd_a:FindFirstChild(bcaa.Name)then
if
bcaa:FindFirstChild("shirtTag")then dd_a[bcaa.Name].Color=bbaa elseif
bcaa:FindFirstChild("colorOverride")then dd_a[bcaa.Name].Color=bcaa.Color end
for ccaa,dcaa in pairs(bcaa:GetChildren())do
if dcaa:IsA("BasePart")then
local _daa=dcaa:Clone()_daa.Anchored=false;_daa.CanCollide=false;if _daa.Name=="hair_Head"then
_daa.Color=abaa end
if _daa.Name=="shirt"or
_daa:FindFirstChild("shirtTag")then _daa.Color=bbaa end;local adaa=Instance.new("Motor6D",_daa)
adaa.Name="projectionWeld"adaa.Part0=_daa;adaa.Part1=dd_a[bcaa.Name]
adaa.C0=CFrame.new()adaa.C1=bcaa.CFrame:toObjectSpace(dcaa.CFrame)
_daa.Name="!! ACCESSORY !!"_daa.Parent=dd_a end end end end end end end end
if __aa and __aa.temporaryEquipment then
for abaa,bbaa in pairs(__aa.temporaryEquipment)do
if

_ac:FindFirstChild("temporaryEquipment")and _ac.temporaryEquipment:FindFirstChild(abaa)then
local cbaa=require(_ac.temporaryEquipment[abaa].application)cbaa(dd_a)end end end;if dd_a then
for abaa,bbaa in pairs(dd_a:GetDescendants())do if bbaa:IsA("BasePart")then
bbaa.CanCollide=false end end end end
local function cbd(dd_a)local __aa=Instance.new("Model")
local a_aa=game.Players:GetPlayerFromCharacter(dd_a.Parent)local b_aa=dd_a:Clone()
b_aa.BrickColor=BrickColor.new("Hot pink")b_aa.CanCollide=false;b_aa.Anchored=true;b_aa.Name="hitbox"
local c_aa=Instance.new("ObjectValue")c_aa.Name="clientHitboxToServerHitboxReference"c_aa.Value=dd_a
c_aa.Parent=__aa;b_aa:ClearAllChildren()__aa.PrimaryPart=b_aa
b_aa.Parent=__aa;if a_aa~=a_c then end
local d_aa=_ac.playerBaseCharacter:Clone()d_aa.Name="entity"d_aa.Parent=__aa
local _aaa=Instance.new("Motor6D")_aaa.Name="projectionWeld"_aaa.Part0=b_aa;_aaa.Part1=d_aa.PrimaryPart
_aaa.C0=CFrame.new()
_aaa.C1=CFrame.new(0,d_aa:GetModelCFrame().Y-
d_aa.PrimaryPart.CFrame.Y,0)_aaa.Parent=b_aa;return __aa end
local function dbd(dd_a)
if aad[dd_a]then
for __aa,a_aa in pairs(aad[dd_a].connections)do a_aa:disconnect()end
if
aad[dd_a].entityContainer and
aad[dd_a].entityContainer:FindFirstChild("entity")and
aad[dd_a].entityContainer.entity:FindFirstChild("AnimationController")then
__d:deregisterAnimationsForAnimationController(aad[dd_a].entityContainer.entity.AnimationController)else
__d:deregisterAnimationsForAnimationController(nil)end;aad[dd_a].entityContainer:Destroy()aad[dd_a]=
nil end end
local function _cd(dd_a,__aa)
if dd_a.PrimaryPart then
local a_aa=dd_a:FindFirstChild("damageIndicator")or
_ac.entities.damageIndicator:Clone()
local b_aa=math.max(
(dd_a.PrimaryPart.Size.X+dd_a.PrimaryPart.Size.Z)/2,3)a_aa.Size=UDim2.new(b_aa,50,6,75)a_aa.Parent=dd_a
a_aa.Enabled=true;local c_aa=a_aa.template:Clone()local d_aa=0.5 -
(math.random()-0.5)*0.7;c_aa.Text=__aa.Text
c_aa.TextColor3=__aa.TextColor3
c_aa.TextStrokeColor3=__aa.TextStrokeColor3 or Color3.new(0,0,0)c_aa.Font=__aa.Font or c_aa.Font;c_aa.TextTransparency=1
c_aa.TextStrokeTransparency=1;c_aa.Position=UDim2.new(d_aa,0,0.8,0)c_aa.Parent=a_aa
c_aa.Size=UDim2.new(0.7,0,0.1,0)c_aa.Visible=true;game.Debris:AddItem(c_aa,3)
local _aaa=math.floor(10 - (
__aa.TextTransparency or 0)*10)c_aa.ZIndex=_aaa
cac(c_aa,{"Position"},UDim2.new(d_aa,0,0,0.3),1.5)
cac(c_aa,{"TextTransparency","TextStrokeTransparency","Size"},{__aa.TextTransparency or 0,
__aa.TextStrokeTransparency or __aa.TextTransparency or 0,UDim2.new(0.7,0,0.3,0)},0.75)
spawn(function()wait(0.5)
cac(c_aa,{"TextTransparency","TextStrokeTransparency","Size"},{1,1,UDim2.new(0.7,0,0.1,0)},0.75)end)end end;local acd=3
local function bcd(dd_a)local __aa;local a_aa=99;for b_aa,c_aa in pairs(dd_a)do
if
c_aa:IsA("GuiObject")and c_aa.LayoutOrder<a_aa then __aa=c_aa;a_aa=c_aa.LayoutOrder end end;return __aa end
local function ccd(dd_a)
if not dd_a.titleFrame.Visible then
if game.Players.LocalPlayer.Character and
dd_a:IsDescendantOf(game.Players.LocalPlayer.Character)then return false end;local __aa=dd_a.Size
if dd_a.titleFrame.title.Text~=""then
dd_a.titleFrame.Visible=true;dd_a.Size=dd_a.Size+UDim2.new(0,0,0,10)dd_a.contents.Position=
dd_a.contents.Position+UDim2.new(0,0,0,5)
local a_aa=(
dd_a.titleFrame.AbsoluteSize.X+20)-dd_a.AbsoluteSize.X;if a_aa>0 then
dd_a.Size=dd_a.Size+UDim2.new(0,a_aa,0,0)end end end end;local dcd={}
local function _dd()local dd_a=35;local __aa=60
for a_aa,b_aa in
pairs(game.CollectionService:GetTagged("chatTag"))do local c_aa=b_aa.Parent;if c_aa==nil then
if b_aa then
local _aaa=b_aa:FindFirstChild("SurfaceGui")if _aaa then _aaa.Enabled=false end end;return false end
local d_aa=_bc.magnitude(
c_aa.Position-workspace.CurrentCamera.CFrame.p)
if b_aa then local _aaa=b_aa:FindFirstChild("SurfaceGui")
local aaaa=dd_a*
(
b_aa:FindFirstChild("rangeMulti")and b_aa.rangeMulti.Value or 1)
local baaa=__aa* (
b_aa:FindFirstChild("rangeMulti")and b_aa.rangeMulti.Value or 1)
if _aaa and _aaa:FindFirstChild("chat")then
if d_aa>baaa then
_aaa.Enabled=false elseif#_aaa.chat:GetChildren()<=1 then _aaa.Enabled=false elseif
c_aa:FindFirstChild("isStealthed")then _aaa.Enabled=false else
local caaa=
Vector3.new(c_aa.Position.X,c_aa.Position.Y+ (4.5 +
c_aa.Size.Y/2),c_aa.Position.Z)+ (b_aa:FindFirstChild("offset")and b_aa.offset.Value or
Vector3.new())
local daaa=(workspace.CurrentCamera.CFrame-
workspace.CurrentCamera.CFrame.p)+caaa
local _baa=daaa*CFrame.new(0,-b_aa.Size.Y/2,0)local abaa=_baa.p-caaa
b_aa.CFrame=daaa-Vector3.new(abaa.X,0,abaa.Z)
if d_aa>baaa-35 then _aaa.chat.Visible=false
_aaa.distant.Visible=true;local bbaa;do
if d_aa>=baaa-10 then bbaa=(d_aa-baaa+10)/10 else bbaa=0 end end;local cbaa=d_aa
local dbaa=math.abs(
workspace.CurrentCamera.CFrame.p.Y-caaa.Y)local _caa=math.atan2(dbaa,cbaa)bbaa=bbaa+
math.clamp(_caa-0.3,0,0.5)/0.5
_aaa.distant.chatFrame.contents.inner.TextTransparency=bbaa;_aaa.distant.chatFrame.ImageTransparency=bbaa else
_aaa.chat.Visible=true;_aaa.distant.Visible=false end;_aaa.Enabled=true end end end end end;local function add(dd_a)
for __aa,a_aa in
pairs(game.CollectionService:GetTagged("chatTag"))do if a_aa.Parent==dd_a then return a_aa end end end
bac:create("{F56AEE68-4457-4BDE-804B-2951C0009A34}","BindableFunction","OnInvoke",add)
local function bdd(dd_a,__aa,a_aa)
local b_aa=dd_a:FindFirstChild("chatGui")or b_c.chatGui:Clone()b_aa.Parent=dd_a;b_aa.Adornee=dd_a.PrimaryPart;b_aa.Enabled=true
local c_aa=Instance.new("NumberValue")c_aa.Name="rangeMulti"c_aa.Value=a_aa or 1;c_aa.Parent=b_aa;__aa=__aa or
Vector3.new()local d_aa=Instance.new("Vector3Value")
d_aa.Name="offset"d_aa.Value=__aa;d_aa.Parent=b_aa
b_aa.ExtentsOffsetWorldSpace=b_aa.ExtentsOffsetWorldSpace+__aa
game.CollectionService:AddTag(b_aa,"chatTag")return b_aa end
bac:create("{BA6DED4C-C2A5-4478-AABB-913C685E8DE0}","BindableFunction","OnInvoke",bdd)
local function cdd(dd_a,__aa,a_aa)local b_aa=dd_a
if b_aa then local c_aa=b_aa.chatTemplate:clone()c_aa.titleFrame.title.Text=
a_aa or""
local d_aa=
game.TextService:GetTextSize(c_aa.titleFrame.title.Text,c_aa.titleFrame.title.TextSize,c_aa.titleFrame.title.Font,Vector2.new()).X+20;c_aa.titleFrame.Size=UDim2.new(0,d_aa,0,32)
c_aa.titleFrame.Visible=false;local _aaa={}
for _baa,abaa in pairs(b_aa.chat:GetChildren())do if
abaa:IsA("GuiObject")then abaa.LayoutOrder=abaa.LayoutOrder-1
table.insert(_aaa,abaa)end end
if#_aaa>=acd then local _baa=bcd(_aaa)_baa:Destroy()end;c_aa.LayoutOrder=10;c_aa.Parent=b_aa.chat
local aaaa,baaa,caaa=bac:invoke("{F679D532-32A5-46B4-9FFB-E7BA60BD7EDB}",c_aa.contents,{{text=__aa,textColor3=Color3.fromRGB(200,200,200)}})
if baaa<18 then c_aa.Size=UDim2.new(0,caaa+20,0,baaa+26)else c_aa.Size=UDim2.new(1,0,0,
baaa+26)end;local daaa=bcd(b_aa.chat:GetChildren())if daaa then
ccd(daaa)end;c_aa.Visible=true
spawn(function()wait(15)if c_aa and c_aa.Parent then
c_aa:Destroy()local _baa=bcd(b_aa.chat:GetChildren())if _baa then
ccd(_baa)end end end)end end
bac:create("{BFD65964-2D21-4001-9E3C-C0959AE35DFC}","BindableFunction","OnInvoke",cdd)local ddd={}
local function ___a(dd_a,__aa)
local a_aa=game.Players:GetPlayerFromCharacter(dd_a.Parent)local b_aa;local c_aa;local d_aa;local _aaa;local aaaa;local baaa=""local caaa=false;local daaa=false;local _baa=false;local abaa={}
local function bbaa()
if

dd_a.entityType.Value=="monster"or dd_a.entityType.Value=="pet"then abaa={}
abc:setWholeCollisionGroup(__aa.entityContainer.entity,"monstersLocal")
for bbba,cbba in
pairs(__aa.entityContainer.entity.animations:GetChildren())do
local dbba=__aa.entityContainer.entity.AnimationController:LoadAnimation(cbba)local _cba="Idle"
if cbba.Name=="attacking"or cbba.Name=="death"then
_cba="Action"elseif cbba.Name=="dashing"or cbba.Name=="damaged"then
_cba="Movement"elseif cbba.Name=="walking"or cbba.Name=="idling"then _cba="Core"end
dbba.Priority=Enum.AnimationPriority[_cba]or Enum.AnimationPriority.Idle;abaa[cbba.Name]=dbba end end end
local function cbaa()
if dd_a.entityType.Value=="character"then
d_aa=__d:registerAnimationsForAnimationController(__aa.entityContainer.entity.AnimationController,"movementAnimations","swordAndShieldAnimations","dualAnimations","greatswordAnimations","swordAnimations","daggerAnimations","staffAnimations","fishing-rodAnimations","emoteAnimations","bowAnimations")elseif dd_a.entityType.Value=="monster"or
dd_a.entityType.Value=="pet"then
aaaa=(dd_a.entityType.Value=="monster")and
c_d[dd_a.entityId.Value]or
b_d[tonumber(dd_a.entityId.Value)]_aaa=_bc.copyTable(aaaa.statesData.states)
setmetatable(_aaa,{__index=function(bbba,cbba)return
ddc[cbba]end})end end
local function dbaa(bbba)
if bbba=="footstep"then
if dd_a:FindFirstChild("isStealthed")then return end;local cbba=""local dbba={workspace.CurrentCamera}
if
workspace:FindFirstChild("placeFolders")then table.insert(dbba,workspace.placeFolders)end
local _cba=Ray.new(dd_a.Position,Vector3.new(0,-5,0))
local acba,bcba,ccba,dcba=workspace:FindPartOnRayWithIgnoreList(_cba,dbba,false,false)
if
acba~=nil and(acba:IsA("BasePart")or acba:IsA("Terrain"))then
if
dcba==Enum.Material.Grass or dcba==Enum.Material.LeafyGrass then cbba="grass"elseif dcba==Enum.Material.Mud or
dcba==Enum.Material.Ground then cbba="dirt"elseif dcba==Enum.Material.Sand or dcba==
Enum.Material.Sandstone then cbba="sand"elseif
dcba==Enum.Material.Snow or dcba==Enum.Material.Ice then cbba="snow"else
cbba="stone"end end;local _dba;local adba={}
for i=1,3 do
local bdba=game.ReplicatedStorage.sounds:FindFirstChild("footstep_"..cbba.. (i>1 and
tostring(i)or""))if bdba then table.insert(adba,bdba)end end
if#adba>0 then _dba=adba[math.random(1,#adba)]end
if _dba and __aa.entityContainer.PrimaryPart then
local bdba=_bc.soundFromMirror(_dba)bdba.Parent=__aa.entityContainer.PrimaryPart
bdba.Looped=false;bdba.Pitch=math.random(95,105)/100
if a_aa==a_c then bdba.Volume=
bdba.Volume*1.5;bdba.EmitterSize=bdba.EmitterSize*3;bdba.MaxDistance=
bdba.MaxDistance*3 end;bdba:Play()game.Debris:AddItem(bdba,1.5)end end end
local function _caa(bbba)
if dd_a.entityType.Value=="character"then
__d:stopPlayingAnimationsByAnimationCollectionNameWithException(d_aa,"emoteAnimations","consume_consumable")
if c_aa then
if typeof(c_aa)=="Instance"then if c_aa.Looped or bbba=="jumping"then
c_aa:Stop()end elseif typeof(c_aa)=="table"then
for cbba,dbba in pairs(c_aa)do if dbba.Looped or
bbba=="jumping"then dbba:Stop()end end end;c_aa=nil end elseif dd_a.entityType.Value=="monster"or
dd_a.entityType.Value=="pet"then
local cbba=not not dd_a:FindFirstChild("pet")
if __aa.entityContainer:FindFirstChild("entity")and
__aa.entityContainer.entity.PrimaryPart:FindFirstChild("walking")then
if

bbba=="walking"or
(
_aaa[bbba]and(_aaa[bbba].animationEquivalent=="walking"))or bbba=="movement"or
(_aaa[bbba]and(_aaa[bbba].animationEquivalent=="movement"))then
if not caaa then
__aa.entityContainer.entity.PrimaryPart.walking.Looped=true
__aa.entityContainer.entity.PrimaryPart.walking:Play()caaa=true end elseif caaa then
__aa.entityContainer.entity.PrimaryPart.walking:Stop()caaa=false end end
if __aa.entityContainer:FindFirstChild("entity")and
__aa.entityContainer.entity.PrimaryPart:FindFirstChild("running")then
if bbba=="running"or
(
_aaa[bbba]and(_aaa[bbba].animationEquivalent=="running"))then
if not _baa then
__aa.entityContainer.entity.PrimaryPart.running.Looped=true
__aa.entityContainer.entity.PrimaryPart.running:Play()_baa=true end elseif _baa then
__aa.entityContainer.entity.PrimaryPart.running:Stop()_baa=false end end
if __aa.entityContainer:FindFirstChild("entity")and
__aa.entityContainer.entity.PrimaryPart:FindFirstChild("idling")then
if
not _baa and not caaa then
if not daaa then
__aa.entityContainer.entity.PrimaryPart.idling.Looped=true
__aa.entityContainer.entity.PrimaryPart.idling:Play()daaa=true end elseif daaa then
__aa.entityContainer.entity.PrimaryPart.idling:Stop()daaa=false end end
if c_aa then if _aaa[baaa]and not _aaa[baaa].doNotStopAnimation then
c_aa:Stop()end;c_aa=nil end end
if bbba=="dead"then
local function cbba(dbba)dbba=dbba or 1;local _cba=dd_a.CFrame
if __aa.entityContainer and
__aa.entityContainer:FindFirstChild("entity")then
if
__aa.entityContainer.entity:FindFirstChild("Torso")then
_cba=__aa.entityContainer.entity.Torso.CFrame elseif
__aa.entityContainer.entity:FindFirstChild("UpperTorso")then
_cba=__aa.entityContainer.entity.UpperTorso.CFrame end end;local acba=Instance.new("Part")acba.Size=dd_a.Size*dbba
acba.CFrame=_cba;acba.Transparency=1;acba.CanCollide=false;acba.Anchored=true
local bcba=Instance.new("Sound")bcba.SoundId="rbxassetid://2199444861"bcba.Name="deathSound"
bcba.MaxDistance=35;bcba.Parent=acba;bcba.Volume=0.2
bcba.PlaybackSpeed=0.8 +math.random()/5
if
dd_a:FindFirstChild("monsterScale")and dd_a.monsterScale.Value>1.3 then
bcba.Volume=bcba.Volume*dd_a.monsterScale.Value
bcba.MaxDistance=bcba.MaxDistance* (dd_a.monsterScale.Value^3)
bcba.PlaybackSpeed=bcba.PlaybackSpeed* (1 -dd_a.monsterScale.Value/8)end;bcba:Play()local ccba=b_c.Death:Clone()ccba.Parent=acba
acba.Parent=workspace.CurrentCamera;local dcba=acba.Size;ccba:Emit(3 *
math.sqrt(dcba.X*dcba.Y*dcba.Z))
game.Debris:AddItem(acba,3)end
for dbba,_cba in
pairs(__aa.entityContainer.entity.AnimationController:GetPlayingAnimationTracks())do _cba:Stop()end
if dd_a.entityType.Value~="character"then dd_a.CanCollide=false end
for dbba,_cba in
pairs(__aa.entityContainer.entity:GetDescendants())do if _cba:IsA("BasePart")then _cba.CanCollide=false end end
if dd_a.entityType.Value=="monster"or
dd_a.entityType.Value=="pet"then local dbba
dbba=abaa.death.Stopped:connect(function()
dbba:disconnect()cbba()dbd(dd_a)end)abaa.death.Looped=false;abaa.death:Play()
if
__aa.entityContainer.entity.PrimaryPart and
__aa.entityContainer.entity.PrimaryPart:FindFirstChild("death")then
local acba={__aa.entityContainer.entity.PrimaryPart.death}
if
__aa.entityContainer.entity.PrimaryPart:FindFirstChild("death2")then
table.insert(acba,__aa.entityContainer.entity.PrimaryPart:FindFirstChild("death2"))end
if
__aa.entityContainer.entity.PrimaryPart:FindFirstChild("death3")then
table.insert(acba,__aa.entityContainer.entity.PrimaryPart:FindFirstChild("death3"))end
if
__aa.entityContainer.entity.PrimaryPart:FindFirstChild("death4")then
table.insert(acba,__aa.entityContainer.entity.PrimaryPart:FindFirstChild("death4"))end;local bcba=math.random(#acba)local ccba=acba[bcba]
if

dd_a:FindFirstChild("monsterScale")and dd_a.monsterScale.Value>1.3 and
ccba:FindFirstChild("scalePitch")==nil then local _dba=dd_a.monsterScale.Value
ccba.Volume=ccba.Volume*_dba;ccba.EmitterSize=ccba.EmitterSize* (_dba^2)ccba.MaxDistance=
ccba.MaxDistance* (_dba^3)
ccba.PlaybackSpeed=1 - ( (_dba-1)*0.2)end;local dcba=Instance.new("Part")dcba.Anchored=true
dcba.CanCollide=false;dcba.Parent=workspace.CurrentCamera
dcba.Size=Vector3.new(0.1,0.1,0.1)dcba.Transparency=1;dcba.CFrame=dd_a.CFrame;ccba.Parent=dcba
ccba:Play()
game.Debris:AddItem(dcba,ccba.TimeLength+0.1)end;local _cba=_aaa[bbba]
spawn(function()
if

_cba and _cba.execute and __aa.entityContainer and __aa.entityContainer:FindFirstChild("entity")then
_cba.execute(a_c,abaa.death,aaaa,__aa.entityContainer)end end)elseif dd_a.entityType.Value=="character"then
local dbba=__aa.entityContainer and
__aa.entityContainer:FindFirstChild("entity")
if dbba then local _cba=dbba:Clone()_cba.Parent=dbba.Parent;dbba:Destroy()
local acba={"Root","Neck","RightShoulder","LeftShoulder","RightElbow","LeftElbow","Waist","RightWrist","LeftWrist","RightHip","LeftHip","RightKnee","LeftKnee","RightAnkle","LeftAnkle"}for _dba,adba in pairs(acba)do
_cba:FindFirstChild(adba,true):Destroy()end;local bcba={}
for _dba,adba in
pairs(_cba:GetDescendants())do
if

adba:IsA("Attachment")and adba.Name:find("RigAttachment")and(not adba.Name:find("Root"))then local bdba=adba.Name;if not bcba[bdba]then bcba[bdba]={}end
table.insert(bcba[bdba],adba)end end;abc:setWholeCollisionGroup(_cba,"passthrough")
local ccba=Instance.new("Folder")ccba.Name="constraints"ccba.Parent=_cba
for _dba,adba in pairs(bcba)do
local bdba=Instance.new("BallSocketConstraint")bdba.LimitsEnabled=true;bdba.TwistLimitsEnabled=true
bdba.Attachment0=adba[1]bdba.Attachment1=adba[2]bdba.Parent=ccba
adba[1].Parent.CanCollide=true;adba[2].Parent.CanCollide=true end
local dcba=__aa.entityContainer:FindFirstChild("hitbox")
if dcba then local _dba=Instance.new("BodyPosition")
_dba.MaxForce=Vector3.new(1e6,0,1e6)_dba.Parent=_cba.LowerTorso;local adba
local function bdba()if not _dba.Parent then
adba:Disconnect()return end;_dba.Position=dcba.Position end
adba=game:GetService("RunService").Heartbeat:Connect(bdba)end end end elseif
bbba=="gettingUp"and dd_a.entityType.Value=="character"then local cbba=d_aa.movementAnimations[bbba]
if cbba then local dbba
local function _cba()if dbba then
dbba:disconnect()dbba=nil end
if a_aa==a_c then
bac:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",false)
bac:invoke("{F9682973-5852-429E-9BAC-8EBECA22DD97}","isGettingUp",false)end end;dbba=cbba.Stopped:connect(_cba)cbba.Looped=false
cbba:Play()if a_aa==a_c then
bac:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",true)end end else
if dd_a.entityType.Value=="monster"or
dd_a.entityType.Value=="pet"then
if abaa[bbba]or
(
_aaa[bbba]and _aaa[bbba].animationEquivalent and abaa[_aaa[bbba].animationEquivalent])then local cbba=abaa[bbba]or
abaa[_aaa[bbba].animationEquivalent]
if abaa[bbba.."2"]then
local _cba=math.random(2)if _cba==2 then cbba=abaa[bbba.."2"]end end;local dbba=_aaa[bbba]
if cbba then c_aa=cbba
c_aa.Priority=
(_aaa[bbba]and _aaa[bbba].animationPriority)or Enum.AnimationPriority.Idle;c_aa.Looped=
(_aaa[bbba]and _aaa[bbba].doNotLoopAnimation~=true)or false
c_aa:Play()else cbba=nil end;if dbba.additional_animation_to_play_temp then
abaa[dbba.additional_animation_to_play_temp]:Play()end;if dbba and dbba.execute then
spawn(function()
dbba.execute(a_c,cbba,aaaa,__aa.entityContainer)end)else end end elseif dd_a.entityType.Value=="character"then
local cbba=dad(__aa.entityContainer.entity)local dbba=""
do
if cbba["1"]and cbba["1"].baseData.equipmentType then
if
__aa.weaponState then dbba="_"..__aa.weaponState elseif cbba["1"]and cbba["11"]then
if
cbba["11"].baseData.equipmentType=="sword"then dbba="_dual"elseif cbba["11"].baseData.equipmentType==
"shield"then dbba="AndShield"end end end end;local _cba=bbba
do
if dd_a.entityId.Value~=""then
if c_d[dd_a.entityId.Value]then
if
c_d[dd_a.entityId.Value].statesData.states[bbba].animationEquivalent then
_cba=c_d[dd_a.entityId.Value].statesData.states[bbba].animationEquivalent elseif ddc[bbba].animationEquivalent then _cba=ddc[bbba].animationEquivalent end end end end
if a_aa and a_aa:FindFirstChild("class")and
d_aa.movementAnimations[
string.lower(a_aa.class.Value).."_".._cba..dbba]then _cba=
string.lower(a_aa.class.Value).."_".._cba..dbba end
if
d_aa.movementAnimations[_cba]or
(
cbba["1"]and cbba["1"].baseData.equipmentType and d_aa.movementAnimations[_cba..
"_"..cbba["1"].baseData.equipmentType..dbba])then
if
cbba["1"]and cbba["1"].baseData and cbba["1"].baseData.equipmentType then local acba=_cba..
"_"..cbba["1"].baseData.equipmentType..dbba
c_aa=
d_aa.movementAnimations[acba]or d_aa.movementAnimations[_cba]else c_aa=d_aa.movementAnimations[_cba]end
if c_aa then
if b_aa then b_aa:disconnect()
local acba=__aa.entityContainer:FindFirstChild("footstep_sound",true)if acba and acba.Playing then acba.Looped=false end end
__d:stopPlayingAnimationsByAnimationCollectionName(d_aa,"emoteAnimations")
if typeof(c_aa)=="Instance"then
b_aa=c_aa.KeyframeReached:connect(dbaa)
if _cba=="walking"then
c_aa:Play(nil,(
c_aa.Priority==Enum.AnimationPriority.Movement and 0.85)or 1)else c_aa:Play(nil,1)end;if _cba=="jumping"then c_aa:AdjustSpeed(1.5)end elseif
typeof(c_aa)=="table"then
b_aa=c_aa[1].KeyframeReached:connect(dbaa)for acba,bcba in pairs(c_aa)do bcba:Play()
if _cba=="jumping"then bcba:AdjustSpeed(1.5)end end end end end;baaa=_cba;return end end;baaa=bbba end
local function acaa()
if
__aa.currentPlayerWeaponAnimations and __aa.currentPlayerWeaponAnimations.stretchHold then
__aa.currentPlayerWeaponAnimations.stretchHold.Looped=true
__aa.currentPlayerWeaponAnimations.stretchHold:Play()end
if __aa.bowStrechAnimationStopped then
__aa.bowStrechAnimationStopped:disconnect()__aa.bowStrechAnimationStopped=nil end end
function __aa:playAnimation(bbba,cbba,dbba)
if d_aa[bbba]and d_aa[bbba][cbba]then
__d:stopPlayingAnimationsByAnimationCollectionName(d_aa,"emoteAnimations")
local _cba=game.Players:GetPlayerFromCharacter(dd_a.Parent)local acba=_cba:FindFirstChild("str")
local bcba=_cba:FindFirstChild("int")local ccba=_cba:FindFirstChild("dex")
local dcba=_cba:FindFirstChild("vit")
local _dba={str=acba.Value,int=bcba.Value,dex=ccba.Value,vit=dcba.Value}local adba=dad(__aa.entityContainer.entity)
if cbba==
"consume_consumable"and dbba and dbba.id then
local bdba=b_d[dbba.id]local cdba=bdba.module:FindFirstChild("manifest")
if
cdba and
__aa.entityContainer and __aa.entityContainer:FindFirstChild("entity")then
local ddba=__aa.entityContainer.entity:FindFirstChild("ConsumableGrip",true)
if ddba then cdba=cdba:Clone()cdba.CanCollide=false;cdba.Anchored=false
for b_ca,c_ca in
pairs(cdba:GetChildren())do
if c_ca:IsA("BasePart")then local d_ca=Instance.new("Motor6D")
d_ca.Part0=cdba;d_ca.Part1=c_ca;d_ca.C0=CFrame.new()
d_ca.C1=c_ca.CFrame:toObjectSpace(cdba.CFrame)d_ca.Parent=c_ca;c_ca.CanCollide=false;c_ca.Anchored=false end end;cdba.Parent=__aa.entityContainer.entity;ddba.Part1=cdba
local __ca=bac:invoke("{E1A443FB-62B9-4FA8-B0D1-0930199949A1}",dd_a)
if __ca then if __ca:IsA("BasePart")then __ca.Transparency=1 end;for b_ca,c_ca in
pairs(__ca:GetDescendants())do
if c_ca:isA("BasePart")then c_ca.Transparency=c_ca.Transparency+1 end end end
d_aa[bbba]["consume_loop"]:Play()local a_ca
a_ca=d_aa[bbba]["consume_loop"].Stopped:connect(function()end)
if
bdba.useSound and game.ReplicatedStorage:FindFirstChild("sounds")and cdba then
local b_ca=game.ReplicatedStorage.sounds:FindFirstChild(bdba.useSound)
if b_ca then local c_ca=Instance.new("Sound")for d_ca,_aca in
pairs(game.HttpService:JSONDecode(b_ca.Value))do c_ca[d_ca]=_aca end
c_ca.Parent=cdba;c_ca.Volume=0.8;c_ca.MaxDistance=150;c_ca:Play()end end
delay(dbba.ANIMATION_DESIRED_LENGTH or 2,function()
if cdba then
if cdba:FindFirstChild("consumed")then
cdba.consumed.Transparency=1 elseif bdba.useSound=="eat_food"then cdba.Transparency=1
for b_ca,c_ca in
pairs(cdba:GetChildren())do if c_ca:IsA("BasePart")then c_ca.Transparency=1 end end end end
delay(0.4,function()if ddba.Part1 ==cdba then ddba.Part1=nil end
if __ca then if
__ca:IsA("BasePart")then __ca.Transparency=0 end;for b_ca,c_ca in
pairs(__ca:GetDescendants())do
if c_ca:isA("BasePart")then c_ca.Transparency=c_ca.Transparency-1 end end end;if cdba then cdba:Destroy()cdba=nil end
a_ca:disconnect()end)
d_aa[bbba]["consume_loop"]:Stop()end)end end elseif cbba=="cast-line"and dbba and dbba.targetPosition then
local bdba=bac:invoke("{E1A443FB-62B9-4FA8-B0D1-0930199949A1}",dd_a)
if not bdba or not bdba:FindFirstChild("line")then return end;d_aa[bbba][cbba]:Play()wait(0.75)if not bdba or not
bdba:FindFirstChild("line")then return end
local cdba=(
bdba.CFrame*CFrame.new(0,bdba.Size.Y/2,0)).p
local ddba=(
(
Vector3.new(dbba.targetPosition.X,dbba.targetPosition.Y,dbba.targetPosition.Z)-cdba).unit+Vector3.new(0,0.08,0)).unit;if __aa.fishingBob then __aa.fishingBob:Destroy()
__aa.fishingBob=nil end
__aa.fishingBob=game.ReplicatedStorage.fishingBob:Clone()
__aa.fishingBob.Parent=bbc.getPlaceFolder("entities")bdba.line.Attachment1=__aa.fishingBob.Attachment
local __ca=_bc.playSound("fishingPoleCast_Short",bdba)local a_ca=
2 * (math.abs(cdba.Y-dbba.targetPosition.Y))/60
local b_ca=(dbba.targetPosition-cdba).magnitude;local c_ca=math.clamp(b_ca/a_ca,1,70)
ccc.createProjectile(cdba,ddba,c_ca,__aa.fishingBob,function(d_ca,_aca,aaca,baca)
if

d_ca and game.CollectionService:HasTag(d_ca,"fishingSpot")then if _cba==a_c then
bac:fire("{65FD0D6A-9D70-4721-9805-E6B71951577C}",true)end;if __aa.fishingBob and
__aa.fishingBob:FindFirstChild("splash")then
__aa.fishingBob.splash:Emit(20)end
if __ca then __ca:Stop()end
_bc.playSound("fishing_BaitSplash",__aa.fishingBob)
bac:invokeServer("{D6E3F48A-F21A-4522-AA30-81C9563343DE}",_aca)else if _cba==a_c then
bac:fire("{65FD0D6A-9D70-4721-9805-E6B71951577C}",false)end
if __aa.fishingBob then game:GetService("Debris"):AddItem(__aa.fishingBob,
1 /30)end;__aa.fishingBob=nil end end,function(d_ca)if
bdba:FindFirstChild("line")then bdba.line.Length=25 *d_ca end end)elseif cbba=="reel-line"then
local bdba=bac:invoke("{E1A443FB-62B9-4FA8-B0D1-0930199949A1}")
if not bdba or not bdba:FindFirstChild("line")then return end;d_aa[bbba][cbba]:Play()
if _cba==a_c then wait(0.75)
bac:invoke("{F9682973-5852-429E-9BAC-8EBECA22DD97}","isFishing",false)
bac:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",false)local cdba,ddba
if __aa.fishingBob then
local __ca,a_ca,b_ca=bac:invokeServer("{51AD8BDD-2BEA-49C4-B9AB-7D3997D72838}",__aa.fishingBob.Position)cdba=a_ca;ddba=b_ca;if bdba then end end;if bdba and not cdba then bdba.line.Attachment1=nil elseif bdba and cdba then
cdba.Velocity=ddba end end;if __aa.fishingBob then __aa.fishingBob:Destroy()
__aa.fishingBob=nil end elseif dbba and dbba.dance then local bdba
if cbba~="point"then
bdba=bac:invoke("{E1A443FB-62B9-4FA8-B0D1-0930199949A1}",dd_a)
if bdba then if bdba:IsA("BasePart")then bdba.Transparency=1 end;for a_ca,b_ca in
pairs(bdba:GetDescendants())do
if b_ca:isA("BasePart")then b_ca.Transparency=b_ca.Transparency+1 end end end end;local cdba
local ddba={["handstand"]={fadeTime=.3},["sit"]={fadeTime=.3},["panic"]={fadeTime=.3},["pushups"]={fadeTime=.3},["point"]={singleAction=true},["flex"]={singleAction=true},["guitar"]={singleAction=true},["tadaa"]={singleAction=true},["cheer"]={singleAction=true}}
if ddba[cbba]and ddba[cbba].fadeTime then
d_aa[bbba][cbba]:Play(ddba[cbba].fadeTime)else d_aa[bbba][cbba]:Play()end
if cbba=="beg"then cdba=b_c.Plate:Clone()
local a_ca=Instance.new("WeldConstraint",cdba)
cdba.CFrame=__aa.entityContainer.entity.RightHand.CFrame*
CFrame.Angles(math.pi,0,0)*CFrame.new(-.5,.16,-.2)a_ca.Part1=cdba
a_ca.Part0=__aa.entityContainer.entity.RightHand;cdba.Parent=workspace
delay(3.1,function()
d_aa[bbba][cbba]:AdjustSpeed(0)end)end;local __ca
__ca=d_aa[bbba][cbba].Stopped:connect(function()if cdba then
cdba:Destroy()end
if bdba then
if bdba:IsA("BasePart")then bdba.Transparency=0 end
for a_ca,b_ca in pairs(bdba:GetDescendants())do if b_ca:isA("BasePart")then b_ca.Transparency=
b_ca.Transparency-1 end end end;if ddba[cbba]and ddba[cbba].singleAction then
bac:fire("{F7F863BC-0B9B-4E07-87C5-278779D08E23}")end
__ca:disconnect()end)else local bdba=d_aa[bbba][cbba]
if bbba=="bowAnimations"then
local cdba=bac:invoke("{E1A443FB-62B9-4FA8-B0D1-0930199949A1}")if cdba then
cdba=cdba:IsA("Model")and cdba.PrimaryPart or cdba end
__d:stopPlayingAnimationsByAnimationCollectionName(d_aa,"bowAnimations")
if cbba=="stretching_bow_stance"then __aa.currentPlayerWeaponAnimations.stretch:Play(
nil,nil,1)
_bc.playSound("bowDraw",cdba)local ddba=b_c.arrow:Clone()__aa.stanceArrow=ddba
ddba.arrowWeld.Part0=__aa.currentPlayerWeapon.slackRopeRepresentation
ddba.arrowWeld.C0=CFrame.Angles(-math.pi/2,0,0)*CFrame.new(0,(-
ddba.Size.Y/2)-0.1,0)ddba.Parent=_cc elseif cbba=="firing_bow_stance"then local ddba=400;local __ca=0
__aa.currentPlayerWeaponAnimations.fire:Play()_bc.playSound("bowFireStance",cdba)
local a_ca=CFrame.new()local b_ca=__aa.stanceArrow;__aa.stanceArrow=nil;if b_ca then a_ca=b_ca.CFrame
b_ca:Destroy()end
local function c_ca(_bca,abca)abca=abca or 1
local bbca=script:FindFirstChild("ring"):Clone()
bbca.CFrame=_bca*CFrame.Angles(math.pi/2,0,0)bbca.Size=Vector3.new(2,0.2,2)*abca
bbca.Parent=_cc;local cbca=0.5
cac(bbca,{"Size"},{bbca.Size*4 *abca},cbca,Enum.EasingStyle.Quad)
cac(bbca,{"Transparency"},{1},cbca,Enum.EasingStyle.Linear)
game:GetService("Debris"):AddItem(bbca,cbca)end;local d_ca=b_c.arrow:Clone()d_ca.Anchored=true;d_ca.CFrame=a_ca
d_ca.Trail.Enabled=true;d_ca.Trail.Lifetime=1.5
d_ca.Trail.WidthScale=NumberSequence.new(1,8)d_ca.Parent=_cc
local _aca=(dbba["mouse-target-position"]-a_ca.Position).Unit;local aaca={}
c_ca(
(CFrame.new(Vector3.new(),_aca)+a_ca.Position)*CFrame.new(0,0,-2))local baca=10;local caca=tick()local daca=0.05
ccc.createProjectile(a_ca.Position,_aca,ddba,d_ca,function(_bca,abca,bbca,cbca)
local dbca,_cca=dcc.canPlayerDamageTarget(game.Players.LocalPlayer,_bca)
if dbca and _cca then
if not aaca[_cca]then aaca[_cca]=true
_bc.playSound("bowArrowImpact",d_ca)
c_ca(d_ca.CFrame*CFrame.Angles(math.pi/2,0,0))if _cba==a_c and dbca then
bac:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",_cca,abca,"equipment",nil,"ranger stance")end end;return true else d_ca.Trail.Enabled=false
game:GetService("Debris"):AddItem(d_ca,d_ca.Trail.Lifetime)end end,function(_bca)local abca=
tick()-caca
if abca>=daca then caca=tick()c_ca(d_ca.CFrame*
CFrame.Angles(math.pi/2,0,0),0.4)end;return CFrame.Angles(math.pi/2,0,0)end,ccc.makeIgnoreList{dd_a,__aa.entityContainer},true,__ca,baca)
print(__aa.entityContainer:GetFullName())elseif cbba=="stretching_bow"then
if __aa.firingAnimationStoppedConnection then
__aa.firingAnimationStoppedConnection:disconnect()__aa.firingAnimationStoppedConnection=nil end;local ddba=_dc.getConfigurationValue("bowPullBackTime")local __ca=(dbba and
dbba.attackSpeed)or 0
__aa.bowStrechAnimationStopped=__aa.currentPlayerWeaponAnimations.stretch.Stopped:connect(acaa)
__aa.currentPlayerWeaponAnimations.stretch:Play(0.1,1,(
__aa.currentPlayerWeaponAnimations.stretch.Length/ddba)* (1 +__ca))_bc.playSound("bowDraw",cdba)local a_ca=tick()
local b_ca=dbba.numArrows or 1;local c_ca=dbba.firingSeed or 1;__aa.currentArrows={}
__aa.firingSeed=c_ca;local d_ca=3;local _aca=- ( (b_ca-1)*d_ca)/2;local aaca=math.huge
for i=1,b_ca
do local baca=b_c.arrow:Clone()
baca.Parent=workspace.CurrentCamera;local caca=_aca+ (i-1)*d_ca
table.insert(__aa.currentArrows,{arrow=baca,angleOffset=caca,orientation=
CFrame.Angles(0,math.pi,0)*CFrame.Angles(math.pi/2,0,0)*CFrame.Angles(math.rad(
caca*3),0,0)})if math.abs(caca)<aaca then __aa.primaryArrow=baca
aaca=math.abs(caca)end end;__aa.currentDrawStartTime=a_ca
if
_bc.doesPlayerHaveEquipmentPerk(_cba,"overdraw")then
for baca,caca in pairs(__aa.currentArrows)do local daca=caca.arrow;daca.Size=daca.Size*2 end end
delay(_dc.getConfigurationValue("maxBowChargeTime"),function()
if
__aa.currentDrawStartTime==a_ca and __aa.currentArrows then
for baca,caca in pairs(__aa.currentArrows)do
local daca=caca.arrow;daca.Material=Enum.Material.Neon
daca.BrickColor=BrickColor.new("Institutional white")end end end)
for baca,caca in pairs(__aa.currentArrows)do local daca=caca.arrow
daca.arrowWeld.Part0=__aa.currentPlayerWeapon.slackRopeRepresentation;daca.arrowWeld.C0=caca.orientation*
CFrame.new(0,(-daca.Size.Y/2)-0.1,0)end;__aa.weaponState="streched"_caa(dd_a.state.Value)
if bdba then
if
typeof(d_aa[bbba][cbba])=="Instance"then
d_aa[bbba][cbba]:Play(0.1,1,(
__aa.currentPlayerWeaponAnimations.stretch.Length/ddba)* (1 +__ca))elseif typeof(d_aa[bbba][cbba])=="table"then bdba=bdba[1]for baca,caca in
pairs(d_aa[bbba][cbba])do
caca:Play(0.1,1,
(__aa.currentPlayerWeaponAnimations.stretch.Length/ddba)* (1 +__ca))end end end;return elseif cbba=="firing_bow"and __aa.currentArrows then
if __aa.bowStrechAnimationStopped then
__aa.bowStrechAnimationStopped:disconnect()__aa.bowStrechAnimationStopped=nil end;if __aa.currentPlayerWeaponAnimations.stretch.IsPlaying then
__aa.currentPlayerWeaponAnimations.stretch:Stop()end;if
__aa.currentPlayerWeaponAnimations.stretchHold.IsPlaying then
__aa.currentPlayerWeaponAnimations.stretchHold:Stop()end
if dbba.canceled then for ddba,__ca in
pairs(__aa.currentArrows)do __ca.arrow:Destroy()end;__aa.currentArrows=
nil;bdba=nil;__aa.weaponState=nil
_caa(dd_a.state.Value)else
local function ddba()
if __aa.firingAnimationStoppedConnection then
__aa.firingAnimationStoppedConnection:disconnect()__aa.firingAnimationStoppedConnection=nil end;__aa.weaponState=nil;_caa(dd_a.state.Value)end
__aa.firingAnimationStoppedConnection=__aa.currentPlayerWeaponAnimations.fire.Stopped:connect(ddba)
__aa.currentPlayerWeaponAnimations.fire:Play()_bc.playSound("bowFire",cdba)local __ca=_dba.int>=30
local a_ca=1.5;local b_ca=1 /4;if _dba.int>=70 then a_ca=2.5 end;if _dba.int>=150 then a_ca=4
b_ca=3 /8 end
local c_ca=_bc.calculatePierceFromStr(_dba.str)local d_ca=#__aa.currentArrows
local _aca=
(__aa.weaponBaseData.projectileSpeed or 200)*
math.clamp(dbba.bowChargeTime/_dc.getConfigurationValue("maxBowChargeTime"),0.1,1)local aaca=c_ca- (d_ca/2)aaca=math.max(aaca,-1)_aca=_aca+
(_aca*aaca*0.5)if _bc.doesPlayerHaveEquipmentPerk(_cba,"overdraw")then _aca=
_aca*2 end
local baca,caca=ccc.getUnitVelocityToImpact_predictiveByAbilityExecutionData(__aa.currentPlayerWeapon.slackRopeRepresentation.Position,
__aa.weaponBaseData.projectileSpeed or 200,dbba)
local daca=
CFrame.new(__aa.currentPlayerWeapon.slackRopeRepresentation.Position,
__aa.currentPlayerWeapon.slackRopeRepresentation.Position+baca)*CFrame.new(0,0,-1.5)
if c_ca>0 then local bbca=0.25
local cbca=script:FindFirstChild("ring"):Clone()cbca.CFrame=daca*CFrame.new(0,0,-1)*
CFrame.Angles(math.pi/2,0,0)
cbca.Size=Vector3.new(2,0.2,2)cbca.Parent=workspace.CurrentCamera
cac(cbca,{"Size"},{Vector3.new(3 + (c_ca*1),0.2,
3 + (c_ca*1))},bbca,Enum.EasingStyle.Quad)
cac(cbca,{"Transparency"},{1},bbca,Enum.EasingStyle.Linear)local dbca=Instance.new("Part")
local _cca=Instance.new("SpecialMesh")dbca.Size=Vector3.new(3 +c_ca,3 +c_ca,2)
dbca.Color=Color3.fromRGB(255,255,255)dbca.Anchored=true;dbca.CanCollide=false
dbca.Material=Enum.Material.Neon;dbca.CFrame=daca*CFrame.new(0,0,-1.5)
_cca.MeshType=Enum.MeshType.Sphere;_cca.Parent=dbca;dbca.Parent=workspace.CurrentCamera
local acca=6 + (c_ca*2)
cac(dbca,{"Transparency"},{1},bbca/2,Enum.EasingStyle.Linear)
cac(dbca,{"Size"},{Vector3.new(0.5,0.5,acca)},bbca/2,Enum.EasingStyle.Quad)
cac(dbca,{"CFrame"},{daca*CFrame.new(0,0,- (1.5 +acca/2))},
bbca/2,Enum.EasingStyle.Quad)
game:GetService("Debris"):AddItem(cbca,bbca)
game:GetService("Debris"):AddItem(dbca,bbca)end;local _bca=Random.new(__aa.firingSeed)
local abca=d_c:GenerateGUID(false)
for bbca,cbca in pairs(__aa.currentArrows)do local dbca=cbca.arrow
dbca.arrowWeld:Destroy()dbca.Anchored=true;local _cca=0;local acca={}
local bcca=CFrame.new(Vector3.new(0,0,0),baca)local ccca=bcca
if d_ca<4 then
ccca=bcca*
CFrame.Angles(_bca:NextNumber(-0.025,0.025),math.rad(cbca.angleOffset),0)else
ccca=bcca*
CFrame.Angles(math.rad(d_ca*0.8)*_bca:NextNumber(-1,1),
math.rad(cbca.angleOffset)+ (math.rad(5)*_bca:NextNumber(-1,1)),0)end;local dcca=ccca.LookVector;if d_ca==1 and _cca>=1 then dcca=baca end;if
dbca:FindFirstChild("Trail")then dbca.Trail.Enabled=true end;__aa.currentDrawStartTime=
nil
ccc.createProjectile(daca.Position,dcca,_aca,dbca,function(_dca,adca,bdca,cdca)
local function ddca(a_da)
local b_da=Instance.new("Part")local c_da=Instance.new("SpecialMesh")b_da.Size=Vector3.new(a_ca*2,a_ca*2,
a_ca*2)
b_da.Shape=Enum.PartType.Ball;b_da.Color=Color3.fromRGB(255,255,255)b_da.Anchored=true
b_da.CanCollide=false;b_da.Material=Enum.Material.Neon
b_da.CFrame=CFrame.new(adca)c_da.Scale=Vector3.new(0,0,0)
c_da.MeshType=Enum.MeshType.Sphere;c_da.Parent=b_da;b_da.Parent=workspace.CurrentCamera
cac(b_da,{"Transparency"},{1},b_ca,Enum.EasingStyle.Linear)
cac(b_da,{"Color"},{Color3.fromRGB(0,255,100)},b_ca,Enum.EasingStyle.Linear)
cac(c_da,{"Scale"},{Vector3.new(1,1,1)*1.25},b_ca,Enum.EasingStyle.Quint)
game:GetService("Debris"):AddItem(b_da,b_ca*1.15)
if _cba==a_c then
for d_da,_ada in pairs(dcc.getDamagableTargets(a_c))do
local aada=(_ada.Size.X+
_ada.Size.Y+_ada.Size.Z)/6
if(_ada.Position-adca).magnitude<= (a_ca)+aada and
_ada~=a_da then
delay(0.1,function()
bac:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",_ada,adca,"equipment",nil,nil,abca)end)end end;if a_da then
delay(0.1,function()
bac:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",a_da,adca,"equipment",nil,nil,abca)end)end end end
local function __da(a_da,b_da,c_da,d_da)a_da=a_da or 3 /4;b_da=b_da or 1;c_da=c_da or 2;d_da=d_da or 1 /3
local _ada=script:FindFirstChild("ring"):Clone()_ada.CFrame=dbca.CFrame;_ada.Transparency=a_da
_ada.Size=Vector3.new(b_da,0.5,b_da)_ada.Parent=workspace.CurrentCamera
cac(_ada,{"Size"},{Vector3.new(c_da,0.2,c_da)},
d_da*1.15,Enum.EasingStyle.Quint)
cac(_ada,{"Transparency"},{1},d_da,Enum.EasingStyle.Linear)
game:GetService("Debris"):AddItem(_ada,d_da*1.15)end
if _dca then
if
(_dca:IsDescendantOf(dbc)or _dca:IsDescendantOf(cbc))then
local a_da,b_da=dcc.canPlayerDamageTarget(game.Players.LocalPlayer,_dca)
if b_da and not acca[b_da]then acca[b_da]=true
if __ca then
_bc.playSound("magicAttack",dbca)else _bc.playSound("bowArrowImpact",dbca)end
if __ca then ddca(b_da)else if _cba==a_c and a_da then
bac:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",b_da,adca,"equipment",nil,nil,abca)end end;_cca=_cca+1
if _cca<=c_ca then local c_da=c_ca- (_cca-1)
c_da=math.clamp(c_da,1,8)
local d_da={function()__da(2 /3,1,2,1 /3)end,function()
__da(1 /2,1.25,3,1 /3)end,function()__da(1 /3,1.5,4,1 /2)end,function()
__da(1 /4,2,5,1 /2)end,function()__da(1 /5,1.5,6,1 /2)end,function()
__da(1 /8,2,7,2 /3)end,function()__da(1 /8,2.5,7.5,2 /3)end,function()
__da(0,3,8,2 /3)end};(d_da[c_da]or d_da[3])()return true else
dbca.Anchored=false;bad(dbca,_dca)
game:GetService("Debris"):AddItem(dbca,3)return false end elseif b_da and acca[b_da]then return true end else
if dbca:FindFirstChild("impact")then local a_da=_dca.Color;if _dca==workspace.Terrain then
if
cdca~=Enum.Material.Water then
a_da=_dca:GetMaterialColor(cdca)else a_da=BrickColor.new("Cyan").Color end end
local b_da=Instance.new("Part")b_da.Size=Vector3.new(0.1,0.1,0.1)b_da.Transparency=1
b_da.Anchored=true;b_da.CanCollide=false
b_da.CFrame=(dbca.CFrame-dbca.CFrame.p)+adca;local c_da=dbca.impact:Clone()c_da.Parent=b_da
b_da.Parent=workspace.CurrentCamera;c_da.Color=ColorSequence.new(a_da)c_da:Emit(10)
game:GetService("Debris"):AddItem(b_da,3)
game:GetService("Debris"):AddItem(dbca,3)
cac(dbca,{"Transparency"},{1},3,Enum.EasingStyle.Linear)end;if __ca then ddca()end;return false end end end,function(_dca)return
CFrame.Angles(math.rad(90),0,0)end,{dd_a,__aa.entityContainer},true)__aa.currentArrows=nil end end else end elseif bbba=="staffAnimations"then
if bdba and not dbba.noRangeManaAttack and
_dc.getConfigurationValue("doUseMageRangeAttack",game.Players.LocalPlayer)then
local cdba=b_c.mageBullet:Clone()cdba.CanCollide=false;cdba.Parent=workspace.CurrentCamera
cdba.CFrame=CFrame.new(__aa.currentPlayerWeapon.magic.WorldPosition)
local ddba,__ca=ccc.getUnitVelocityToImpact_predictiveByAbilityExecutionData(cdba.Position,__aa.weaponBaseData.projectileSpeed or 50,dbba,0.05)
_bc.playSound("magicAttack",__aa.currentPlayerWeapon)
ccc.createProjectile(cdba.Position,ddba,__aa.weaponBaseData.projectileSpeed or 40,cdba,function(a_ca,b_ca,c_ca,d_ca)
cac(cdba,{"Transparency"},1,0.5)for _aca,aaca in pairs(cdba:GetChildren())do
if aaca:IsA("ParticleEmitter")or
aaca:IsA("Light")then aaca.Enabled=false end end
game.Debris:AddItem(cdba,0.5)
if _cba==a_c and a_ca then
local _aca,aaca=dcc.canPlayerDamageTarget(game.Players.LocalPlayer,a_ca)if _aca and aaca then
bac:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",aaca,b_ca,"equipment",nil,"magic-ball")end end end,
nil,{dd_a,__aa.entityContainer},true,0.01,0.8)
if
__aa.currentPlayerWeapon and __aa.currentPlayerWeapon:FindFirstChild("magic")and
__aa.currentPlayerWeapon.magic:FindFirstChild("castEffect")then
__aa.currentPlayerWeapon.magic.castEffect:Emit(1)end end end
if bdba then
if

bbba=="staffAnimations"or bbba=="swordAnimations"or bbba==
"daggerAnimations"or
bbba=="greatswordAnimations"or bbba=="dualAnimations"or bbba=="swordAndShieldAnimations"then local cdba=(dbba and dbba.attackSpeed)or 0;d_aa[bbba][cbba]:Play(0.1,1,(
1 +cdba))else
if
typeof(d_aa[bbba][cbba])=="Instance"then
d_aa[bbba][cbba]:Play()elseif typeof(d_aa[bbba][cbba])=="table"then bdba=bdba[1]for cdba,ddba in
pairs(d_aa[bbba][cbba])do ddba:Play()end end end end end end end;local function bcaa(bbba)dbd(dd_a)
bac:invoke("{17A36949-EEA3-4DB6-962F-0E88121DF82E}",dd_a)end;local function ccaa()end;local dcaa;local _daa
local function adaa()
dcaa=b_c.monsterHealth:Clone()dcaa.Parent=__aa.entityContainer;dcaa.Adornee=__aa.entityContainer
dcaa.Enabled=false
local bbba=__aa.entityContainer:FindFirstChild("MonsterEnemyTag")or
b_c.MonsterEnemyTag:Clone()bbba.Parent=workspace.CurrentCamera;_daa=bbba.SurfaceGui
_daa.Enabled=false;local cbba=false;local function dbba()
if not cbba then if dd_a.monsterScale.Value>1.3 then cbba=true
_daa.skull.Visible=true end end end
if
dd_a:FindFirstChild("monsterScale")then dbba()else local adba
adba=dd_a.ChildAdded:connect(function(bdba)
if bdba.Name=="monsterScale"then if adba then
adba:disconnect()adba=nil end;dbba()end end)table.insert(__aa.connections,adba)end;bbba.Parent=__aa.entityContainer
local _cba=dd_a:FindFirstChild("level")and
dd_a.level.Value or 1;local acba="Lvl "..tostring(_cba)_daa.level.Text=acba;if
__aa.disableLevelUI then _daa.level.Visible=false end
local bcba=
game.TextService:GetTextSize(acba,_daa.level.TextSize,_daa.level.Font,Vector2.new()).X+6;_daa.level.Size=UDim2.new(0,bcba,1,-6)local ccba=not not
dd_a:FindFirstChild("pet")
local dcba=
dd_a.entityId:FindFirstChild("nickname")and dd_a.entityId.nickname.Value or
dd_a.entityId.Value
local _dba=dd_a.entityId:FindFirstChild("nickname")~=nil;if
ccba and not dd_a.entityId:FindFirstChild("nickname")then
dcba=b_d[tonumber(dd_a.entityId.Value)].name end;if
dd_a:FindFirstChild("specialName")then dcba=dd_a.specialName.Value end
if

dd_a:FindFirstChild("monsterScale")and(not dd_a:FindFirstChild("notGiant"))then
if dd_a.monsterScale.Value>4.5 then dcba="Colossal "..dcba elseif
dd_a.monsterScale.Value>2.5 then dcba="Super Giant "..dcba elseif
dd_a.monsterScale.Value>1.3 then dcba="Giant "..dcba end end
if not ccba then _daa.monster.AutoLocalize=true;_daa.monster.Text=dcba
_daa.monster.Size=UDim2.new(0,game.TextService:GetTextSize(dcba,_daa.monster.TextSize,_daa.monster.Font,Vector2.new()).X,1,0)else _daa.level.Visible=false;_daa.monster.Visible=false
_daa.nickname.Visible=true;_daa.nickname.AutoLocalize=not _dba
_daa.nickname.Text=dcba
_daa.nickname.Size=UDim2.new(0,
game.TextService:GetTextSize(dcba,_daa.nickname.TextSize,_daa.nickname.Font,Vector2.new()).X+10,1,-4)end end
local function bdaa()
local bbba=__aa.entityContainer:FindFirstChild("MonsterEnemyTag")if bbba then bbba:Destroy()end end
local function cdaa()
local bbba=
__aa.entityContainer.PrimaryPart:FindFirstChild("PlayerTag")or b_c.PlayerTag:Clone()bbba.Parent=__aa.entityContainer.PrimaryPart
if a_aa then
local dbba=b_c.xpTag:Clone()dbba.Parent=__aa.entityContainer.PrimaryPart
dbba.Enabled=true;ddd[a_aa]=dbba end;local cbba=bdd(__aa.entityContainer)
dcaa=b_c.monsterHealth:Clone()dcaa.Parent=__aa.entityContainer;dcaa.Adornee=__aa.entityContainer
dcaa.Enabled=false
if a_aa and bbba then
local function dbba()local _cba=
a_aa:FindFirstChild("level")and a_aa.level.Value or 0
local acba="Lvl.".._cba;bbba.SurfaceGui.top.level.Text=acba
local bcba=
a_aa:FindFirstChild("class")and a_aa.class.Value or"unknown"
if bcba:lower()~="adventurer"then bbba.SurfaceGui.top.class.Image=
"rbxgameasset://Images/emblem_"..bcba:lower()
bbba.SurfaceGui.top.class.Visible=true else bbba.SurfaceGui.top.class.Visible=false end
bbba.SurfaceGui.bottom.guild.Visible=false
if
a_aa:FindFirstChild("guildId")and a_aa.guildId.Value~=""then
local adba=game.ReplicatedStorage:FindFirstChild("guildDataFolder")
if adba then
spawn(function()
local bdba=adba:WaitForChild(a_aa.guildId.Value,10)
if bdba then local cdba=d_c:JSONDecode(bdba.Value)
if cdba.name then
bbba.SurfaceGui.bottom.guild.Text=cdba.name
local ddba=
game.TextService:GetTextSize(cdba.name,bbba.SurfaceGui.bottom.guild.TextSize,bbba.SurfaceGui.bottom.guild.Font,Vector2.new()).X+10
bbba.SurfaceGui.bottom.guild.Size=UDim2.new(0,ddba,1,-4)bbba.SurfaceGui.bottom.guild.Visible=true end end end)end end;bbba.SurfaceGui.top.input.Visible=false
for adba,bdba in
pairs(bbba.SurfaceGui.top.input:GetChildren())do if bdba:IsA("GuiObject")then bdba.Visible=false end end
if a_aa:FindFirstChild("input")then
local adba=bbba.SurfaceGui.top.input:FindFirstChild(a_aa.input.Value)if adba then adba.Visible=true
bbba.SurfaceGui.top.input.Visible=true end end;bbba.SurfaceGui.top.dev.Visible=
a_aa:FindFirstChild("developer")~=nil
bbba.SurfaceGui.top.player.Text=a_aa.Name
local ccba=
game.TextService:GetTextSize(acba,bbba.SurfaceGui.top.level.TextSize,bbba.SurfaceGui.top.level.Font,Vector2.new()).X+8
bbba.SurfaceGui.top.level.Size=UDim2.new(0,ccba,1,-4)
local dcba=
game.TextService:GetTextSize(a_aa.Name,bbba.SurfaceGui.top.player.TextSize,bbba.SurfaceGui.top.player.Font,Vector2.new()).X+10
bbba.SurfaceGui.top.player.Size=UDim2.new(0,dcba,1,-4)local _dba=0
for adba,bdba in
pairs(bbba.SurfaceGui.top:GetChildren())do if bdba:IsA("GuiObject")and bdba.Visible then
_dba=_dba+bdba.AbsoluteSize.X end end
bbba.SurfaceGui.curve.Size=UDim2.new(0,_dba+10,0.5,-4)end;dbba()if a_aa:FindFirstChild("guildId")then
table.insert(__aa.connections,a_aa.guildId.Changed:connect(dbba))end;if
a_aa:FindFirstChild("level")then
table.insert(__aa.connections,a_aa.level.Changed:connect(dbba))end;if
a_aa:FindFirstChild("class")then
table.insert(__aa.connections,a_aa.class.Changed:connect(dbba))end;if
a_aa:FindFirstChild("input")then
table.insert(__aa.connections,a_aa.input.Changed:connect(dbba))end end end
local function ddaa()
local bbba=__aa.entityContainer.PrimaryPart:FindFirstChild("PlayerTag")if bbba then bbba:Destroy()end
local cbba=__aa.entityContainer:FindFirstChild("chatGui")if cbba then cbba:Destroy()end end;local __ba=dd_a.health.Value;local a_ba=false
local function b_ba(bbba)
if not dcaa then if
__aa.entityContainer.PrimaryPart:FindFirstChild("monsterNameUI")then
dcaa=__aa.entityContainer.PrimaryPart.monsterNameUI end end
if not _daa then if
__aa.entityContainer.PrimaryPart:FindFirstChild("monsterNameTag")then
_daa=__aa.entityContainer.PrimaryPart.monsterNameTag end end;if _daa and __aa.entityContainer.Name~="Chicken"then
_daa.Enabled=true end
if dcaa then local cbba=dcaa
if aaaa and aaaa.boss then
dcaa.Enabled=false
cbba=bac:invoke("{62930EB2-D79E-4277-AC23-50E9C793046D}",aaaa)or cbba;if cbba and bbba<=0 then cbba.Visible=false end else
if

dd_a.maxHealth.Value>bbba and __aa.entityContainer.Name~="Chicken"then if a_aa then dcaa.Enabled=true else dcaa.Enabled=true end else
dcaa.Enabled=false end end;local dbba=cbba.container.backgroundFill
local _cba=UDim2.new(math.clamp(bbba/
dd_a.maxHealth.Value,0,1),0,1,0)if dbba.healthLag.Size.X.Scale<
dbba.currentHealthFill.Size.X.Scale then
dbba.healthLag.Size=dbba.currentHealthFill.Size end
dbba.healthLag.ImageColor3=Color3.fromRGB(255,23,23)
local acba=dbba.currentHealthFill.Size.X.Scale-_cba.X.Scale;dbba.currentHealthFill.Size=_cba
spawn(function()wait(0.5)
if
dbba and
dbba:FindFirstChild("healthLag")and dbba.currentHealthFill.Size==_cba then
cac(dbba.healthLag,{"Size","ImageColor3"},{_cba,Color3.fromRGB(255,210,38)},0.3)end end)end
if bbba<__ba then
if not a_ba then a_ba=true
local cbba=

__aa.entityContainer.entity:FindFirstChild("head")or __aa.entityContainer.entity:FindFirstChild("body")or __aa.entityContainer.PrimaryPart;if cbba:FindFirstChild("damageTaken")then
cbba.damageTaken:Play()end;if abaa.damaged then abaa.damaged.Looped=false
abaa.damaged:Play()end;local dbba
if
__aa.entityContainer.entity.PrimaryPart and
__aa.entityContainer.entity.PrimaryPart:FindFirstChild("hit")then
local _cba={__aa.entityContainer.entity.PrimaryPart.hit}
if
__aa.entityContainer.entity.PrimaryPart:FindFirstChild("hit2")then
table.insert(_cba,__aa.entityContainer.entity.PrimaryPart:FindFirstChild("hit2"))end
if
__aa.entityContainer.entity.PrimaryPart:FindFirstChild("hit3")then
table.insert(_cba,__aa.entityContainer.entity.PrimaryPart:FindFirstChild("hit3"))end
if
__aa.entityContainer.entity.PrimaryPart:FindFirstChild("hit4")then
table.insert(_cba,__aa.entityContainer.entity.PrimaryPart:FindFirstChild("hit4"))end;dbba=_cba[math.random(1,#_cba)]end
if dbba then
if

dd_a:FindFirstChild("monsterScale")and dd_a.monsterScale.Value>1.3 and dbba:FindFirstChild("scalePitch")==nil then local _cba=dd_a.monsterScale.Value
dbba.EmitterSize=dbba.EmitterSize*_cba;dbba.MaxDistance=dbba.MaxDistance* (_cba^2)
local acba=Instance.new("PitchShiftSoundEffect")acba.Name="scalePitch"acba.Octave=0.9;acba.Parent=dbba end;dbba:Play()end
spawn(function()wait(0.5)if a_ba then a_ba=false end end)end end;__ba=bbba end
function __aa:setWeaponState(bbba,cbba)__aa.weaponState=cbba
if
dd_a.entityType.Value=="character"then local dbba=dad(__aa.entityContainer.entity)if dbba["1"]then
if bbba==
dbba["1"].baseData.equipmentType then _caa(dd_a.state.Value)end end end end
function __aa:changeStatusEffectState(bbba,cbba,dbba,_cba)
if cbba=="ability"and __aa.entityContainer then local acba;if bbba==
game.Players.LocalPlayer then
acba=bac:invoke("{4947D6C0-3492-484E-8D54-243215910D55}")end
local bcba=dd_a.activeAbilityExecutionData.Value;local ccba,dcba=_bc.safeJSONDecode(bcba)
local _dba=d_d[dbba](acba,dcba)
if _dba then
if _cba and _dba.onStatusEffectBegan then
_dba:onStatusEffectBegan(__aa.entityContainer)elseif not _cba and _dba.onStatusEffectEnded then
_dba:onStatusEffectEnded(__aa.entityContainer)end end end end;local c_ba=nil
local function d_ba(bbba)local cbba,dbba=_bc.safeJSONDecode(bbba)
if cbba then
if c_ba then local _cba={}for acba,bcba in pairs(dbba)do
_cba[bcba.id]=1 end;for acba,bcba in pairs(c_ba)do
_cba[bcba.id]=(_cba[bcba.id]or 0)-1 end
for acba,bcba in pairs(_cba)do local ccba=_ad[acba]
if ccba then
if bcba==1 and
ccba.__clientApplyTransitionEffectOnCharacter then
ccba.__clientApplyTransitionEffectOnCharacter(__aa.entityContainer)elseif bcba==1 and ccba.__clientApplyStatusEffectOnCharacter then
ccba.__clientApplyStatusEffectOnCharacter(__aa.entityContainer)elseif bcba==0 then elseif bcba==-1 and ccba.__clientRemoveStatusEffectOnCharacter then
ccba.__clientRemoveStatusEffectOnCharacter(__aa.entityContainer)end end end;c_ba=dbba else
for _cba,acba in pairs(dbba)do local bcba=_ad[acba.id]if
bcba and bcba.__clientApplyStatusEffectOnCharacter then
bcba.__clientApplyStatusEffectOnCharacter(__aa.entityContainer)end end;c_ba=dbba end end end;local _aba=0
local function aaba(bbba)if a_aa==a_c then return end
local cbba=dd_a.activeAbilityExecutionData.Value;local dbba,_cba=_bc.safeJSONDecode(cbba)
if _aba>0 then
local acba=d_d[_aba](nil,_cba)if acba and acba.onCastingEnded__client then
acba:onCastingEnded__client(__aa.entityContainer)end end
if bbba>0 then local acba=d_d[bbba](nil,_cba)if
acba and acba.onCastingBegan__client then
acba:onCastingBegan__client(__aa.entityContainer)end end;_aba=bbba end;local baba={id=0}
local function caba(bbba)local cbba,dbba=_bc.safeJSONDecode(bbba)
if cbba then
if
baba["ability-guid"]==dbba["ability-guid"]and
baba["ability-state"]=="end"then return false end;local _cba;if a_aa==a_c then
_cba=bac:invoke("{4947D6C0-3492-484E-8D54-243215910D55}")end
if dbba.id==0 then
local acba=d_d[baba.id](_cba,baba)
if acba and acba.cleanup then acba:cleanup(__aa.entityContainer)end;baba["ability-state"]="end"if
acba and acba.abilityDecidesEnd and acba.execute then
acba:execute(__aa.entityContainer,baba,a_aa==a_c,a_aa==a_c and baba["ability-guid"])end;if a_aa==
a_c then
bac:fire("{51252262-788E-447C-A950-A8E92643DAEA}",false)end else
if dbba["ability-guid"]==
baba["ability-guid"]and baba.step and
dbba.step<=baba.step then return false end;baba=dbba;local acba=d_d[dbba.id](_cba,dbba)
if acba and acba.execute then
acba:execute(__aa.entityContainer,dbba,
a_aa==a_c,a_aa==a_c and dbba["ability-guid"])if a_aa==a_c and not acba.abilityDecidesEnd then wait()
bac:invoke("{C8F2171C-1C77-4D97-89FD-DBA03550755B}",dbba.id,"end",dbba,dbba.guid)end end end end end
local function daba(bbba)local cbba,dbba=_bc.safeJSONDecode(bbba)if cbba then
bbd(__aa.entityContainer.entity,dbba,dd_a)end end;local _bba
local function abba(bbba)local cbba,dbba=_bc.safeJSONDecode(bbba)
if cbba then
if _bba then local _cba={}for acba,bcba in pairs(dbba)do
_cba[bcba.statusEffectType]=1 end
for acba,bcba in pairs(_bba)do _cba[bcba.statusEffectType]=(
_cba[bcba.statusEffectType]or 0)-1 end
for acba,bcba in pairs(_cba)do local ccba=_ad[acba]
if ccba then
if
bcba==1 and ccba.__clientApplyTransitionEffectOnCharacter then
ccba.__clientApplyTransitionEffectOnCharacter(__aa.entityContainer)elseif bcba==1 and ccba.__clientApplyStatusEffectOnCharacter then
ccba.__clientApplyStatusEffectOnCharacter(__aa.entityContainer)elseif bcba==0 then elseif bcba==-1 and ccba.__clientRemoveStatusEffectOnCharacter then
ccba.__clientRemoveStatusEffectOnCharacter(__aa.entityContainer)end end end;_bba=dbba else
for _cba,acba in pairs(dbba)do local bcba=_ad[acba.statusEffectType]
if bcba then if
bcba.__clientApplyStatusEffectOnCharacter then
bcba.__clientApplyStatusEffectOnCharacter(__aa.entityContainer)end end end;_bba=dbba end end end
if not
__aa.entityContainer.entity:FindFirstChild("AnimationController")then
local bbba=Instance.new("AnimationController")bbba.Parent=__aa.entityContainer.entity end;cbaa()
if dd_a.entityType.Value=="monster"or
dd_a.entityType.Value=="pet"then
if dd_a.entityType.Value=="pet"then
for bbba,cbba in
pairs(__aa.entityContainer.entity:GetDescendants())do if cbba:IsA("BasePart")then cbba.CanCollide=false end end end;bbaa()ddaa()adaa()elseif dd_a.entityType.Value=="character"then
d_ba(dd_a.statusEffects.Value)aaba(dd_a.castingAbilityId.Value)bdaa()
cdaa()
table.insert(__aa.connections,dd_a.statusEffects.Changed:connect(d_ba))
table.insert(__aa.connections,dd_a.activeAbilityExecutionData.Changed:connect(caba))
table.insert(__aa.connections,dd_a.castingAbilityId.Changed:connect(aaba))
table.insert(__aa.connections,dd_a.appearance.Changed:connect(daba))end;_caa(dd_a.state.Value)
if
dd_a:FindFirstChild("statusEffectsV2")then abba(dd_a.statusEffectsV2.Value)
table.insert(__aa.connections,dd_a.statusEffectsV2.Changed:connect(abba))end
table.insert(__aa.connections,dd_a.state.Changed:connect(_caa))
table.insert(__aa.connections,dd_a.entityType.Changed:connect(bcaa))
table.insert(__aa.connections,dd_a.entityId.Changed:connect(ccaa))
table.insert(__aa.connections,dd_a.health.Changed:connect(b_ba))if a_aa==a_c then
bac:fire("{8BABF769-4B51-49E3-9501-B715DD0790C7}",__aa.entityContainer)end end
adc:registerForEvent("playersXpGained",function(dd_a)
for __aa,a_aa in pairs(dd_a)do
local b_aa=game.Players:FindFirstChild(__aa)
if b_aa then local c_aa=ddd[b_aa]
if c_aa and c_aa.Parent then
spawn(function()
local d_aa=c_aa:FindFirstChild("timestamp")if d_aa==nil then d_aa=Instance.new("NumberValue")
d_aa.Name="timestamp"d_aa.Parent=c_aa end;local _aaa=d_aa.Value-
tick()if _aaa<=0 then d_aa.Value=tick()+0.2 else
d_aa.Value=d_aa.Value+0.2;wait(_aaa)end
local aaaa=c_aa.Frame.template:Clone()
aaaa.Text="+"..tostring(math.floor(a_aa)).." XP"aaaa.Parent=c_aa.Frame;aaaa.TextTransparency=1
aaaa.TextStrokeTransparency=1;aaaa.Visible=true
cac(aaaa,{"Position"},UDim2.new(0.5,0,0,0),2,Enum.EasingStyle.Linear)
cac(aaaa,{"TextTransparency","TextStrokeTransparency"},{0,0.5},0.3)
delay(0.5,function()if aaaa and aaaa.Parent then
cac(aaaa,{"TextTransparency","TextStrokeTransparency"},{1,1},1.5)end end)game.Debris:AddItem(aaaa,2)end)end end end end)
game.ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents").OnMessageDoneFiltering.OnClientEvent:connect(function(dd_a,__aa)
if
dd_a.IsFilterResult or c_c:IsStudio()then
local a_aa=game.Players:GetPlayerByUserId(dd_a.SpeakerUserId)local b_aa=dd_a.Message
if
a_aa and a_aa.Character and a_aa.Character.PrimaryPart and b_aa then
local c_aa=aad[a_aa.Character.PrimaryPart]if
not c_aa or not c_aa.entityContainer.PrimaryPart then return false end
local d_aa=c_aa.entityContainer:FindFirstChild("chatGui")if d_aa then cdd(d_aa,b_aa,a_aa.Name)end end end end)local function a__a()end
local function b__a(dd_a)local __aa=dd_a.entityContainer
local a_aa=__aa:FindFirstChild("MonsterEnemyTag")
if a_aa then local b_aa=a_aa:FindFirstChild("SurfaceGui")
if b_aa then
local c_aa=a_c.Character and
a_c.Character.PrimaryPart or workspace.CurrentCamera
local d_aa=_bc.magnitude(__aa.PrimaryPart.Position-c_aa.CFrame.p)local _aaa=35
local aaaa=dd_a.entityManifest:FindFirstChild("damagedByPlayer")~=nil;if aaaa then _aaa=50 end
if
not dd_a.disableNameTagUI and d_aa<_aaa and not
dd_a.entityManifest:FindFirstChild("isStealthed")and
dd_a.entityManifest.entityId.Value~="Chicken"then b_aa.Enabled=true
local baaa=Vector3.new(__aa.PrimaryPart.Position.X,
__aa.PrimaryPart.Position.Y- (1 +__aa.PrimaryPart.Size.Y/2),__aa.PrimaryPart.Position.Z)
a_aa.CFrame=(workspace.CurrentCamera.CFrame-
workspace.CurrentCamera.CFrame.p)+baaa;local caaa=__aa:FindFirstChild("monsterHealth")
if
not dd_a.disableHealthBarUI and caaa then caaa.Enabled=aaaa elseif caaa then caaa.Enabled=false end;local daaa
if __aa.PrimaryPart:FindFirstChild("monsterScale")and
__aa.PrimaryPart.monsterScale.Value>1.3 then _aaa=_aaa*
__aa.PrimaryPart.monsterScale.Value end;local _baa=5;if aaaa then _baa=10 end;if d_aa>=_baa then
daaa=(d_aa-_baa)/ (_aaa-_baa)else daaa=0 end
if b_aa:FindFirstChild("level")then
b_aa.level.TextTransparency=daaa;b_aa.level.curve.ImageTransparency=daaa
b_aa.level.curve.shadow.ImageTransparency=daaa end
if b_aa:FindFirstChild("monster")then b_aa.monster.TextTransparency=daaa;b_aa.monster.TextStrokeTransparency=
daaa*1.1
b_aa.monster.curve.ImageTransparency=daaa
b_aa.monster.curve.shadow.ImageTransparency=daaa;if b_aa.nickname.Text~=""then b_aa.nickname.TextTransparency=daaa
b_aa.nickname.BackgroundTransparency=daaa end end;if b_aa:FindFirstChild("skull")and b_aa.skull.Visible then
b_aa.skull.ImageTransparency=daaa end else b_aa.Enabled=false
local baaa=__aa:FindFirstChild("monsterHealth")if baaa then baaa.Enabled=false end end end end end;local c__a;local function d__a(dd_a)
c__a=dd_a or bac:invokeServer("{D2B7113F-C646-40B1-A09E-2DB52FB5C4E7}")end
local function _a_a(dd_a)if c__a then
for __aa,a_aa in pairs(c__a.members)do if
a_aa.player==dd_a then return true end end end end
local function aa_a(dd_a)local __aa=dd_a.entityContainer;local a_aa=dd_a.entityManifest;local b_aa=35;local c_aa=60
local d_aa=dd_a.entityContainer.PrimaryPart:FindFirstChild("PlayerTag")
if a_aa==nil then if d_aa then local baaa=d_aa:FindFirstChild("SurfaceGui")if baaa then
baaa.Enabled=false end end;return false end;local _aaa=workspace.CurrentCamera
local aaaa=_bc.magnitude(__aa.PrimaryPart.Position-
_aaa.CFrame.p)
if d_aa then local baaa=d_aa:FindFirstChild("SurfaceGui")
if baaa then
local caaa=Color3.new(1,1,1)
local daaa=game.Players:GetPlayerFromCharacter(a_aa.Parent)if not daaa then return end;local _baa=_a_a(daaa)if _baa then b_aa=150 end
if
not
a_aa:FindFirstChild("isStealthed")and aaaa<b_aa and daaa~=a_c then baaa.Enabled=true;local abaa=daaa
local bbaa=__aa:FindFirstChild("monsterHealth")
if bbaa then
if

a_aa.health.Value/a_aa.maxHealth.Value<1 and(not daaa or
(daaa:FindFirstChild("isInPVP")and daaa.isInPVP.Value))then bbaa.Enabled=true
bbaa.container.backgroundFill.currentHealthFill.ImageColor3=Color3.fromRGB(77,225,69)elseif _baa then bbaa.Enabled=true
bbaa.container.backgroundFill.currentHealthFill.ImageColor3=Color3.fromRGB(226,34,40)else bbaa.Enabled=false end end;local cbaa=20
if _baa then cbaa=50;b_aa=150;caaa=Color3.fromRGB(100,255,255)
baaa.top.party.Visible=true elseif abaa:FindFirstChild("developer")then
caaa=Color3.fromRGB(255,255,128)else baaa.top.party.Visible=false end
local dbaa=Vector3.new(a_aa.Position.X,a_aa.Position.Y- (1.9 +a_aa.Size.Y/2),a_aa.Position.Z)
d_aa.CFrame=(workspace.CurrentCamera.CFrame-
workspace.CurrentCamera.CFrame.p)+dbaa;local _caa
if aaaa>=cbaa then _caa=(aaaa-cbaa)/ (b_aa-cbaa)else _caa=0 end;baaa.curve.ImageTransparency=_caa;if
baaa.top:FindFirstChild("level")then baaa.top.level.TextTransparency=_caa
baaa.top.level.TextColor3=caaa end;if
baaa.top:FindFirstChild("player")then baaa.top.player.TextTransparency=_caa
baaa.top.player.TextColor3=caaa end;if
baaa.top:FindFirstChild("class")then baaa.top.class.ImageTransparency=_caa
baaa.top.class.ImageColor3=caaa end;if
baaa.bottom:FindFirstChild("guild")then baaa.bottom.guild.TextTransparency=_caa
baaa.bottom.guild.BackgroundTransparency=_caa end;if
baaa.top:FindFirstChild("party")then baaa.top.party.image.ImageTransparency=_caa
baaa.top.party.image.ImageColor3=caaa end
if
baaa.top:FindFirstChild("input")then for acaa,bcaa in pairs(baaa.top.input:GetChildren())do
if
bcaa:IsA("ImageLabel")then bcaa.ImageColor3=caaa;bcaa.ImageTransparency=_caa end end end
if baaa.top:FindFirstChild("dev")then
baaa.top.dev.TextTransparency=_caa;baaa.top.dev.TextColor3=caaa end else baaa.Enabled=false
local abaa=__aa:FindFirstChild("monsterHealth")if abaa then abaa.Enabled=false end end end end end
local function ba_a(dd_a)
local __aa=game.Players:GetPlayerFromCharacter(dd_a.Parent)
do if __aa then
if not __aa:FindFirstChild("dataLoaded")then return end end end;local a_aa=d_c:JSONDecode(dd_a.appearance.Value)
local b_aa=cbd(dd_a)b_aa.Parent=dbc
local c_aa={entityContainer=b_aa,entityManifest=dd_a,connections={}}___a(dd_a,c_aa)aad[dd_a]=c_aa
bbd(b_aa.entity,a_aa,dd_a)end
local function ca_a(dd_a)local __aa=Instance.new("Model")local a_aa=dd_a:Clone()
a_aa.BrickColor=BrickColor.new("Hot pink")a_aa.CanCollide=false;a_aa.Anchored=true;a_aa.Name="hitbox"
local b_aa=Instance.new("ObjectValue")b_aa.Name="clientHitboxToServerHitboxReference"b_aa.Value=dd_a
b_aa.Parent=__aa;a_aa:ClearAllChildren()__aa.PrimaryPart=a_aa
a_aa.Parent=__aa;local c_aa,d_aa,_aaa
do
if not dd_a:FindFirstChild("pet")then c_aa=false
d_aa=c_d[dd_a.entityId.Value]
_aaa=c_d[dd_a.entityId.Value].entity:Clone()else c_aa=true
d_aa=b_d[tonumber(dd_a.entityId.Value)]
_aaa=b_d[tonumber(dd_a.entityId.Value)].entity:Clone()end
if _aaa then
if dd_a:FindFirstChild("colorVariant")then
for caaa,daaa in
pairs(_aaa:GetDescendants())do
if
daaa:IsA("BasePart")and daaa:FindFirstChild("doNotDye")==nil then
if daaa:FindFirstChild("colorOverride")then
local _baa=dd_a.colorVariant.Value
daaa.Color=Color3.new(math.clamp(_baa.r,0,1),math.clamp(_baa.g,0,1),math.clamp(_baa.b,0,1))else local _baa=daaa.Color;local abaa=dd_a.colorVariant.Value
daaa.Color=Color3.new(math.clamp(
_baa.r*abaa.r,0,1),math.clamp(_baa.g*abaa.g,0,1),math.clamp(
_baa.b*abaa.b,0,1))end end end end
if dd_a:FindFirstChild("specialName")then
for caaa,daaa in pairs(_aaa:GetDescendants())do
if

daaa:IsA("BasePart")and daaa.Name==
"variation_"..dd_a:FindFirstChild("specialName").Value then daaa.Transparency=0;daaa.CanCollide=true elseif daaa:IsA("BasePart")and daaa.Name==
"variation_default"then daaa.Transparency=1
daaa.CanCollide=false end end end end end;if dd_a:FindFirstChild("monsterScale")then
_bc.scale(_aaa,dd_a.monsterScale.Value)end
local aaaa=Instance.new("Motor6D")aaaa.Name="projectionWeld"aaaa.Part0=a_aa;aaaa.Part1=_aaa.PrimaryPart
aaaa.C0=CFrame.new()
aaaa.C1=CFrame.new(0,_aaa:GetModelCFrame().Y-
_aaa.PrimaryPart.CFrame.Y,0)aaaa.Parent=a_aa;_aaa.Parent=__aa;__aa.Parent=dbc
local baaa={entityContainer=__aa,entityManifest=dd_a,disableHealthBarUI=not not
dd_a:FindFirstChild("isPassive"),disableLevelUI=not
not dd_a:FindFirstChild("isPassive")or
not not dd_a:FindFirstChild("hideLevel"),connections={}}if c_aa then baaa.disableHealthBarUI=true end
if aad[dd_a]then dbd(dd_a)end;___a(dd_a,baaa)aad[dd_a]=baaa;return __aa end
local function da_a(dd_a,__aa)local a_aa
if typeof(dd_a)=="Instance"then a_aa=dd_a else
a_aa=Instance.new("Part")a_aa.CFrame=CFrame.new(dd_a)
a_aa.Size=Vector3.new(0.2,0.2,0.2)a_aa.Transparency=1;a_aa.Anchored=true;a_aa.CanCollide=false
a_aa.Name="DamagePositionPart"a_aa.Parent=workspace.CurrentCamera
game.Debris:AddItem(a_aa,3)end;local b_aa=Instance.new("Sound")
b_aa.SoundId="rbxassetid://2065833626"b_aa.MaxDistance=__aa and 200 or 1000
b_aa.Volume=__aa and 0.25 or 1.5;b_aa.EmitterSize=__aa and 1 or 5;b_aa.Parent=a_aa
b_aa:Play()game.Debris:AddItem(b_aa,5)
if not __aa then
local c_aa=
a_aa:FindFirstChild("hitParticle")or b_c.hitParticle:Clone()c_aa.Parent=a_aa;c_aa:Emit(3)end end;local function _b_a(dd_a)
return dd_a.Parent and
(dd_a.Parent==workspace or dd_a.Parent:IsDescendantOf(workspace))end
local function ab_a(dd_a)
for __aa,a_aa in pairs(dd_a)do
local b_aa=aad[a_aa]
if b_aa and _b_a(a_aa)and b_aa.entityContainer and
b_aa.entityContainer.PrimaryPart then
b_aa.entityContainer.PrimaryPart.CFrame=a_aa.CFrame
if a_aa.entityType.Value=="character"then aa_a(b_aa)elseif

a_aa.entityType.Value=="monster"or a_aa.entityType.Value=="pet"then b__a(b_aa)end else dbd(a_aa)end end end;local function bb_a(dd_a)
for __aa,a_aa in pairs(aad)do if a_aa.entityContainer==dd_a then return __aa end end;return nil end
local cb_a=300
local function db_a()
__d=require(script.Parent:WaitForChild("animationInterface"))
while true do
if _dc.getConfigurationValue("doFixShadowCloneJutsu",a_c)then
for dd_a,__aa in
pairs(dbc:GetChildren())do local a_aa=bb_a(__aa)
if
not a_aa or not a_aa:IsDescendantOf(workspace)then if a_aa then aad[a_aa]=nil end;__aa:Destroy()end end end;for dd_a,__aa in pairs(game.Players:GetPlayers())do
if __aa.Character and
__aa.Character.Parent~=cbc then __aa.Character.Parent=cbc end end
if
a_c.Character and a_c.Character.PrimaryPart then
local dd_a=workspace.CurrentCamera.CFrame.Position;local __aa=_bc.getEntities()
for a_aa,b_aa in pairs(__aa)do
local c_aa=(b_aa.Position-dd_a).magnitude
local d_aa=(b_aa:FindFirstChild("alwaysRendered")~=nil)
if d_aa then if not aad[b_aa]then ca_a(b_aa)end else
if
c_aa<=cb_a and not aad[b_aa]then
if b_aa.entityType.Value=="character"then ba_a(b_aa)elseif

b_aa.entityType.Value=="monster"or b_aa.entityType.Value=="pet"then ca_a(b_aa)end elseif
c_aa>cb_a*1.05 and aad[b_aa]and not aad[b_aa].isPinned then
if b_aa.entityType.Value=="character"then dbd(b_aa)elseif
b_aa.entityType.Value==
"monster"or b_aa.entityType.Value=="pet"then dbd(b_aa)end end end end end;wait(1)end end
local function _c_a(dd_a)local __aa=Color3.fromRGB(255,89,92)
if dd_a>4.5 then
__aa=Color3.fromRGB(255,64,0)elseif dd_a>=2.5 then __aa=Color3.fromRGB(214,19,146)end;return __aa end
local function ac_a()
local dd_a=game.Lighting:FindFirstChild("giantMonsterColor")if dd_a==nil then dd_a=b_c.giantMonsterColor:Clone()
dd_a.Parent=game.Lighting end;local __aa=0
for a_aa,b_aa in
pairs(game.CollectionService:GetTagged("giantEnemy"))do
if
b_aa:FindFirstChild("health")and b_aa.health.Value>0 then
if
b_aa:FindFirstChild("monsterScale")and b_aa.monsterScale.Value>__aa then __aa=b_aa.monsterScale.Value end end end
if __aa>=1.3 and game.PlaceId~=3303140173 then local a_aa=_c_a(__aa)
local b_aa=Color3.new(math.clamp(
a_aa.r*1.2,0,1),math.clamp(a_aa.g*1.2,0,1),math.clamp(a_aa.b*1.2,0,1))
cac(dd_a,{"Brightness","Contrast","Saturation","TintColor"},{0,0.1,0,b_aa},0.5)else
cac(dd_a,{"Brightness","Contrast","Saturation","TintColor"},{0,0,0,Color3.new(1,1,1)},1)end end;local bc_a;local cc_a
local function dc_a(dd_a)local __aa=dd_a:WaitForChild("monsterScale",60)if
not __aa then return false end;local a_aa=__aa.Value;local b_aa=_c_a(a_aa)local c_aa
if a_aa>4.5 then
c_aa=
"SWEET MOTHER OF MUSHROOM! A COLOSSAL "..dd_a.Name.." has been spotted!"elseif a_aa>2.5 then
c_aa="GET OUT OF HERE! A super giant "..dd_a.Name.." has been spotted!"else
c_aa="Run for your life! A giant "..dd_a.Name.." has been spotted!"end
bac:fire("{97822377-6CF7-4275-B2B8-3E4E2E50F11C}",{text=c_aa,textColor3=Color3.new(0,0,0),backgroundColor3=b_aa,backgroundTransparency=0,textStrokeTransparency=1,font=Enum.Font.SourceSansBold},6,"giantEnemySpawned")
game.StarterGui:SetCore("ChatMakeSystemMessage",{Text=c_aa,Color=b_aa,Font=Enum.Font.SourceSansBold})local d_aa=b_c.giantEnemySmoke:Clone()
d_aa.Color=ColorSequence.new(b_aa,Color3.new(0,0,0))d_aa.Rate=80 *a_aa;d_aa.Parent=dd_a;local _aaa=b_c.beam:Clone()
_aaa.CFrame=
_aaa.CFrame-_aaa.Position+dd_a.Position;_aaa.Anchored=true;_aaa.CanCollide=false
_aaa.Parent=workspace.CurrentCamera;_aaa.Color=b_aa;_bc.playSound("giantEnemyBoom",_aaa)
cac(_aaa,{"Transparency"},1,2)
cac(_aaa.Mesh,{"Scale"},Vector3.new(10000,20,20),2)game.Debris:AddItem(_aaa,3)if
(
workspace.CurrentCamera.CFrame.Position-dd_a.Position).magnitude<200 then
bac:invoke("{6E4CC329-38FC-4087-A3E8-9F4FB9E3A452}")end
local aaaa=game.Lighting:FindFirstChild("giantMonsterColor")if aaaa==nil then aaaa=b_c.giantMonsterColor:Clone()
aaaa.Parent=game.Lighting end;cc_a=dd_a;bc_a=true;local baaa=
math.max(b_aa.r,b_aa.g,b_aa.b)^2
local caaa=Color3.new((b_aa.r^3)/baaa,
(b_aa.g^3)/baaa,(b_aa.b^3)/baaa)
cac(aaaa,{"Brightness","Contrast","Saturation","TintColor"},{0.2,0.8,-1,caaa},0.3)
delay(0.5,function()if cc_a==dd_a then bc_a=false;ac_a()end end)end
game.CollectionService:GetInstanceRemovedSignal("giantEnemy"):connect(function(dd_a)if
not bc_a then ac_a()end end)
game.CollectionService:GetInstanceAddedSignal("giantEnemy"):connect(dc_a)
spawn(function()for dd_a,__aa in
pairs(game.CollectionService:GetTagged("giantEnemy"))do dc_a(__aa)end end)
bac:connect("{94EA4964-9682-4133-B150-B6EE2056FD70}","OnClientEvent",function(dd_a,__aa)local a_aa=aad[dd_a]
if a_aa then local b_aa;if dd_a.Parent and
dd_a.Parent:IsA("Model")then
b_aa=game.Players:GetPlayerFromCharacter(dd_a.Parent)end;local c_aa=false
do
if b_aa~=a_c and
(
__aa.sourcePlayerId==nil or __aa.sourcePlayerId~=a_c.UserId)then c_aa=true;if __aa.damage>0 then
bac:fire("{E29E22FB-E00A-4D5C-924C-01172195752D}",dd_a,true)end end end
if __aa.sourcePlayerId==a_c.UserId and
dd_a:FindFirstChild("damagedByPlayer")==nil then
local bbaa=Instance.new("BoolValue")bbaa.Name="damagedByPlayer"bbaa.Parent=dd_a end;if b_aa==a_c and __aa.damage>0 then
bac:fire("{E29E22FB-E00A-4D5C-924C-01172195752D}",dd_a)end;local d_aa=a_aa.entityContainer
local _aaa=d_aa:FindFirstChild("damageIndicator")
if _aaa==nil then
_aaa=_ac.entities.damageIndicator:Clone()
local bbaa=math.max(
(d_aa.PrimaryPart.Size.X+d_aa.PrimaryPart.Size.Z)/2,3)_aaa.Size=UDim2.new(bbaa,50,6,75)_aaa.Parent=d_aa end
if not _aaa.Adornee then _aaa.Adornee=d_aa.PrimaryPart;_aaa.Enabled=true end;local aaaa=_aaa.template:Clone()local baaa=0.5 -
(math.random()-0.5)*0.5
aaaa.Text=tostring(math.floor(
math.abs(__aa.damage)or 0))aaaa.TextTransparency=1;aaaa.TextStrokeTransparency=1
aaaa.Position=UDim2.new(baaa,0,0.85,0)aaaa.Parent=_aaa;game.Debris:AddItem(aaaa,3)
aaaa.Size=UDim2.new(0.7,0,0.1,0)aaaa.Visible=true;if __aa.damage<0 then c_aa=false end;aaaa.ZIndex=
(c_aa and 1)or 2;local caaa=UDim2.new(baaa,0,0,0.3)
local daaa=c_aa and 0.7 or 0;local _baa=UDim2.new(0.7,0,0.3,0)
local abaa=UDim2.new(0.7,0,0.1,0)
if c_aa then local bbaa=tick()
local cbaa=c_c.Heartbeat:connect(function(dbaa)local _caa=(tick()-bbaa)/1.5;aaaa.Position=UDim2.new(baaa,0,
0.85 -0.55 *_caa,0)
if _caa>0.5 then _caa=
(_caa-0.5)*2
aaaa.Size=UDim2.new(0.7,0,0.3 -0.2 *_caa,0)aaaa.TextTransparency=0.5 +_caa/2
aaaa.TextStrokeTransparency=0.5 +_caa/_caa else _caa=_caa*2
aaaa.Size=UDim2.new(0.7,0,0.1 +0.2 *_caa,0)aaaa.TextTransparency=1 -_caa/2
aaaa.TextStrokeTransparency=1 -_caa/2 end end)
delay(1.5,function()cbaa:disconnect()cbaa=nil end)else cac(aaaa,{"Position"},caaa,1.5)
cac(aaaa,{"TextTransparency","TextStrokeTransparency","Size"},{daaa,daaa,_baa},0.75)
delay(0.75,function()
cac(aaaa,{"TextTransparency","TextStrokeTransparency","Size"},{1,1,abaa},0.75)end)end;aaaa.TextColor3=Color3.fromRGB(255,251,117)
aaaa.Font=Enum.Font.SourceSans
if __aa.damage<0 then aaaa.TextColor3=Color3.fromRGB(0,255,213)
aaaa.Font=Enum.Font.SourceSansBold else
if b_aa==a_c then aaaa.TextColor3=Color3.fromRGB(204,0,255)if __aa.supressed then
aaaa.TextColor3=Color3.fromRGB(176,137,200)end elseif b_aa and c_aa then
aaaa.TextColor3=Color3.fromRGB(204,0,255)aaaa.TextTransparency=0.5;if __aa.supressed then
aaaa.TextColor3=Color3.fromRGB(176,137,200)end else if __aa.isCritical then
aaaa.TextColor3=Color3.fromRGB(255,175,83)end;if __aa.supressed then
aaaa.TextColor3=Color3.fromRGB(150,150,150)end end
if __aa.isCritical then aaaa.Font=Enum.Font.SourceSansBold end end end end)local function _d_a(dd_a)end
local function ad_a(dd_a,__aa,a_aa,b_aa)
local c_aa=dd_a.Character and dd_a.Character.PrimaryPart
if aad[c_aa]then aad[c_aa]:playAnimation(__aa,a_aa,b_aa)end end
local function bd_a(dd_a,__aa,a_aa)
if not dd_a or not dd_a.Character or
not dd_a.Character.PrimaryPart then return end;local b_aa=b_d[__aa]
local c_aa=aad[dd_a.Character.PrimaryPart]and
aad[dd_a.Character.PrimaryPart].entityContainer
if c_aa then
if b_aa and b_aa.module then
local d_aa=b_aa.module:FindFirstChild("manifest")
if d_aa then
if d_aa:IsA("MeshPart")then local _aaa=d_aa:Clone()_aaa.Transparency=1
_aaa.CanCollide=false;_aaa.Anchored=false;_aaa.Name="scrollUseRepresentation"local aaaa=_aaa.Size
_aaa.Parent=workspace.CurrentCamera;_aaa.Size=aaaa/10
cac(_aaa,{"Size","Transparency"},{aaaa,0},0.3)local baaa=Instance.new("Vector3Value")
baaa.Value=Vector3.new(0,3,0)
local function caaa()if _aaa then
if c_aa and c_aa.PrimaryPart then
_aaa.CFrame=CFrame.new(c_aa.PrimaryPart.Position+baaa.Value)else _aaa:Destroy()end end end;local daaa
if dd_a==game.Players.LocalPlayer then
daaa=c_c.RenderStepped:connect(caaa)else daaa=c_c.Heartbeat:connect(caaa)end;cac(baaa,{"Value"},Vector3.new(0,5,0),0.3)
if
_aaa then if a_aa then _bc.playSound("scrollSuccess",_aaa)else
_bc.playSound("scrollFail",_aaa)end end;wait(0.5)
if a_aa then
local _baa=b_c.scrollSuccess.Sparkles:Clone()_baa.Enabled=false;_baa.Parent=_aaa;_baa:Emit(30)
local abaa=b_c.scrollSuccess.Attachment:Clone()abaa.Parent=_aaa;wait(0.1)
cac(baaa,{"Value"},Vector3.new(0,5,0),0.7,nil,Enum.EasingDirection.In)cac(_aaa,{"Transparency"},1,0.7)wait(3)else wait(0.1)
local _baa=Instance.new("Explosion")_baa.DestroyJointRadiusPercent=0;_baa.Parent=workspace
_baa.Position=_aaa.Position;daaa:disconnect()_aaa.Anchored=false;_aaa.CanCollide=true
_aaa.Velocity=Vector3.new(math.random(
-100,100),math.random(-100,100),math.random(-100,100))wait(3)end
pcall(function()daaa:disconnect()daaa=nil end)if _aaa then _aaa:Destroy()end end end end end end
local function cd_a()
bac:create("{7FE9D2B7-10FB-4012-8803-C5D8D5E8DFCA}","BindableFunction","OnInvoke",function()
while not a_c.Character or not
a_c.Character.PrimaryPart or not
aad[a_c.Character.PrimaryPart]do wait(0.1)end
return aad[a_c.Character.PrimaryPart].entityContainer end)
bac:create("{CA61CBF0-3B04-4617-8D2D-50C80D51AB19}","BindableFunction","OnInvoke",function(c_aa)return dad(c_aa)end)
bac:create("{B3E10A46-3111-43EB-844A-FCB82CEFDE54}","BindableFunction","OnInvoke",function(c_aa)local d_aa=dad(c_aa)local _aaa={}
local aaaa={d_aa["1"]and
d_aa["1"].manifest,d_aa["11"]and d_aa["11"].manifest}
local function baaa(caaa)
table.insert(_aaa,{part=caaa,transparency=caaa.Transparency})caaa.Transparency=1 end
for caaa,daaa in pairs(aaaa)do if daaa:IsA("BasePart")then baaa(daaa)end
for _baa,abaa in
pairs(daaa:GetDescendants())do if abaa:IsA("BasePart")then baaa(abaa)end end end
return function()
for caaa,daaa in pairs(_aaa)do daaa.part.Transparency=daaa.transparency end end end)
bac:connect("{5F04834B-A4C5-4006-9375-D69A8D6AD983}","OnClientEvent",bd_a)
bac:create("{8BABF769-4B51-49E3-9501-B715DD0790C7}","BindableEvent")
bac:create("{01474D9A-12D0-4C30-90B0-649477E2B77A}","BindableFunction","OnInvoke",function(c_aa,d_aa)
local _aaa=cbd(c_aa.PrimaryPart)bbd(_aaa.entity,d_aa)return _aaa end)
bac:create("{01EB882F-C148-4B63-9A71-26F27C3CC9F6}","BindableFunction","OnInvoke",function(c_aa)local d_aa=ca_a(c_aa)return d_aa end)
bac:create("{819E7CC3-4F36-4808-916D-4395D84EF25F}","BindableFunction","OnInvoke",function(c_aa,d_aa)bbd(c_aa,d_aa)end)
bac:create("{274EE822-1EE6-45E1-A502-3F1CA795FFED}","BindableEvent")
bac:create("{CA747B60-B6A3-491A-8CB3-842595C3B0DC}","BindableFunction","OnInvoke",function(c_aa)
local d_aa=c_aa.Character and c_aa.Character.PrimaryPart
if d_aa and aad[d_aa]then
local _aaa=dad(aad[d_aa].entityContainer.entity)return _aaa["1"]and _aaa["1"].manifest end end)
bac:create("{7C64A511-FF4D-4ADC-B9A2-2E5EDDB8E412}","BindableEvent")
bac:create("{E1A443FB-62B9-4FA8-B0D1-0930199949A1}","BindableFunction","OnInvoke",function(c_aa)c_aa=c_aa or
(a_c.Character and a_c.Character.PrimaryPart)
if c_aa and aad[c_aa]then
local d_aa=dad(aad[c_aa].entityContainer.entity)return d_aa["1"]and d_aa["1"].manifest end end)
bac:create("{17A36949-EEA3-4DB6-962F-0E88121DF82E}","BindableFunction","OnInvoke",function(c_aa)
if
c_aa.entityType.Value=="character"then return ba_a(c_aa)elseif c_aa.entityType.Value=="monster"or
c_aa.entityType.Value=="pet"then return ca_a(c_aa)end end)
bac:create("{6AE8FB7E-9DA0-489D-BBD3-0A56102AC4E4}","BindableFunction","OnInvoke",function()end)
bac:create("{E29E22FB-E00A-4D5C-924C-01172195752D}","BindableEvent","Event",da_a)
bac:create("{CA09ED16-A4C8-4148-9701-4B531599C9E9}","BindableFunction","OnInvoke",function(c_aa)if c_aa and aad[c_aa]then return
aad[c_aa].entityContainer end end)
bac:create("{861EE202-C233-489B-8CF8-DF5C9F4248C1}","BindableFunction","OnInvoke",function(c_aa,d_aa)
local _aaa=c_aa.Character and c_aa.Character.PrimaryPart;if _aaa and aad[_aaa]then return aad[_aaa][d_aa]end end)
bac:create("{43AF616F-F116-4C11-A6BC-C47304DE8FE6}","BindableFunction","OnInvoke",function(c_aa)for d_aa,_aaa in pairs(aad)do if
c_aa==_aaa.entityContainer then return d_aa end end;return
nil end)
bac:create("{71510047-678D-48FB-8A57-28C119ED14DB}","BindableFunction","OnInvoke",function(c_aa,d_aa,_aaa)if c_aa and aad[c_aa]then
aad[c_aa][d_aa]=_aaa end end)
bac:create("{BEC900E6-8DE3-4227-8435-05D09CBBABA5}","BindableFunction","OnInvoke",function(c_aa,d_aa)if c_aa and aad[c_aa]then return
aad[c_aa][d_aa]end;return nil end)
bac:connect("{721D8B67-F3EC-4074-949F-32BC2FA6A069}","OnClientEvent",function(c_aa,...)ad_a(c_aa,...)end)
bac:create("{E030A052-D0AC-42A9-A9C5-97BD70690281}","BindableEvent","Event",function(...)ad_a(a_c,...)end)
bac:create("{4E4654AC-9AEF-4436-8F7C-6AEA2AB8851B}","BindableFunction","OnInvoke",function(c_aa)return"not added"end)
bac:create("{49A19B85-437F-4528-8584-C43D5A8089EB}","BindableFunction","OnInvoke",function(c_aa)
return error("NOT YET IMPLEMENTED")end)
bac:create("{D13D9151-7254-4ED9-8DEA-979E6B884458}","BindableFunction","OnInvoke",function(c_aa)local d_aa=aad[c_aa]if d_aa then
return d_aa.entityContainer end end)
bac:create("{52A4BEBC-137A-4481-BE88-37B1662CEFC9}","BindableEvent","Event",function(c_aa,d_aa)
local _aaa=a_c.Character and a_c.Character.PrimaryPart;if _aaa and aad[_aaa]then
return aad[_aaa]:setWeaponState(c_aa,d_aa)end end)
bac:connect("{52175EBD-EE9F-41F5-A81F-8F6BC2A6E040}","OnClientEvent",d__a)
bac:create("{F22A757B-3CF2-4CEE-ACF2-466C636EF6BB}","BindableFunction","OnInvoke",function(c_aa,d_aa,_aaa,aaaa)local baaa=d_aa;if not __d then
__d=require(script.Parent:WaitForChild("animationInterface"))end
if
_aaa and __d.rawAnimationData.movementAnimations[baaa..
"_".._aaa]then baaa=baaa.."_".._aaa
if aaaa and
__d.rawAnimationData.movementAnimations[baaa.."_"..aaaa]then baaa=baaa.."_"..aaaa end end
return __d.getSingleAnimation(c_aa,"movementAnimations",baaa)end)local dd_a=30;local __aa=50;local a_aa={}local b_aa={}
c_c:BindToRenderStep("updateEntityRendering",50,function()a_aa={}b_aa={}local c_aa=0
local d_aa=game.Players.LocalPlayer
local _aaa=d_aa.Character and d_aa.Character.PrimaryPart and
d_aa.Character.PrimaryPart.Position;for aaaa,baaa in pairs(aad)do
if
c_aa<=dd_a and(aaaa.Position-_aaa).magnitude<=__aa then table.insert(b_aa,aaaa)else table.insert(a_aa,aaaa)end end
ab_a(b_aa)end)
c_c.Heartbeat:connect(function()ab_a(a_aa)end)cbc.ChildAdded:connect(_d_a)d__a()spawn(db_a)end;cd_a()return __c