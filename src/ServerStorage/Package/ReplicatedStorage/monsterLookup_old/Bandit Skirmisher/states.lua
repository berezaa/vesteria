local _c=game:GetService("ReplicatedStorage")
local ac=require(_c.modules)local bc=ac.load("pathfinding")local cc=ac.load("utilities")
local dc=ac.load("detection")local _d=ac.load("network")local ad=ac.load("placeSetup")
local bd=ac.load("projectile")local cd=ac.load("placeSetup")
local dd=cd.awaitPlaceFolder("entityManifestCollection")local __a=cd.awaitPlaceFolder("entityRenderCollection")
local a_a=1;local b_a=Random.new()
local function c_a(d_a,_aa)local aaa=Instance.new("Motor6D")
aaa.Part0=d_a;aaa.Part1=_aa;aaa.C0=CFrame.new()
aaa.C1=_aa.CFrame:toObjectSpace(d_a.CFrame)aaa.Name=_aa.Name;aaa.Parent=d_a end
return
{processDamageRequest=function(d_a,_aa)if d_a=="pierce"then return _aa,"physical","direct"end
return _aa,"physical","direct"end,getClosestEntities=function(d_a)
local _aa=cc.getEntities()
for i=#_aa,1,-1 do local aaa=_aa[i]
if



(aaa.Name=="Bandit")or(aaa.Name=="Bandit Skirmisher")or(aaa.Name=="Hitbox")or
(aaa.Name=="Scarab")or(aaa.Name=="Stingtail")or(aaa.Name=="Deathsting")or aaa==d_a.manifest then table.remove(_aa,i)end end;return _aa end,default="sleeping",states={["setup"]={animationEquivalent="idling",transitionLevel=0,step=function(d_a)
if
d_a.moveGoal then d_a.__directRoamGoal=d_a.moveGoal
d_a.__directRoamOrigin=d_a.manifest.Position;d_a.__blockConfidence=0;d_a.__LAST_ROAM_TIME=tick()return"direct-roam"end end},["sleeping"]={animationEquivalent="idling",timeBetweenUpdates=5,transitionLevel=1,execute=function(d_a,_aa,aaa,baa)
end,step=function(d_a,_aa)if d_a.closestEntity then return"idling"end end},["idling"]={lockTimeForLowerTransition=3,transitionLevel=2,execute=function(d_a,_aa,aaa,baa)
if
baa and baa:FindFirstChild("entity")then
baa.entity.arrow.Transparency=1;baa.entity.arrow2.Transparency=1
if
baa.entity.arrow:FindFirstChild("moved")==nil then
baa.entity.arrow.Position=baa.entity.arrowhold.Position
local caa=Instance.new("BoolValue",baa.entity.arrow)caa.Name="moved"end end end,step=function(d_a,_aa)
d_a.manifest.BodyVelocity.Velocity=Vector3.new()
if d_a.moveGoal then d_a.__directRoamGoal=d_a.moveGoal
d_a.__directRoamOrigin=d_a.manifest.Position;d_a.__blockConfidence=0;d_a.__LAST_ROAM_TIME=tick()end
if d_a.closestEntity then
local aaa=cc.magnitude(d_a.closestEntity.Position-d_a.manifest.Position)
if

d_a.targetEntity and d_a:isTargetEntityInLineOfSight(d_a.aggressionRange,false)and aaa<d_a.aggressionRange then return"following"end end
if d_a.closestEntity then
local aaa=cc.magnitude(d_a.closestEntity.Position-d_a.manifest.Position)
if aaa<=d_a.aggressionRange and
d_a:isTargetEntityInLineOfSight(d_a.aggressionRange,false)then
d_a.__providedDirectRoamTheta=nil;d_a:setTargetEntity(d_a.closestEntity)return"following"else
if _aa or
d_a.__providedDirectRoamTheta then if

(d_a.__LAST_ROAM_TIME and tick()-d_a.__LAST_ROAM_TIME<5)and(d_a.__providedDirectRoamTheta==nil)then return"idling"end
local baa=Vector3.new(1,0,1)local caa=b_a:NextInteger(1,360)
if d_a.__providedDirectRoamTheta then
caa=d_a.__providedDirectRoamTheta;d_a.__providedDirectRoamTheta=nil end;local daa=math.rad(caa)local _ba=d_a.manifest.Position*baa
local aba=
_ba+
Vector3.new(math.cos(daa),0,math.sin(daa))*b_a:NextInteger(30,
d_a.maxRoamDistance or 50)local bba=aba-_ba;local cba=d_a.manifest.Position+
Vector3.new(0,d_a.manifest.Size.Y,0)local dba=bba-
Vector3.new(0,d_a.manifest.Size.Y,0)local _ca=Ray.new(cba,dba)
local aca,bca=workspace:FindPartOnRayWithIgnoreList(_ca,{d_a.manifest,workspace.placeFolders:FindFirstChild("entityRenderCollection"),workspace.placeFolders:FindFirstChild("foilage")})
local cca=(d_a.manifest.Size.X+d_a.manifest.Size.Z)/2;local dca=(bca-d_a.manifest.Position).magnitude
local _da=true;local ada=(bca-bba*cca/2)*baa
local bda=(
d_a.origin and d_a.origin.p or d_a.manifest.Position)*baa;local cda=(ada-bda).magnitude;local dda=(_ba-bda).magnitude
if dda<cda then
if
cda>=200 then if b_a:NextNumber()<1 then _da=false end elseif cda>=150 then if
b_a:NextNumber()<0.8 then _da=false end elseif cda>=100 then if
b_a:NextNumber()<0.6 then _da=false end elseif cda>=75 then
if b_a:NextNumber()<0.4 then _da=false end elseif cda>=50 then if b_a:NextNumber()<0.3 then _da=false end elseif cda>=25 then if
b_a:NextNumber()<0.2 then _da=false end end end
if dca>=cca and _da then d_a.__directRoamGoal=ada;d_a.__directRoamOrigin=_ba
d_a.__directRoamTheta=caa;d_a.__blockConfidence=0;d_a.__LAST_ROAM_TIME=tick()end;d_a.__LAST_ROAM_TIME=tick()-4.5;return end end else return"sleeping"end end},["wait-roaming"]={animationEquivalent="idling",transitionLevel=3,step=function(d_a,_aa)
if
not d_a.__IS_WAITING_FOR_PATH_FINDING then if d_a.isProcessingPath then return"roaming"else
d_a:setTargetEntity(nil,nil)return"idling"end end
if
d_a.__PATHFIND_QUEUE_TIME and tick()-d_a.__PATHFIND_QUEUE_TIME>5 then d_a:resetPathfinding()return"idling"end end},["direct-roam"]={animationEquivalent="walking",transitionLevel=3,step=function(d_a,_aa)
if
d_a.moveGoal then d_a.moveGoal=nil;d_a.__strictMovement=true end;if d_a.targetEntity then return"following"end
if d_a.closestEntity and _aa then
local caa=cc.magnitude(
d_a.closestEntity.Position-d_a.manifest.Position)
if caa<=d_a.aggressionRange and
d_a:isTargetEntityInLineOfSight(d_a.aggressionRange,false)then
d_a:setTargetEntity(d_a.closestEntity,d_a.closestEntity)return"following"end end;local aaa,baa=d_a.__directRoamOrigin,d_a.__directRoamGoal
if aaa and baa then
local caa=Vector3.new(1,0,1)local daa=cc.magnitude(baa*caa-aaa*caa)
local _ba=cc.magnitude(
d_a.manifest.Position*caa-aaa*caa)local aba=(baa*caa-aaa*caa).unit;d_a.manifest.BodyVelocity.Velocity=
aba*d_a.baseSpeed;d_a.manifest.BodyGyro.CFrame=CFrame.new(
aaa*caa,baa*caa)
if _ba>=daa then
d_a.__strictMovement=false
if d_a.__directRoamTheta and b_a:NextNumber()>0.5 then
d_a.__providedDirectRoamTheta=
d_a.__directRoamTheta+b_a:NextInteger(-35,35)return"idling"end;d_a.__providedDirectRoamTheta=nil
d_a.manifest.BodyVelocity.Velocity=Vector3.new()return"idling"end;local bba=d_a.manifest.BodyVelocity.Velocity
local cba=d_a.manifest.Velocity;local dba=d_a.manifest.BodyVelocity.Velocity
local _ca=d_a.manifest.Velocity
local aca=Ray.new(d_a.manifest.Position,Vector3.new(0,-50,0))
local bca=Ray.new(d_a.manifest.Position+ (aba*d_a.baseSpeed*0.15),Vector3.new(0,
-50,0))
local cca,dca=workspace:FindPartOnRayWithIgnoreList(aca,{d_a.manifest,workspace.placeFolders:FindFirstChild("entityRenderCollection"),workspace.placeFolders:FindFirstChild("foilage")})
local _da,ada=workspace:FindPartOnRayWithIgnoreList(bca,{d_a.manifest,workspace.placeFolders:FindFirstChild("entityRenderCollection"),workspace.placeFolders:FindFirstChild("foilage")})local bda=ada.Y-dca.Y
if not d_a.__strictMovement then
if-bda>=
d_a.manifest.Size.Y/6 then
d_a.__blockConfidence=d_a.__blockConfidence+1
if-bda>=d_a.manifest.Size.Y/1.5 then d_a.__blockConfidence=
d_a.__blockConfidence+2 elseif-bda>=
d_a.manifest.Size.Y/3 then d_a.__blockConfidence=d_a.__blockConfidence+1 end;if d_a.__blockConfidence>=3 then
d_a.manifest.BodyVelocity.Velocity=Vector3.new()return"idling"end elseif
(bda>=
d_a.manifest.Size.Y/2)or(_ca.magnitude<dba.magnitude and
cc.magnitude(dba-_ca)>d_a.baseSpeed*0.9)then d_a.__blockConfidence=d_a.__blockConfidence+1;if
d_a.__blockConfidence>=4 then
d_a.manifest.BodyVelocity.Velocity=Vector3.new()return"idling"end elseif d_a.__blockConfidence and
d_a.__blockConfidence>0 then
d_a.__blockConfidence=d_a.__blockConfidence-1 end end;return end;return"idling"end},["roaming"]={animationEquivalent="walking",transitionLevel=3,step=function(d_a,_aa)
if
d_a.closestEntity then if not d_a.path then return"idling"end
local aaa=cc.magnitude(d_a.closestEntity.Position-
d_a.manifest.Position)local baa=d_a.path[d_a.currentNode]
local caa=d_a.path[d_a.currentNode+1]
if baa and caa then
if
bc.isPastNextPathfindingNodeNode(baa.Position,d_a.manifest.Position,caa.Position)then d_a.currentNode=d_a.currentNode+1
d_a.__PATH_FIND_NODE_START=tick()
if aaa<=d_a.aggressionRange and
d_a:isTargetEntityInLineOfSight(d_a.aggressionRange,false)then
d_a:resetPathfinding()
d_a:setTargetEntity(d_a.closestEntity,d_a.closestEntity)return"following"end else
if tick()-d_a.__PATH_FIND_NODE_START<2 then
local daa=Vector3.new(caa.Position.X,d_a.manifest.Position.Y,caa.Position.Z)
d_a.manifest.BodyGyro.CFrame=CFrame.new(d_a.manifest.Position,daa)d_a.manifest.BodyVelocity.Velocity=
(daa-d_a.manifest.Position).unit*d_a.baseSpeed else
d_a.manifest.BodyVelocity.Velocity=Vector3.new()d_a:resetPathfinding()return"idling"end end elseif baa and not caa then
d_a.manifest.BodyVelocity.Velocity=Vector3.new()d_a:resetPathfinding()return"idling"end end end},["following"]={transitionLevel=4,step=function(d_a,_aa)
if
not d_a.targetEntity then d_a:setTargetEntity(nil,nil)return"idling"end;local aaa=d_a.manifest.Position;local baa=d_a.targetEntity;local caa=baa.Position
local daa=caa
if
d_a.manifest.BodyVelocity.MaxForce.Y<=0.1 then daa=Vector3.new(caa.X,aaa.Y,caa.Z)end
if d_a.targetingYOffsetMulti then daa=daa+
Vector3.new(0,d_a.manifest.Size.Y*d_a.targetingYOffsetMulti,0)end;daa=daa+baa.Velocity*0.1
local _ba=cc.magnitude(aaa-daa)local aba=(daa-aaa).unit
local bba=daa-aba* (d_a.attackRange)
if
d_a:isTargetEntityInLineOfSight(d_a.targetEntitySetSource and 999,false)then
if _ba<=d_a.attackRange then
d_a.manifest.BodyGyro.CFrame=CFrame.new(aaa,Vector3.new(daa.X,aaa.Y,daa.Z))d_a.__LAST_POSITION_SEEN=bba
d_a.__LAST_MOVE_DIRECTION=aba*d_a.baseSpeed else
d_a.manifest.BodyGyro.CFrame=CFrame.new(aaa,Vector3.new(daa.X,aaa.Y,daa.Z))
d_a.manifest.BodyVelocity.Velocity=Vector3.new()end else
if not d_a.__LAST_POSITION_SEEN and false then
d_a:setTargetEntity(nil,nil)
d_a.manifest.BodyVelocity.Velocity=Vector3.new()return"idling"elseif d_a.__LAST_POSITION_SEEN then
local cba=Vector3.new(d_a.__LAST_POSITION_SEEN.X,aaa.Y,d_a.__LAST_POSITION_SEEN.Z)
if _ba<=d_a.aggressionRange then if
cc.magnitude(aaa-d_a.__LAST_POSITION_SEEN)>a_a then d_a.__LAST_POSITION_SEEN=nil
d_a:setTargetEntity(nil)return"idling"end else
if
d_a.targetEntitySetSource==nil then d_a:setTargetEntity(nil)return"idling"end end else d_a:setTargetEntity(nil)return"idling"end end
if cc.magnitude(daa-aaa)>=d_a.attackRange or
d_a.entityMonsterWasAttackedBy==nil then return"attack-ready"else return"retreat-attack"end end},["following-after-retreat"]={animationEquivalent="strafe-backwards",transitionLevel=4,step=function(d_a,_aa)
if
not d_a.targetEntity then d_a:setTargetEntity(nil,nil)return"idling"end;local aaa=d_a.manifest.Position;local baa=d_a.targetEntity;local caa=baa.Position
local daa=caa
if
d_a.manifest.BodyVelocity.MaxForce.Y<=0.1 then daa=Vector3.new(caa.X,aaa.Y,caa.Z)end
if d_a.targetingYOffsetMulti then daa=daa+
Vector3.new(0,d_a.manifest.Size.Y*d_a.targetingYOffsetMulti,0)end;daa=daa+baa.Velocity*0.1
local _ba=cc.magnitude(aaa-daa)local aba=(daa-aaa).unit
local bba=daa-aba* (d_a.attackRange)
if
d_a:isTargetEntityInLineOfSight(d_a.targetEntitySetSource and 999,false)then
if _ba<=d_a.attackRange then
d_a.manifest.BodyGyro.CFrame=CFrame.new(aaa,Vector3.new(daa.X,aaa.Y,daa.Z))d_a.__LAST_POSITION_SEEN=bba
d_a.__LAST_MOVE_DIRECTION=aba*d_a.baseSpeed else
d_a.manifest.BodyGyro.CFrame=CFrame.new(aaa,Vector3.new(daa.X,aaa.Y,daa.Z))
d_a.manifest.BodyVelocity.Velocity=Vector3.new()end else
if not d_a.__LAST_POSITION_SEEN and false then
d_a:setTargetEntity(nil,nil)
d_a.manifest.BodyVelocity.Velocity=Vector3.new()return"idling"elseif d_a.__LAST_POSITION_SEEN then
local cba=Vector3.new(d_a.__LAST_POSITION_SEEN.X,aaa.Y,d_a.__LAST_POSITION_SEEN.Z)
if _ba<=d_a.aggressionRange then if
cc.magnitude(aaa-d_a.__LAST_POSITION_SEEN)>a_a then d_a.__LAST_POSITION_SEEN=nil
d_a:setTargetEntity(nil)return"idling"end else
if
d_a.targetEntitySetSource==nil then d_a:setTargetEntity(nil)return"idling"end end else d_a:setTargetEntity(nil)return"idling"end end
if cc.magnitude(daa-aaa)>=d_a.attackRange or
d_a.entityMonsterWasAttackedBy==nil then return"attack-ready"else return"retreat-attack"end end},["retreat-attack"]={animationEquivalent="strafe-backwards",transitionLevel=5,lockTimeForLowerTransition=.96,execute=function(d_a,_aa,aaa,baa)
if

not game:GetService("RunService"):IsClient()then
warn("attacking::execute can only be called on client")return elseif not aaa.damageHitboxCollection then end;local caa=false;local daa=d_a.Character.PrimaryPart
local _ba=baa.clientHitboxToServerHitboxReference.Value
if baa:FindFirstChild("entity")and
baa.entity.animations:FindFirstChild("strafe-attack")then
local bba=baa.entity.AnimationController:LoadAnimation(baa.entity.animations:FindFirstChild("strafe-attack"))
local cba=baa.entity.Bow.AnimationController:LoadAnimation(script:FindFirstChild("bownormal"))if bba then bba:Play()end
if cba then cba:Play()
baa.entity.arrow.Transparency=1;baa.entity.arrow2.Transparency=0 end end;local aba=.5;wait(aba)
if _ba.targetEntity.Value then
baa.entity.arrow2.Transparency=1;local bba=baa.entity["arrow2"]:Clone()
bba.WeldConstraint:Destroy()bba.Transparency=0;bba.Anchored=true;bba.CanCollide=false
game:GetService("Debris"):AddItem(bba,30)bba.Parent=cd.getPlaceFolder("entities")local cba=150
local dba=baa.entity["arrow2"].Position
local _ca,aca=bd.getUnitVelocityToImpact_predictive(dba,cba,_ba.targetEntity.Value.Position,_ba.targetEntity.Value.Velocity)bba.CFrame=CFrame.new(bba.Position,aca)*
CFrame.Angles(0,-math.pi/2,0)local bca=bba.CFrame-
bba.CFrame.p;bba.Trail.Enabled=true
local cca=cd.getPlaceFolder("entityRenderCollection")
bd.createProjectile(dba,_ca,cba,bba,function(dca,_da,ada,bda)
if bba:FindFirstChild("Trail")then bba.Trail.Enabled=false end;local cda=2
if dca then
if
(dca:IsDescendantOf(__a)or dca:IsDescendantOf(dd))then bba.Anchored=false;c_a(bba,dca)cda=5 else
if bba:FindFirstChild("impact")then
local dda=dca.Color;if dca==workspace.Terrain then
if bda~=Enum.Material.Water then
dda=dca:GetMaterialColor(bda)else dda=BrickColor.new("Cyan").Color end end
local __b=Instance.new("Part")__b.Size=Vector3.new(0.1,0.1,0.1)__b.Transparency=1
__b.Anchored=true;__b.CanCollide=false
__b.CFrame=bba.CFrame-bba.CFrame.p+_da;local a_b=bba.impact:Clone()a_b.Parent=__b
__b.Parent=workspace.CurrentCamera;a_b.Color=ColorSequence.new(dda)a_b:Emit(10)
game.Debris:AddItem(__b,3)end end end;cc.playSound("bowArrowImpact",bba)
game:GetService("Debris"):AddItem(bba,cda)
if dca then
if game.Players.LocalPlayer.Character and dca==
game.Players.LocalPlayer.Character.PrimaryPart then
_d:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",_ba,_da,"monster","retreat")end end end,function(dca)return CFrame.Angles(0,
-math.pi/2,0)end,{baa,_ba,__a},true)end end,step=function(d_a,_aa)
if
not d_a.targetEntity then d_a:setTargetEntity(nil,nil)return"idling"end;local aaa=d_a.manifest.Position;local baa=d_a.targetEntity;local caa=baa.Position
local daa=caa
if
d_a.manifest.BodyVelocity.MaxForce.Y<=0.1 then daa=Vector3.new(caa.X,aaa.Y,caa.Z)end
if d_a.targetingYOffsetMulti then daa=daa+
Vector3.new(0,d_a.manifest.Size.Y*d_a.targetingYOffsetMulti,0)end;daa=daa+baa.Velocity*0.1
local _ba=cc.magnitude(aaa-daa)local aba=(daa-aaa).unit
local bba=daa-aba* (d_a.attackRange)
if
d_a:isTargetEntityInLineOfSight(d_a.targetEntitySetSource and 999,false)then
if _ba<=d_a.attackRange then
d_a.manifest.BodyVelocity.Velocity=-aba*d_a.baseSpeed
d_a.manifest.BodyGyro.CFrame=CFrame.new(aaa,Vector3.new(daa.X,aaa.Y,daa.Z))d_a.__LAST_POSITION_SEEN=bba
d_a.__LAST_MOVE_DIRECTION=aba*d_a.baseSpeed else
d_a.manifest.BodyGyro.CFrame=CFrame.new(aaa,Vector3.new(daa.X,aaa.Y,daa.Z))end else
if not d_a.__LAST_POSITION_SEEN and false then
d_a:setTargetEntity(nil,nil)
d_a.manifest.BodyVelocity.Velocity=Vector3.new()return"idling"elseif d_a.__LAST_POSITION_SEEN then
local cba=Vector3.new(d_a.__LAST_POSITION_SEEN.X,aaa.Y,d_a.__LAST_POSITION_SEEN.Z)
d_a.manifest.BodyVelocity.Velocity=-1 * (cba-aaa).unit*d_a.baseSpeed
if _ba<=d_a.aggressionRange then if
cc.magnitude(aaa-d_a.__LAST_POSITION_SEEN)>a_a then d_a.__LAST_POSITION_SEEN=nil
d_a:setTargetEntity(nil)return"idling"end else
if
d_a.targetEntitySetSource==nil then d_a:setTargetEntity(nil)return"idling"end end else d_a:setTargetEntity(nil)return"idling"end end;if _aa then return"following-after-retreat"end end},["attack-ready"]={transitionLevel=5,step=function(d_a,_aa)
if
d_a.targetEntity==nil then d_a:setTargetEntity(nil,nil)return"idling"end;local aaa=d_a.manifest.Position;local baa=d_a.targetEntity;local caa=baa.Position
local daa=caa
d_a.manifest.BodyGyro.CFrame=CFrame.new(aaa,Vector3.new(daa.X,aaa.Y,daa.Z))
if
d_a.manifest.BodyVelocity.MaxForce.Y<=0.1 then daa=Vector3.new(caa.X,aaa.Y,caa.Z)end
if d_a.targetingYOffsetMulti then daa=daa+
Vector3.new(0,d_a.manifest.Size.Y*d_a.targetingYOffsetMulti,0)end;local _ba=cc.magnitude(aaa-daa)local aba=(daa-aaa).unit;local bba=daa-aba*
(d_a.attackRange)
if _ba>=d_a.attackRange and
_ba<d_a.aggressionRange then local cba=d_a.manifest.Position
if
tick()-d_a.__LAST_ATTACK_TIME>=d_a.attackSpeed then d_a.__LAST_ATTACK_TIME=tick()
return"attacking"else
d_a.manifest.BodyVelocity.Velocity=Vector3.new()end else if
_ba<d_a.aggressionRange and d_a.entityMonsterWasAttackedBy==nil then return"attacking"end
d_a:setTargetEntity(nil,nil)return"idling"end end},["attacking"]={transitionLevel=6,animationPriority=Enum.AnimationPriority.Action,doNotLoopAnimation=true,doNotStopAnimation=true,lockTimeForLowerTransition=2.8,execute=function(d_a,_aa,aaa,baa)
if

not game:GetService("RunService"):IsClient()then
warn("attacking::execute can only be called on client")return elseif not aaa.damageHitboxCollection then end;local caa=false;local daa=d_a.Character.PrimaryPart
local _ba=baa.clientHitboxToServerHitboxReference.Value
local aba=baa.entity.Bow.AnimationController:LoadAnimation(script:FindFirstChild("bowpierce"))if aba then aba:Play()baa.entity.arrow2.Transparency=1
baa.entity.arrow.Transparency=0 end;local bba=2.1;wait(bba)
if
_ba.targetEntity.Value then baa.entity.arrow.Transparency=1
local cba=baa.entity["arrow"]:Clone()cba.WeldConstraint:Destroy()cba.Transparency=0
cba.CanCollide=false;cba.Anchored=true;local dba=64;if _ba:FindFirstChild("projectileSpeedOverride")then
dba=_ba.projectileSpeedOverride.Value end
local _ca=baa.entity["arrow"].Position
local aca,bca=bd.getUnitVelocityToImpact_predictive(_ca,dba,_ba.targetEntity.Value.Position,_ba.targetEntity.Value.Velocity)if not(aca and bca)then return end
game:GetService("Debris"):AddItem(cba,30)cba.Parent=cd.getPlaceFolder("entities")
cba.CFrame=
CFrame.new(cba.Position,bca)*CFrame.Angles(0,-math.pi/2,0)local cca=cba.CFrame-cba.CFrame.p;cba.Trail.Enabled=true
local dca=cd.getPlaceFolder("entityRenderCollection")
bd.createProjectile(_ca,aca,dba,cba,function(_da,ada,bda,cda)
if cba:FindFirstChild("Trail")then cba.Trail.Enabled=false end;local dda=2
if _da then
if
(_da:IsDescendantOf(__a)or _da:IsDescendantOf(dd))then cba.Anchored=false;c_a(cba,_da)dda=5 else
if cba:FindFirstChild("impact")then
local __b=_da.Color;if _da==workspace.Terrain then
if cda~=Enum.Material.Water then
__b=_da:GetMaterialColor(cda)else __b=BrickColor.new("Cyan").Color end end
local a_b=Instance.new("Part")a_b.Size=Vector3.new(0.1,0.1,0.1)a_b.Transparency=1
a_b.Anchored=true;a_b.CanCollide=false
a_b.CFrame=cba.CFrame-cba.CFrame.p+ada;local b_b=cba.impact:Clone()b_b.Parent=a_b
a_b.Parent=workspace.CurrentCamera;b_b.Color=ColorSequence.new(__b)b_b:Emit(10)
game.Debris:AddItem(a_b,3)end end end;cc.playSound("bowArrowImpact",cba)
game:GetService("Debris"):AddItem(cba,dda)
if _da then
if game.Players.LocalPlayer.Character and _da==
game.Players.LocalPlayer.Character.PrimaryPart then
_d:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",_ba,ada,"monster","pierce")end end end,function(_da)return CFrame.Angles(0,
-math.pi/2,0)end,{baa,_ba,dca},true)end end,step=function(d_a,_aa)
if
d_a.targetEntity==nil then d_a:setTargetEntity(nil,nil)return"idling"end;local aaa=d_a.manifest.Position;local baa=d_a.targetEntity;local caa=baa.Position
local daa=caa
d_a.manifest.BodyGyro.CFrame=CFrame.new(aaa,Vector3.new(daa.X,aaa.Y,daa.Z))
d_a.manifest.BodyVelocity.Velocity=Vector3.new()
if d_a.closestEntity and _aa then
local cba=cc.magnitude(d_a.closestEntity.Position-d_a.manifest.Position)
if cba<=d_a.aggressionRange and
d_a:isTargetEntityInLineOfSight(d_a.aggressionRange,false)then
d_a:setTargetEntity(d_a.closestEntity)
if cba<d_a.attackRange then return"following"elseif cba<d_a.aggressionRange then return"attack-ready"end;d_a:setTargetEntity(nil,nil)return"idling"end end
if
d_a.manifest.BodyVelocity.MaxForce.Y<=0.1 then daa=Vector3.new(caa.X,aaa.Y,caa.Z)end
if d_a.targetingYOffsetMulti then daa=daa+
Vector3.new(0,d_a.manifest.Size.Y*d_a.targetingYOffsetMulti,0)end;daa=daa+baa.Velocity*0.1
local _ba=cc.magnitude(aaa-daa)local aba=(daa-aaa).unit
local bba=daa-aba* (d_a.attackRange)
d_a.manifest.BodyVelocity.Velocity=Vector3.new()return"idling"end},["special-attacking"]={animationEquivalent="special-attack",transitionLevel=7,step=function(d_a,_aa)d_a.specialsUsed=
d_a.specialsUsed+1;if d_a.__STATE_OVERRIDES["special-attacking"]then
d_a.__STATE_OVERRIDES["special-attacking"](d_a)end;return"special-recovering"end},["micro-sleeping"]={animationEquivalent="idling",transitionLevel=8,lockTimeForLowerTransition=0.2,step=function(d_a,_aa)d_a:setTargetEntity(
nil,nil)return"idling"end},["special-recovering"]={animationEquivalent="idling",transitionLevel=9,lockTimeForLowerTransition=0.75,step=function(d_a,_aa)return
"attack-ready"end},["dead"]={animationEquivalent="death",transitionLevel=math.huge,stopTransitions=false,step=function(d_a,_aa)return
nil end,execute=function()return nil end},["attacked-by-player"]={transitionLevel=10,lockTimeForLowerTransition=.3,doNotStopAnimation=true,step=function(d_a)
d_a.manifest.BodyVelocity.Velocity=Vector3.new()
if d_a.closestEntity and d_a.entityMonsterWasAttackedBy then
local _aa=cc.magnitude(
d_a.entityMonsterWasAttackedBy.Position-d_a.manifest.Position)
if d_a:isTargetEntityInLineOfSight(nil,false,d_a.entityMonsterWasAttackedBy)then
d_a:setTargetEntity(d_a.entityMonsterWasAttackedBy)return"following"end end;return"idling"end}},processDamageRequestToMonster=function(d_a,_aa)if
_aa.damageType=="magical"then
_aa.damage=math.floor(_aa.damage*0.5)_aa.supressed=true end;return _aa end}