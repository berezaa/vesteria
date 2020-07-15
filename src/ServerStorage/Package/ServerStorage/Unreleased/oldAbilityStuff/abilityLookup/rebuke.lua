
local cb=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")local db=game:GetService("Debris")
local _c=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local ac=_c.load("network")local bc=_c.load("damage")
local cc=_c.load("placeSetup")local dc=_c.load("tween")local _d=_c.load("ability_utilities")
local ad=_c.load("effects")local bd=_c.load("utilities")
local cd=cc.awaitPlaceFolder("entities")
local dd={id=56,name="Rebuke",image="rbxassetid://4465750691",description="Strike the area with a fierce rebuke, damaging and knocking away enemies.",mastery="More damage and knockback.",layoutOrder=0,maxRank=10,statistics=_d.calculateStats{maxRank=10,static={radius=32,cooldown=16},staggered={damageMultiplier={first=2,final=3,levels={2,3,5,6,8,9}},knockback={first=15000,final=30000,levels={4,7,10}}},pattern={manaCost={base=20,pattern={2,2,4}}}},windupTime=1,securityData={playerHitMaxPerTag=64,isDamageContained=true,projectileOrigin="character"},disableAutoaim=true,equipmentTypeNeeded="sword"}
function dd._serverProcessDamageRequest(__a,a_a)if __a=="blast"then return a_a,"magical","aoe"end end;function dd._abilityExecutionDataCallback(__a,a_a)
a_a["bounceback"]=__a and
__a.nonSerializeData.statistics_final.activePerks["bounceback"]end
function dd:execute_server(__a,a_a,b_a,c_a,d_a)if
not b_a then return end
for _aa,aaa in pairs(d_a)do if a_a["bounceback"]then
bd.playSound("bounce",aaa)end
local baa=a_a["bounceback"]and 15 or 1
_d.knockbackMonster(aaa,c_a,a_a["ability-statistics"]["knockback"]*baa)end end
function dd:execute(__a,a_a,b_a,c_a)local d_a=__a.PrimaryPart;if not d_a then return end
local _aa=__a:FindFirstChild("entity")if not _aa then return end
local aaa=_aa:FindFirstChild("AnimationController")if not aaa then return end
local baa=aaa:LoadAnimation(cb.warrior_forwardDownslash)baa:Play()if b_a then
ac:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",true)end;local caa;do
local _ca=d_a.CFrame*CFrame.new(0,0,-6)caa=_ca.Position end;for _ca,aca in
pairs{script.cast1,script.cast2}do local bca=aca:Clone()bca.Parent=d_a;bca:Play()
db:AddItem(bca,bca.TimeLength)end
do local _ca=4
local aca=


CFrame.new(
caa+Vector3.new(0,-2.5,0))*CFrame.Angles(0,
math.pi*2 *math.random(),0)*CFrame.Angles(math.pi/6 *math.random(),0,0)*CFrame.Angles(0,math.pi*2 *math.random(),0)*CFrame.new(0,8,0)local bca=aca*CFrame.Angles(math.pi,0,0)
local cca=aca*
CFrame.new(0,512,0)*CFrame.Angles(math.pi,0,0)local dca=script.sword:Clone()dca.CFrame=cca;dca.Parent=cd
dc(dca,{"CFrame"},bca,self.windupTime,Enum.EasingStyle.Quad,Enum.EasingDirection.In)
delay(self.windupTime,function()dca.hit:Play()
db:AddItem(dca,dca.hit.TimeLength)dc(dca,{"Transparency"},1,_ca)end)end;wait(self.windupTime)if b_a then
ac:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",false)end
local daa=a_a["ability-statistics"]
do local _ca=1;local aca=daa.radius;local bca=aca*2 +8;local cca=3
local dca=Enum.EasingStyle.Quint;local _da=Enum.EasingDirection.Out
local ada=script.sphere:Clone()ada.Position=caa;ada.Parent=cd
dc(ada,{"Size","Transparency"},{Vector3.new(aca*2,aca/2,aca*2),1},_ca,dca,_da)
delay(_ca,function()ada.emitter.Enabled=false
wait(ada.emitter.Lifetime.Max)ada:Destroy()end)
for _=1,cca do local bda=script.ring:Clone()
bda.CFrame=CFrame.new(caa)*
CFrame.Angles(
math.pi*2 *math.random(),0,math.pi*2 *math.random())bda.Parent=cd
dc(bda,{"Size","Transparency"},{Vector3.new(bca,2,bca),1},_ca,dca,_da)db:AddItem(bda,_ca)end end;local _ba=game.Players.LocalPlayer.Character
if not _ba then return end;local aba=_ba.PrimaryPart;if not aba then return end
local bba=_d.getCastingPlayer(a_a)local cba=bc.getDamagableTargets(bba)local dba={}
for _ca,aca in pairs(cba)do
local bca=aca.Position-caa;local cca=bca.Magnitude
if cca<=daa.radius then
if b_a then
ac:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",aca,aca.position,"ability",self.id,"blast",c_a)
if
aca:FindFirstChild("entityType")and aca.entityType.Value=="monster"then table.insert(dba,aca)end end
if aca==aba then local dca=a_a["bounceback"]and 15 or 1;_d.knockbackLocalPlayer(caa,
daa.knockback*dca)end end end;if b_a then
ac:fireServer("{7170F8E2-9C53-42D1-A10A-E8383DB284E0}",a_a,self.id,caa,dba)end end;return dd