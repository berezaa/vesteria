
local dc=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local _d=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local ad=_d.load("projectile")local bd=_d.load("placeSetup")
local cd=_d.load("client_utilities")local dd=_d.load("network")local __a=_d.load("damage")
local a_a=_d.load("detection")local b_a=_d.load("ability_utilities")
local c_a=_d.load("utilities")local d_a=bd.getPlaceFolder("entities")
local _aa=game:GetService("HttpService")local aaa=game:GetService("RunService")
local baa={cost=2,upgradeCost=2,maxRank=8,layoutOrder=3,requirement=function(bba)
return bba.class=="Warrior"end}
local caa={id=17,metadata=baa,name="Parry",image="rbxassetid://3736685722",description="Prepare a powerful counterattack!",mastery="Longer parry uptime.",damageType="physical",prerequisite={{id=26,rank=1}},layoutOrder=1,windupTime=0.1,maxRank=5,cooldown=3,cost=10,statistics={[1]={damageMultiplier=3.4,cooldown=10,manaCost=15,duration=1.5},[2]={damageMultiplier=3.6,manaCost=16},[3]={damageMultiplier=3.8,manaCost=17},[4]={damageMultiplier=4.0,manaCost=18},[5]={damageMultiplier=4.3,cooldown=8,manaCost=20,tier=3},[6]={damageMultiplier=4.6,manaCost=22},[7]={damageMultiplier=4.9,manaCost=24},[8]={damageMultiplier=5.3,cooldown=6,manaCost=23,tier=4}},securityData={playerHitMaxPerTag=1,isDamageContained=true},damage=30,maxRange=30,projectileSpeed=150,equipmentTypeNeeded="sword"}
function caa._serverProcessDamageRequest(bba,cba)
if bba=="ranged-hit"then return cba*1.25,"physical","projectile"elseif bba==
"melee-hit"then return cba,"physical","direct"end end
local function daa(bba)
for cba,dba in pairs(bba:GetDescendants())do
if

dba:IsA("BasePart")and dba.Transparency<1 and dba.Name~="!! PARRY_REDUCTION_AURA !!"then local _ca=dba:Clone()
for bca,cca in pairs(_ca:GetDescendants())do if not
cca:IsA("DataModelMesh")then cca:Destroy()end end;_ca.RootPriority=-127;_ca.Transparency=0.75
_ca.BrickColor=BrickColor.new("Royal purple")_ca.Material=Enum.Material.Glass
_ca.Name="!! PARRY_REDUCTION_AURA !!"_ca.Anchored=false;_ca.CanCollide=false;_ca.Size=_ca.Size+
Vector3.new(0.2,0.2,0.2)
local aca=Instance.new("Motor6D")aca.Part0=_ca;aca.Part1=dba;aca.Parent=_ca;_ca.Parent=dba end end end;local function _ba(bba)
for cba,dba in pairs(bba:GetDescendants())do if dba.Name=="!! PARRY_REDUCTION_AURA !!"then
dba:Destroy()end end end;function caa._abilityExecutionDataCallback(bba,cba)
cba["bounceback"]=
bba and
bba.nonSerializeData.statistics_final.activePerks["bounceback"]end;local function aba(bba)
return(
bba["bounceback"]and 15000 or 1000)*3 end
function caa:execute_server(bba,cba,dba,_ca,aca,bca)if not dba then return end;if
cba["bounceback"]then c_a.playSound("bounce",aca)end
b_a.knockbackMonster(aca,_ca,bca,0.2)end
function caa:doKnockback(bba,cba,dba,_ca)
if cba:FindFirstChild("entityType")and
cba.entityType.Value=="monster"then
dd:fireServer("{7170F8E2-9C53-42D1-A10A-E8383DB284E0}",bba,self.id,dba,cba,_ca)end;local aca=game.Players.LocalPlayer;local bca=aca.Character
if not bca then return end;local cca=bca.PrimaryPart;if not cca then return end;if cba==cca then
b_a.knockbackLocalPlayer(dba,_ca)end end
function caa:execute(bba,cba,dba,_ca)
if not bba:FindFirstChild("entity")then return end
local aca=dd:invoke("{CA61CBF0-3B04-4617-8D2D-50C80D51AB19}",bba.entity)local bca=aca["1"]and aca["1"].manifest
if not bca then return end
local cca=bba.entity.AnimationController:LoadAnimation(dc.warrior_parryStart)
local dca=bba.entity.AnimationController:LoadAnimation(dc.warrior_parryHold)
local _da=bba.entity.AnimationController:LoadAnimation(dc.warrior_parryMelee)
local ada=bba.entity.AnimationController:LoadAnimation(dc.warrior_parryRanged)local bda;do
bda=cca.Stopped:connect(function()
if bda then bda:disconnect()bda=nil;dca:Play()end end)end;cca:Play()
local cda=script.cast:Clone()cda.Parent=bca;cda:Play()
if not dba then cda.Volume=cda.Volume*0.7 end;game.Debris:AddItem(cda,5)daa(bba)if dba then
dd:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",true)end;local dda,__b;local a_b
local function b_b(d_b,_ab,aab,bab)if not __b then return end;if
_ab~=self.id then return end
if cba["cast-player-userId"]~=d_b.userId then return end;__b:disconnect()__b=nil
if bda then bda:disconnect()bda=nil end;dca:Stop()cca:Stop()_ba(bba)
if aab.category=="projectile"and
bca:IsDescendantOf(bba)then while ada.Length==0 do wait(0)end
ada:Play()wait(ada.Length*0.9)
if bca:IsDescendantOf(bba)then
local cab=script.projectileParry:Clone()cab.Parent=bd.getPlaceFolder("entities")
local dab=bca.CFrame*Vector3.new(0,-
bca.Size.Y*0.45,0)
local _bb,abb=ad.getUnitVelocityToImpact_predictive(dab,self.projectileSpeed,bab.Position,bab.Velocity,nil)local bbb=script.deflect:Clone()bbb.Parent=bca
bbb:Play()if not dba then bbb.Volume=bbb.Volume*0.7 end
game.Debris:AddItem(bbb,5)
ad.createProjectile(dab,_bb,self.projectileSpeed,cab,function(cbb,dbb)
game:GetService("Debris"):AddItem(cab,2 /30)
if dba then
if cbb then
local _cb,acb=__a.canPlayerDamageTarget(game.Players.LocalPlayer,cbb)
if _cb and acb then
dd:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",acb,dbb,"ability",self.id,"ranged-hit",_ca)self:doKnockback(cba,acb,dbb,aba(cba))end end end end)end elseif aab.category=="direct"then while _da.Length==0 do wait(0)end
_da:Play()local cab={}local dab=script.counter:Clone()dab.Parent=bca
dab:Play()if not dba then dab.Volume=dab.Volume*0.7 end
game.Debris:AddItem(dab,5)local _bb;local abb=bca:FindFirstChild("bottomAttachment")
local bbb=bca:FindFirstChild("topAttachment")
if abb and bbb then _bb=script.Trail:Clone()
_bb.Name="groundSlamTrail"_bb.Parent=bca;_bb.Attachment0=abb;_bb.Attachment1=bbb;_bb.Enabled=true end
while _da.IsPlaying do
if dba then
for cbb,dbb in
pairs(__a.getDamagableTargets(game.Players.LocalPlayer))do
if not cab[dbb]then local _cb=bca.CFrame
local acb=a_a.projection_Box(dbb.CFrame,dbb.Size,_cb.p)
if
a_a.boxcast_singleTarget(_cb,bca.Size*Vector3.new(5,1.5,5),acb)then cab[dbb]=true
dd:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",dbb,acb,"ability",self.id,"melee-hit",_ca)self:doKnockback(cba,dbb,acb,aba(cba))end end end end;wait(1 /20)end;_bb:Destroy()end;if dba then
dd:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",false)end;a_b=true end
dda,__b=dd:connect("{03A1736D-FB27-4236-AD23-82B12E8C9785}","OnClientEvent",b_b)local c_b=tick()repeat wait()until a_b or
tick()-c_b>cba["ability-statistics"].duration
if __b then
__b:disconnect()__b=nil;if bda then bda:disconnect()bda=nil end;dca:Stop()
cca:Stop()_ba(bba)if dba then
dd:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",false)end end end;return caa