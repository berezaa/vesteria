
local bc=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")local cc=game:GetService("Debris")
local dc=game:GetService("RunService")
local _d=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local ad=_d.load("network")local bd=_d.load("damage")
local cd=_d.load("placeSetup")local dd=_d.load("tween")
local __a=_d.load("ability_utilities")local a_a=_d.load("effects")local b_a=_d.load("detection")
local c_a=cd.awaitPlaceFolder("entities")
local d_a={id=43,name="Shadow Flurry",image="rbxassetid://4079577011",description="Assault the area in front of you with your shadow. (Requires dagger.)",mastery="More damage.",maxRank=10,statistics=__a.calculateStats{maxRank=10,static={cooldown=10},staggered={damageMultiplier={first=1,final=2,levels={2,3,5,6,8,9}},strikeCount={first=4,final=7,levels={4,7,10},integer=true}},pattern={manaCost={base=6,pattern={2,2,5}}}},windupTime=0.25,securityData={playerHitMaxPerTag=6,isDamageContained=true},equipmentTypeNeeded="dagger"}
local function _aa(caa)local daa=Instance.new("Model")
for _ba,aba in
pairs(caa:GetDescendants())do
if aba:IsA("BasePart")then local bba=aba:Clone()
for cba,dba in pairs(bba:GetChildren())do if(not
dba:IsA("SpecialMesh"))then dba:Destroy()end end;bba.Anchored=true
if bba.Transparency<1 then bba.Color=Color3.new(0,0,0)
bba.Transparency=0.5;bba.Material=Enum.Material.SmoothPlastic end;bba.Parent=daa
if aba==caa.PrimaryPart then daa.PrimaryPart=bba end end end;return daa end
local function aaa(caa,daa)for _ba,aba in pairs(caa:GetDescendants())do
if aba:IsA("BasePart")then daa(aba)end end end;local function baa(caa,daa,_ba)return caa+ (daa-caa)*_ba end
function d_a._serverProcessDamageRequest(caa,daa)if
caa=="strike"then return daa,"physical","aoe"end end
function d_a:validateDamageRequest(caa,daa)return(caa-daa).magnitude<=8 end
function d_a:execute(caa,daa,_ba,aba)local bba=caa.PrimaryPart;if not bba then return end
local cba=ad:invoke("{CA61CBF0-3B04-4617-8D2D-50C80D51AB19}",caa.entity)local dba=cba["1"]and cba["1"].manifest
if not dba then return end
local _ca=caa.entity.AnimationController:LoadAnimation(bc["dagger_execute"])_ca:Play()local aca=script.slash:Clone()aca.Parent=bba
aca:Play()cc:AddItem(aca,aca.TimeLength)
delay(self.windupTime-0.1,function()
local __b=script.dark:Clone()__b.Parent=bba;__b:Play()
cc:AddItem(__b,__b.TimeLength)end)wait(self.windupTime)local bca=_aa(caa.entity)local cca=(bba.CFrame*CFrame.new(0,0,
-6)).Position
local dca=8;local _da=dca^2
local function ada()if not _ba then return end
local __b=bd.getDamagableTargets(game.Players.LocalPlayer)
for a_b,b_b in pairs(__b)do local c_b=b_b.Position-cca
local d_b=c_b.X^2 +c_b.Z^2;if d_b<=_da then
ad:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",b_b,b_b.position,"ability",self.id,"strike",aba)end end end
local bda=daa["ability-statistics"]["strikeCount"]local cda={}
for strikeNumber=1,bda do local __b=bca:Clone()
local a_b=(math.pi*2)* ( (strikeNumber-1)/bda)local b_b=12;local c_b=math.cos(a_b)*b_b;local d_b=6
local _ab=math.sin(a_b)*b_b
__b:SetPrimaryPartCFrame(CFrame.new(cca+Vector3.new(c_b,d_b,_ab),cca))
aaa(__b,function(aab)local bab=aab.Transparency;aab.Transparency=1
dd(aab,{"Transparency"},bab,0.25)end)__b.Parent=c_a;table.insert(cda,__b)end;local dda=0.25
for __b,a_b in pairs(cda)do local b_b=Instance.new("Part")
b_b.CFrame=a_b.PrimaryPart.CFrame
dd(b_b,{"CFrame"},b_b.CFrame+ (cca-a_b.PrimaryPart.Position),dda,Enum.EasingStyle.Quad,Enum.EasingDirection.In)
a_a.onHeartbeatFor(dda,function(c_b,d_b,_ab)a_b:SetPrimaryPartCFrame(b_b.CFrame)
if _ab==1 then
aaa(a_b,function(aab)
dd(aab,{"Transparency"},1,0.25)end)cc:AddItem(a_b,0.25)ada()end end)wait(dda*0.5)end end;return d_a