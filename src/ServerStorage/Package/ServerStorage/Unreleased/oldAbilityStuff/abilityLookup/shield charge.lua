
local db=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")local _c=game:GetService("Debris")
local ac=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local bc=ac.load("network")local cc=ac.load("damage")
local dc=ac.load("placeSetup")local _d=ac.load("tween")local ad=ac.load("ability_utilities")
local bd=ac.load("effects")local cd=ac.load("detection")local dd=ac.load("physics")
local __a=dc.awaitPlaceFolder("entities")
local a_a={id=61,name="Shield Charge",image="rbxassetid://1193579056",description="Rush forward with your shield, bashing enemies and stunning them. (Requires shield.)",mastery="More damage.",layoutOrder=0,maxRank=10,statistics=ad.calculateStats{maxRank=10,static={cooldown=5,distance=24},staggered={damageMultiplier={first=2,final=3,levels={2,5,8}},cooldown={first=10,final=6,levels={3,6,9}},stunDuration={first=1,final=2,levels={4,7,10}}},pattern={manaCost={base=15,pattern={2,2,3}}}},securityData={playerHitMaxPerTag=64,isDamageContained=true,projectileOrigin="character"},windupTime=0.25,duration=0.5}function a_a._serverProcessDamageRequest(b_a,c_a)
if b_a=="strike"then return c_a,"physical","direct"end end
function a_a:execute_server(b_a,c_a,d_a,_aa)
if not d_a then return end;local aaa=b_a.Character;if not aaa then return end;local baa=aaa.PrimaryPart
if not baa then return end;local caa=c_a["ability-statistics"]
bc:invoke("{964385B0-1F06-4732-A494-F5D6F84ABC61}",_aa,"stunned",{duration=caa.stunDuration,modifierData={walkspeed_totalMultiplicative=
-1}},baa,"ability",a_a.id)end
function a_a:tryDealWeaponDamage(b_a,c_a,d_a,_aa,aaa,baa)local caa=cc.getDamagableTargets(b_a)
for daa,_ba in pairs(caa)do
if
not _aa[_ba]then
local aba=cd.projection_Box(_ba.CFrame,_ba.Size,d_a.Position)
if cd.boxcast_singleTarget(d_a.CFrame,d_a.Size*2,aba)then _aa[_ba]=true
local bba=script.bonk:Clone()bba.Parent=_ba;bba:Play()
_c:AddItem(bba,bba.TimeLength)
if aaa then
bc:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",_ba,aba,"ability",self.id,"strike",c_a)
bc:fireServer("{7170F8E2-9C53-42D1-A10A-E8383DB284E0}",baa,self.id,_ba)end end end end end
function a_a:execute(b_a,c_a,d_a,_aa)local aaa=b_a.PrimaryPart;if not aaa then return end
local baa=b_a:FindFirstChild("entity")if not baa then return end
local caa=baa:FindFirstChild("AnimationController")if not caa then return end
local daa=bc:invoke("{CA61CBF0-3B04-4617-8D2D-50C80D51AB19}",b_a.entity)if not daa then return end;local _ba=daa["11"]if not _ba then return end;if
_ba.baseData.equipmentType~="shield"then return end;_ba=_ba.manifest;if not _ba then
return end;local aba={}
local bba=caa:LoadAnimation(db.shield_charge)bba:Play()local cba;if d_a then
cba=bc:invoke("{952A8B11-BC62-42C8-9898-0A3A6E1B00C4}")
bc:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",true)end
wait(self.windupTime)
if d_a then
local _ca=(cba.magnitude>0.01)and cba.unit or aaa.CFrame.LookVector;local aca=c_a["ability-statistics"]["distance"]local bca=aca/
self.duration;local cca=_ca*bca
bc:invoke("{C43ACD39-75B4-40F2-B91B-74FAD166EE59}",cca)local dca=game.Players.LocalPlayer.Character
if
dca and dca.PrimaryPart then
local _da=dca.PrimaryPart:FindFirstChild("hitboxGyro")
if _da then _da.CFrame=CFrame.new(Vector3.new(),cca)end;dd:setWholeCollisionGroup(dca,"passthrough")end end;local dba=self.duration;while dba>0 do local _ca=wait(0.05)dba=dba-_ca
self:tryDealWeaponDamage(game.Players.LocalPlayer,_aa,_ba,aba,d_a,c_a)end
if d_a then
bc:invoke("{C43ACD39-75B4-40F2-B91B-74FAD166EE59}",Vector3.new())
bc:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",false)local _ca=game.Players.LocalPlayer.Character;if _ca then
dd:setWholeCollisionGroup(_ca,"characters")end end end;return a_a