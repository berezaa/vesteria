
local cb=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")local db=game:GetService("Debris")
local _c=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local ac=_c.load("network")local bc=_c.load("damage")
local cc=_c.load("placeSetup")local dc=_c.load("tween")local _d=_c.load("ability_utilities")
local ad=_c.load("effects")local bd=cc.awaitPlaceFolder("entities")
local cd={id=55,name="Blade Spin",image="rbxassetid://4465750273",description="Become a whirlwind of blades, constantly damaging enemies near you. (Requires dual melee weapons.)",mastery="More damage and longer duration.",layoutOrder=0,maxRank=10,statistics=_d.calculateStats{maxRank=10,static={radius=12},staggered={damageMultiplier={first=2.5,final=3.5,levels={2,5,8}},duration={first=2.5,final=5,levels={3,6,9}},cooldown={first=12,final=9,levels={4,7,10}}},pattern={manaCost={base=10,pattern={2,3,3}}}},windupTime=0.75,securityData={playerHitMaxPerTag=64,isDamageContained=true,projectileOrigin="character"},disableAutoaim=true,equipmentTypeRequired="sword"}local dd=0.2;function cd._serverProcessDamageRequest(__a,a_a)
if __a=="spin"then return a_a*dd,"physical","aoe"end end
function cd:execute(__a,a_a,b_a,c_a)
local d_a=__a.PrimaryPart;if not d_a then return end;local _aa=__a:FindFirstChild("entity")if not _aa then
return end
local aaa=_aa:FindFirstChild("AnimationController")if not aaa then return end
local baa=ac:invoke("{CA61CBF0-3B04-4617-8D2D-50C80D51AB19}",__a.entity)if not baa then return end;local caa=baa["1"]local daa=baa["11"]if
(not caa)or(not daa)then return end
if(caa.baseData.equipmentType~="sword")or(
daa.baseData.equipmentType~="sword")then return end;local _ba=aaa:LoadAnimation(cb.bladespin_start)
local aba=aaa:LoadAnimation(cb.bladespin_loop)local bba=aaa:LoadAnimation(cb.bladespin_end)_ba:Play()
local cba=script.channel:Clone()cba.Parent=d_a;cba:Play()
db:AddItem(cba,cba.TimeLength)wait(self.windupTime)aba:Play(0)
local dba=a_a["ability-statistics"]local _ca=dba.duration;local aca=dba.radius^2
do local cca=_ca+0.75;local dca={}
for radiusFactor=0.25,1,0.25 do local ada=
math.pi*2 *math.random()
for bda,cda in pairs{0,math.pi}do local dda=
dba.radius*radiusFactor;if bda==1 then dda=dda-2 end
local __b=script.crescent:Clone()__b.Size=Vector3.new(dda*2,0.05,dda)
local a_b=__b.Transparency;__b.Transparency=1;dc(__b,{"Transparency"},a_b,0.25)
delay(
cca-0.25,function()dc(__b,{"Transparency"},1,0.25)wait(0.25)
__b:Destroy()end)__b.Parent=bd
table.insert(dca,{part=__b,rotOffset=ada+cda})end end;local _da=math.pi*8
ad.onHeartbeatFor(cca,function(ada,bda,cda)
for dda,__b in pairs(dca)do local a_b=dda-2
local b_b=bda*_da+__b.rotOffset
__b.part.CFrame=
CFrame.new(d_a.Position)*CFrame.new(0,a_b,0)*CFrame.Angles(0,b_b,0)*CFrame.new(0,0,-
__b.part.Size.Z/2)end end)end;local bca=0
while bca<_ca do
spawn(function()local dca=3
for soundNumber=1,dca do local _da=script.slash:Clone()_da.PlaybackSpeed=
0.8 +0.4 *math.random()_da.Parent=d_a
_da:Play()
db:AddItem(_da,_da.TimeLength/_da.PlaybackSpeed)wait(dd/dca)end end)local cca=wait(dd)bca=bca+cca
if b_a then
local dca=bc.getDamagableTargets(game.Players.LocalPlayer)
for _da,ada in pairs(dca)do local bda=ada.Position-d_a.Position
local cda=bda.X^2 +bda.Z^2;if(cda<aca)and(bda.Y^2 <aca)then
ac:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",ada,ada.position,"ability",self.id,"spin",c_a)end end end end;aba:Stop(0)bba:Play(0)end;return cd