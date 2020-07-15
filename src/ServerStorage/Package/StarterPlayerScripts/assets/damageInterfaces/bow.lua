local dba={}local _ca={}_ca.isEquipped=false
local aca=game:GetService("RunService")local bca=game:GetService("UserInputService")
local cca=game:GetService("ReplicatedStorage")local dca=require(cca.modules)local _da=dca.load("network")
local ada=dca.load("utilities")local bda=dca.load("client_utilities")
local cda=dca.load("detection")local dda=dca.load("placeSetup")
local __b=dca.load("projectile")local a_b=dca.load("configuration")
local b_b=dca.load("damage")local c_b=dca.load("tween")
local d_b=require(script.Parent.Parent.Parent:WaitForChild("repo"):WaitForChild("animationInterface"))local _ab=dda.awaitPlaceFolder("entityRenderCollection")
local aab=dda.awaitPlaceFolder("entityManifestCollection")local bab=dda.awaitPlaceFolder("items")
local cab=dda.awaitPlaceFolder("entities")local dab=false;local _bb;local abb;local bbb;local cbb;local dbb=workspace.CurrentCamera
local _cb=game.Players.LocalPlayer;local acb=false
local function bcb(b_c,c_c)local d_c=c_c-b_c.Origin
local _ac=(b_c.Origin+b_c.Direction)-b_c.Origin;local aac=d_c:Dot(_ac)/_ac:Dot(_ac)
aac=math.clamp(aac,0,1)return b_c.Origin+aac*_ac end
local function ccb(b_c,c_c)if b_c=="isSprinting"then acb=c_c end end
local function dcb()
if dab and bbb.stretchHold then bbb.stretchHold:Play()end;if cbb.bowAnimations.stretching_bow.IsPlaying then
cbb.bowAnimations.stretching_bow:Stop()end end;local _db
local function adb(b_c)
local c_c=_da:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","inventory")or{}
for d_c,_ac in pairs(c_c)do if _ac.id==87 and _ac.stacks>=1 then
return true,math.min(_ac.stacks,b_c)end end;return false end;local bdb=0.8;local cdb=1 /bdb;local ddb=0
function _ca:attackRangerStance()local b_c,c_c=adb(1)
if not b_c then
_da:fire("{97822377-6CF7-4275-B2B8-3E4E2E50F11C}",{text="You don't have any arrows!",id="noarrows"},3)return false end
_da:invoke("{B30EB314-CDF0-4ED4-B056-C19256A25390}",false)
_da:invoke("{8CDB267C-DC11-4E51-BEB5-EB2A7A4790CE}",false)
_da:invoke("{66E6687B-A074-43EF-B3A3-695E375D4A41}",true)dab=true
d_b:replicatePlayerAnimationSequence("bowAnimations","stretching_bow_stance",nil,{attackSpeed=1,numArrows=c_c,firingSeed=math.random(1,2048)})wait(0.8)
if not dab then return elseif not adb(1)then
_da:invoke("{B30EB314-CDF0-4ED4-B056-C19256A25390}",true)
_da:invoke("{8CDB267C-DC11-4E51-BEB5-EB2A7A4790CE}",true)
_da:invoke("{66E6687B-A074-43EF-B3A3-695E375D4A41}",false)dab=false;return end
local d_c=_da:invoke("{0659F187-209D-48FD-AE95-040A0C31DB94}")
d_c.bowChargeTime=a_b.getConfigurationValue("maxBowChargeTime")
d_b:replicatePlayerAnimationSequence("bowAnimations","firing_bow_stance",nil,d_c)wait(0.9)
_da:invoke("{B30EB314-CDF0-4ED4-B056-C19256A25390}",true)
_da:invoke("{8CDB267C-DC11-4E51-BEB5-EB2A7A4790CE}",true)
_da:invoke("{66E6687B-A074-43EF-B3A3-695E375D4A41}",false)dab=false end;local __c
function _ca:attack(b_c)
if not cbb or not cbb.bowAnimations then print"no bow anim"
return elseif acb then print"is sprint"return elseif not bbb then print"no bowtool anim"return elseif not abb then
print("no weapon")return elseif
not _cb.Character or not _cb.Character.PrimaryPart or
_cb.Character.PrimaryPart.state.Value=="dead"then print"is dead"return elseif dab then
print"already charging"return end;if b_c.UserInputState~=Enum.UserInputState.Begin then
print"not begin"return end
if
ada.doesEntityHaveStatusEffect(_cb.Character.PrimaryPart,"ranger stance")then self:attackRangerStance()return end
local c_c=_da:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","nonSerializeData").statistics_final;local d_c=ada.calculateNumArrowsFromDex(c_c.dex)
local _ac,aac=adb(d_c)
if not _ac then
_da:fire("{97822377-6CF7-4275-B2B8-3E4E2E50F11C}",{text="You don't have any arrows!",id="noarrows"},3)return false end
_da:invoke("{B30EB314-CDF0-4ED4-B056-C19256A25390}",false)
_da:invoke("{8CDB267C-DC11-4E51-BEB5-EB2A7A4790CE}",false)
_da:invoke("{66E6687B-A074-43EF-B3A3-695E375D4A41}",true)dab=true;local bac=0.33;local cac=(c_c.attackSpeed/2)+bac
local dac=1 +cac
d_b:replicatePlayerAnimationSequence("bowAnimations","stretching_bow",nil,{attackSpeed=c_c.attackSpeed,numArrows=aac,firingSeed=math.random(1,2048)})_db=tick()while b_c.UserInputState~=Enum.UserInputState.End do
aca.Stepped:wait()end;self:fireArrow()end;function _ca:release()end
function _ca:fireArrow()
local b_c=_da:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","nonSerializeData").statistics_final;local c_c=ada.calculateNumArrowsFromDex(b_c.dex)
if not dab then return elseif not
adb(c_c)then
_da:invoke("{B30EB314-CDF0-4ED4-B056-C19256A25390}",true)
_da:invoke("{8CDB267C-DC11-4E51-BEB5-EB2A7A4790CE}",true)
_da:invoke("{66E6687B-A074-43EF-B3A3-695E375D4A41}",false)dab=false;return end;dab=false;local d_c=1 +b_c.attackSpeed
local _ac=_da:invoke("{0659F187-209D-48FD-AE95-040A0C31DB94}")_ac.bowChargeTime=tick()-_db;_db=nil
_da:invoke("{B30EB314-CDF0-4ED4-B056-C19256A25390}",true)
_da:invoke("{8CDB267C-DC11-4E51-BEB5-EB2A7A4790CE}",true)
_da:invoke("{66E6687B-A074-43EF-B3A3-695E375D4A41}",false)if
_ac.bowChargeTime<=a_b.getConfigurationValue("minBowChargeTime")then _ac.canceled=true end
local aac=_da:invoke("{861EE202-C233-489B-8CF8-DF5C9F4248C1}",_cb,"primaryArrow")
if not _ac.canceled and aac then
local bac=b_b.getDamagableTargets(_cb)
local cac,dac,_bc,abc,bbc=bda.raycastFromCurrentScreenPoint({_ab,bab,cab})
local cbc=Ray.new(aac.Position,(dac-aac.Position).unit*50)
local dbc,_cc,acc=nil,a_b.getConfigurationValue("bowSnapTargetMaxDistance"),nil
for bcc,ccc in pairs(bac)do local dcc=bcb(cbc,ccc.Position)
local _dc=cda.projection_Box(ccc.CFrame,ccc.Size,dcc)local adc=(dcc-_dc).magnitude
if adc<=_cc then _cc=adc;dbc=ccc;acc=_dc end end
if dbc then _ac["target-position"]=acc
_ac["target-velocity"]=dbc.Velocity;if _cb.Character and _cb.Character.PrimaryPart then
_ac["target-distance-away"]=(
dbc.Position-_cb.Character.PrimaryPart.Position).magnitude end end end
d_b:replicatePlayerAnimationSequence("bowAnimations","firing_bow",nil,_ac)end
function _ca:equip()
local b_c=_da:invoke("{7FE9D2B7-10FB-4012-8803-C5D8D5E8DFCA}")
if b_c then
abb=_da:invoke("{E1A443FB-62B9-4FA8-B0D1-0930199949A1}")
cbb=d_b:getAnimationsForAnimationController(b_c.entity.AnimationController)
if abb and abb:FindFirstChild("AnimationController")then
bbb=d_b:getAnimationsForAnimationController(abb.AnimationController,"bowToolAnimations_noChar").bowToolAnimations_noChar end end end;function _ca:unequip()
_da:fire("{52A4BEBC-137A-4481-BE88-37B1662CEFC9}","bow",nil)end;local function a_c()
_da:connect("{94D3C981-27E0-4907-86A8-0C1F0F5CAE6C}","Event",ccb)end;a_c()return _ca