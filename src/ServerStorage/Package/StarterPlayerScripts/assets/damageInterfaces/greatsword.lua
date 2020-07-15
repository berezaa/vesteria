local aba={}aba.isEquipped=false
local bba=game:GetService("UserInputService")local cba=game:GetService("HttpService")
local dba=game:GetService("ReplicatedStorage")
local _ca=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")local aca=require(dba.modules)local bca=aca.load("network")
local cca=aca.load("utilities")local dca=aca.load("detection")
local _da=aca.load("placeSetup")local ada=cba:GenerateGUID(false)
local bda=require(script.Parent.Parent.Parent:WaitForChild("repo"):WaitForChild("animationInterface"))local cda;local dda;local __b;local a_b;local b_b=false;local c_b=false;local d_b=false;local _ab=false;local aab=false
local bab=false;local cab;local dab;local _bb;local abb=game.Players.LocalPlayer;local bbb=false;local function cbb(adb,bdb)if
adb=="isSprinting"then bbb=bdb end end
local function dbb(adb,bdb)if _bb then
for cdb,ddb in pairs(_bb)do if ddb.id==
adb and ddb.rank>0 then
if bdb then return ddb.variant==bdb else return true end end end end
return false end;local _cb=false
local function acb()if _cb then return end;_cb=true
while _cb do
if


__b.greatswordAnimations.strike1.IsPlaying or __b.greatswordAnimations.strike2.IsPlaying or __b.greatswordAnimations.strike3.IsPlaying then if d_b then
bca:invoke("{5F5D5BE5-27D1-4783-ABB2-4C83A1E617AE}","equipment",nil,ada)end;wait(1 /20)else break end end;_cb=false end
local function bcb(adb)
if adb=="startDamageSequence"then local bdb=cab:FindFirstChild("Swing")
if
bdb==nil then bdb=Instance.new("Sound")bdb.PlaybackSpeed=0.6;bdb.Volume=1
bdb.MaxDistance=50;bdb.SoundId="rbxassetid://2069260907"bdb.Name="Swing"bdb.Parent=cab end;bdb:Play()d_b=true;if cab and cab:FindFirstChild("Trail")then
cab.Trail.Enabled=true end elseif adb=="stopDamageSequence"then d_b=false
if cab and
cab:FindFirstChild("Trail")then cab.Trail.Enabled=false end end end
local function ccb(adb)ada=cba:GenerateGUID(false)if
cab and cab:FindFirstChild("Trail")then cab.Trail.Enabled=false end
if bab then if a_b then
a_b:disconnect()a_b=nil end
if slashAnimationKeyframeConnection then
slashAnimationKeyframeConnection:disconnect()slashAnimationKeyframeConnection=nil end
local bdb=(adb=="strike1"and"strike2")or(adb=="strike2"and"strike3")
if bdb then
slashAnimationKeyframeConnection=__b.greatswordAnimations[bdb].KeyframeReached:connect(bcb)
a_b=__b.greatswordAnimations[bdb].Stopped:connect(function()
ccb(bdb)end)
bda:replicateClientAnimationSequence("greatswordAnimations",bdb)spawn(acb)end else if a_b then a_b:disconnect()a_b=nil end
if slashAnimationKeyframeConnection then
slashAnimationKeyframeConnection:disconnect()slashAnimationKeyframeConnection=nil end end;bab=false end
function aba:attack()
if not __b or not __b.greatswordAnimations then return elseif bbb then return elseif not cab then return elseif
not
abb.Character or not abb.Character.PrimaryPart or
abb.Character.PrimaryPart.state.Value=="dead"then return elseif
__b.greatswordAnimations.strike1.IsPlaying and bab then return elseif
__b.greatswordAnimations.strike2.IsPlaying and bab then return elseif __b.greatswordAnimations.strike3.IsPlaying then return end
if
not __b.greatswordAnimations.strike1.IsPlaying and not
__b.greatswordAnimations.strike2.IsPlaying and not
__b.greatswordAnimations.strike3.IsPlaying then if a_b then a_b:disconnect()a_b=nil end
if slashAnimationKeyframeConnection then
slashAnimationKeyframeConnection:disconnect()slashAnimationKeyframeConnection=nil end
a_b=__b.greatswordAnimations.strike1.Stopped:connect(function()
ccb("strike1")end)
slashAnimationKeyframeConnection=__b.greatswordAnimations.strike1.KeyframeReached:connect(bcb)
bda:replicateClientAnimationSequence("greatswordAnimations","strike1")ada=cba:GenerateGUID(false)spawn(acb)else bab=true end end
function aba:equip()b_b=false;c_b=false;d_b=false;_cb=false
dab=bca:invoke("{7FE9D2B7-10FB-4012-8803-C5D8D5E8DFCA}")if dab then
cab=bca:invoke("{E1A443FB-62B9-4FA8-B0D1-0930199949A1}")
__b=bda:getAnimationsForAnimationController(dab.entity.AnimationController)end end;function aba:unequip()end
local function dcb(adb,bdb)if adb=="abilities"then _bb=bdb;_ab=dbb(3)
aab=dbb(3,"tripleSlash")end end
local function _db()
dcb("abilities",bca:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","abilities"))
bca:connect("{B5BFDE4F-1C2E-4D65-ACB4-277DB309BF6D}","Event",dcb)
bca:connect("{94D3C981-27E0-4907-86A8-0C1F0F5CAE6C}","Event",cbb)end;_db()return aba