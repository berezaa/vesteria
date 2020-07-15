
local cb=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")local db=game:GetService("Debris")
local _c=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local ac=_c.load("network")local bc=_c.load("damage")
local cc=_c.load("placeSetup")local dc=_c.load("tween")local _d=_c.load("effects")
local ad=_c.load("ability_utilities")local bd=cc.awaitPlaceFolder("entities")
local cd=game.ReplicatedStorage:WaitForChild("abilityAnimations")
local dd={id=51,name="Disengage",image="rbxassetid://2735680078",description="Leap backwards while shooting nearby targets. (Requires bow.)",mastery="",maxRank=10,windupTime=0.25,statistics=ad.calculateStats{maxRank=10,static={cooldown=4,range=16},staggered={jumpSpeed={first=50,final=150,levels={3,7}},damageMultiplier={first=1,final=1.5,levels={2,4,6,8,10}},range={first=16,final=24,levels={5,9}}},pattern={manaCost={base=5,pattern={2,1,2,3}}}},securityData={playerHitMaxPerTag=64,isDamageContained=true,projectileOrigin="character"},equipmentTypeNeeded="bow",disableAutoaim=true}
function dd._serverProcessDamageRequest(__a,a_a)if __a=="shot"then return a_a,"physical","aoe"end end
function dd:execute(__a,a_a,b_a,c_a)local d_a=__a.PrimaryPart;if not d_a then return end
local _aa=__a:FindFirstChild("entity")if not _aa then return end
local aaa=ac:invoke("{CA61CBF0-3B04-4617-8D2D-50C80D51AB19}",_aa)if not aaa then return end
aaa=aaa["1"]and aaa["1"].manifest;if not aaa then return end
local baa=_aa:FindFirstChild("AnimationController")if not baa then return end
local caa=aaa:FindFirstChild("AnimationController")if not caa then return end
if b_a then
local cca=a_a["ability-statistics"]["jumpSpeed"]local dca=workspace.CurrentCamera.CFrame
local _da=-dca.LookVector;_da=Vector3.new(_da.X,0,_da.Z)
local ada=CFrame.new(Vector3.new(0,0,0),_da)ada=ada*CFrame.Angles(math.pi/4,0,0)
local bda=ada.LookVector
ac:fire("{7EEEF31B-024D-429C-8220-4A6094CFA5B8}",bda*cca)end
baa:LoadAnimation(cd.player_tripleshot):Play(nil,nil,2)
caa:LoadAnimation(cd.bow_tripleshot):Play(nil,nil,2)local daa=script.arrow:Clone()
daa:ClearAllChildren()daa.Anchored=false;daa.Parent=bd
local _ba=aaa.slackRopeRepresentation.arrowHolder
_ba.C0=CFrame.Angles(-math.pi/2,0,0)*CFrame.new(0,
-daa.Size.Y/2 -0.2,0)_ba.Part1=daa;db:AddItem(daa,self.windupTime)local aba={}
local bba=ad.getCastingPlayer(a_a)local cba=a_a["ability-statistics"]local dba=cba.range^2
for cca,dca in
pairs(bc.getDamagableTargets(bba))do local _da=dca.Position-d_a.Position
local ada=_da.X^2 +_da.Z^2;if ada<=dba then table.insert(aba,dca)end end;local _ca=script.draw:Clone()_ca.Parent=d_a;_ca:Play()
db:AddItem(_ca,_ca.TimeLength)wait(self.windupTime)
local aca=script.shoot:Clone()aca.Parent=d_a;aca:Play()
db:AddItem(aca,aca.TimeLength)local bca=128
for cca,dca in pairs(aba)do local _da=script.arrow:Clone()
local ada=_da.trail
local function bda()_da.CFrame=CFrame.new(_da.Position,dca.Position)*
CFrame.Angles(math.pi/2,0,0)end;_da.Position=aaa.PrimaryPart.Position;bda()_da.Parent=bd
_d.onHeartbeatFor(0,function(cda)local dda=
dca.Position-_da.Position
local __b=dda.X^2 +dda.Y^2 +dda.Z^2
if __b<=4 then if b_a then
ac:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",dca,dca.Position,"ability",self.id,"shot",c_a)end;_da.Transparency=1
db:AddItem(_da,ada.Lifetime)return true else local a_b=dda.Unit
_da.CFrame=_da.CFrame+a_b*bca*cda;bda()end end)end end;return dd