local caa={}caa.isEquipped=false
local daa=game:GetService("UserInputService")local _ba=game:GetService("HttpService")
local aba=game:GetService("ReplicatedStorage")local bba=require(aba.modules)local cba=bba.load("network")
local dba=bba.load("utilities")local _ca=bba.load("detection")
local aca=bba.load("placeSetup")local bca=_ba:GenerateGUID(false)
local cca=require(script.Parent.Parent.Parent:WaitForChild("repo"):WaitForChild("animationInterface"))local dca;local _da;local ada;local bda;local cda;local dda=false;local __b=false;local a_b=false;local b_b=false;local c_b;local d_b
local _ab=game.Players.LocalPlayer;local aab=false
local function bab(_cb,acb)if _cb=="isSprinting"then aab=acb end end
local function cab(_cb)
if d_b then for acb,bcb in pairs(d_b)do
if bcb.id==_cb and bcb.rank>0 then return true end end end;return false end;local dab=false
local function _bb()if dab then return end;dab=true
while dab do
if

bda.daggerAnimations.strike1.IsPlaying or bda.daggerAnimations.strike2.IsPlaying then if a_b then
cba:invoke("{5F5D5BE5-27D1-4783-ABB2-4C83A1E617AE}","equipment",nil,bca)end;wait(1 /20)else break end end;dab=false end
local function abb()bca=_ba:GenerateGUID(false)
if cda then cda:disconnect()cda=nil end
if slashAnimationKeyframeConnection then
slashAnimationKeyframeConnection:disconnect()slashAnimationKeyframeConnection=nil end
if c_b and c_b:FindFirstChild("Trail")then c_b.Trail.Enabled=false end end
local function bbb(_cb)
if _cb=="slash1PeriodStart"then dda=true
delay(3 /10,function()dda=false end)elseif _cb=="slash2PeriodStart"then __b=true
delay(3 /10,function()__b=false end)elseif _cb=="startDamageSequence"then local acb=c_b:FindFirstChild("Swing")
if
acb==nil then acb=Instance.new("Sound")acb.Volume=1;acb.MaxDistance=50
acb.SoundId="rbxassetid://2069260907"acb.Name="Swing"acb.Parent=c_b end;acb:Play()a_b=true;if c_b and c_b:FindFirstChild("Trail")then
c_b.Trail.Enabled=true end elseif _cb=="stopDamageSequence"then a_b=false
if c_b and
c_b:FindFirstChild("Trail")then c_b.Trail.Enabled=false end end end
function caa:attack()
if not bda or not bda.swordAnimations then return elseif aab then return elseif not c_b then return elseif

not _ab.Character or not _ab.Character.PrimaryPart or
_ab.Character.PrimaryPart.state.Value=="dead"then return elseif
bda.swordAnimations.strike1.IsPlaying and(not __b or not b_b)then return elseif
bda.swordAnimations.strike2.IsPlaying and not dda then return end;local _cb=dca.entity.AnimationController
for acb,bcb in
pairs(_cb:GetPlayingAnimationTracks())do if
bcb.Name=="rock_throw_upper"or bcb.Name=="rock_throw_upper_loop"then return end end
if
bda.daggerAnimations.strike1.IsPlaying and __b and b_b then if cda then cda:disconnect()cda=nil end
if slashAnimationKeyframeConnection then
slashAnimationKeyframeConnection:disconnect()slashAnimationKeyframeConnection=nil end
bda.daggerAnimations.strike1:Stop()
cda=bda.daggerAnimations.strike2.Stopped:connect(abb)
slashAnimationKeyframeConnection=bda.daggerAnimations.strike2.KeyframeReached:connect(bbb)
cca:replicatePlayerAnimationSequence("daggerAnimations","strike2")bca=_ba:GenerateGUID(false)spawn(_bb)elseif
not
bda.daggerAnimations.strike1.IsPlaying and(
not bda.daggerAnimations.strike2.IsPlaying or dda)then if cda then cda:disconnect()cda=nil end
if slashAnimationKeyframeConnection then
slashAnimationKeyframeConnection:disconnect()slashAnimationKeyframeConnection=nil end
bda.daggerAnimations.strike2:Stop()
cda=bda.daggerAnimations.strike1.Stopped:connect(abb)
slashAnimationKeyframeConnection=bda.daggerAnimations.strike1.KeyframeReached:connect(bbb)
cca:replicatePlayerAnimationSequence("daggerAnimations","strike1")bca=_ba:GenerateGUID(false)spawn(_bb)end end
function caa:equip()dda=false;__b=false;a_b=false;dab=false
dca=cba:invoke("{7FE9D2B7-10FB-4012-8803-C5D8D5E8DFCA}")if dca then
c_b=cba:invoke("{E1A443FB-62B9-4FA8-B0D1-0930199949A1}")
bda=cca:getAnimationsForAnimationController(dca.entity.AnimationController)end end;function caa:unequip()end
local function cbb(_cb,acb)if _cb=="abilities"then d_b=acb
if cab(3)then b_b=true else b_b=false end end end
local function dbb()
cbb("abilities",cba:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","abilities"))
cba:connect("{B5BFDE4F-1C2E-4D65-ACB4-277DB309BF6D}","Event",cbb)
cba:connect("{94D3C981-27E0-4907-86A8-0C1F0F5CAE6C}","Event",bab)end;dbb()return caa