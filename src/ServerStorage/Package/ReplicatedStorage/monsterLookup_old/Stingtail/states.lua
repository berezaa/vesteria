local da=game:GetService("ReplicatedStorage")
local _b=require(da.modules)local ab=_b.load("pathfinding")local bb=_b.load("utilities")
local cb=_b.load("detection")local db=_b.load("network")local _c=1;local ac=Random.new()
return
{processDamageRequest=function(bc,cc)
if bc=="claws"then return
cc*0.75,"physical","direct"elseif bc=="stinger"then return cc*2,"physical","direct"end end,getClosestEntities=function(bc)
local cc=bb.getEntities()
for i=#cc,1,-1 do local dc=cc[i]
if

(dc.Name=="Deathsting")or(dc.Name=="Stingtail")or(dc.Name=="Dustwurm")or dc==bc.manifest then table.remove(cc,i)end end;return cc end,default="idling",states={["attacking"]={transitionLevel=6,animationPriority=Enum.AnimationPriority.Action,doNotLoopAnimation=true,doNotStopAnimation=true,execute=function(bc,cc,dc,_d)
if

not game:GetService("RunService"):IsClient()then
warn("attacking::execute can only be called on client")return elseif not dc.damageHitboxCollection then end;local ad=false;local bd=bc.Character.PrimaryPart
local cd=_d.clientHitboxToServerHitboxReference.Value
if _d:FindFirstChild("entity")and
_d.entity.PrimaryPart:FindFirstChild("attacking")then local _aa=1
if _d:FindFirstChild("entity")and
_d.entity.PrimaryPart:FindFirstChild("attacking2")then _aa=math.random(2)if _aa==2 then
_d.entity.PrimaryPart.attacking2:Play()end end;if _aa==1 then
_d.entity.PrimaryPart.attacking:Play()end end
local dd=cc.Length* (dc.animationDamageStart or 0.3)wait(dd)
local __a=cc.Length* (dc.animationDamageEnd or 0.7)local a_a=__a-dd;local b_a=a_a/10;local c_a=false;local d_a=false
for i=0,a_a,b_a do
if cc.IsPlaying and
_d:FindFirstChild("entity")then
for _aa,aaa in pairs(dc.damageHitboxCollection)do
if
_d.entity:FindFirstChild(aaa.partName)then
local baa=(aaa.partName=="RightClaw"or aaa.partName=="LeftClaw")local caa=(aaa.partName=="Stinger")
if
(baa and not c_a)or(caa and not d_a)then
local daa=_d.entity[aaa.partName].CFrame*aaa.originOffset;local _ba=cb.projection_Box(bd.CFrame,bd.Size,daa.p)
if
cb.boxcast_singleTarget(daa,
_d.entity[aaa.partName].Size* (aaa.hitboxSizeMultiplier or Vector3.new(1,1,1)),_ba)then
db:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",cd,_ba,"monster",baa and"claws"or"stinger")if baa then c_a=true elseif caa then d_a=true end end end end end;wait(b_a)else break end end end,step=function(bc,cc)if
bc.targetEntity==nil then return"idling"end
local dc=bc.manifest.Position;local _d=bc.targetEntity;local ad=_d.Position;local bd=ad
if
bc.manifest.BodyVelocity.MaxForce.Y<=0.1 then bd=Vector3.new(ad.X,dc.Y,ad.Z)end
if bc.targetingYOffsetMulti then bd=bd+
Vector3.new(0,bc.manifest.Size.Y*bc.targetingYOffsetMulti,0)end;bd=bd+_d.Velocity*0.1;local cd=bb.magnitude(dc-bd)
local dd=(bd-dc).unit;local __a=bd-dd* (bc.attackRange)
bc.manifest.BodyGyro.CFrame=CFrame.new(dc,bd)
if bb.magnitude(_d.Velocity)>3 then local b_a=(bd-dc).unit;local c_a=bd-
b_a* (bc.attackRange)bc.manifest.BodyVelocity.Velocity=b_a*
(bc.baseSpeed*0.7)else
bc.manifest.BodyVelocity.Velocity=Vector3.new()end
local a_a=game.Players:GetPlayerFromCharacter(bc.targetEntity.Parent)
if not a_a then
delay(0.25,function()
db:invoke("{031BE66E-62B6-4583-B409-DCB61C0DA077}",nil,bc.targetEntity,{damage=bc.damage,sourceType="monster",sourceId=nil,damageCategory="direct",damageType="physical"})end)end;return"micro-sleeping"end}}}