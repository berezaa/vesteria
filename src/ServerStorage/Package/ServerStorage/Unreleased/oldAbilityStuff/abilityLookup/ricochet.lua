
local db=game.ReplicatedStorage:WaitForChild("abilityAnimations")local _c=game:GetService("Debris")
local ac=game:GetService("RunService")
local bc=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local cc=bc.load("network")local dc=bc.load("damage")
local _d=bc.load("placeSetup")local ad=bc.load("tween")local bd=bc.load("ability_utilities")
local cd=bc.load("effects")local dd=bc.load("projectile")
local __a=_d.awaitPlaceFolder("entities")
local a_a={id=31,name="Ricochet",image="rbxassetid://4465750391",description="Shoot an arrow that will ricochet off its target, striking multiple targets.",mastery="More ricochets",maxRank=10,statistics=bd.calculateStats{maxRank=10,static={cooldown=3},staggered={damageMultiplier={first=1,final=1.5,levels={2,4,6,8,10}},bounces={first=3,final=10,levels={3,5,7,9},integer=true}},pattern={manaCost={base=5,pattern={2,3}}}},windupTime=0.5,securityData={playerHitMaxPerTag=64,isDamageContained=true,projectileOrigin="character"},abilityDecidesEnd=true,equipmentTypeNeeded="bow",disableAutoaim=true}function a_a._serverProcessDamageRequest(b_a,c_a)
if b_a=="boulder"then return c_a,"magical","projectile"end end
function a_a:execute(b_a,c_a,d_a,_aa)
local aaa=b_a.PrimaryPart;if not aaa then return end;local baa=b_a:FindFirstChild("entity")if not baa then
return end
local caa=cc:invoke("{CA61CBF0-3B04-4617-8D2D-50C80D51AB19}",baa)if not caa then return end
caa=caa["1"]and caa["1"].manifest;if not caa then return end
local daa=baa:FindFirstChild("AnimationController")if not daa then return end
local _ba=caa:FindFirstChild("AnimationController")if not _ba then return end
local aba=b_a.clientHitboxToServerHitboxReference.Value;if not aba then return end
local function bba()if not d_a then return end
local cba=cc:invoke("{0659F187-209D-48FD-AE95-040A0C31DB94}",a_a.id,c_a)cba["ability-state"]="update"cba["ability-guid"]=_aa
cc:invoke("{C8F2171C-1C77-4D97-89FD-DBA03550755B}",a_a.id,"update",cba,_aa)end
if c_a["ability-state"]=="begin"then
daa:LoadAnimation(db.player_tripleshot):Play()
_ba:LoadAnimation(db.bow_tripleshot):Play()local cba=script.arrow:Clone()
cba:ClearAllChildren()cba.Anchored=false;cba.Parent=__a
local dba=caa.slackRopeRepresentation.arrowHolder
dba.C0=CFrame.Angles(-math.pi/2,0,0)*CFrame.new(0,
-cba.Size.Y/2 -0.2,0)dba.Part1=cba;_c:AddItem(cba,self.windupTime)
local _ca=script.draw:Clone()_ca.Parent=aaa;_ca:Play()
_c:AddItem(_ca,_ca.TimeLength)wait(self.windupTime)
local aca=script.shoot:Clone()aca.Parent=aaa;aca:Play()
_c:AddItem(aca,aca.TimeLength)bba()elseif c_a["ability-state"]=="update"then
local cba=c_a["ability-statistics"]["bounces"]local dba=bd.getCastingPlayer(c_a)local _ca={}
local function aca(bda)for cda,dda in pairs(_ca)do
if dda==bda then return true end end;return false end;local bca,cca
function bca(bda,cda,dda)if cba<=0 then return end;if not dda then return end
table.insert(_ca,dda)table.insert(cda,dda)
local __b=cc:invoke("{CA09ED16-A4C8-4148-9701-4B531599C9E9}",dda)if __b then table.insert(cda,__b)end
local a_b=dc.getDamagableTargets(dba)local b_b=32 ^2;local c_b=nil
for d_b,_ab in pairs(a_b)do
if not aca(_ab)then local aab=_ab.Position-bda;local bab=
aab.X^2 +aab.Y^2 +aab.Z^2;if bab<b_b then c_b=_ab
b_b=bab end end end;if c_b then cca(bda,c_b.Position,cda)end end
function cca(bda,cda,dda)cba=cba-1;local __b=script.arrow:Clone()local a_b=__b.trail
__b.Position=bda;__b.Parent=__a;local b_b=200
local c_b=dd.getUnitVelocityToImpact_predictive(bda,b_b,cda,Vector3.new())
dd.createProjectile(bda,c_b or(cda-bda).Unit,b_b,__b,function(d_b)__b.Transparency=1
a_b.Enabled=false;_c:AddItem(__b,a_b.Lifetime)__b.hit:Play()
local _ab,aab=dc.canPlayerDamageTarget(dba,d_b)
if _ab then if d_a then
cc:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",aab,__b.Position,"ability",self.id,"boulder",_aa)end;delay(0.1,function()
bca(__b.Position,dda,aab)end)end end,function(d_b)return CFrame.Angles(
math.pi/2,0,0)end,dda,true,1)end;local dca=c_a["mouse-target-position"]
local _da=dd.makeIgnoreList{b_a,aba}local ada=caa.PrimaryPart.Position;cca(ada,dca,_da)wait(0.1)if d_a then
cc:fire("{51252262-788E-447C-A950-A8E92643DAEA}",false)
cc:invoke("{C8F2171C-1C77-4D97-89FD-DBA03550755B}",a_a.id,"end")end end end;return a_a