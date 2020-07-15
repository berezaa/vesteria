local _ba={}_ba.isEquipped=false
local aba=game:GetService("UserInputService")local bba=game:GetService("HttpService")
local cba=game:GetService("ReplicatedStorage")
local dba=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")local _ca=require(cba.modules)local aca=_ca.load("network")
local bca=_ca.load("utilities")local cca=_ca.load("detection")
local dca=_ca.load("placeSetup")local _da=bba:GenerateGUID(false)
local ada=require(script.Parent.Parent.Parent:WaitForChild("repo"):WaitForChild("animationInterface"))local bda;local cda;local dda;local __b;local a_b=false;local b_b=false;local c_b=false;local d_b=false;local _ab=false;local aab
local bab;local cab;local dab=game.Players.LocalPlayer;local _bb=false;local function abb(dcb,_db)
if dcb=="isSprinting"then _bb=_db end end
local function bbb(dcb,_db)
if cab then for adb,bdb in pairs(cab)do
if
bdb.id==dcb and bdb.rank>0 then if _db then return bdb.variant==_db else return true end end end end;return false end;local cbb=false
local function dbb()if cbb then return end;cbb=true
while cbb do
if


dda.swordAnimations.strike1.IsPlaying or dda.swordAnimations.strike2.IsPlaying or dda.swordAnimations.strike3.IsPlaying then if c_b then
aca:invoke("{5F5D5BE5-27D1-4783-ABB2-4C83A1E617AE}","equipment",nil,_da)end;wait(1 /20)else break end end;cbb=false end
local function _cb()_da=bba:GenerateGUID(false)
if __b then __b:disconnect()__b=nil end
if slashAnimationKeyframeConnection then
slashAnimationKeyframeConnection:disconnect()slashAnimationKeyframeConnection=nil end
if aab and aab:FindFirstChild("Trail")then aab.Trail.Enabled=false end end
local function acb(dcb)
if dcb=="slash1PeriodStart"then a_b=true
delay(3 /10,function()a_b=false end)elseif dcb=="slash2PeriodStart"then b_b=true
delay(3 /10,function()b_b=false end)elseif dcb=="startDamageSequence"then local _db=aab:FindFirstChild("Swing")
if
_db==nil then _db=Instance.new("Sound")_db.Volume=1;_db.MaxDistance=50
_db.SoundId="rbxassetid://2069260907"_db.Name="Swing"_db.Parent=aab end;_db:Play()c_b=true;if aab and aab:FindFirstChild("Trail")then
aab.Trail.Enabled=true end elseif dcb=="stopDamageSequence"then c_b=false
if aab and
aab:FindFirstChild("Trail")then aab.Trail.Enabled=false end end end
function _ba:attack()
if not dda or not dda.swordAnimations then return elseif _bb then return elseif not aab then return elseif

not dab.Character or not dab.Character.PrimaryPart or
dab.Character.PrimaryPart.state.Value=="dead"then return elseif
dda.swordAnimations.strike1.IsPlaying and(not b_b or not d_b)then return elseif
dda.swordAnimations.strike2.IsPlaying and not a_b then return elseif dda.swordAnimations.strike3.IsPlaying then return end;local dcb=bab.entity.AnimationController
for _db,adb in
pairs(dcb:GetPlayingAnimationTracks())do if
adb.Name=="rock_throw_upper"or adb.Name=="rock_throw_upper_loop"then return end end
if dda.swordAnimations.strike1.IsPlaying and b_b then if __b then
__b:disconnect()__b=nil end
if slashAnimationKeyframeConnection then
slashAnimationKeyframeConnection:disconnect()slashAnimationKeyframeConnection=nil end;dda.swordAnimations.strike1:Stop()
__b=dda.swordAnimations.strike2.Stopped:connect(_cb)
slashAnimationKeyframeConnection=dda.swordAnimations.strike2.KeyframeReached:connect(acb)
ada:replicateClientAnimationSequence("swordAnimations","strike2")_da=bba:GenerateGUID(false)spawn(dbb)elseif not
dda.swordAnimations.strike1.IsPlaying and(
not dda.swordAnimations.strike2.IsPlaying or a_b)then
if

_ab and dda.swordAnimations.strike2.IsPlaying and

dda.swordAnimations.strike2.TimePosition>=dda.swordAnimations.strike2.Length*0.3 and

dda.swordAnimations.strike2.TimePosition<=dda.swordAnimations.strike2.Length*0.7 then if __b then __b:disconnect()__b=nil end
if slashAnimationKeyframeConnection then
slashAnimationKeyframeConnection:disconnect()slashAnimationKeyframeConnection=nil end;dda.swordAnimations.strike2:Stop()
__b=dda.swordAnimations.strike3.Stopped:connect(_cb)
slashAnimationKeyframeConnection=dda.swordAnimations.strike3.KeyframeReached:connect(acb)
ada:replicateClientAnimationSequence("swordAnimations","strike3")_da=bba:GenerateGUID(false)spawn(dbb)else if __b then
__b:disconnect()__b=nil end
if slashAnimationKeyframeConnection then
slashAnimationKeyframeConnection:disconnect()slashAnimationKeyframeConnection=nil end;dda.swordAnimations.strike2:Stop()
__b=dda.swordAnimations.strike1.Stopped:connect(function()
c_b=false;a_b=false;b_b=false end)
slashAnimationKeyframeConnection=dda.swordAnimations.strike1.KeyframeReached:connect(acb)
ada:replicateClientAnimationSequence("swordAnimations","strike1")_da=bba:GenerateGUID(false)spawn(dbb)end end end
function _ba:equip()a_b=false;b_b=false;c_b=false;cbb=false
bab=aca:invoke("{7FE9D2B7-10FB-4012-8803-C5D8D5E8DFCA}")if bab then
aab=aca:invoke("{E1A443FB-62B9-4FA8-B0D1-0930199949A1}")
dda=ada:getAnimationsForAnimationController(bab.entity.AnimationController)end end;function _ba:unequip()end
local function bcb(dcb,_db)if dcb=="abilities"then cab=_db;d_b=bbb(3)
_ab=bbb(3,"tripleSlash")end end
local function ccb()
bcb("abilities",aca:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","abilities"))
aca:connect("{B5BFDE4F-1C2E-4D65-ACB4-277DB309BF6D}","Event",bcb)
aca:connect("{94D3C981-27E0-4907-86A8-0C1F0F5CAE6C}","Event",abb)end;ccb()return _ba