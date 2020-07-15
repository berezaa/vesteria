
local bc=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")local cc=game:GetService("Debris")
local dc=game:GetService("RunService")
local _d=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local ad=_d.load("network")local bd=_d.load("damage")
local cd=_d.load("placeSetup")local dd=_d.load("tween")
local __a=_d.load("ability_utilities")local a_a=_d.load("effects")local b_a=_d.load("projectile")
local c_a=cd.awaitPlaceFolder("entities")
local d_a={id=42,name="Prism Trap",image="rbxassetid://4079577550",description="Place a trap at your feet that will immobilize the first enemy to step on it and explode.",mastery="More damage.",maxRank=10,statistics=__a.calculateStats{maxRank=10,static={cooldown=10,trapDuration=8},staggered={damageMultiplier={first=2,final=3,levels={2,5,8}},radius={first=12,final=20,levels={3,6,9}},rootDuration={first=3,final=6,levels={4,7,10}},traps={first=1,final=3,levels={1,5,10},integer=true}},pattern={manaCost={base=10,pattern={2,1,3}}}},windupTime=0.6,securityData={playerHitMaxPerTag=16,isDamageContained=true,projectileOrigin="character"}}
local _aa={BrickColor.new("Bright red"),BrickColor.new("Bright orange"),BrickColor.new("Bright yellow"),BrickColor.new("Bright green"),BrickColor.new("Bright blue"),BrickColor.new("Bright violet")}local aaa=#_aa
function createEffectPart()local caa=Instance.new("Part")caa.Anchored=true
caa.CanCollide=false;caa.TopSurface=Enum.SurfaceType.Smooth
caa.BottomSurface=Enum.SurfaceType.Smooth;return caa end;function d_a._serverProcessDamageRequest(caa,daa)
if caa=="trap"then return daa,"magical","projectile"end end
local function baa(caa)return
caa:FindFirstChild("resilient")~=nil end
function d_a:execute_server(caa,daa,_ba,aba)if not _ba then return end;local bba=caa.Character;if not bba then return end
local cba=bba.PrimaryPart;if not cba then return end
local dba=daa["ability-statistics"]["trapDuration"]
local _ca=daa["ability-statistics"]["rootDuration"]local aca=daa["ability-statistics"]["radius"]
local bca=aca^2;local cca=2;local dca=cca^2
local function _da(bda)local cda=Instance.new("Model")
local dda=script.trap:Clone()dda.Position=bda;dda.locator.Position=dda.Position
dda.gyro.CFrame=CFrame.new()dda.Parent=cda;local __b=math.random(1,aaa)local a_b=dda:Clone()a_b.Position=
bda+Vector3.new(0,0.25,0)
a_b.locator.Position=a_b.Position
a_b.spinner.AngularVelocity=-a_b.spinner.AngularVelocity;a_b.Parent=cda;local b_b=math.random(1,aaa)
a_a.onHeartbeatFor(dba+_ca,function(aab,bab,cab)
local dab=aaa*2;local _bb=math.floor(bab*dab)local abb=(_bb+__b)%aaa+1;local bbb=(_bb+
b_b)%aaa+1;dda.BrickColor=_aa[abb]
a_b.BrickColor=_aa[bbb]end)cda.Parent=c_a;local c_b=false
local function d_b(aab)c_b=true
ad:fireAllClients("{04BC293A-E219-4FFD-AFDC-1E71EA3B6921}",daa,self.id,bda,aca)
for dab,_bb in pairs(bd.getDamagableTargets(caa))do
local abb=_bb.position-bda;local bbb=abb.X^2 +abb.Z^2;if bbb<=bca then
ad:fire("{9AF17239-FE35-48D5-B980-F2FA7DF2DBBC}",caa,_bb,_bb.Position,"ability",self.id,"trap",aba)end end;local bab=script.hit:Clone()bab.Parent=aab;bab:Play()
cc:AddItem(bab,bab.TimeLength)if baa(aab)then cda:Destroy()return end;local cab=aab.Position+
Vector3.new(0,4,0)
if
aab:FindFirstChildOfClass("BodyPosition")then local dab=Instance.new("Part")dab.Size=Vector3.new()
dab.CanCollide=false;dab.Transparency=1;dab.CFrame=aab.CFrame;dab.Parent=c_a
local _bb=Instance.new("WeldConstraint")_bb.Part0=dab;_bb.Part1=aab;_bb.Parent=dab
local abb=Instance.new("BodyPosition")abb.MaxForce=Vector3.new(1e12,1e12,1e12)abb.Position=cab
abb.Parent=dab
delay(_ca,function()dab:Destroy()cda:Destroy()end)else local dab=Instance.new("BodyPosition")
dab.MaxForce=Vector3.new(1e12,1e12,1e12)dab.Position=cab;dab.Parent=aab;delay(_ca,function()dab:Destroy()
cda:Destroy()end)end;dda.locator.Position=cab+Vector3.new(0,1,0)a_b.locator.Position=
cab+Vector3.new(0,-1,0)end
local function _ab()local aab=nil;local bab=dca
for cab,dab in pairs(bd.getDamagableTargets(caa))do
local _bb=dab.Position-bda;local abb=_bb.X^2 +_bb.Z^2;if abb<=bab then aab=dab;bab=abb end end;if aab then d_b(aab)end end
spawn(function()while not c_b do _ab()wait(0.05)end end)
delay(dba,function()if not c_b then c_b=true;cda:Destroy()end end)end;local ada=daa["ability-statistics"]["traps"]
if ada==1 then
_da(
cba.Position+Vector3.new(0,-1.5,0))elseif ada==2 then local bda=cba.CFrame
local cda=bda.Position+Vector3.new(0,-1.5,0)_da(cda+bda.RightVector*4)_da(cda-
bda.RightVector*4)elseif ada==3 then local bda=cba.CFrame;local cda=6;local function dda(a_b)a_b=a_b-
math.pi/2
return(bda*
CFrame.new(math.cos(a_b)*cda,-1.5,math.sin(a_b)*cda)).Position end
local __b=math.pi*2;_da(dda(__b*0 /3))_da(dda(__b*1 /3))_da(dda(
__b*2 /3))end end
function d_a:execute_client(caa,daa,_ba)local aba=createEffectPart()
aba.Shape=Enum.PartType.Ball;aba.Position=daa;aba.Size=Vector3.new()
aba.Material=Enum.Material.Neon;aba.Parent=c_a;local bba=1
dd(aba,{"Size","Transparency"},{
Vector3.new(1,1,1)*_ba*2,1},bba)local cba=0
a_a.onHeartbeatFor(bba,function(dba)cba=cba-dba;if cba<=0 then cba=0.1
aba.BrickColor=_aa[math.random(1,#_aa)]end end)cc:AddItem(aba,bba)end
function d_a:execute(caa,daa,_ba,aba)local bba=caa.PrimaryPart;if not bba then return end
local cba=caa:FindFirstChild("entity")if not cba then return end;local dba=cba:FindFirstChild("LeftHand")if
not dba then return end
local _ca=caa.clientHitboxToServerHitboxReference.Value;if not _ca then return end
local aca=caa.entity.AnimationController:LoadAnimation(bc["mage_slash_down"])aca:Play()local bca=Instance.new("Attachment")
bca.Name="TrickTrapEmitterAttachment"bca.Parent=dba;local cca=script.whimsyEmitter:Clone()
cca.Parent=bca
delay(self.windupTime-cca.Lifetime.Max,function()cca.Enabled=false end)if _ba then
ad:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",true)end;wait(self.windupTime)
aca:Stop(0.25)if _ba then
ad:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",false)end
local dca=script.cast:Clone()dca.Parent=dba;dca:Play()
cc:AddItem(dca,dca.TimeLength)if _ba then
ad:invokeServer("{7EE4FFC2-5AFD-40AB-A7C0-09FE74A020C3}",daa,self.id,aba)end end;return d_a