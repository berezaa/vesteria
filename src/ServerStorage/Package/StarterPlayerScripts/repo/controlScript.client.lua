local b__a={}local c__a=game.Players.LocalPlayer
local d__a=game:GetService("StarterPlayer")local _a_a=50;local aa_a=0.5;local ba_a=aa_a
local ca_a=math.floor(d__a.CameraMaxZoomDistance*1.25)
local da_a=script.Parent.Parent:WaitForChild("assets")local _b_a;local ab_a;local bb_a=16;local cb_a={}
local function db_a(c__b,d__b)cb_a=d__b;bb_a=cb_a.walkspeed or 14 end;local _c_a=game:GetService("UserInputService")
local ac_a=require(game.ReplicatedStorage:WaitForChild("modules"))local bc_a=ac_a.load("placeSetup")
local cc_a=ac_a.load("network")local dc_a=ac_a.load("client_utilities")
local _d_a=ac_a.load("tween")local ad_a=ac_a.load("utilities")
local bd_a=ac_a.load("terrainUtil")local cd_a=ac_a.load("damage")
local dd_a=ac_a.load("configuration")local __aa
cc_a:create("{20F87B18-E1C4-453E-9CE1-1F4E6F225EC2}","BindableEvent","Event",function(c__b)__aa=c__b end)
local a_aa=bc_a.awaitPlaceFolder("entityRenderCollection")
local b_aa=bc_a.awaitPlaceFolder("entityManifestCollection")local c_aa={bc_a.getPlaceFoldersFolder()}
local d_aa=game:GetService("UserInputService")local _aaa=workspace.Camera;local aaaa;local baaa=true;local caaa=true;local daaa=false;local _baa=1
local abaa=false;local bbaa=false
local cbaa=require(game.Players.LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("repo"):WaitForChild("animationInterface"))
local dbaa=c__a:WaitForChild("PlayerGui"):WaitForChild("gameUI")
local _caa=require(game.ReplicatedStorage.itemData)
local function acaa(c__b)
if c__b.Parent:FindFirstChild("clientHitboxToServerHitboxReference")then return
c__b.Parent.clientHitboxToServerHitboxReference.Value end end
local function bcaa(c__b)abaa=c__b
spawn(function()
if c__b then
for i=1,0.5,-1 /30 do if not abaa then break end;_baa=i;wait()end;_baa=0.5 else for i=0.5,1,1 /30 do if abaa then break end;_baa=i;wait()end
_baa=1 end end)end;local ccaa=game:GetService("TweenService")
local dcaa=TweenInfo.new(1 /3,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0)local _daa=Instance.new("NumberValue")_daa.Name="sprintFOV"
_daa.Parent=script;local adaa=0;local bdaa=0.3;local cdaa;local ddaa=false;local __ba=false;local a_ba=false;local b_ba=false;local c_ba=false
local d_ba=false;local _aba=false;local aaba={}aaba.isSprinting=false;aaba.isInAir=false
aaba.isMoving=false;aaba.isJumping=false;aaba.isSitting=false;aaba.isExhausted=false
aaba.isDoubleJumping=false;aaba.isFalling=false;aaba.isRotating=false;aaba.isFishing=false
aaba.isGettingUp=false;aaba.isSwimming=false
local function baba(c__b,d__b,_a_b)local aa_b=c__a.Character;if not aa_b then return false end
local ba_b=aa_b.PrimaryPart;if not ba_b then return false end
local ca_b=ba_b:FindFirstChild("statusEffectsV2")if not ca_b then return false end
local da_b,_b_b=ad_a.safeJSONDecode(ca_b.Value)if not da_b then return false end
for ab_b,bb_b in pairs(_b_b)do if bb_b.statusEffectType==c__b then
if(
d__b==nil or bb_b.sourceId==d__b)and
(_a_b==nil or bb_b.variant==_a_b)then return true end end end;return false end
cc_a:create("{DEE6248B-5F6A-406E-AC36-86EA853CC31E}","BindableFunction","OnInvoke",baba)local function caba()return baba("stunned")end
cc_a:create("{BF956380-404B-41BA-8742-E8FD573AD12E}","BindableFunction","OnInvoke",caba)local function daba()
cc_a:invoke("{F9682973-5852-429E-9BAC-8EBECA22DD97}","isSprinting",true)end;local function _bba()
cc_a:invoke("{F9682973-5852-429E-9BAC-8EBECA22DD97}","isSprinting",false)end
local function abba(c__b)if not _aba then if caaa and c__b then daba()else
_bba()end else _bba()end end;local bbba=2 *math.pi;local function cbba(c__b,d__b)return
(math.atan2(d__b,c__b)-math.pi/2)%bbba end;local dbba;local _cba
cc_a:create("{2E5C6D9D-C401-4231-8CF6-BBBF30455217}","BindableEvent","Event",function(c__b)
_cba=c__b end)
local function acba()local c__b
if __ba and
( ( (c_ba and b_ba)and not a_ba)or not(a_ba or c_ba or b_ba))then c__b=0 elseif
__ba and c_ba and not(a_ba or b_ba)then c__b=math.pi/4 elseif
c_ba and( ( (__ba and a_ba)and not b_ba)or not
(__ba or a_ba or b_ba))then c__b=math.pi/2 elseif a_ba and c_ba and not(__ba or b_ba)then c__b=
3 *math.pi/4 elseif a_ba and( ( (c_ba and b_ba)and not __ba)or
not(__ba or b_ba or c_ba))then
c__b=math.pi elseif a_ba and b_ba and not(c_ba or __ba)then
c__b=5 *math.pi/4 elseif b_ba and
( ( (__ba and a_ba)and not c_ba)or not(c_ba or __ba or a_ba))then c__b=3 *math.pi/2 elseif b_ba and __ba and not(
c_ba or a_ba)then c__b=7 *math.pi/4 end
if _cba then
if _cba.magnitude>0.1 then dbba=_cba else dbba=nil;return nil end;return cbba(_cba.X,-_cba.Y)end;if c__b then dbba=nil;return c__b end
local d__b=_c_a:GetGamepadState(Enum.UserInputType.Gamepad1)
if d__b then
for _a_b,aa_b in pairs(d__b)do
if aa_b.KeyCode==Enum.KeyCode.Thumbstick1 then
if

aa_b.Position.magnitude>0.2 and not game.GuiService.SelectedObject then dbba=aa_b.Position else if aaba.isSprinting then abba(false)end;dbba=nil
return nil end;return cbba(aa_b.Position.X,aa_b.Position.Y)end end end;dbba=nil;return c__b end;local function bcba(c__b)
return
c__b.X>=0 and c__b.X<=dbaa.AbsoluteSize.X and
c__b.Y>=0 and c__b.Y<=dbaa.AbsoluteSize.Y and c__b.Z>0 end
local ccba={}local dcba=1;local _dba;local adba
local function bdba()
local c__b=c__a.Character and c__a.Character.PrimaryPart;if not c__b then return end
if tick()-adaa>=bdaa then adaa=tick()local d__b={}
local _a_b,aa_b=dc_a.raycastFromCurrentScreenPoint({a_aa})
if _a_b then local _b_b,ab_b
do local bb_b,cb_b=cd_a.canPlayerDamageTarget(c__a,_a_b)
if
bb_b and cb_b then
if cb_b.entityId.Value=="character"then
_b_b=game.Players:GetPlayerFromCharacter(cb_b.Parent)elseif cb_b.entityId.Value=="monster"then ab_b=cb_b end end end
if ab_b and not ab_b:FindFirstChild("pet")and not
ab_b:FindFirstChild("isStealthed")then local bb_b=(ab_b.Position-
c__b.Position).magnitude;if bb_b<=_a_a then
_dba=ab_b;adba=bb_b;return _dba,adba end end end;local ba_b,ca_b=nil,_a_a
local da_b=cd_a.getDamagableTargets(game.Players.LocalPlayer)
for _b_b,ab_b in pairs(da_b)do
local bb_b=ab_b:FindFirstChild("isStealthed")~=nil
if not bb_b then
local cb_b=ad_a.magnitude(ab_b.Position-c__b.Position)
if ca_b>cb_b then
local db_b,_c_b=_aaa:WorldToScreenPoint(ab_b.Position)if
db_b.Z>0 and bcba(db_b)and ab_b.health.Value>0 then ba_b=ab_b;ca_b=cb_b end end end end;_dba=ba_b;adba=ca_b end;return _dba,adba end
local function cdba(c__b)if#ccba>1 then
if c__b then if dcba==1 then dcba=#ccba else dcba=dcba-1 end else dcba=( (dcba+1)%
#ccba)+1 end else dcba=1 end;_dba=
ccba[dcba]and ccba[dcba].manifest;adba=ccba[dcba]and
ccba[dcba].distanceAway end;local ddba
local function __ca(c__b)aaba.isSprinting=false;aaba.isInAir=false;aaba.isMoving=false
aaba.isJumping=false;aaba.isSitting=false;aaba.isExhausted=false;aaba.isDoubleJumping=false
aaba.isFishing=false;aaba.isRotating=false;aaba.isFalling=false;aaba.isGettingUp=false
aaba.isSwimming=false;bcaa(false)
aaaa=cc_a:invoke("{7FE9D2B7-10FB-4012-8803-C5D8D5E8DFCA}")
if
c__b.PrimaryPart==nil and c__b:FindFirstChild("hitbox")then c__b.PrimaryPart=c__b.hitbox end;local d__b=tick()repeat wait()until c__b.PrimaryPart or c__b.Parent==nil or
tick()-d__b>=10;if not
c__b.PrimaryPart then return false end
cc_a:fireServer("{AE5C9ED5-A3D2-4192-BF39-21F2FD69D483}",c__b.PrimaryPart.state.Value)end;local a_ca=0;local b_ca=false
local function c_ca(c__b)if b_ca then return end
cc_a:fire("{CB527931-903D-443E-9010-9C92D87E9BE2}","sprint")b_ca=true;_d_a(_daa,{"Value"},15,0.5)
if
not aaba.isInAir and aaaa and aaaa:FindFirstChild("entity")then
aaaa.entity.RightFoot.ParticleEmitter.Enabled=true
aaaa.entity.LeftFoot.ParticleEmitter.Enabled=true end;a_ca=tick()end
local function d_ca()b_ca=false;_d_a(_daa,{"Value"},0,0.5)
if aaaa and
aaaa:FindFirstChild("entity")then
aaaa.entity.RightFoot.ParticleEmitter.Enabled=false
aaaa.entity.LeftFoot.ParticleEmitter.Enabled=false end end;local _aca;local aaca=game:GetService("RunService")local baca=nil
local function caca(c__b,d__b)local _a_b=c__a.Character and
c__a.Character.PrimaryPart
if _a_b then
local aa_b=workspace.CurrentCamera:ScreenPointToRay(c__b,d__b)
local ba_b=Ray.new(aa_b.Origin,aa_b.Direction.unit*ca_a)
local ca_b,da_b=workspace:FindPartOnRayWithIgnoreList(ba_b,c_aa)return ca_b,da_b, (
ca_b and ad_a.magnitude(ca_b.Position-_a_b.Position)or nil)end end;local daca=""local _bca=false;local abca=false
local bbca={["dance"]=true,["dance2"]=true,["dance3"]=true,["oh yea"]=true,["hype"]=true,["sit"]=true,["wave"]=true,["point"]=true,["beg"]=true,["flex"]=true,["handstand"]=true,["tadaa"]=true,["jumps"]=true,["guitar"]=true,["panic"]=true,["cheer"]=true,["pushups"]=true}
cc_a:create("{A0FA1B07-2089-41D8-91EA-E16F3B6288DF}","BindableFunction","OnInvoke",function(c__b)
if







aaba.isSprinting or aaba.isInAir or aaba.isMoving or aaba.isJumping or aaba.isSitting or aaba.isExhausted or aaba.isDoubleJumping or aaba.isFalling or aaba.isFishing or aaba.isGettingUp or aaba.isSwimming then return false end
local d__b=cc_a:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","globalData").emotes;local _a_b=false;c__b=string.lower(c__b)for aa_b,ba_b in pairs(d__b)do
if c__b==ba_b then _a_b=true end end;if bbca[c__b]then _a_b=true end
if
_a_b and not abca then
if daca~=c__b then daca=c__b;_bca=true
spawn(function()abca=true;wait(1)abca=false end)
c__a.Character.PrimaryPart.state.Value="idling"
cc_a:fireServer("{AE5C9ED5-A3D2-4192-BF39-21F2FD69D483}","idling")
cbaa:replicatePlayerAnimationSequence("emoteAnimations",c__b,nil,{dance=true})return true end else if abca then return false,"Emote on cooldown."end
return false,"Cannot perform invalid emote."end end)
cc_a:create("{F7F863BC-0B9B-4E07-87C5-278779D08E23}","BindableEvent","Event",function()if _bca then daca=""_bca=false end end)
local function cbca(c__b,d__b,...)
if

aaba[c__b]~=nil and aaba[c__b]~=d__b and c__a.Character and c__a.Character.PrimaryPart and
c__a.Character.PrimaryPart.state.Value~="dead"then _bca=false;daca=""
if c__b=="isSprinting"and not
cc_a:invoke("{CB505807-178C-4E8F-AE40-B0B823BF476E}")and not
aaba.isExhausted then
if aaba.isMoving then
if not
aaba[c__b]and d__b then c_ca()elseif aaba[c__b]and not d__b then d_ca()end else if aaba[c__b]and not d__b then d_ca()end end elseif
c__b=="isSprinting"and(cc_a:invoke("{CB505807-178C-4E8F-AE40-B0B823BF476E}")or
aaba.isExhausted)then return elseif c__b=="isMoving"and not aaba.isExhausted then
if
aaba.isSprinting and not b_ca then c_ca(true)elseif not aaba.isSprinting and b_ca then d_ca(true)end elseif c__b=="isGettingUp"then
if aaba.isSprinting then aaba.isSprinting=false;d_ca(true)end end;aaba[c__b]=d__b
if c__a.Character and c__a.Character.PrimaryPart then
if not
aaba.isGettingUp then
if not aaba.isSwimming then
if not aaba.isFishing then
if not aaba.isSitting then
if
not aaba.isFalling then
if not aaba.isJumping then
if aaba.isMoving or aaba.isRotating then
if
aaba.isSprinting and not _aba then if
c__a.Character.PrimaryPart.state.Value~="sprinting"then
cc_a:fireServer("{AE5C9ED5-A3D2-4192-BF39-21F2FD69D483}","sprinting")end
c__a.Character.PrimaryPart.state.Value="sprinting"else
if aaba.isExhausted then
c__a.Character.PrimaryPart.state.Value="walking_exhausted"
cc_a:fireServer("{AE5C9ED5-A3D2-4192-BF39-21F2FD69D483}","walking_exhausted")else if
c__a.Character.PrimaryPart.state.Value~="walking"then
cc_a:fireServer("{AE5C9ED5-A3D2-4192-BF39-21F2FD69D483}","walking")end
c__a.Character.PrimaryPart.state.Value="walking"end end else
if aaba.isExhausted then
c__a.Character.PrimaryPart.state.Value="idling_exhausted"
cc_a:fireServer("{AE5C9ED5-A3D2-4192-BF39-21F2FD69D483}","idling_exhausted")else
c__a.Character.PrimaryPart.state.Value="idling"
cc_a:fireServer("{AE5C9ED5-A3D2-4192-BF39-21F2FD69D483}","idling","kicking")end end else
if not aaba.isDoubleJumping then
c__a.Character.PrimaryPart.state.Value="jumping"
cc_a:fireServer("{AE5C9ED5-A3D2-4192-BF39-21F2FD69D483}","jumping")else
c__a.Character.PrimaryPart.state.Value="double_jumping"
cc_a:fireServer("{AE5C9ED5-A3D2-4192-BF39-21F2FD69D483}","double_jumping")end end else
c__a.Character.PrimaryPart.state.Value="falling"
cc_a:fireServer("{AE5C9ED5-A3D2-4192-BF39-21F2FD69D483}","falling")end else
c__a.Character.PrimaryPart.state.Value="sitting"
cc_a:fireServer("{AE5C9ED5-A3D2-4192-BF39-21F2FD69D483}","sitting",nil,...)end else
c__a.Character.PrimaryPart.state.Value="fishing"
cc_a:fireServer("{AE5C9ED5-A3D2-4192-BF39-21F2FD69D483}","fishing")end else
c__a.Character.PrimaryPart.state.Value="swimming"
cc_a:fireServer("{AE5C9ED5-A3D2-4192-BF39-21F2FD69D483}","swimming")end else
c__a.Character.PrimaryPart.state.Value="gettingUp"
cc_a:fireServer("{AE5C9ED5-A3D2-4192-BF39-21F2FD69D483}","gettingUp",nil,...)end end
cc_a:fire("{94D3C981-27E0-4907-86A8-0C1F0F5CAE6C}",c__b,d__b,...)return true end end;local dbca=math.rad(20)
local function _cca(c__b,d__b,_a_b)local aa_b=c__b:Dot(d__b)
local ba_b=math.acos(aa_b)return ba_b<=dbca,aa_b<0,ba_b,
math.sign(c__b:Cross(d__b):Dot(Vector3.new(0,1,0)))end;local acca=da_a.wind
local bcca=

game.ReplicatedStorage:FindFirstChild("windVolume")and game.ReplicatedStorage.windVolume.Value or 0.02;acca.Volume=bcca;acca:Play()local ccca=500;local dcca=ccca
local _dca=Vector3.new()local adca=Vector3.new()local bdca
local function cdca(c__b,d__b)
if c__b then _aba=true;adca=Vector3.new()if
aaba.isSprinting then d_ca(true)end;cbca("isMoving",false)
cbca("isSprinting",false)cbca("isSitting",false)cbca("isRotating",false)
if d__b then
bdca=d__b;_dca=Vector3.new()
c__a.Character:SetPrimaryPartCFrame(d__b)
local _a_b=c__a.Character and c__a.Character.PrimaryPart
if _a_b then local aa_b=_a_b.grounder;local ba_b=_a_b.hitboxVelocity;local ca_b=_a_b.hitboxGyro
aa_b.MaxForce=Vector3.new(1e5,1e5,1e5)ba_b.MaxForce=Vector3.new(0,0,0)ca_b.CFrame=bdca
aa_b.Position=bdca.Position end end else _aba=false;bdca=nil;local _a_b=Enum.KeyCode.LeftShift
local aa_b=d_aa:IsKeyDown(_a_b)if aa_b then abba(true)end end end
cc_a:create("{CB433F4F-FA88-41E0-A9CF-A589687842AF}","BindableFunction","OnInvoke",function()return _aba end)
cc_a:create("{27791132-7095-4A6F-B12B-2480E95768A2}","BindableFunction","OnInvoke",cdca)local ddca=0
local __da=cc_a:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","nonSerializeData").statistics_final
cc_a:connect("{9928EED8-32C2-49B0-8C6A-30D599B6414B}","OnClientEvent",function(c__b,d__b)__da=d__b end)local a_da;local b_da={}
do local c__b=20;function b_da:applyJoltVelocity(_b_b)if a_da then _b_b=_b_b*0.5 end
_dca=_dca+_b_b end;local function d__b(_b_b)
b_da:applyJoltVelocity(_b_b)end
cc_a:create("{7EEEF31B-024D-429C-8220-4A6094CFA5B8}","BindableEvent","Event",d__b)
cc_a:connect("{6A99938B-6371-4BBA-9DF6-AC72C78A47D6}","OnClientEvent",d__b)local _a_b;local aa_b=Instance.new("BlurEffect")aa_b.Size=4
aa_b.Enabled=false;aa_b.Parent=game.Lighting
local ba_b=Instance.new("ColorCorrectionEffect")ba_b.Saturation=0.35;ba_b.Contrast=0.05;ba_b.Enabled=false
ba_b.Parent=game.Lighting;local ca_b=Instance.new("BloomEffect")ca_b.Enabled=false
ca_b.Parent=game.Lighting;local da_b=game.SoundService.AmbientReverb
function b_da:stepCurrentVelocity(_b_b)local ab_b=c__a.Character and
c__a.Character.PrimaryPart;local bb_b=false
local cb_b=ab_b.Velocity;local db_b=baba("heat exhausted")
if aaba.isSprinting and
ab_b.Velocity.Magnitude>0.2 then
ab_b.stamina.Value=math.max(ab_b.stamina.Value-_b_b,0)elseif not aaba.isExhausted and not aaba.isJumping and
not aaba.isDoubleJumping then local dc_b=__da.staminaRecovery
if
(tick()-ddca)>1 / (dc_b)then local _d_b=dc_b;if db_b then _d_b=_d_b-1 end
ab_b.stamina.Value=math.min(
ab_b.stamina.Value+ (ab_b.maxStamina.Value*_b_b/3 *_d_b),ab_b.maxStamina.Value)end end;if db_b then
ab_b.stamina.Value=math.max(ab_b.stamina.Value-_b_b/16,0)end
if ab_b.health.Value<=0 or
ab_b.state.Value=="dead"then if aaba.isExhausted then
cbca("isExhausted",false)end elseif
ab_b.stamina.Value<=0 and not aaba.isExhausted then cbca("isSprinting",false)cbca("isExhausted",true)
spawn(function()
wait(2)ab_b.stamina.Value=0;cbca("isExhausted",false)end)
cc_a:fireServer("{955F2AFD-1B68-4304-841F-472796A574E0}")end;local _c_b=70 +_daa.Value+
math.clamp(ad_a.magnitude(cb_b)/5 -10,0,40)
local ac_b=workspace.CurrentCamera.FieldOfView
if _c_b~=ac_b then local dc_b=_c_b-ac_b
local _d_b=math.abs(dc_b)*_b_b*3 +0.1
if _c_b>ac_b then
if _c_b>ac_b+_d_b then ac_b=ac_b+_d_b else ac_b=_c_b end else if _c_b<ac_b-_d_b then ac_b=ac_b-_d_b else ac_b=_c_b end end
if
not workspace.CurrentCamera:FindFirstChild("overridden")then workspace.CurrentCamera.FieldOfView=ac_b end end
local bc_b=game.Players.LocalPlayer.Character and
game.Players.LocalPlayer.Character.PrimaryPart
if bc_b then
if(not a_da)and bd_a.isPointUnderwater(bc_b.Position)then _dca=
_dca/5;a_da=true
local dc_b=game.ReplicatedStorage.sounds:FindFirstChild("water_in")
if dc_b then local ad_b=Instance.new("Sound")for bd_b,cd_b in
pairs(game.HttpService:JSONDecode(dc_b.Value))do ad_b[bd_b]=cd_b end
ad_b.Parent=game.Players.LocalPlayer.Character.PrimaryPart;ad_b.PlaybackSpeed=math.random(105,120)/100
ad_b:Play()game.Debris:AddItem(ad_b,5)end
local _d_b=game.ReplicatedStorage:FindFirstChild("fishingBob")
if _d_b then _d_b=_d_b:Clone()_d_b.Transparency=1;_d_b.CanCollide=false;_d_b.CFrame=
CFrame.new()+bc_b.Position
_d_b.splash.Color=ColorSequence.new(workspace.Terrain.WaterColor)_d_b.splash:Emit(20)
_d_b.Parent=workspace.CurrentCamera;game.Debris:AddItem(_d_b,5)end
cc_a:fireServer("{A7BDA262-3811-4DBB-9B06-CFEB16E25D3B}",bc_b.Position)elseif a_da and not
bd_a.isPointUnderwater(bc_b.Position-Vector3.new(0,0.5,0))then
a_da=false
if aaba.isSwimming then cbca("isSwimming",false)
cbca("isJumping",false)cbca("isDoubleJumping",false)perform_forceJump()end
local dc_b=game.ReplicatedStorage.sounds:FindFirstChild("water_out")
if dc_b then local _d_b=Instance.new("Sound")for ad_b,bd_b in
pairs(game.HttpService:JSONDecode(dc_b.Value))do _d_b[ad_b]=bd_b end
_d_b.Parent=game.Players.LocalPlayer.Character.PrimaryPart;_d_b.PlaybackSpeed=math.random(105,120)/100
_d_b:Play()game.Debris:AddItem(_d_b,5)end end end
if
bd_a.isPointUnderwater(workspace.CurrentCamera.CFrame.Position)then
if not _a_b then _a_b=true;game.SoundService.AmbientReverb="UnderWater"
aa_b.Enabled=true;ba_b.Enabled=true;ca_b.Enabled=true end elseif _a_b and
not bd_a.isPointUnderwater(workspace.CurrentCamera.CFrame.Position+
Vector3.new(0,0.25,0))then _a_b=false
game.SoundService.AmbientReverb=da_b;aa_b.Enabled=false;ba_b.Enabled=false;ca_b.Enabled=false end
if not aaba.isSwimming and
(ad_a.magnitude(_dca)>0 or aaba.isInAir)then local dc_b=_dca+adca;local _d_b=ab_b.Velocity
local ad_b=math.abs(
dc_b.X-_d_b.X)*_b_b*3
local bd_b=math.abs(dc_b.Z-_d_b.Z)*_b_b*3;local cd_b=Vector3.new(_dca.X,0,_dca.Z)local dd_b=Vector3.new(0,
workspace.Gravity*_b_b,0)
if a_da then dd_b=dd_b/5 end
if aaba.isInAir then
local __ab=math.clamp((_d_b.magnitude-100)/500,bcca,2)local a_ab=math.abs(__ab-acca.Volume)
if acca.Volume<__ab then acca.Volume=
acca.Volume+math.clamp(a_ab,0.01,0.1)else acca.Volume=
acca.Volume-math.clamp(a_ab,0.01,0.1)end;local b_ab=
c__b*_b_b* (math.abs(_dca.X)/ad_a.magnitude(cd_b))+ad_b
local c_ab=c__b*_b_b* (
math.abs(_dca.Z)/ad_a.magnitude(cd_b))+bd_b
if math.abs(_dca.X)>b_ab then
_dca=Vector3.new(_dca.X-
b_ab*math.sign(_dca.X),_dca.Y,_dca.Z)else _dca=Vector3.new(0,_dca.Y,_dca.Z)end
if math.abs(_dca.Z)>c_ab then
_dca=Vector3.new(_dca.X,_dca.Y,_dca.Z-c_ab*
math.sign(_dca.Z))else _dca=Vector3.new(_dca.X,_dca.Y,0)end;_dca=_dca-dd_b else
if acca.Volume>bcca then acca.Volume=acca.Volume-0.02 end;local __ab=
dcca*_b_b* (math.abs(_dca.X)/ad_a.magnitude(cd_b))+ad_b
local a_ab=dcca*_b_b* (
math.abs(_dca.Z)/ad_a.magnitude(cd_b))+bd_b
if __ab>0 then
if math.abs(_dca.X)>__ab then
_dca=Vector3.new(_dca.X-
__ab*math.sign(_dca.X),_dca.Y,_dca.Z)bb_b=true else _dca=Vector3.new(0,_dca.Y,_dca.Z)end end
if a_ab>0 then
if math.abs(_dca.Z)>a_ab then
_dca=Vector3.new(_dca.X,_dca.Y,_dca.Z-a_ab*
math.sign(_dca.Z))bb_b=true else _dca=Vector3.new(_dca.X,_dca.Y,0)end end;if _dca.Y>=dd_b.Y then _dca=_dca-dd_b else
_dca=Vector3.new(_dca.X,0,_dca.Z)end end else
if acca.Volume>bcca then acca.Volume=acca.Volume-0.02 end end
if aaaa and aaaa:FindFirstChild("entity")then
if bb_b then local dc_b=math.clamp(
ad_a.magnitude(_dca)/3,5,60)
aaaa.entity.RightFoot.smoke.Rate=dc_b;aaaa.entity.LeftFoot.smoke.Rate=dc_b end;aaaa.entity.RightFoot.smoke.Enabled=bb_b
aaaa.entity.LeftFoot.smoke.Enabled=bb_b end;local cc_b=1;if a_da then cc_b=0.7 end
if
c__a.Character and c__a.Character.PrimaryPart and
c__a.Character.PrimaryPart.state.Value=="dead"then adca=Vector3.new()end
if a_da and aaba.isSwimming then _dca=Vector3.new()return adca*cc_b+
Vector3.new(0,16,0)else return(adca+_dca)*cc_b end end end
local function c_da(c__b,d__b)
local _a_b,aa_b,ba_b,ca_b=workspace:FindPartOnRayWithIgnoreList(c__b,d__b,true)
local da_b=workspace.placeFolders:FindFirstChild("items")
while
_a_b and
not
(

_a_b.CanCollide and(not _a_b:IsDescendantOf(b_aa)or
(not
_a_b:FindFirstChild("entityType")or _a_b.entityType.Value~="pet"))and ca_b~=Enum.Material.Water and(da_b==nil or not _a_b:IsDescendantOf(da_b)))do d__b[#d__b+1]=_a_b
_a_b,aa_b,ba_b,ca_b=workspace:FindPartOnRayWithIgnoreList(c__b,d__b,true)end;return _a_b,aa_b,ba_b,ca_b end;local d_da;local _ada;local aada;local bada
local function cada()
local function c__b(d__b,_a_b)
local aa_b=c__a.Character and c__a.Character.PrimaryPart
local ba_b=aa_b and aa_b:FindFirstChild("grounder")
local ca_b=aa_b and aa_b:FindFirstChild("hitboxVelocity")
local da_b=aa_b and aa_b:FindFirstChild("hitboxGyro")if not ba_b or not ca_b or not da_b then return end;if bdca then
ba_b.MaxForce=Vector3.new(1e5,1e5,1e5)ca_b.MaxForce=Vector3.new(0,0,0)da_b.CFrame=bdca
ba_b.Position=bdca.Position;return end
local _b_b=acba()local ab_b;if baca then
d__b,ab_b=caca(baca.Position.X,baca.Position.Y)end
local bb_b={bc_a.awaitPlaceFolder("playerRenderCollection"),bc_a.awaitPlaceFolder("playerManifestCollection"),aaaa}
local cb_b=Ray.new(aa_b.Position,Vector3.new(0,-5,0))local db_b,_c_b,ac_b,bc_b=c_da(cb_b,bb_b)local cc_b=2.5
if
ad_a.magnitude(adca)>0.1 then local bd_b=adca.Unit
local cd_b=Ray.new(aa_b.Position,Vector3.new(bd_b.X,-cc_b,bd_b.Z))local dd_b,__ab=c_da(cd_b,bb_b)
if dd_b then
local a_ab=__ab.Y- (aa_b.Position.Y-cc_b)if a_ab>0 and a_ab<cc_b then cc_b=cc_b+a_ab*12 end end end
local function dc_b()ba_b.MaxForce=Vector3.new(0,1e4,0)
ca_b.MaxForce=Vector3.new(1e4,0,1e4)aaba.isInAir=false;local bd_b=0
if aaba.isJumping then cbca("isJumping",false)
cbca("isDoubleJumping",false)if aaba.isFalling then bd_b=_dca.Y end;cbca("isFalling",false)elseif
aaba.isFalling then bd_b=_dca.Y;cbca("isFalling",false)end;ba_b.Position=_c_b+Vector3.new(0,cc_b,0)end
if db_b then if game.CollectionService:HasTag(db_b,"ActivePart")then
cc_a:fire("{14A8A03B-76C4-47BC-8191-E79E7C849059}",db_b,aa_b)end
if
aaba.isSprinting and aaaa and aaaa:FindFirstChild("entity")then
aaaa.entity.RightFoot.ParticleEmitter.Enabled=true
aaaa.entity.LeftFoot.ParticleEmitter.Enabled=true;local bd_b=db_b.Color
if
db_b:IsA("Terrain")and(bc_b~=Enum.Material.Air)then bd_b=db_b:GetMaterialColor(bc_b)end
aaaa.entity.LeftFoot.ParticleEmitter.Color=ColorSequence.new(bd_b)
aaaa.entity.RightFoot.ParticleEmitter.Color=ColorSequence.new(bd_b)end
if
db_b:isDescendantOf(b_aa)or db_b:isDescendantOf(a_aa)then
local bd_b=


(db_b:FindFirstChild("clientHitboxToServerHitboxReference")and db_b)or(db_b.Parent:FindFirstChild("clientHitboxToServerHitboxReference")and
db_b.Parent)or(
db_b.Parent.Parent:FindFirstChild("clientHitboxToServerHitboxReference")and db_b.Parent.Parent)or
(
db_b.Parent.Parent.Parent:FindFirstChild("clientHitboxToServerHitboxReference")and db_b.Parent.Parent.Parent)local cd_b=db_b.Parent;if bd_b then
cd_b=bd_b.clientHitboxToServerHitboxReference.Value.Parent end
if
game.Players:GetPlayerFromCharacter(cd_b)then dcca=ccca*db_b.Friction;dc_b()else dcca=0;local dd_b=
(aa_b.Position-db_b.Position).unit*10;_dca=_dca+
Vector3.new(dd_b.X,0,dd_b.Z)end else dcca=ccca*db_b.Friction end end
if not a_da or not aaba.isSwimming then
if _dca.Y>0.1 or db_b==nil or(
aa_b.Position.Y-_c_b.Y)>cc_b+1 then
ca_b.MaxForce=Vector3.new(1e4,1e4,1e4)ba_b.MaxForce=Vector3.new()aaba.isInAir=true
if _dca.Y<-30 and not
aaba.isFalling then cbca("isFalling",true)end;if
not aada and aa_b.Velocity.Y<-30 and aaba.isFalling then aada=aa_b.Position end
if
aaba.isSprinting and aaaa and aaaa:FindFirstChild("entity")then
aaaa.entity.RightFoot.ParticleEmitter.Enabled=false
aaaa.entity.LeftFoot.ParticleEmitter.Enabled=false end else dc_b()end else ca_b.MaxForce=Vector3.new(1e4,1e4,1e4)
ba_b.MaxForce=Vector3.new()end
local _d_b=ab_b and
CFrame.new(aa_b.Position,Vector3.new(ab_b.X,aa_b.Position.Y,ab_b.Z)).lookVector
_d_b=_d_b and(_d_b-Vector3.new(0,_d_b.Y,0)).unit;if __aa then
_d_b=aa_b.CFrame.lookVector*Vector3.new(1,0,1)end;local ad_b
if not _aba then
if _b_b then
local bd_b=workspace.CurrentCamera.CFrame:toWorldSpace(CFrame.Angles(0,_b_b,0)).lookVector
bd_b=(bd_b-Vector3.new(0,bd_b.Y,0)).unit;local cd_b=bb_a;if b_ca then cd_b=cd_b*2 +1 end
local dd_b=cd_b*math.clamp(_baa,0.5,1)dbba=dbba or Vector3.new(1,0,0)
adca=bd_b*dd_b*dbba.magnitude;ca_b.Velocity=b_da:stepCurrentVelocity(_a_b)
if ab_a~="bow"and
not daaa and not d_ba and _d_b then
if
not aaba.isSprinting then local __ab,a_ab,b_ab,c_ab=_cca(bd_b,_d_b,_b_b)
if __ab then
ad_b=CFrame.new(Vector3.new(),_d_b)else if not a_ab then ad_b=CFrame.Angles(0,dbca*c_ab,0)*
CFrame.new(Vector3.new(),bd_b)else
ad_b=CFrame.new(Vector3.new(),bd_b)end end else ad_b=CFrame.new(Vector3.new(),bd_b)end elseif daaa then
ad_b=CFrame.new(Vector3.new(),_aaa.CFrame.lookVector*Vector3.new(1,0,1))elseif _d_b then ad_b=CFrame.new(Vector3.new(),_d_b)else
ad_b=CFrame.new(Vector3.new(),bd_b)end;da_a.bRef.Value=ca_b;cbca("isMoving",true)else if daaa then
ad_b=CFrame.new(Vector3.new(),
_aaa.CFrame.lookVector*Vector3.new(1,0,1))elseif _d_b then
ad_b=_d_b and CFrame.new(Vector3.new(),_d_b)end
adca=Vector3.new()ca_b.Velocity=b_da:stepCurrentVelocity(_a_b)
cbca("isMoving",false)end else ca_b.Velocity=b_da:stepCurrentVelocity(_a_b)end;bdba()
if

_dba and ab_a~="bow"and not daaa and not aaba.isSprinting and not d_ba and ad_b then local bd_b=( (adba-10)/ (_a_a-10))^2;local cd_b=
2 * (1 / (_a_a-10))* (adba-10)if cd_b<0 then bd_b=0 end;bd_b=math.clamp(
1 -bd_b,0,1)
ad_b=ad_b:lerp(CFrame.new(aa_b.Position,Vector3.new(_dba.Position.X,aa_b.Position.Y,_dba.Position.Z)),bd_b)end
if

not _aba and ad_b and c__a.Character and c__a.Character.PrimaryPart and
c__a.Character.PrimaryPart.state.Value~="dead"and not _bca then if daaa then da_b.CFrame=ad_b else
da_b.CFrame=da_b.CFrame:lerp(ad_b,0.1)end
local bd_b=Vector3.new(ad_b.lookVector.X,0,ad_b.lookVector.Z).unit:Dot(Vector3.new(aa_b.CFrame.lookVector.X,0,aa_b.CFrame.lookVector.Z).unit)if math.abs(1 -bd_b)>0.05 then if not aaba.isRotating then
cbca("isRotating",true)end else
if aaba.isRotating then cbca("isRotating",false)end end end end
if c__a.Character and c__a.Character.PrimaryPart and
c__a.Character.PrimaryPart.state.Value~="dead"then if
bada then bada:disconnect()bada=nil end
bada=aaca.Stepped:connect(c__b)end end
local function dada(c__b)
local d__b=cc_a:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","abilities")
if d__b then for _a_b,aa_b in pairs(d__b)do
if aa_b.id==c__b and aa_b.rank>0 then return true end end end;return false end;local _bda=false;local abda=false
function perform_forceJump(c__b)if not c__a.Character or
not c__a.Character.PrimaryPart then return end
if caba()then return end
if aaba.isJumping then
if


c__a.Character.PrimaryPart.state.Value~="dead"and not aaba.isExhausted and dada(7)and not aaba.isDoubleJumping and aaba.isInAir then
if
_dca.Y>-60 then
c__a.Character.PrimaryPart.stamina.Value=math.max(
c__a.Character.PrimaryPart.stamina.Value-0.5,0)cbca("isDoubleJumping",true)
_dca=Vector3.new(_dca.X,80,_dca.Z)
cc_a:fire("{CB527931-903D-443E-9010-9C92D87E9BE2}","jump")ddca=tick()end end else
if
c__a.Character.PrimaryPart.state.Value~="dead"and not aaba.isExhausted then
c__a.Character.PrimaryPart.stamina.Value=math.max(
c__a.Character.PrimaryPart.stamina.Value-0.5,0)cbca("isJumping",true)
cc_a:fire("{CB527931-903D-443E-9010-9C92D87E9BE2}","jump")local d__b=__da.jump
b_da:applyJoltVelocity(Vector3.new(0,d__b,0))ddca=tick()end end
if a_da and c__b then
delay(0.25,function()
if a_da and
c__b.UserInputState==Enum.UserInputState.Begin then cbca("isSwimming",true)
cbca("isSprinting",false)caaa=false;while
a_da and c__b.UserInputState==Enum.UserInputState.Begin do wait(0.05)end
cbca("isSwimming",false)caaa=true end end)end end
local function bbda(c__b,d__b)if d__b then return false end
if c__b.KeyCode==Enum.KeyCode.W or c__b.KeyCode==
Enum.KeyCode.Up then __ba=true elseif
c__b.KeyCode==
Enum.KeyCode.S or c__b.KeyCode==Enum.KeyCode.Down then a_ba=true elseif c__b.KeyCode==Enum.KeyCode.D then b_ba=true elseif c__b.KeyCode==
Enum.KeyCode.A then c_ba=true elseif
c__b.KeyCode==Enum.KeyCode.LeftShift or
c__b.KeyCode==Enum.KeyCode.ButtonL3 and aaba.isMoving then abba(true)elseif c__b.KeyCode==Enum.KeyCode.Space or c__b.KeyCode==
Enum.KeyCode.LeftAlt or c__b.KeyCode==
Enum.KeyCode.ButtonA then if
not _aba then
if baaa and not aaba.isSwimming then perform_forceJump(c__b)end end end end
cc_a:create("{ADF79FEF-4171-45E0-AE56-ED1CDDFCAF2E}","BindableFunction","OnInvoke",function()if not _aba then if baaa then
perform_forceJump()end end end)
cc_a:create("{8223B2F8-2FC1-480A-B726-2468E4E5FE9E}","BindableFunction","OnInvoke",function(c__b)abba(c__b)end)
cc_a:create("{E7FC437C-0080-4CDD-A9D5-BC1E7A0FE7BF}","BindableEvent","Event",function(c__b)bbaa=c__b end)
local function cbda(c__b)
if
c__b.KeyCode==Enum.KeyCode.W or c__b.KeyCode==Enum.KeyCode.Up then __ba=false elseif c__b.KeyCode==Enum.KeyCode.S or
c__b.KeyCode==Enum.KeyCode.Down then a_ba=false elseif
c__b.KeyCode==Enum.KeyCode.D then b_ba=false elseif c__b.KeyCode==Enum.KeyCode.A then c_ba=false elseif c__b.KeyCode==
Enum.KeyCode.LeftShift then abba(false)elseif c__b.KeyCode==Enum.KeyCode.P then end end;local dbda=false
local function _cda(c__b)if c__b.UserInputType==Enum.UserInputType.MouseMovement then
baca=c__b end end
local function acda()if bada then bada:disconnect()bada=nil end end
local function bcda(c__b,d__b,...)
if aaba[c__b]==nil or aaba[c__b]==d__b then return end;return cbca(c__b,d__b,...)end;local function ccda(c__b)if c__b then bdba()end;return _dba end
local function dcda(c__b)d_ba=c__b end;local function _dda()return adca end
local function adda()
local c__b=
c__a.Character and c__a.Character.PrimaryPart and
c__a.Character.PrimaryPart:FindFirstChild("hitboxVelocity")if c__b then return c__b.Velocity end;return Vector3.new(0,0,0)end;local function bdda()return aaba end;local function cdda(c__b)adca=c__b end
local function ddda(c__b)baaa=c__b end;local function ___b(c__b)caaa=c__b end
local function a__b(c__b,d__b)
if c__b=="equipment"then local _a_b
do for aa_b,ba_b in pairs(d__b)do if
ba_b.position==1 then _a_b=ba_b end end end;if _a_b then ab_a=_caa[_a_b.id].equipmentType end end end
local function b__b()if c__a.Character then __ca(c__a.Character)end
cc_a:connect("{8BABF769-4B51-49E3-9501-B715DD0790C7}","Event",function()
__ca(c__a.Character)end)
cc_a:connect("{A1923ADF-D5CB-403B-8289-093517D98E38}","Event",function(d__b)daaa=d__b end)d_aa.InputBegan:connect(bbda)
d_aa.InputChanged:connect(_cda)d_aa.InputEnded:connect(cbda)
cc_a:connect("{274EE822-1EE6-45E1-A502-3F1CA795FFED}","Event",acda)
cc_a:create("{CB527931-903D-443E-9010-9C92D87E9BE2}","BindableEvent")
cc_a:create("{66E6687B-A074-43EF-B3A3-695E375D4A41}","BindableFunction","OnInvoke",bcaa)
cc_a:create("{C43ACD39-75B4-40F2-B91B-74FAD166EE59}","BindableFunction","OnInvoke",cdda)
cc_a:create("{B30EB314-CDF0-4ED4-B056-C19256A25390}","BindableFunction","OnInvoke",ddda)
cc_a:create("{8CDB267C-DC11-4E51-BEB5-EB2A7A4790CE}","BindableFunction","OnInvoke",___b)
cc_a:create("{94D3C981-27E0-4907-86A8-0C1F0F5CAE6C}","BindableEvent")
cc_a:create("{F9682973-5852-429E-9BAC-8EBECA22DD97}","BindableFunction","OnInvoke",bcda)
cc_a:create("{084553EF-B1E8-45AB-B5E5-FAE997F82465}","RemoteEvent","OnClientEvent",bcda)
cc_a:create("{037FE164-CCF7-41A0-87B1-D384E9A16236}","BindableFunction","OnInvoke",ccda)
cc_a:create("{952A8B11-BC62-42C8-9898-0A3A6E1B00C4}","BindableFunction","OnInvoke",_dda)
cc_a:create("{348D3B42-CC0E-4882-9083-A4CCFFD2EF04}","BindableFunction","OnInvoke",adda)
cc_a:create("{ACB01AD9-CBB1-46ED-8062-F2A62AF8A5A8}","BindableFunction","OnInvoke",dcda)
cc_a:create("{EAD6BA98-4037-456F-AB79-F30E6DD0D488}","BindableFunction","OnInvoke",bdda)
cc_a:connect("{9928EED8-32C2-49B0-8C6A-30D599B6414B}","OnClientEvent",db_a)
cc_a:connect("{B5BFDE4F-1C2E-4D65-ACB4-277DB309BF6D}","Event",a__b)
cc_a:connect("{E68719DC-5D55-4EF3-B970-EAACE3A872AB}","OnClientEvent",function(d__b,_a_b)local aa_b=c__a.Character
if not aa_b then return end;local ba_b=aa_b.PrimaryPart;if not ba_b then return end
local ca_b=ba_b:FindFirstChild("stamina")if not ca_b then return end
local da_b=ba_b:FindFirstChild("maxStamina")if not da_b then return end;if d__b=="max"then d__b=da_b.Value end
ca_b.Value=d__b;if _a_b then cbca("isExhausted",false)end end)
cb_a=cc_a:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","nonSerializeData").statistics_final;while
not c__a.Character or not c__a.Character.PrimaryPart do wait(0.5)end;local c__b=tick()d_aa.InputBegan:connect(function()
c__b=tick()end)
spawn(function()
while true do
if
c__a.Character and c__a.Character.PrimaryPart then
if


c__a.Character.PrimaryPart.state.Value=="idling"and(tick()-c__b)>5 and not _bca and not bbaa then local d__b={"idling_kicking"}
local _a_b=d__b[math.random(#d__b)]
cbaa:replicatePlayerAnimationSequence("emoteAnimations",_a_b)end end;wait(math.random(5,10))end end)cada()end;b__b()