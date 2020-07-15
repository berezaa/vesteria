
local cb=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")local db=game:GetService("Debris")
local _c=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local ac=_c.load("network")local bc=_c.load("damage")
local cc=_c.load("placeSetup")local dc=_c.load("tween")local _d=_c.load("ability_utilities")
local ad=_c.load("effects")local bd=_c.load("detection")
local cd=cc.awaitPlaceFolder("entities")
local dd={id=60,name="Ferocious Assault",image="rbxassetid://3006001373",description="Unleash a furious sequence of blows. (Requires dual melee weapons.)",mastery="More damage.",layoutOrder=0,maxRank=10,statistics={[1]={animationSpeed=100,manaCost=15,cooldown=12,damageMultiplier=1},[2]={manaCost=17,damageMultiplier=1.125},[3]={manaCost=19,damageMultiplier=1.5},[4]={manaCost=21,damageMultiplier=1.625},[5]={animationSpeed=150,manaCost=27},[6]={manaCost=29,damageMultiplier=1.75},[7]={manaCost=31,damageMultiplier=1.},[8]={manaCost=33,damageMultiplier=1.875},[9]={animationSpeed=200,manaCost=39},[10]={manaCost=41,damageMultiplier=2}},securityData={playerHitMaxPerTag=64,isDamageContained=true,projectileOrigin="character"},disableAutoaim=true}function dd._serverProcessDamageRequest(__a,a_a)
if __a=="strike"then return a_a,"physical","direct"end end
function dd:tryDealWeaponDamage(__a,a_a,b_a,c_a)
local d_a=bc.getDamagableTargets(__a)
for _aa,aaa in pairs(d_a)do
if not c_a[aaa]then
local baa=bd.projection_Box(aaa.CFrame,aaa.Size,b_a.Position)
if bd.boxcast_singleTarget(b_a.CFrame,b_a.Size*2,baa)then c_a[aaa]=true
ac:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",aaa,baa,"ability",self.id,"strike",a_a)end end end end
function dd:execute(__a,a_a,b_a,c_a)local d_a=__a.PrimaryPart;if not d_a then return end
local _aa=__a:FindFirstChild("entity")if not _aa then return end
local aaa=_aa:FindFirstChild("AnimationController")if not aaa then return end
local baa=ac:invoke("{CA61CBF0-3B04-4617-8D2D-50C80D51AB19}",__a.entity)if not baa then return end;local caa=baa["1"]local daa=baa["11"]if
(not caa)or(not daa)then return end
if(caa.baseData.equipmentType~="sword")or(
daa.baseData.equipmentType~="sword")then return end;caa=caa.manifest;daa=daa.manifest
if(not caa)or(not daa)then return end;local _ba=caa:FindFirstChild("Trail")
local aba=daa:FindFirstChild("Trail")if(not _ba)or(not aba)then return end;local bba=false;local cba=false;local dba={}
local _ca={}
local aca=a_a["ability-statistics"]["animationSpeed"]/100;local bca=aaa:LoadAnimation(cb.ferocious_assault)local cca
do cca={}for ada,bda in
pairs{caa,daa}do local cda=script.emitter:Clone()cda.Parent=bda
table.insert(cca,cda)end end
local function dca(ada)
if ada=="rightStart"then _ba.Enabled=true;bba=true;dba={}
local bda=script.slash:Clone()bda.Parent=caa;bda:Play()
db:AddItem(bda,bda.TimeLength)elseif ada=="rightStop"then _ba.Enabled=false;bba=false elseif ada=="leftStart"then aba.Enabled=true
cba=true;_ca={}local bda=script.slash:Clone()bda.Parent=daa
bda:Play()db:AddItem(bda,bda.TimeLength)elseif ada=="leftStop"then
aba.Enabled=false;cba=false end end;bca.KeyframeReached:Connect(dca)
bca:Play(nil,nil,aca)if b_a then
ac:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",true)end;local _da=bca.Length/aca
while _da>0 do
local ada=wait(0.05)_da=_da-ada
if b_a then if bba then
self:tryDealWeaponDamage(game.Players.LocalPlayer,c_a,caa,dba)end;if cba then
self:tryDealWeaponDamage(game.Players.LocalPlayer,c_a,daa,_ca)end end end;for ada,bda in pairs(cca)do bda.Enabled=false
db:AddItem(bda,bda.Lifetime.Max)end;if b_a then
ac:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",false)end end;return dd