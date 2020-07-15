local bba={}bba.isEquipped=false
local cba=game:GetService("UserInputService")local dba=game:GetService("HttpService")
local _ca=game:GetService("ReplicatedStorage")
local aca=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")local bca=require(_ca.modules)local cca=bca.load("network")
local dca=bca.load("utilities")local _da=bca.load("detection")
local ada=bca.load("placeSetup")local bda=dba:GenerateGUID(false)
local cda=require(script.Parent.Parent.Parent:WaitForChild("repo"):WaitForChild("animationInterface"))local dda;local __b;local a_b;local b_b;local c_b=false;local d_b=false;local _ab=false;local aab=false;local bab=false;local cab,dab
local _bb;local abb;local bbb=game.Players.LocalPlayer;local cbb=false;local function dbb(cdb,ddb)
if cdb=="isSprinting"then cbb=ddb end end
local function _cb(cdb)
if abb then for ddb,__c in pairs(abb)do if
__c.id==cdb and __c.rank>0 then return true end end end;return false end;local acb=false
local function bcb()if acb then return end;acb=true
while acb do
if


a_b.dualAnimations.strike1.IsPlaying or a_b.dualAnimations.strike2.IsPlaying or a_b.dualAnimations.strike3.IsPlaying then if _ab then
cca:invoke("{5F5D5BE5-27D1-4783-ABB2-4C83A1E617AE}","equipment",nil,bda)end;wait(1 /20)else break end end;acb=false end
local function ccb()bda=dba:GenerateGUID(false)
if b_b then b_b:disconnect()b_b=nil end
if slashAnimationKeyframeConnection then
slashAnimationKeyframeConnection:disconnect()slashAnimationKeyframeConnection=nil end end
local function dcb(cdb)local ddb=a_b.dualAnimations;if not ddb then return end;local __c
if ddb.strike1.IsPlaying then
__c={cab}elseif ddb.strike2.IsPlaying then __c={dab}elseif ddb.strike3.IsPlaying then __c={cab,dab}else __c={}end
if cdb=="slash1PeriodStart"then c_b=true
delay(0.6,function()c_b=false end)elseif cdb=="slash2PeriodStart"then d_b=true
delay(0.6,function()d_b=false end)elseif cdb=="startDamageSequence"then _ab=true
for a_c,b_c in pairs(__c)do
local c_c=b_c:FindFirstChild("Swing")
if c_c==nil then c_c=Instance.new("Sound")c_c.Volume=1
c_c.MaxDistance=50;c_c.SoundId="rbxassetid://2069260907"c_c.Name="Swing"c_c.Parent=b_c end;c_c:Play()if b_c and b_c:FindFirstChild("Trail")then
b_c.Trail.Enabled=true end end elseif cdb=="stopDamageSequence"then _ab=false
for a_c,b_c in pairs(__c)do if
b_c and b_c:FindFirstChild("Trail")then b_c.Trail.Enabled=false end end end end
local function _db()if b_b then b_b:disconnect()b_b=nil end
if slashAnimationKeyframeConnection then
slashAnimationKeyframeConnection:disconnect()slashAnimationKeyframeConnection=nil end end
function bba:attack()if not a_b then return end;local cdb=a_b.dualAnimations
if not cdb then return elseif cbb then return elseif
not(cab and cab)then return elseif
not bbb.Character or not bbb.Character.PrimaryPart or
bbb.Character.PrimaryPart.state.Value=="dead"then return elseif cdb.strike1.IsPlaying then return elseif
cdb.strike2.IsPlaying then return elseif cdb.strike3.IsPlaying then return end
local ddb=(not cdb.strike1.IsPlaying)or(c_b and(not bab))
local __c=(not cdb.strike2.IsPlaying)and d_b and aab
local a_c=(not cdb.strike3.IsPlaying)and c_b and bab
if a_c then c_b=false;_db()
b_b=cdb.strike3.Stopped:Connect(ccb)
slashAnimationKeyframeConnection=cdb.strike3.KeyframeReached:Connect(dcb)
cda:replicateClientAnimationSequence("dualAnimations","strike3")bda=dba:GenerateGUID(false)spawn(bcb)elseif __c then d_b=false;_db()
b_b=cdb.strike2.Stopped:Connect(ccb)
slashAnimationKeyframeConnection=cdb.strike2.KeyframeReached:Connect(dcb)
cda:replicateClientAnimationSequence("dualAnimations","strike2")bda=dba:GenerateGUID(false)spawn(bcb)elseif ddb then c_b=false;_db()
b_b=cdb.strike1.Stopped:Connect(ccb)
slashAnimationKeyframeConnection=cdb.strike1.KeyframeReached:Connect(dcb)
cda:replicateClientAnimationSequence("dualAnimations","strike1")bda=dba:GenerateGUID(false)spawn(bcb)end end
function bba:equip()c_b=false;d_b=false;_ab=false;acb=false
_bb=cca:invoke("{7FE9D2B7-10FB-4012-8803-C5D8D5E8DFCA}")
if _bb then
local cdb=cca:invoke("{CA61CBF0-3B04-4617-8D2D-50C80D51AB19}",_bb.entity)cab=cdb["1"].manifest;dab=cdb["11"].manifest
a_b=cda:getAnimationsForAnimationController(_bb.entity.AnimationController)end end;function bba:unequip()end;local function adb(cdb,ddb)
if cdb=="abilities"then abb=ddb;aab=_cb(3)bab=_cb(30)end end
local function bdb()
adb("abilities",cca:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","abilities"))
cca:connect("{B5BFDE4F-1C2E-4D65-ACB4-277DB309BF6D}","Event",adb)
cca:connect("{94D3C981-27E0-4907-86A8-0C1F0F5CAE6C}","Event",dbb)end;bdb()return bba