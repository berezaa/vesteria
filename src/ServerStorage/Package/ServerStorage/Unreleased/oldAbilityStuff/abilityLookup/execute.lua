
local db=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local _c=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local ac=_c.load("projectile")local bc=_c.load("placeSetup")
local cc=_c.load("client_utilities")local dc=_c.load("network")local _d=_c.load("detection")
local ad=_c.load("damage")
local bd={cost=2,upgradeCost=2,maxRank=8,layoutOrder=3,requirement=function(b_a)return b_a.class=="Hunter"end}local cd=bc.awaitPlaceFolder("entityManifestCollection")
local dd=game:GetService("HttpService")
local __a={id=6,book="hunter",metadata=bd,name="Execute",image="rbxassetid://3736597640",description="A powerful finisher. Resets cooldown if it lands a kill.",damageType="physical",prerequisite={{id=7,rank=1}},layoutOrder=2,animationName={"dagger_execute"},windupTime=0.1,maxRank=10,resetCooldownOnKill=true,statistics={[1]={damageMultiplier=2,manaCost=10,cooldown=6},[2]={damageMultiplier=2.2,manaCost=11},[3]={damageMultiplier=2.4,manaCost=12},[4]={damageMultiplier=2.6,manaCost=13},[5]={damageMultiplier=2.9,manaCost=15,cooldown=5,tier=3},[6]={damageMultiplier=3.2,manaCost=17},[7]={damageMultiplier=3.5,manaCost=19},[8]={damageMultiplier=4.0,manaCost=22,tier=4}},securityData={playerHitMaxPerTag=1,isDamageContained=true},damage=50,maxRange=30,equipmentTypeNeeded="dagger"}function __a._abilityExecutionDataCallback(b_a,c_a)
c_a["one good hit"]=b_a and
b_a.nonSerializeData.statistics_final.activePerks["one good hit"]end
function __a._serverProcessDamageRequest(b_a,c_a)if
b_a=="strike"then return c_a,"physical","direct"elseif b_a=="shadowblast"then
return c_a*1.5,"magical","aoe"end end
local function a_a(b_a)local c_a=Instance.new("Part")
local d_a=Instance.new("SpecialMesh")
c_a.Size=Vector3.new(explodeRadius*2,explodeRadius*2,explodeRadius*2)c_a.Shape=Enum.PartType.Ball
c_a.Color=Color3.fromRGB(255,255,255)c_a.Anchored=true;c_a.CanCollide=false
c_a.Material=Enum.Material.Neon;c_a.CFrame=CFrame.new(hitPosition)
d_a.Scale=Vector3.new(0,0,0)d_a.MeshType=Enum.MeshType.Sphere;d_a.Parent=c_a
c_a.Parent=workspace.CurrentCamera
tween(c_a,{"Transparency"},{1},explodeDurration,Enum.EasingStyle.Linear)
tween(c_a,{"Color"},{Color3.fromRGB(0,255,100)},explodeDurration,Enum.EasingStyle.Linear)
tween(d_a,{"Scale"},{Vector3.new(1,1,1)*1.25},explodeDurration,Enum.EasingStyle.Quint)
game:GetService("Debris"):AddItem(c_a,explodeDurration*1.15)
if associatePlayer==client then
for _aa,aaa in pairs(ad.getDamagableTargets(client))do
local baa=(
aaa.Size.X+aaa.Size.Y+aaa.Size.Z)/6
if
(aaa.Position-hitPosition).magnitude<= (explodeRadius)+baa and aaa~=needsToHit then
delay(0.1,function()
dc:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",aaa,hitPosition,"equipment")end)end end;if needsToHit then
delay(0.1,function()
dc:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",needsToHit,hitPosition,"equipment")end)end end end
function __a.onPlayerKilledMonster_server(b_a,c_a)
local d_a=dc:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",b_a)
if d_a then
local _aa=dc:invoke("{85D4FB3D-CC96-464E-96A9-E796B8EA4DA5}",b_a,__a.id)local aaa=d_a.nonSerializeData.statistics_final
local baa=__a.statistics[_aa]local caa=0;local daa=0;local _ba=baa.manaCost;if aaa.vit>=30 then caa=40 end;if aaa.vit>=60 then
caa=100 end;if aaa.vit>=100 then caa=150;daa=_ba end
local aba=b_a.Character;if not aba then return end;local bba=aba.PrimaryPart;if not bba then return end
local cba=bba:FindFirstChild("health")if not cba then return end;local dba=bba:FindFirstChild("maxHealth")if
not dba then return end;local _ca=bba:FindFirstChild("mana")
if not _ca then return end;local aca=bba:FindFirstChild("maxMana")if not aca then return end;cba.Value=math.min(
cba.Value+caa,dba.Value)
_ca.Value=math.min(_ca.Value+daa,aca.Value)end end
function __a:execute_server(b_a,c_a,d_a,_aa)if not d_a then return end
if c_a["one good hit"]then if
_aa:FindFirstChild("resilient")then return end;local aaa=_aa:FindFirstChild("health")if not
aaa then return end;local baa=_aa:FindFirstChild("maxHealth")if
not baa then return end
if(aaa.Value/baa.Value)>0.25 then return end;local caa=_aa:FindFirstChild("entityType")if not caa then return end
caa=caa.Value
local daa={damage=aaa.Value*2,sourceType="ability",sourceId=self.id,damageType="physical",sourcePlayerId=b_a.UserId}
if caa=="monster"then
dc:invoke("{031BE66E-62B6-4583-B409-DCB61C0DA077}",b_a,_aa,daa)else
dc:invoke("{AC8B16AA-3BD2-4B7F-B12C-5558B8857745}",b_a,_aa,daa)end end end
function __a:validateDamageRequest(b_a,c_a)return(b_a-c_a).magnitude<=8 end
function __a:execute(b_a,c_a,d_a,_aa)
if not b_a:FindFirstChild("entity")then return end
local aaa=dc:invoke("{CA61CBF0-3B04-4617-8D2D-50C80D51AB19}",b_a.entity)local baa=aaa["1"]and aaa["1"].manifest
if not baa then return end
local caa=b_a.entity.AnimationController:LoadAnimation(db[self.animationName[1]])caa:Play()
if b_a.PrimaryPart then local _ba=script.sound:Clone()
_ba.Parent=b_a.PrimaryPart;_ba:Play()game.Debris:AddItem(_ba,5)end;local daa=script.Dust:Clone()daa.Parent=baa;daa.Enabled=true
game.Debris:AddItem(daa,3)wait(self.windupTime)if
not b_a:FindFirstChild("entity")then return end
if d_a then local _ba={}
local aba=ad.getDamagableTargets(game.Players.LocalPlayer)
while caa.IsPlaying do
for bba,cba in pairs(aba)do
if not _ba[cba]then local dba=baa.CFrame
local _ca=_d.projection_Box(cba.CFrame,cba.Size,dba.p)
if
_d.boxcast_singleTarget(dba,baa.Size*Vector3.new(4,4,4),_ca)then _ba[cba]=true
if daa then local aca=Instance.new("Part")
aca.CFrame=CFrame.new(_ca)aca.CanCollide=false;aca.Anchored=true;aca.Transparency=1
aca.Parent=workspace.CurrentCamera;local bca=daa:Clone()bca.Parent=aca;bca.Enabled=false;bca:Emit(50)
game.Debris:AddItem(aca,5)end
dc:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",cba,_ca,"ability",self.id,"strike",_aa)if c_a["one good hit"]then
dc:fireServer("{7170F8E2-9C53-42D1-A10A-E8383DB284E0}",c_a,self.id,cba)end end end end;wait(1 /20)end
if daa then daa.Enabled=false;game.Debris:AddItem(daa,2)end end end;return __a