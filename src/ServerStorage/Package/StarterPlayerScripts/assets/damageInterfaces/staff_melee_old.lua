local daa={}daa.isEquipped=false
local _ba=game:GetService("UserInputService")local aba=game:GetService("HttpService")
local bba=game:GetService("ReplicatedStorage")
local cba=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")local dba=require(bba.modules)local _ca=dba.load("network")
local aca=dba.load("utilities")local bca=dba.load("detection")
local cca=dba.load("placeSetup")local dca=aba:GenerateGUID(false)
local _da=require(script.Parent.Parent.Parent:WaitForChild("repo"):WaitForChild("animationInterface"))local ada;local bda;local cda;local dda;local __b=false;local a_b=false;local b_b=false;local c_b=false;local d_b;local _ab;local aab
local bab=game.Players.LocalPlayer;local cab=false
local function dab(bcb,ccb)if bcb=="isSprinting"then cab=ccb end end
local function _bb(bcb)
if aab then for ccb,dcb in pairs(aab)do
if dcb.id==bcb and dcb.rank>0 then return true end end end;return false end;local abb=false
local function bbb()if abb then return end;abb=true
while abb do
if

cda.swordAnimations.strike1.IsPlaying or cda.swordAnimations.strike2.IsPlaying then if b_b then
_ca:invoke("{5F5D5BE5-27D1-4783-ABB2-4C83A1E617AE}","equipment",nil,dca)end;wait(1 /20)else break end end;abb=false end
local function cbb()dca=aba:GenerateGUID(false)
if dda then dda:disconnect()dda=nil end
if slashAnimationKeyframeConnection then
slashAnimationKeyframeConnection:disconnect()slashAnimationKeyframeConnection=nil end
if d_b and d_b:FindFirstChild("Trail")then d_b.Trail.Enabled=false end end
local function dbb(bcb)
if bcb=="slash1PeriodStart"then __b=true
delay(3 /10,function()__b=false end)elseif bcb=="slash2PeriodStart"then a_b=true
delay(3 /10,function()a_b=false end)elseif bcb=="startDamageSequence"then local ccb=d_b:FindFirstChild("Swing")
if
ccb==nil then ccb=Instance.new("Sound")ccb.Volume=1;ccb.MaxDistance=50
ccb.SoundId="rbxassetid://2069260907"ccb.Name="Swing"ccb.Parent=d_b end;ccb:Play()b_b=true;if d_b and d_b:FindFirstChild("Trail")then
d_b.Trail.Enabled=true end elseif bcb=="stopDamageSequence"then b_b=false
if d_b and
d_b:FindFirstChild("Trail")then d_b.Trail.Enabled=false end end end
function daa:attack()
if not cda or not cda.swordAnimations then return elseif cab then return elseif not d_b then return elseif

not bab.Character or not bab.Character.PrimaryPart or
bab.Character.PrimaryPart.state.Value=="dead"then return elseif
cda.swordAnimations.strike1.IsPlaying and(not a_b or not c_b)then return elseif
cda.swordAnimations.strike2.IsPlaying and not __b then return end
if cda.swordAnimations.strike1.IsPlaying and a_b then if dda then
dda:disconnect()dda=nil end
if slashAnimationKeyframeConnection then
slashAnimationKeyframeConnection:disconnect()slashAnimationKeyframeConnection=nil end;cda.swordAnimations.strike1:Stop()
dda=cda.swordAnimations.strike2.Stopped:connect(cbb)
slashAnimationKeyframeConnection=cda.swordAnimations.strike2.KeyframeReached:connect(dbb)
_da:replicateClientAnimationSequence("swordAnimations","strike2")dca=aba:GenerateGUID(false)spawn(bbb)elseif not
cda.swordAnimations.strike1.IsPlaying and(
not cda.swordAnimations.strike2.IsPlaying or __b)then if
dda then dda:disconnect()dda=nil end
if slashAnimationKeyframeConnection then
slashAnimationKeyframeConnection:disconnect()slashAnimationKeyframeConnection=nil end;cda.swordAnimations.strike2:Stop()
dda=cda.swordAnimations.strike1.Stopped:connect(function()
b_b=false;__b=false;a_b=false end)
slashAnimationKeyframeConnection=cda.swordAnimations.strike1.KeyframeReached:connect(dbb)
_da:replicateClientAnimationSequence("swordAnimations","strike1")dca=aba:GenerateGUID(false)spawn(bbb)end end
function daa:equip()__b=false;a_b=false;b_b=false;abb=false
_ab=_ca:invoke("{7FE9D2B7-10FB-4012-8803-C5D8D5E8DFCA}")if _ab then
d_b=_ca:invoke("{E1A443FB-62B9-4FA8-B0D1-0930199949A1}")
cda=_da:getAnimationsForAnimationController(_ab.entity.AnimationController)end end;function daa:unequip()end
local function _cb(bcb,ccb)if bcb=="abilities"then aab=ccb;c_b=_bb(3)end end
local function acb()
_cb("abilities",_ca:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","abilities"))
_ca:connect("{B5BFDE4F-1C2E-4D65-ACB4-277DB309BF6D}","Event",_cb)
_ca:connect("{94D3C981-27E0-4907-86A8-0C1F0F5CAE6C}","Event",dab)end;acb()return daa