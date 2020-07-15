
local bc=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")local cc=game:GetService("Debris")
local dc=game:GetService("RunService")local _d=game:GetService("Players")
local ad=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local bd=ad.load("network")local cd=ad.load("damage")
local dd=ad.load("placeSetup")local __a=ad.load("tween")
local a_a=ad.load("ability_utilities")local b_a=ad.load("effects")local c_a=ad.load("projectile")
local d_a=ad.load("detection")local _aa=dd.awaitPlaceFolder("entities")
local aaa={id=48,name="Smite",image="rbxassetid://4079576639",description="Send forth a crescent of holy light to damage foes.",mastery="",maxRank=10,statistics=a_a.calculateStats{maxRank=10,static={range=24},staggered={width={first=10,final=22,levels={2,5,8}},cooldown={first=6,final=3,levels={3,6,9}},damageMultiplier={first=2,final=3,levels={4,7,10}}},pattern={manaCost={base=22,pattern={3,0,5}}}},securityData={playerHitMaxPerTag=64,isDamageContained=true,projectileOrigin="character"},equipmentTypeNeeded="sword"}local baa=32
function createEffectPart()local caa=Instance.new("Part")caa.Anchored=true
caa.CanCollide=false;caa.TopSurface=Enum.SurfaceType.Smooth
caa.BottomSurface=Enum.SurfaceType.Smooth;return caa end;function aaa._serverProcessDamageRequest(caa,daa)
if caa=="smite"then return daa,"magical","projectile"end end
function aaa:execute(caa,daa,_ba,aba)
local bba=caa.PrimaryPart;if not bba then return end;local cba=caa:FindFirstChild("entity")if not cba then
return end;local dba=a_a.getCastingPlayer(daa)
if not dba then return end
local _ca=caa.entity.AnimationController:LoadAnimation(bc["basic_slash"])_ca:Play()wait(0.3)local aca=script.cast:Clone()
aca.Parent=bba;aca:Play()cc:AddItem(aca,aca.TimeLength)
local bca=daa["mouse-world-position"]local cca=bba.Position;local dca=Vector3.new(bca.X,cca.Y,bca.Z)
local _da=daa["ability-statistics"]local ada=script.crescent:Clone()local bda=ada.emitter
ada.Size=Vector3.new(0,0,0)ada.CFrame=CFrame.new(cca,dca)ada.Parent=_aa
__a(ada,{"Size"},Vector3.new(_da.width,0.05,
_da.width/2),0.25)local cda=_da.range/baa;local dda=0.25
delay(cda-dda,function()
__a(ada,{"Transparency"},1,dda)end)
local function __b(b_b)local c_b=script.hit:Clone()c_b.Parent=b_b;c_b:Play()
cc:AddItem(c_b,c_b.TimeLength)local d_b=script.spark:Clone()d_b.Size=Vector3.new()
d_b.Parent=_aa;local _ab=0.5
__a(d_b,{"Size","Transparency"},{Vector3.new(1,1,1)*12,1},_ab)
local aab=CFrame.Angles(math.pi*2 *math.random(),0,math.pi*2 *math.random())
b_a.onHeartbeatFor(_ab,function(bab,cab,dab)
d_b.CFrame=CFrame.new(b_b.Position)*aab;if dab==1 then d_b:Destroy()end end)end;local a_b={}
b_a.onHeartbeatFor(cda,function(b_b,c_b,d_b)
local _ab=ada.CFrame.LookVector*baa*b_b;local aab=ada.Position+_ab
local bab=CFrame.new((ada.Position+aab)/2,aab)
local cab=Vector3.new(_da.width,_da.width,_ab.Magnitude)
local dab=d_a.boxcast_all(cd.getDamagableTargets(dba),bab,cab)
for _bb,abb in pairs(dab)do
if not a_b[abb]then a_b[abb]=true;__b(abb)if _ba then
bd:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",abb,abb.Position,"ability",self.id,"smite",aba)end end end;ada.CFrame=ada.CFrame+_ab;if d_b==1 then bda.Enabled=false
wait(bda.Lifetime.Max)ada:Destroy()end end)end;return aaa