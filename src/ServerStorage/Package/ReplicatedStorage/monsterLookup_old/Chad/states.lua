local _b=game:GetService("ReplicatedStorage")
local ab=require(_b.modules)local bb=ab.load("pathfinding")local cb=ab.load("utilities")
local db=ab.load("detection")local _c=ab.load("network")local ac=ab.load("tween")local bc=1
local cc=Random.new()
return
{processDamageRequest=function(dc,_d)
if dc=="slam"then return math.ceil(_d*10),"physical","direct"elseif dc=="wheel"then return math.ceil(
_d*.3),"physical","direct"end;return _d,"physical","direct"end,getClosestEntities=function(dc)
local _d=cb.getEntities()
for i=#_d,1,-1 do local ad=_d[i]if
(
ad.Name=="Elder Shroom"or ad.Name=="Shroom"or ad.Name=="Baby Shroom"or ad.Name=="Chad")or ad==dc.manifest then
table.remove(_d,i)end end;return _d end,default="idling",states={["setup"]={animationEquivalent="idling",transitionLevel=0,step=function(dc)
if
dc.moveGoal then dc.__directRoamGoal=dc.moveGoal
dc.__directRoamOrigin=dc.manifest.Position;dc.__blockConfidence=0;dc.__LAST_ROAM_TIME=tick()return"direct-roam"end end},["sleeping"]={animationEquivalent="idling",timeBetweenUpdates=5,transitionLevel=1,step=function(dc,_d)if
dc.closestEntity then return"idling"end end},["idling"]={lockTimeForLowerTransition=3,transitionLevel=2,step=function(dc,_d)if
dc.manifest:FindFirstChild("locator")then
dc.manifest:FindFirstChild("locator"):Destroy()end
dc.manifest.BodyVelocity.Velocity=Vector3.new()if dc.spinning==nil then dc.spinning=false end
if dc.moveGoal then
dc.__directRoamGoal=dc.moveGoal;dc.__directRoamOrigin=dc.manifest.Position;dc.__blockConfidence=0
dc.__LAST_ROAM_TIME=tick()return"direct-roam"end;if dc.targetEntity then return"following"end
if dc.closestEntity then
local ad=cb.magnitude(
dc.closestEntity.Position-dc.manifest.Position)local bd=dc.aggressionLockRange or dc.aggressionRange
if
ad<=bd and dc:isTargetEntityInLineOfSight(bd,true)then dc.__providedDirectRoamTheta=
nil;dc:setTargetEntity(dc.closestEntity)return
"following"else
if _d or dc.__providedDirectRoamTheta then
if(dc.__LAST_ROAM_TIME and
tick()-dc.__LAST_ROAM_TIME<5)and
(dc.__providedDirectRoamTheta==nil)then return"idling"end;local cd=Vector3.new(1,0,1)local dd=cc:NextInteger(1,360)
if
dc.__providedDirectRoamTheta then dd=dc.__providedDirectRoamTheta;dc.__providedDirectRoamTheta=nil end;local __a=math.rad(dd)local a_a=dc.manifest.Position*cd
local b_a=a_a+

Vector3.new(math.cos(__a),0,math.sin(__a))*cc:NextInteger(30,dc.maxRoamDistance or 50)local c_a=b_a-a_a;local d_a=dc.manifest.Position+
Vector3.new(0,dc.manifest.Size.Y,0)local _aa=c_a-
Vector3.new(0,dc.manifest.Size.Y,0)local aaa=Ray.new(d_a,_aa)
local baa,caa=workspace:FindPartOnRayWithIgnoreList(aaa,{dc.manifest,workspace.placeFolders:FindFirstChild("entityRenderCollection"),workspace.placeFolders:FindFirstChild("foilage")})
local daa=(dc.manifest.Size.X+dc.manifest.Size.Z)/2;local _ba=(caa-dc.manifest.Position).magnitude
local aba=true;local bba=(caa-c_a*daa/2)*cd
local cba=(dc.origin and dc.origin.p or
dc.manifest.Position)*cd;local dba=(bba-cba).magnitude;local _ca=(a_a-cba).magnitude
if _ca<dba then
if
dba>=200 then if cc:NextNumber()<1 then aba=false end elseif dba>=150 then if cc:NextNumber()<
0.8 then aba=false end elseif dba>=100 then if cc:NextNumber()<0.6 then
aba=false end elseif dba>=75 then
if cc:NextNumber()<0.4 then aba=false end elseif dba>=50 then if cc:NextNumber()<0.3 then aba=false end elseif dba>=25 then if
cc:NextNumber()<0.2 then aba=false end end end
if _ba>=daa and aba then dc.__directRoamGoal=bba;dc.__directRoamOrigin=a_a
dc.__directRoamTheta=dd;dc.__blockConfidence=0;dc.__LAST_ROAM_TIME=tick()return"direct-roam"end;dc.__LAST_ROAM_TIME=tick()-4.5;return end end else return"sleeping"end end},["attack-ready"]={animationEquivalent="idling",transitionLevel=5,step=function(dc,_d)if
dc.targetEntity==nil then return"idling"end
local ad=dc.manifest.Position;local bd=dc.targetEntity;local cd=bd.Position;local dd=cd
if
dc.manifest.BodyVelocity.MaxForce.Y<=0.1 then dd=Vector3.new(cd.X,ad.Y,cd.Z)end
if dc.targetingYOffsetMulti then dd=dd+
Vector3.new(0,dc.manifest.Size.Y*dc.targetingYOffsetMulti,0)end
local __a=db.projection_Box(dc.manifest.CFrame,dc.manifest.Size,cd)
local a_a=db.projection_Box(dc.targetEntity.CFrame,dc.targetEntity.Size,dc.manifest.Position)local b_a=cb.magnitude(__a-a_a)
if b_a<=dc.attackRange then
local c_a=dc.manifest.Position
if tick()-dc.__LAST_ATTACK_TIME>=dc.attackSpeed then
dc.__LAST_ATTACK_TIME=tick()local d_a=math.random()if d_a<.2 then return"spin-begin"elseif d_a<.7 then return"attacking"else
return"attacking-wheel"end else
dc.manifest.BodyVelocity.Velocity=Vector3.new()end else return"following"end end},["attacking"]={transitionLevel=6,animationPriority=Enum.AnimationPriority.Action,doNotLoopAnimation=true,doNotStopAnimation=true,execute=function(dc,_d,ad,bd)
if

not game:GetService("RunService"):IsClient()then
warn("attacking::execute can only be called on client")return elseif not ad.damageHitboxCollection then end;local cd=false;local dd=dc.Character.PrimaryPart
local __a=bd.clientHitboxToServerHitboxReference.Value
if bd:FindFirstChild("entity")and
bd.entity.PrimaryPart:FindFirstChild("attacking")then local _aa=1
if bd:FindFirstChild("entity")and
bd.entity.PrimaryPart:FindFirstChild("attacking2")then _aa=math.random(2)if _aa==2 then
bd.entity.PrimaryPart.attacking2:Play()end end;if _aa==1 then
bd.entity.PrimaryPart.attacking:Play()end end
local a_a=_d.Length* (ad.animationDamageStart or 0.3)wait(a_a)
local b_a=_d.Length* (ad.animationDamageEnd or 0.7)local c_a=b_a-a_a;local d_a=c_a/10
for i=0,c_a,d_a do
if _d.IsPlaying and not cd and
bd:FindFirstChild("entity")then
for _aa,aaa in pairs(ad.damageHitboxCollection)do
if
bd.entity:FindFirstChild(aaa.partName)and not cd then
if aaa.castType=="sphere"then
local baa=(
bd.entity[aaa.partName].CFrame*aaa.originOffset).p;local caa=db.projection_Box(dd.CFrame,dd.Size,baa)
if
db.spherecast_singleTarget(baa,aaa.radius,caa)then cd=true
_c:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",__a,caa,"monster")
local daa=( (dd.Position-__a.Position)*Vector3.new(1,0,1)).unit
_c:fire("{7EEEF31B-024D-429C-8220-4A6094CFA5B8}",(daa*100 +Vector3.new(0,-10,0)))end elseif aaa.castType=="box"then
local baa=bd.entity[aaa.partName].CFrame*aaa.originOffset;local caa=db.projection_Box(dd.CFrame,dd.Size,baa.p)
if
db.boxcast_singleTarget(baa,
bd.entity[aaa.partName].Size* (aaa.hitboxSizeMultiplier or Vector3.new(1,1,1)),caa)then cd=true
local daa=( (dd.Position-__a.Position)*Vector3.new(1,0,1)).unit
_c:fire("{7EEEF31B-024D-429C-8220-4A6094CFA5B8}",(daa*100 +Vector3.new(0,-10,0)))
_c:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",__a,caa,"monster")end end end end;wait(d_a)else break end end end,step=function(dc,_d)if
dc.targetEntity==nil then return"idling"end
local ad=dc.manifest.Position;local bd=dc.targetEntity;local cd=bd.Position;local dd=cd
if
dc.manifest.BodyVelocity.MaxForce.Y<=0.1 then dd=Vector3.new(cd.X,ad.Y,cd.Z)end
if dc.targetingYOffsetMulti then dd=dd+
Vector3.new(0,dc.manifest.Size.Y*dc.targetingYOffsetMulti,0)end;dd=dd+bd.Velocity*0.1;local __a=cb.magnitude(ad-dd)
local a_a=(dd-ad).unit;local b_a=dd-a_a* (dc.attackRange)
dc.manifest.BodyGyro.CFrame=CFrame.new(ad,dd)
if cb.magnitude(bd.Velocity)>3 then local d_a=(dd-ad).unit;local _aa=dd-
d_a* (dc.attackRange)dc.manifest.BodyVelocity.Velocity=d_a*
(dc.baseSpeed*0.7)else
dc.manifest.BodyVelocity.Velocity=Vector3.new()end
local c_a=game.Players:GetPlayerFromCharacter(dc.targetEntity.Parent)
if not c_a then
delay(0.25,function()
_c:invoke("{031BE66E-62B6-4583-B409-DCB61C0DA077}",nil,dc.targetEntity,{damage=dc.damage,sourceType="monster",sourceId=nil,damageCategory="direct",damageType="physical"})end)end;return"micro-sleeping"end},["attacking-wheel"]={transitionLevel=6,animationPriority=Enum.AnimationPriority.Action,doNotLoopAnimation=true,doNotStopAnimation=true,execute=function(dc,_d,ad,bd)
if

not game:GetService("RunService"):IsClient()then
warn("attacking::execute can only be called on client")return elseif not ad.damageHitboxCollection then end;local cd=false;local dd=dc.Character.PrimaryPart
local __a=bd.clientHitboxToServerHitboxReference.Value;if bd:FindFirstChild("entity")and
bd.entity.PrimaryPart:FindFirstChild("attacking-wheel")then
bd.entity.PrimaryPart["attacking-wheel"]:Play()end
local a_a=0;wait(a_a)local b_a=1.7;local c_a=b_a-a_a;local d_a=c_a/10
for i=0,c_a,d_a do cd=false
if
_d.IsPlaying and not cd and bd:FindFirstChild("entity")then
for _aa,aaa in
pairs(ad.damageHitboxCollection2)do
if bd.entity:FindFirstChild(aaa.partName)and not cd then
if
aaa.castType=="sphere"then
local baa=(bd.entity[aaa.partName].CFrame*aaa.originOffset).p;local caa=db.projection_Box(dd.CFrame,dd.Size,baa)if
db.spherecast_singleTarget(baa,aaa.radius,caa)then cd=true
_c:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",__a,caa,"monster","wheel")end elseif
aaa.castType=="box"then
local baa=bd.entity[aaa.partName].CFrame*aaa.originOffset;local caa=db.projection_Box(dd.CFrame,dd.Size,baa.p)
if
db.boxcast_singleTarget(baa,
bd.entity[aaa.partName].Size* (aaa.hitboxSizeMultiplier or Vector3.new(1,1,1)),caa)then cd=true
_c:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",__a,caa,"monster","wheel")
local daa=( (dd.Position-__a.Position)*Vector3.new(1,0,1)).unit
_c:fire("{7EEEF31B-024D-429C-8220-4A6094CFA5B8}",(daa*20 +Vector3.new(0,5,0)))end end end end;wait(d_a)else break end end end,step=function(dc,_d)if
dc.targetEntity==nil then return"idling"end
local ad=dc.manifest.Position;local bd=dc.targetEntity;local cd=bd.Position;local dd=cd
if
dc.manifest.BodyVelocity.MaxForce.Y<=0.1 then dd=Vector3.new(cd.X,ad.Y,cd.Z)end
if dc.targetingYOffsetMulti then dd=dd+
Vector3.new(0,dc.manifest.Size.Y*dc.targetingYOffsetMulti,0)end;dd=dd+bd.Velocity*0.1;local __a=cb.magnitude(ad-dd)
local a_a=(dd-ad).unit;local b_a=dd-a_a* (dc.attackRange)
dc.manifest.BodyGyro.CFrame=CFrame.new(ad,dd)
if cb.magnitude(bd.Velocity)>3 then local d_a=(dd-ad).unit;local _aa=dd-
d_a* (dc.attackRange)dc.manifest.BodyVelocity.Velocity=d_a*
(dc.baseSpeed*0.7)else
dc.manifest.BodyVelocity.Velocity=Vector3.new()end
local c_a=game.Players:GetPlayerFromCharacter(dc.targetEntity.Parent)
if not c_a then
delay(0.25,function()
_c:invoke("{031BE66E-62B6-4583-B409-DCB61C0DA077}",nil,dc.targetEntity,{damage=dc.damage,sourceType="monster",sourceId=nil,damageCategory="direct",damageType="physical"})end)end;return"micro-sleeping"end},["spin-begin"]={transitionLevel=7,doNotLoopAnimation=true,doNotStopAnimation=true,animationPriority=Enum.AnimationPriority.Action,lockTimeForLowerTransition=3.2,step=function(dc,_d)
if

dc.manifest:FindFirstChild("locator")==nil and tick()<dc.__LAST_ATTACK_TIME+1.5 then
local ad=script:FindFirstChild("locator"):Clone()
ad.Position=dc.manifest.Position+Vector3.new(0,8,0)ad.Parent=dc.manifest end;dc.slamTime=tick()return"spin-end"end,execute=function(dc,_d,ad,bd)
if

not game:GetService("RunService"):IsClient()then
warn("attacking::execute can only be called on client")return elseif not ad.damageHitboxCollection then end;local cd=false;local dd=dc.Character.PrimaryPart
local __a=bd.clientHitboxToServerHitboxReference.Value;if bd:FindFirstChild("entity")and
bd.entity.PrimaryPart:FindFirstChild("spin-begin")then
bd.entity.PrimaryPart["spin-begin"]:Play()end end},["spin-end"]={transitionLevel=6,doNotLoopAnimation=true,doNotStopAnimation=true,animationPriority=Enum.AnimationPriority.Action,lockTimeForLowerTransition=2.5,execute=function(dc,_d,ad,bd)
if

not game:GetService("RunService"):IsClient()then
warn("attacking::execute can only be called on client")return elseif not ad.damageHitboxCollection then end;local cd=false;local dd=dc.Character.PrimaryPart
local __a=bd.clientHitboxToServerHitboxReference.Value;if bd:FindFirstChild("entity")and
bd.entity.PrimaryPart:FindFirstChild("spin-end")then
bd.entity.PrimaryPart["spin-end"]:Play()end;local a_a=1.1
wait(a_a)local b_a=script.slampart:Clone()local c_a=1
if
bd.clientHitboxToServerHitboxReference.Value:FindFirstChild("monsterScale")then
c_a=bd.clientHitboxToServerHitboxReference.Value:FindFirstChild("monsterScale").Value;if c_a>=2 then c_a=c_a*1.2 elseif c_a>2 then c_a=c_a*1.7 end else end;b_a.Position=bd.entity["LowerTorso"].Position+
(Vector3.new(0,-3,0)*c_a)b_a.Size=Vector3.new(
.5 *c_a,20 *c_a,20 *c_a)if
_d.IsPlaying and not cd and bd:FindFirstChild("entity")then
b_a.Parent=workspace;b_a.impact:Emit(100 *c_a)
game.Debris:AddItem(b_a,2)end
local d_a=Instance.new("Part")d_a.Anchored=true;d_a.CanCollide=false;d_a.Position=b_a.Position
d_a.Material=Enum.Material.Neon;d_a.Color=Color3.fromRGB(255,255,255)
d_a.Size=Vector3.new(1,1,1)d_a.Shape="Ball"d_a.Parent=workspace
game.Debris:AddItem(d_a,2)
ac(d_a,{"Transparency","Size"},{1,Vector3.new(30,30,30)},.4)local _aa=1.4;local aaa=_aa-a_a;local baa=aaa/10
for i=0,aaa,baa do
if _d.IsPlaying and not cd and
bd:FindFirstChild("entity")then
if dc.Character then local caa=dc.Character.PrimaryPart
local daa=CFrame.new(bd.entity["LowerTorso"].Position)local _ba=db.projection_Box(caa.CFrame,caa.Size,daa.p)
if
db.boxcast_singleTarget(daa,Vector3.new(20,5,20),_ba)then cd=true
_c:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",__a,_ba,"monster","slam")
local aba=( (caa.Position-__a.Position)*Vector3.new(1,0,1)).unit
_c:fire("{7EEEF31B-024D-429C-8220-4A6094CFA5B8}",(aba*300 +Vector3.new(0,240,0)))end end;wait(baa)else break end end end,step=function(dc,_d)
if
dc.manifest:FindFirstChild("locator")and tick()<dc.slamTime+2.2 then
dc.manifest:FindFirstChild("locator").Position=
dc.manifest:FindFirstChild("locator").Position-Vector3.new(0,8,0)end;return"idling"end}},processDamageRequestToMonster=function(dc,_d)
if
dc.state=="spin-begin"or dc.state=="spin-end"then _d.damage=math.floor(
_d.damage*0.1)_d.supressed=true end;return _d end}