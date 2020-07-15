local _ba={}local aba={}aba.isEquipped=false
local bba=game:GetService("UserInputService")local cba=game:GetService("HttpService")
local dba=game:GetService("ReplicatedStorage")local _ca=require(dba.modules)local aca=_ca.load("network")
local bca=_ca.load("utilities")local cca=_ca.load("detection")
local dca=_ca.load("placeSetup")local _da=_ca.load("configuration")
local ada=cba:GenerateGUID(false)
local bda=require(script.Parent.Parent.Parent:WaitForChild("repo"):WaitForChild("animationInterface"))local cda;local dda;local __b;local a_b;local b_b;local c_b=false;local d_b=false;local _ab=false;local aab=false;local bab;local cab
local dab=game.Players.LocalPlayer;local _bb=false
local function abb(dcb,_db)if dcb=="isSprinting"then _bb=_db end end
local function bbb(dcb)
if cab then for _db,adb in pairs(cab)do
if adb.id==dcb and adb.rank>0 then return true end end end;return false end;local cbb=false;local function dbb()if cbb then return end;cbb=true;cbb=false end
local function _cb()
ada=cba:GenerateGUID(false)if a_b then a_b:disconnect()a_b=nil end
if slashAnimationKeyframeConnection then
slashAnimationKeyframeConnection:disconnect()slashAnimationKeyframeConnection=nil end;if bab and bab:FindFirstChild("Trail")then end end
local function acb(dcb)
if dcb=="slash1PeriodStart"then c_b=true
delay(3 /10,function()c_b=false end)elseif dcb=="slash2PeriodStart"then d_b=true
delay(3 /10,function()d_b=false end)elseif dcb=="startDamageSequence"then local _db=bab:FindFirstChild("Swing")
if
_db==nil then _db=Instance.new("Sound")_db.Volume=1;_db.MaxDistance=50
_db.SoundId="rbxassetid://2069260907"_db.Name="Swing"_db.Parent=bab end;_ab=true
if bab and bab:FindFirstChild("Trail")then end elseif dcb=="stopDamageSequence"then _ab=false;if
bab and bab:FindFirstChild("Trail")then end end end
function aba:attack()
if not __b or not __b.staffAnimations then return elseif _bb then return elseif not bab then return elseif

not dab.Character or not dab.Character.PrimaryPart or
dab.Character.PrimaryPart.state.Value=="dead"then return elseif
__b.staffAnimations.strike1.IsPlaying and(not d_b or not aab)then return elseif
__b.staffAnimations.strike2.IsPlaying and not c_b then return end;local dcb=b_b.entity.AnimationController
for bdb,cdb in
pairs(dcb:GetPlayingAnimationTracks())do if
cdb.Name=="rock_throw_upper"or cdb.Name=="rock_throw_upper_loop"then return end end
local _db=aca:invoke("{0659F187-209D-48FD-AE95-040A0C31DB94}")
local adb=_da.getConfigurationValue("mageManaDrainFromBasicAttack")if dab.Character.PrimaryPart.mana.Value<adb then
_db.noRangeManaAttack=true end
if
__b.staffAnimations.strike1.IsPlaying and d_b then
if a_b then a_b:disconnect()a_b=nil end
if slashAnimationKeyframeConnection then
slashAnimationKeyframeConnection:disconnect()slashAnimationKeyframeConnection=nil end;__b.staffAnimations.strike1:Stop()
a_b=__b.staffAnimations.strike2.Stopped:connect(_cb)
slashAnimationKeyframeConnection=__b.staffAnimations.strike2.KeyframeReached:connect(acb)
bda:replicatePlayerAnimationSequence("staffAnimations","strike2",nil,_db)ada=cba:GenerateGUID(false)spawn(dbb)elseif not
__b.staffAnimations.strike1.IsPlaying and(
not __b.staffAnimations.strike2.IsPlaying or c_b)then if
a_b then a_b:disconnect()a_b=nil end
if slashAnimationKeyframeConnection then
slashAnimationKeyframeConnection:disconnect()slashAnimationKeyframeConnection=nil end;__b.staffAnimations.strike2:Stop()
a_b=__b.staffAnimations.strike1.Stopped:connect(_cb)
slashAnimationKeyframeConnection=__b.staffAnimations.strike1.KeyframeReached:connect(acb)
bda:replicatePlayerAnimationSequence("staffAnimations","strike1",nil,_db)ada=cba:GenerateGUID(false)spawn(dbb)end end
function aba:equip()c_b=false;d_b=false;_ab=false;cbb=false
b_b=aca:invoke("{7FE9D2B7-10FB-4012-8803-C5D8D5E8DFCA}")if b_b then
bab=aca:invoke("{E1A443FB-62B9-4FA8-B0D1-0930199949A1}")
__b=bda:getAnimationsForAnimationController(b_b.entity.AnimationController)end end;function aba:unequip()end
local function bcb(dcb,_db)if dcb=="abilities"then cab=_db
if bbb(3)then aab=true else aab=false end end end
local function ccb()
bcb("abilities",aca:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","abilities"))
aca:connect("{B5BFDE4F-1C2E-4D65-ACB4-277DB309BF6D}","Event",bcb)
aca:connect("{94D3C981-27E0-4907-86A8-0C1F0F5CAE6C}","Event",abb)end;ccb()return aba