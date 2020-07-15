
local _d=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")local ad=game:GetService("Debris")
local bd=game:GetService("RunService")
local cd=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local dd=cd.load("network")local __a=cd.load("damage")
local a_a=cd.load("placeSetup")local b_a=cd.load("tween")
local c_a=cd.load("ability_utilities")local d_a=cd.load("effects")local _aa=cd.load("projectile")
local aaa=cd.load("utilities")local baa=a_a.awaitPlaceFolder("entities")
local caa={id=40,name="Pillage Vitality",image="rbxassetid://4079576752",description="Hurl a dark bolt which steals health from its victim.",mastery="More health stolen.",maxRank=10,statistics=c_a.calculateStats{maxRank=10,static={cooldown=2},staggered={damageMultiplier={first=1,final=2,levels={2,5,8}},healing={first=50,final=100,levels={3,6,9}},projectileSpeed={first=50,final=100,levels={4,7,10}},bolts={first=1,final=3,levels={1,5,10},integer=true}},pattern={manaCost={base=10,pattern={2,3,3}}}},windupTime=0.55,securityData={playerHitMaxPerTag=4,isDamageContained=true,projectileOrigin="character"},abilityDecidesEnd=true,targetingData={targetingType="projectile",projectileSpeed=64,projectileGravity=0.0001,onStarted=function(dba,_ca)
local aca=dba.entity.AnimationController:LoadAnimation(_d.left_hand_targeting_sequence)aca:Play()local bca=dba.entity.LeftHand
return{track=aca,projectionPart=bca}end,onEnded=function(dba,_ca,aca)
aca.track:Stop()end}}local daa="warlockSimulacrumData"
local function _ba(dba)local _ca=dba:FindFirstChild(daa)if _ca then return#
_ca:GetChildren()>0 end;return false end
local function aba(dba)local _ca=c_a.getCastingPlayer(dba)if not _ca then return end
local aca=_ca:FindFirstChild(daa)if not aca then return end;local bca=aca:GetChildren()if#bca==0 then return end
local cca=bca[1]if not cca then return end;local dca=cca:FindFirstChild("modelRef")if
not dca then return end;return dca.Value end
local function bba()local dba=Instance.new("Part")dba.Anchored=true
dba.CanCollide=false;dba.TopSurface=Enum.SurfaceType.Smooth
dba.BottomSurface=Enum.SurfaceType.Smooth;return dba end;function caa._serverProcessDamageRequest(dba,_ca)
if dba=="bolt"then return _ca,"magical","projectile"end end
local function cba(dba,_ca)local aca=dba.Character;if not
aca then return end;local bca=aca.PrimaryPart;if not bca then return end
local cca=_ca["ability-statistics"]["healing"]aaa.healEntity(bca,bca,cca)end
function caa:execute_server(dba,_ca,aca)if not aca then return end;local bca=1;if _ba(dba)then bca=bca+1 end
local cca=Instance.new("RemoteEvent")cca.Name="PillageVitalityTemporarySecureRemote"
cca.OnServerEvent:Connect(function(...)
cba(...)bca=bca-1;if bca<=0 then cca:Destroy()end end)cca.Parent=game.ReplicatedStorage;ad:AddItem(cca,30)return cca end
function caa:execute(dba,_ca,aca,bca)local cca=dba.PrimaryPart;if not cca then return end
local dca=dba:FindFirstChild("entity")if not dca then return end;local _da=dca:FindFirstChild("LeftHand")if
not _da then return end;local ada=dca:FindFirstChild("UpperTorso")if not ada then
return end
local bda=_ca["target-position"]or _ca["mouse-world-position"]local cda=c_a.getCastingPlayer(_ca)local dda=aba(_ca)
local function __b()
if not aca then return end
local a_b=dd:invoke("{0659F187-209D-48FD-AE95-040A0C31DB94}",caa.id,_ca)a_b["ability-state"]="update"a_b["ability-guid"]=bca
dd:invoke("{C8F2171C-1C77-4D97-89FD-DBA03550755B}",caa.id,"update",a_b,bca)end
if _ca["ability-state"]=="begin"then
local a_b=dba.entity.AnimationController:LoadAnimation(_d["mage_cast_left_hand_top"])a_b:Play()
if dda then
local _ab=dda:FindFirstChild("animationController")if _ab then
_ab:LoadAnimation(_d["mage_cast_left_hand_top"]):Play()end
dda:SetPrimaryPartCFrame(CFrame.new(dda.PrimaryPart.Position,Vector3.new(bda.X,dda.PrimaryPart.Position.Y,bda.Z)))end;local b_b=Instance.new("Attachment")
b_b.Name="PillageVitalityEmitterAttachment"b_b.Parent=_da;local c_b=script.darkEmitter:Clone()
c_b.Parent=b_b;local d_b=script.charge:Clone()d_b.Parent=_da
d_b:Play()
delay(self.windupTime-c_b.Lifetime.Max,function()c_b.Enabled=false end)wait(self.windupTime)d_b:Stop()d_b:Destroy()__b()elseif
_ca["ability-state"]=="update"then local a_b=script.cast:Clone()
a_b.Parent=_da;a_b:Play()ad:AddItem(a_b,a_b.TimeLength)
local function b_b(c_b)local d_b;if aca then
d_b=dd:invokeServer("{7EE4FFC2-5AFD-40AB-A7C0-09FE74A020C3}",_ca,self.id)end
local _ab=script.bolt:Clone()_ab.Parent=baa
local aab=_aa.makeIgnoreList{dba,dba.clientHitboxToServerHitboxReference.Value}
local function bab(bbb,cbb,dbb)local _cb=1;local acb=16;local bcb=script.blood:Clone()local ccb=bcb.trail
bcb.CFrame=bbb.CFrame;bcb.Parent=baa
local dcb=CFrame.Angles(0,0,dbb)*CFrame.new(0,acb,0)
local _db=CFrame.Angles(0,0,-dbb)*CFrame.new(0,acb,0)
d_a.onHeartbeatFor(_cb,function(adb,bdb,cdb)
local ddb=CFrame.new(bbb.Position,cbb.Position)local __c=CFrame.new(cbb.Position,bbb.Position)
local a_c=ddb.Position;local b_c=(ddb*dcb).Position;local c_c=(__c*_db).Position
local d_c=__c.Position;local _ac=a_c+ (b_c-a_c)*cdb
local aac=c_c+ (d_c-c_c)*cdb;local bac=_ac+ (aac-_ac)*cdb
bcb.CFrame=CFrame.new(bac)end)
delay(_cb,function()bcb.Transparency=1;ccb.Enabled=false
ad:AddItem(bcb,ccb.Lifetime)end)end
local function cab(bbb)
for blood=1,3 do local cbb=(blood-2)* (math.pi/3)bab(bbb,ada,cbb)end
delay(1,function()local cbb=script.restore:Clone()cbb.Parent=cca
cbb:Play()ad:AddItem(cbb,cbb.TimeLength)local dbb=1;local _cb=bba()
_cb.Shape=Enum.PartType.Ball;_cb.Color=script.blood.Color
_cb.Material=Enum.Material.Neon;_cb.Size=Vector3.new()
_cb.CFrame=CFrame.new(ada.Position)_cb.Parent=baa
b_a(_cb,{"Size","Transparency"},{Vector3.new(8,8,8),1},dbb)
d_a.onHeartbeatFor(dbb,function()_cb.CFrame=CFrame.new(ada.Position)end)ad:AddItem(_cb,dbb)
if aca then d_b:FireServer(_ca)end end)end
local dab=_ca["ability-statistics"]["projectileSpeed"]local _bb=_ca["mouse-target-position"]local abb=(_bb-c_b).Unit
_aa.createProjectile(c_b,abb,dab,_ab,function(bbb)
_ab.Transparency=1;_ab.emitterAttachment.emitter.Enabled=false
ad:AddItem(_ab,_ab.emitterAttachment.emitter.Lifetime.Max)local cbb,dbb=__a.canPlayerDamageTarget(cda,bbb)
if cbb then
local _cb=script.hit:Clone()_cb.Parent=dbb;_cb:Play()
ad:AddItem(_cb,_cb.TimeLength)cab(dbb)if aca then
dd:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",dbb,_ab.Position,"ability",self.id,"bolt",bca)end end end,function(bbb)return CFrame.Angles(0,math.pi,
math.pi*2 *bbb)end,aab,true,0)end;b_b(_da.Position)
if dda and dda.Parent then
local c_b=dda:FindFirstChild("LeftHand")if c_b then b_b(c_b.Position)end end
if aca then
if
_ca["times-updated"]<_ca["ability-statistics"]["bolts"]then __b()else
dd:fire("{51252262-788E-447C-A950-A8E92643DAEA}",false)
dd:invoke("{C8F2171C-1C77-4D97-89FD-DBA03550755B}",caa.id,"end")end end end end;return caa