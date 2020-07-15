
local dc=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local _d=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local ad=_d.load("projectile")local bd=_d.load("placeSetup")
local cd=_d.load("client_utilities")local dd=_d.load("network")local __a=_d.load("tween")
local a_a=_d.load("damage")local b_a=_d.load("detection")
local c_a=_d.load("ability_utilities")local d_a=_d.load("utilities")
local _aa=bd.awaitPlaceFolder("entityManifestCollection")local aaa=bd.getPlaceFolder("entities")
local baa=game:GetService("HttpService")
local caa={cost=4,upgradeCost=2,maxRank=8,layoutOrder=3,requirement=function(bba)return bba.class=="Warrior"end}
local daa={id=5,metadata=caa,name="Ground Slam",image="rbxassetid://3736598447",description="Leap forward and slam your blade down!",damageType="physical",layoutOrder=3,windupTime=0.5,maxRank=10,cooldown=7,cost=10,speedMulti=1.5,statistics={[1]={damageMultiplier=3.2,radius=15,cooldown=12,manaCost=20},[2]={damageMultiplier=3.4,manaCost=21},[3]={damageMultiplier=3.6,manaCost=22},[4]={damageMultiplier=3.8,manaCost=23},[5]={damageMultiplier=4.1,manaCost=25,radius=17,tier=3},[6]={damageMultiplier=4.4,manaCost=27},[7]={damageMultiplier=4.7,manaCost=29},[8]={damageMultiplier=5.1,manaCost=32,radius=19,tier=4}},securityData={playerHitMaxPerTag=3,isDamageContained=true},damage=30,maxRange=30,equipmentTypeNeeded="sword"}
function daa._serverProcessDamageRequest(bba,cba)
if bba=="shockwave"then return cba,"physical","aoe"elseif
bba=="shockwave-outer"then return cba/2,"physical","aoe"elseif bba=="slash"then return cba,"physical","direct"elseif
bba=="aftershock"then return cba/2,"physical","aoe"end end;local function _ba()end
function daa._abilityExecutionDataCallback(bba,cba)
cba["bounceback"]=bba and
bba.nonSerializeData.statistics_final.activePerks["bounceback"]
cba["aftershock"]=bba and
bba.nonSerializeData.statistics_final.activePerks["aftershock"]end
local function aba(bba)return bba["bounceback"]and 15000 or 1000 end
function daa:execute_server(bba,cba,dba,_ca,aca,bca)if not dba then return end;if cba["bounceback"]then
d_a.playSound("bounce",aca)end
c_a.knockbackMonster(aca,_ca,bca,0.2)end
function daa:doKnockback(bba,cba,dba,_ca)
if cba:FindFirstChild("entityType")and
cba.entityType.Value=="monster"then
dd:fireServer("{7170F8E2-9C53-42D1-A10A-E8383DB284E0}",bba,self.id,dba,cba,_ca)end;local aca=game.Players.LocalPlayer;local bca=aca.Character
if not bca then return end;local cca=bca.PrimaryPart;if not cca then return end;if cba==cca then
c_a.knockbackLocalPlayer(dba,_ca)end end
function daa:execute(bba,cba,dba,_ca)
if not bba:FindFirstChild("entity")then return end
local aca=dd:invoke("{CA61CBF0-3B04-4617-8D2D-50C80D51AB19}",bba.entity)local bca=aca["1"]and aca["1"].manifest
if not bca then return end
local cca=bba.entity.AnimationController:LoadAnimation(dc.warrior_forwardDownslash)local dca
if bca then local d_b=script.cast:Clone()d_b.Parent=bca;if not dba then d_b.Volume=
d_b.Volume*0.7 end;d_b:Play()
game.Debris:AddItem(d_b,5)local _ab=bca:FindFirstChild("bottomAttachment")
local aab=bca:FindFirstChild("topAttachment")
if _ab and aab then dca=script.Trail:Clone()
dca.Name="groundSlamTrail"dca.Parent=bca;dca.Attachment0=_ab;dca.Attachment1=aab;dca.Enabled=true end end;local _da;_da=cca.Stopped:connect(function()end)
local ada=game.Players.LocalPlayer.Character
if dba and ada then while cca.Length==0 do wait(0)end end;cca:Play(0.1,1,self.speedMulti or 1)wait(
cca.Length*0.06 /cca.Speed)
if dba then
local d_b=dd:invoke("{952A8B11-BC62-42C8-9898-0A3A6E1B00C4}")local _ab;if d_b.magnitude>0 then _ab=d_b.unit else
_ab=ada.PrimaryPart.CFrame.lookVector*0.05 end
dd:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",true)local aab=ada.PrimaryPart.hitboxGyro
local bab=ada.PrimaryPart.hitboxVelocity;aab.CFrame=CFrame.new(Vector3.new(),_ab)_ab=_ab+
Vector3.new(0,1,0)
dd:invoke("{C43ACD39-75B4-40F2-B91B-74FAD166EE59}",_ab*23 *cca.Speed)end;wait(cca.Length*0.36 /cca.Speed)if not
bba:FindFirstChild("entity")then return end
dd:invoke("{C43ACD39-75B4-40F2-B91B-74FAD166EE59}",Vector3.new())local bda=30;local cda=tick()local dda=cca.TimePosition;local __b,a_b,b_b
local c_b=game:GetService("RunService")cca:AdjustSpeed(0)if dba then
dd:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",false)end
repeat
local d_b=Ray.new(bca.Position+ (
bba.PrimaryPart.CFrame.lookVector*3)+Vector3.new(0,2.5,0),Vector3.new(0,
-10,0))
__b,a_b,b_b=workspace:FindPartOnRayWithIgnoreList(d_b,{bba,bca})wait()until __b or tick()-cda>=bda;if dca then dca:Destroy()end;if dba then
dd:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",true)end
cca:AdjustSpeed(self.speedMulti)
spawn(function()if not __b then return false end
if cba["aftershock"]then local dbb=8;local _cb=dbb^2;local acb=0.5
local function bcb(dcb)
local _db=Instance.new("Part")_db.Anchored=true;_db.CanCollide=false
_db.TopSurface=Enum.SurfaceType.Smooth;_db.BottomSurface=_db.TopSurface
_db.Shape=Enum.PartType.Cylinder;_db.BrickColor=BrickColor.new("Dirt brown")
_db.CFrame=
CFrame.new(dcb)*CFrame.Angles(0,0,math.pi/2)_db.Size=Vector3.new(1,1,1)_db.Parent=aaa
__a(_db,{"Size","Transparency"},{Vector3.new(1,
dbb*2,dbb*2),1},acb)
game:GetService("Debris"):AddItem(_db,acb)
if dba then
for adb,bdb in
pairs(a_a.getDamagableTargets(game.Players.LocalPlayer))do local cdb=b_a.projection_Box(bdb.CFrame,bdb.Size,dcb)
local ddb=cdb-dcb;local __c=ddb.X^2 +ddb.Y^2 +ddb.Z^2;if __c<=_cb then
dd:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",bdb,bdb.Position,"ability",self.id,"aftershock",_ca)end end end end
local function ccb()local dcb=8
for aftershockNumber=1,dcb do
local _db=aftershockNumber/dcb*math.pi*2
local adb=cba["ability-statistics"]["radius"]*0.75;local bdb=math.cos(_db)*adb;local cdb=math.sin(_db)*adb;bcb(
a_b+Vector3.new(bdb,0,cdb))end;d_a.playSound(script.aftershock,a_b)end;delay(0.5,ccb)end
local d_b=game.ReplicatedStorage.shockwaveEntity:Clone()
local _ab=game.ReplicatedStorage.shockwaveEntity:Clone()d_b.Parent=aaa;_ab.Parent=aaa
local aab=cba["ability-statistics"].radius;local bab=script.dustPart:Clone()
bab.Parent=workspace.CurrentCamera;bab.CFrame=CFrame.new(a_b)bab.Dust.Speed=NumberRange.new(30 * (aab/10),
50 * (aab/10))
bab.Dust:Emit(100)game.Debris:AddItem(bab,6)
local cab=script.impact:Clone()if not dba then cab.Volume=cab.Volume*0.7 end
cab.Parent=bab;cab:Play()
if dba then
for dbb,_cb in
pairs(a_a.getDamagableTargets(game.Players.LocalPlayer))do local acb=b_a.projection_Box(_cb.CFrame,_cb.Size,a_b)
if

(
(acb-a_b)*Vector3.new(1,0,1)).magnitude<=aab*0.7 and( (acb-a_b)*Vector3.new(0,1,0)).magnitude<=
(aab/2)*0.7 then
dd:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",_cb,a_b,"ability",self.id,"shockwave",_ca)self:doKnockback(cba,_cb,a_b,aba(cba))elseif
( (acb-a_b)*
Vector3.new(1,0,1)).magnitude<=aab and( (acb-a_b)*
Vector3.new(0,1,0)).magnitude<= (aab/2)then
dd:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",_cb,a_b,"ability",self.id,"shockwave-outer",_ca)self:doKnockback(cba,_cb,a_b,aba(cba))end end end;local dab=tick()local _bb=CFrame.new(a_b,a_b+b_b)*
CFrame.Angles(math.pi/2,0,0)local abb=Vector3.new(aab*1.7,-1.1,
aab*1.7)
local bbb=Vector3.new(0.25,1.5,0.25)local cbb=0.8;d_b.Size=bbb;_ab.Size=bbb;d_b.CFrame=_bb;_ab.CFrame=_bb
d_b.Transparency=0;_ab.Transparency=0
__a(d_b,{"Size","Transparency"},{bbb+abb,1},1,Enum.EasingStyle.Quad)
__a(_ab,{"Size","Transparency"},{bbb+abb,1},1,Enum.EasingStyle.Quint)game.Debris:AddItem(d_b,1)
game.Debris:AddItem(_ab,1)end)cca:AdjustSpeed(self.speedMulti*1.65)wait(
cca.Length*0.4 /cca.Speed)if dba then
dd:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",false)end;return true end;return daa