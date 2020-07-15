local cb=game:GetService("ReplicatedStorage")
local db=require(cb.modules)local _c=db.load("pathfinding")local ac=db.load("utilities")
local bc=db.load("detection")local cc=db.load("network")local dc=db.load("placeSetup")
local _d=db.load("projectile")local ad=dc.getPlaceFolder("entityRenderCollection")local bd=1
local cd=Random.new()local dd=Random.new()
return
{processDamageRequest=function(__a,a_a)
if __a=="rock-throw"then return a_a,"physical","projectile"elseif __a==
"boosted-smack"then return(a_a and a_a*2)or a_a,"physical","direct"end;return a_a,"physical","direct"end,getClosestEntities=function(__a)
local a_a=ac.getEntities()
for i=#a_a,1,-1 do local b_a=a_a[i]if
(b_a.Name=="Shaman"or b_a.Name=="Goblin")or b_a==__a.manifest then
table.remove(a_a,i)end end;return a_a end,default="setup",states={["setup"]={transitionLevel=0,step=function(__a)return
"sleeping"end},["sleeping"]={timeBetweenUpdates=5,transitionLevel=1,step=function(__a,a_a)if __a.closestEntity then
return"idling"end end},["idling"]={lockTimeForLowerTransition=3,transitionLevel=2,execute=function(__a,a_a,b_a,c_a)
if
c_a:FindFirstChild("linked")==nil then local d_a=Instance.new("BoolValue")
d_a.Name="linked"d_a.Parent=c_a:FindFirstChild("entity")
local _aa=c_a.clientHitboxToServerHitboxReference.Value
_aa.DescendantAdded:connect(function(aaa)
if aaa.Name=="boosted"then
if
c_a and c_a:FindFirstChild("entity")then local baa=c_a:FindFirstChild("entity")
local caa=Instance.new("BoolValue")caa.Name="boosted"caa.Parent=baa
game.Debris:AddItem(caa,4)
baa.eye1:FindFirstChild("ParticleEmitter").Enabled=true
baa.eye2:FindFirstChild("ParticleEmitter").Enabled=true;baa.Club.Material=Enum.Material.Neon
baa.eye1.Material=Enum.Material.Neon;baa.eye2.Material=Enum.Material.Neon
baa.eye1.Color=Color3.fromRGB(0,255,255)baa.eye2.Color=Color3.fromRGB(0,255,255)
baa.Club.Color=Color3.fromRGB(0,255,255)end end end)
_aa.DescendantRemoving:connect(function(aaa)local baa=0
for caa,daa in pairs(_aa:GetChildren())do if daa.Name==
"boosted"then baa=baa+1 end end
if _aa:FindFirstChild("boosted")==nil or baa==1 then
if
c_a and c_a:FindFirstChild("entity")then
local caa=c_a:FindFirstChild("entity")
caa.eye1:FindFirstChild("ParticleEmitter").Enabled=false
caa.eye2:FindFirstChild("ParticleEmitter").Enabled=false;caa.Club.Material=Enum.Material.SmoothPlastic
caa.eye1.Material=Enum.Material.SmoothPlastic;caa.eye2.Material=Enum.Material.SmoothPlastic
caa.eye1.Color=Color3.fromRGB(0,0,0)caa.eye2.Color=Color3.fromRGB(0,0,0)
caa.Club.Color=Color3.fromRGB(108,88,75)end end end)end end,step=function(__a,a_a)
__a.manifest.BodyVelocity.Velocity=Vector3.new()
if __a.closestEntity then
local b_a=ac.magnitude(__a.closestEntity.Position-__a.manifest.Position)
if b_a<=__a.aggressionRange and
__a:isTargetEntityInLineOfSight(__a.aggressionRange,true)then
__a:setTargetEntity(__a.closestEntity)return"following"else
if a_a then
if b_a>=__a.aggressionRange*1 and b_a<=
__a.aggressionRange*1.75 and
tick()-__a.__LAST_ATTACK_TIME>=5 then
if
__a:isTargetEntityInLineOfSight(__a.aggressionRange,false,__a.closestEntity)then local ada=cd:NextInteger(1,5)
if ada==3 then __a.__LAST_ATTACK_TIME=tick()
__a.manifest.targetEntity.Value=__a.closestEntity
__a.manifest.BodyGyro.CFrame=CFrame.new(__a.manifest.Position,Vector3.new(__a.closestEntity.Position.X,__a.manifest.Position.Y,__a.closestEntity.Position.Z))return"special-attacking"else __a.__LAST_ATTACK_TIME=tick()-2.5 end end end;if
__a.__LAST_ROAM_TIME and tick()-__a.__LAST_ROAM_TIME<5 then return"idling"end
local c_a=Vector3.new(1,0,1)local d_a=dd:NextInteger(1,360)
if __a.__providedDirectRoamTheta then
d_a=__a.__providedDirectRoamTheta;__a.__providedDirectRoamTheta=nil end;local _aa=math.rad(d_a)local aaa=__a.manifest.Position*c_a
local baa=
aaa+
Vector3.new(math.cos(_aa),0,math.sin(_aa))*dd:NextInteger(30,
__a.maxRoamDistance or 50)local caa=baa-aaa;local daa=__a.manifest.Position+
Vector3.new(0,__a.manifest.Size.Y,0)local _ba=caa-
Vector3.new(0,__a.manifest.Size.Y,0)local aba=Ray.new(daa,_ba)
local bba,cba=workspace:FindPartOnRayWithIgnoreList(aba,{__a.manifest,ad,workspace.placeFolders:FindFirstChild("foilage")})
local dba=(__a.manifest.Size.X+__a.manifest.Size.Z)/2;local _ca=(cba-__a.manifest.Position).magnitude
local aca=true;local bca=(cba-caa*dba/2)*c_a
local cca=(
__a.origin and __a.origin.p or __a.manifest.Position)*c_a;local dca=(bca-cca).magnitude;local _da=(aaa-cca).magnitude
if _da<dca then
if
dca>=200 then if dd:NextNumber()<1 then aca=false end elseif dca>=150 then if dd:NextNumber()<
0.8 then aca=false end elseif dca>=100 then if dd:NextNumber()<0.6 then
aca=false end elseif dca>=75 then
if dd:NextNumber()<0.4 then aca=false end elseif dca>=50 then if dd:NextNumber()<0.3 then aca=false end elseif dca>=25 then if
dd:NextNumber()<0.2 then aca=false end end end
if _ca>=dba and aca then __a.__directRoamGoal=bca;__a.__directRoamOrigin=aaa
__a.__directRoamTheta=d_a;__a.__blockConfidence=0;__a.__LAST_ROAM_TIME=tick()return"direct-roam"end;__a.__LAST_ROAM_TIME=tick()-4 end end else return"sleeping"end end},["wait-roaming"]={animationEquivalent="idling",transitionLevel=3,step=function(__a,a_a)
if
not __a.__IS_WAITING_FOR_PATH_FINDING then if __a.isProcessingPath then return"roaming"else
__a:setTargetEntity(nil,nil)return"idling"end end;return"idling"end},["direct-roam"]={animationEquivalent="walking",transitionLevel=3,step=function(__a,a_a)
local b_a=__a.__directRoamGoal
if b_a then
local c_a=Vector3.new(b_a.X,__a.manifest.Position.Y,b_a.Z)
__a.manifest.BodyGyro.CFrame=CFrame.new(__a.manifest.Position,c_a)
if __a.manifest:FindFirstChild("boosted")then __a.manifest.BodyVelocity.Velocity=
(
c_a-__a.manifest.Position).unit*__a.baseSpeed*2 else
__a.manifest.BodyVelocity.Velocity=(
c_a-__a.manifest.Position).unit*__a.baseSpeed end;local d_a=__a.manifest.Position
if __a.closestEntity then
local baa=ac.magnitude(__a.closestEntity.Position-
__a.manifest.Position)
if baa<=__a.aggressionRange and
__a:isTargetEntityInLineOfSight(__a.aggressionRange,true)then
__a:resetPathfinding()__a:setTargetEntity(__a.closestEntity)return"following"end end
if
ac.magnitude(Vector3.new(d_a.X,0,d_a.Z)-Vector3.new(b_a.X,0,b_a.Z))<1 then
__a.manifest.BodyVelocity.Velocity=Vector3.new()return"idling"end;local _aa=__a.manifest.BodyVelocity.Velocity
local aaa=__a.manifest.Velocity
if ac.magnitude(_aa-aaa)>__a.baseSpeed/2 then __a.__blockConfidence=
__a.__blockConfidence+1;if __a.__blockConfidence>=3 then
__a.manifest.BodyVelocity.Velocity=Vector3.new()return"idling"end end;return end;return"idling"end},["roaming"]={animationEquivalent="walking",transitionLevel=3,step=function(__a,a_a)
if
__a.closestEntity then if not __a.path then return"idling"end
local b_a=ac.magnitude(__a.closestEntity.Position-
__a.manifest.Position)local c_a=__a.path[__a.currentNode]
local d_a=__a.path[__a.currentNode+1]
if c_a and d_a then
if
_c.isPastNextPathfindingNodeNode(c_a.Position,__a.manifest.Position,d_a.Position)then __a.currentNode=__a.currentNode+1
__a.__PATH_FIND_NODE_START=tick()
if b_a<=__a.aggressionRange and
__a:isTargetEntityInLineOfSight(__a.aggressionRange,true)then
__a:resetPathfinding()__a:setTargetEntity(__a.closestEntity)return"following"end else
if tick()-__a.__PATH_FIND_NODE_START<2 then
local _aa=Vector3.new(d_a.Position.X,__a.manifest.Position.Y,d_a.Position.Z)
__a.manifest.BodyGyro.CFrame=CFrame.new(__a.manifest.Position,_aa)
if __a.manifest:FindFirstChild("boosted")then __a.manifest.BodyVelocity.Velocity=
(
_aa-__a.manifest.Position).unit*__a.baseSpeed*2 else
__a.manifest.BodyVelocity.Velocity=(
_aa-__a.manifest.Position).unit*__a.baseSpeed end else
__a.manifest.BodyVelocity.Velocity=Vector3.new()__a:resetPathfinding()return"idling"end end elseif c_a and not d_a then
__a.manifest.BodyVelocity.Velocity=Vector3.new()__a:resetPathfinding()return"idling"end end end},["following"]={animationEquivalent="walking",transitionLevel=4,step=function(__a,a_a)if
not __a.targetEntity then return"idling"end
local b_a=__a.manifest.Position;local c_a=__a.targetEntity;local d_a=c_a.Position
local _aa=Vector3.new(d_a.X,b_a.Y,d_a.Z)local aaa=ac.magnitude(b_a-_aa)local baa=(_aa-b_a).unit;local caa=_aa-baa*
(__a.attackRange)
if
__a:isTargetEntityInLineOfSight(nil,true)then
if __a.manifest:FindFirstChild("boosted")then __a.manifest.BodyVelocity.Velocity=
baa*__a.baseSpeed*2 else __a.manifest.BodyVelocity.Velocity=
baa*__a.baseSpeed end
__a.manifest.BodyGyro.CFrame=CFrame.new(b_a,_aa)__a.__LAST_POSITION_SEEN=caa;if __a.manifest:FindFirstChild("boosted")then __a.__LAST_MOVE_DIRECTION=
baa*__a.baseSpeed*2 else
__a.__LAST_MOVE_DIRECTION=baa*__a.baseSpeed end else
if not
__a.__LAST_POSITION_SEEN and false then
__a:setTargetEntity(nil,nil)
__a.manifest.BodyVelocity.Velocity=Vector3.new()return"idling"elseif __a.__LAST_POSITION_SEEN then
local daa=Vector3.new(__a.__LAST_POSITION_SEEN.X,b_a.Y,__a.__LAST_POSITION_SEEN.Z)
if __a.manifest:FindFirstChild("boosted")then
__a.manifest.BodyVelocity.Velocity=(
daa-b_a).unit*__a.baseSpeed*2 else
__a.manifest.BodyVelocity.Velocity=(daa-b_a).unit*__a.baseSpeed end
if aaa<=__a.aggressionRange then if
ac.magnitude(b_a-__a.__LAST_POSITION_SEEN)<bd then __a.__LAST_POSITION_SEEN=nil
__a:setTargetEntity(nil,nil)return"idling"end else __a:setTargetEntity(
nil,nil)return"idling"end else __a:setTargetEntity(nil,nil)return"idling"end end
if ac.magnitude(_aa-b_a)<=__a.attackRange then return"attack-ready"elseif

aaa>
__a.attackRange*3 and aaa<=__a.attackRange*3.5 and tick()-__a.__LAST_ATTACK_TIME>=3 then __a.__LAST_ATTACK_TIME=tick()return"special-attacking"end end},["attack-ready"]={animationEquivalent="idling",transitionLevel=5,step=function(__a,a_a)
if
__a.targetEntity==nil or __a.targetEntity==nil then return"idling"end;local b_a=__a.manifest.Position;local c_a=__a.targetEntity;local d_a=c_a.Position
local _aa=Vector3.new(d_a.X,b_a.Y,d_a.Z)local aaa=ac.magnitude(b_a-_aa)local baa=(_aa-b_a).unit;local caa=_aa-baa*
(__a.attackRange)
if aaa<=__a.attackRange then
local daa=__a.manifest.Position
__a.manifest.BodyGyro.CFrame=CFrame.new(daa,_aa)
if tick()-__a.__LAST_ATTACK_TIME>=__a.attackSpeed then
__a.__LAST_ATTACK_TIME=tick()return"attacking"else
__a.manifest.BodyVelocity.Velocity=Vector3.new()end else
if

aaa>__a.attackRange*3 and aaa<=__a.attackRange*3.5 and tick()-__a.__LAST_ATTACK_TIME>=3 then __a.__LAST_ATTACK_TIME=tick()return"special-attacking"end;return"following"end end},["attacking"]={transitionLevel=6,animationPriority=Enum.AnimationPriority.Action,doNotLoopAnimation=true,doNotStopAnimation=true,execute=function(__a,a_a,b_a,c_a)
if

not game:GetService("RunService"):IsClient()then
warn("attacking::execute can only be called on client")return elseif not b_a.damageHitboxCollection then end;local d_a=false;local _aa=__a.Character.PrimaryPart
local aaa=c_a.clientHitboxToServerHitboxReference.Value
local baa=a_a.Length* (b_a.animationDamageStart or 0.3)wait(baa)
local caa=a_a.Length* (b_a.animationDamageEnd or 0.7)local daa=caa-baa;local _ba=daa/10
for i=0,daa,_ba do
if a_a.IsPlaying and not d_a and
c_a:FindFirstChild("entity")then
for aba,bba in pairs(b_a.damageHitboxCollection)do
if
c_a.entity:FindFirstChild(bba.partName)and not d_a then
if bba.castType=="sphere"then
local cba=(
c_a.entity[bba.partName].CFrame*bba.originOffset).p;local dba=bc.projection_Box(_aa.CFrame,_aa.Size,cba)
if
bc.spherecast_singleTarget(cba,bba.radius,dba)then d_a=true
if c_a.entity:FindFirstChild("boosted")then
cc:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",aaa,dba,"monster","boosted-smack")else
cc:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",aaa,dba,"monster")end end elseif bba.castType=="box"then
local cba=c_a.entity[bba.partName].CFrame*bba.originOffset;local dba=bc.projection_Box(_aa.CFrame,_aa.Size,cba.p)
if
bc.boxcast_singleTarget(cba,c_a.entity[bba.partName].Size,dba)then d_a=true
if c_a.entity:FindFirstChild("boosted")then
cc:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",aaa,dba,"monster","boosted-smack")else
cc:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",aaa,dba,"monster")end end end end end;wait(_ba)else break end end end,verify=function(__a)if
not __a.targetEntity then return end
delay(0.2,function()
if not __a.targetEntity then return end;local a_a=__a.manifest.CFrame
local b_a=bc.projection_Box(__a.targetEntity.CFrame,__a.targetEntity.Size,a_a.p)
if
bc.boxcast_singleTarget(a_a,__a.targetEntity.Size*Vector3.new(2,1,2),b_a)then
cc:invoke("{031BE66E-62B6-4583-B409-DCB61C0DA077}",nil,__a.targetEntity,{damage=__a.damage,sourceType="monster",sourceId=nil,damageCategory="direct",damageType="physical"})end end)end,lockTimeForPreventStateTransition=0.6,step=function(__a,a_a)
if
__a.targetEntity==nil or __a.targetEntity==nil then return"idling"end;local b_a=__a.manifest.Position;local c_a=__a.targetEntity
local d_a=__a.targetEntity;local _aa=d_a.Position;local aaa=Vector3.new(_aa.X,b_a.Y,_aa.Z)local baa=ac.magnitude(
b_a-aaa)local caa=(aaa-b_a).unit;local daa=aaa-
caa* (__a.attackRange)
local _ba=aaa+d_a.Velocity*0.2
if ac.magnitude(d_a.Velocity)>3 then local aba=(_ba-b_a).unit;local bba=_ba-aba*
(__a.attackRange)__a.manifest.BodyVelocity.Velocity=
aba* (__a.baseSpeed*1.2)
__a.manifest.BodyGyro.CFrame=CFrame.new(b_a,Vector3.new(_aa.X,__a.manifest.Position.Y,_aa.Z))else
__a.manifest.BodyVelocity.Velocity=Vector3.new()end;return"micro-sleeping"end},["special-attacking"]={animationEquivalent="throwingrock",additional_animation_to_play_temp="throwingrocklower",transitionLevel=7,lockTimeForPreventStateTransition=0.5,execute=function(__a,a_a,b_a,c_a)
if
not c_a or
not c_a:FindFirstChild("clientHitboxToServerHitboxReference")then return end;local d_a=c_a.clientHitboxToServerHitboxReference.Value
if not
game:GetService("RunService"):IsClient()then
warn("attacking::execute can only be called on client")return elseif not b_a.damageHitboxCollection then return elseif not d_a then return elseif not
d_a:FindFirstChild("targetEntity")then return elseif not d_a.targetEntity.Value then return elseif not __a.Character or not
__a.Character.PrimaryPart then return elseif

not c_a:FindFirstChild("entity")or not c_a.entity:FindFirstChild("RightHand")then return end;local _aa=false;local aaa=__a.Character.PrimaryPart;local baa=a_a.Length*
(b_a.animationDamageStart or 0.3)wait(baa)
if
not d_a.Parent then return elseif not d_a:FindFirstChild("targetEntity")then return elseif not
d_a.targetEntity.Value then return elseif
not __a.Character or not __a.Character.PrimaryPart then return elseif not c_a:FindFirstChild("entity")or not
c_a.entity:FindFirstChild("RightHand")then return end
local caa=game.ReplicatedStorage.rockToThrow:Clone()caa.Parent=dc.getPlaceFolder("entities")local daa=60
local _ba=c_a.entity["RightHand"].Position
local aba,bba=_d.getUnitVelocityToImpact_predictive(_ba,daa,d_a.targetEntity.Value.Position,d_a.targetEntity.Value.Velocity)
_d.createProjectile(_ba,aba,daa,caa,function(cba,dba)
game:GetService("Debris"):AddItem(caa,2 /30)
if cba then
if game.Players.LocalPlayer.Character and cba==
game.Players.LocalPlayer.Character.PrimaryPart then
cc:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",d_a,dba,"monster","rock-throw")end end end,
nil,{c_a,d_a,ad})end,step=function(__a,a_a)
__a.manifest.BodyVelocity.Velocity=Vector3.new()return"micro-sleeping"end},["micro-sleeping"]={animationEquivalent="idling",transitionLevel=8,lockTimeForLowerTransition=0.2,step=function(__a,a_a)return
"attack-ready"end},["special-recovering"]={animationEquivalent="idling",transitionLevel=9,lockTimeForLowerTransition=0.75,step=function(__a,a_a)return
"attack-ready"end},["dead"]={animationEquivalent="death",transitionLevel=math.huge,stopTransitions=false,step=function(__a,a_a)return
nil end},["attacked-by-player"]={transitionLevel=1,step=function(__a)return
"following"end}},processDamageRequestToMonster=function(__a,a_a)
if
__a.manifest:FindFirstChild("boosted")and a_a.damageType~="magical"then a_a.damage=math.floor(
a_a.damage*0.25)a_a.supressed=true end;return a_a end}