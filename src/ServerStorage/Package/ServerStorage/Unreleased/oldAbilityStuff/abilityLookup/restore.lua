
local _b=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local ab=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local bb=ab.load("projectile")local cb=ab.load("placeSetup")
local db=ab.load("client_utilities")local _c=ab.load("network")local ac=ab.load("damage")
local bc=game:GetService("HttpService")
local cc={id=20,book="mage",name="Restore",image="rbxassetid://2528901888",description="Infuse your ally with life.",mastery="Infuse yourself and your ally with life.",castType="target",windupTime=0.35,maxRank=2,cooldown=10,projectileSpeed=50,projectileGravityMultipler=0.0001,statistics={[1]={magicalStrength=1,range=50,manaCost=40,cooldown=10},[2]={magicalStrength=1.25,manaCost=60,cooldown=8}},equipmentTypeNeeded="staff"}function cc._serverProcessAbilityActivated(dc,_d,ad,bd)end
function cc._serverProcessAbilityDeactivated(dc,_d,ad,bd)end;function cc._serverProcessAbilityHit(dc,_d,ad,bd,cd)return false end
function cc:onCastingBegan__client(dc)if not dc or not
dc:FindFirstChild("entity")or not
dc.entity:FindFirstChild("AnimationController")then
return end
local _d=dc.entity.AnimationController:LoadAnimation(self.castingAnimation)_d:Play()return dc.entity["RightHand"]end
function cc:onCastingEnded__client(dc)
if
not dc or not dc:FindFirstChild("entity")or
not dc.entity:FindFirstChild("AnimationController")then return end;for _d,ad in
pairs(dc.entity.AnimationController:GetPlayingAnimationTracks())do
if ad.Animation==self.castingAnimation then ad:Stop()end end end
function cc:execute(dc,_d,ad,bd)
if not dc:FindFirstChild("entity")then return end
local cd=_c:invoke("{CA61CBF0-3B04-4617-8D2D-50C80D51AB19}",dc.entity)local dd=cd["1"]and cd["1"].manifest;if not dd or not
dd:FindFirstChild("magic")then return end
local __a=bc:GenerateGUID(false)
for aaa,baa in pairs(self.animationName)do
local caa=dc.entity.AnimationController:LoadAnimation(_b[baa])caa:Play()
if dc.PrimaryPart then local daa=script.cast:Clone()
daa.Parent=dc.PrimaryPart;if not ad then daa.Volume=daa.Volume*0.7 end
daa:Play()game.Debris:AddItem(daa,5)end end;dd.magic.castEffect.Enabled=true
wait(self.windupTime)dd.magic.castEffect.Enabled=false;if
not dc:FindFirstChild("entity")then return end
local a_a=game.ReplicatedStorage.magicBombEntity:Clone()
local b_a=_c:invoke("{037FE164-CCF7-41A0-87B1-D384E9A16236}")local c_a=dd.magic.WorldPosition
local d_a,_aa=bb.getUnitVelocityToImpact_predictiveByAbilityExecutionData(c_a,self.projectileSpeed,_d,self.projectileGravityMultipler)if not d_a then return false end
a_a.Parent=cb.getPlaceFolder("entities")
bb.createProjectile(c_a,d_a,self.projectileSpeed,a_a,function(aaa,baa)
if aaa then
local _da,ada=ac.canPlayerDamageTarget(game.Players.LocalPlayer,aaa)if _da and ada then
_c:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",ada,baa,"ability",self.id,nil,bd)end end
local caa=game.ReplicatedStorage.magicBombRing:Clone()caa.Parent=a_a
local daa=game.ReplicatedStorage.magicBombRing:Clone()daa.Parent=a_a
local _ba=game.ReplicatedStorage.magicBombRing:Clone()_ba.Parent=a_a
local aba=CFrame.Angles(2 *math.pi*math.random(),0,2 *math.pi*
math.random())
local bba=CFrame.Angles(2 *math.pi*math.random(),0,2 *math.pi*math.random())
local cba=CFrame.Angles(2 *math.pi*math.random(),0,2 *math.pi*math.random())
local dba=_d["ability-statistics"]["blast radius"]or 10;local _ca=(a_a.Mesh.Scale*0.45 *dba/10)+
Vector3.new(0.6,0.6,0.6)
local aca=script.boom:Clone()aca.Parent=a_a
aca.Volume=math.clamp(_ca.magnitude/3,0.2,1)aca.MaxDistance=aca.MaxDistance*aca.Volume;aca.EmitterSize=
aca.EmitterSize*aca.Volume;if not ad then
aca.Volume=aca.Volume*0.4 end;aca:Play()
local bca=math.clamp(_ca.magnitude/2,0.3,1)
delay(0.05 *bca,function()a_a.explosionParticles.Drag=
(2 * (_ca.X*8 -0 -160 *1.5))/ (1.5 *1.5)
a_a.explosionParticles:Emit(100)end)local cca=tick()local dca
dca=game:GetService("RunService").RenderStepped:connect(function(_da)local ada=(
tick()-cca)/ (1.5 *bca)
local bda=_ca:lerp(_ca*12,ada^ (1 /5))a_a.Mesh.Scale=bda
a_a.Rays.Size=NumberSequence.new(bda.magnitude)
a_a.Glow.Size=NumberSequence.new(bda.magnitude)caa.Size=bda*Vector3.new(1.25,0.25,1.25)
caa.CFrame=
a_a.CFrame*aba*CFrame.Angles(0,0,math.pi* (ada^0.5))daa.Size=bda*Vector3.new(1.25,0.25,1.25)
daa.CFrame=
a_a.CFrame*bba*CFrame.Angles(0,0,math.pi* (ada^0.5))_ba.Size=bda*Vector3.new(1.25,0.25,1.25)
_ba.CFrame=
a_a.CFrame*cba*CFrame.Angles(0,0,math.pi* (ada^0.5))a_a.Transparency=ada^2;caa.Transparency=0.1 +ada^ (1 /3)daa.Transparency=
0.1 +ada^ (1 /3)
_ba.Transparency=0.1 +ada^ (1 /3)end)
if baa and ad then
for _da,ada in
pairs(ac.getDamagableTargets(game.Players.LocalPlayer))do
if(ada.Position-baa).magnitude<=0.1 +_ca.X*6 then
spawn(function()
wait(0.1)
_c:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",ada,baa,"ability",self.id,"explosion",bd)end)end end end;wait(0.5 *bca)a_a.Rays.Enabled=false
a_a.Glow.Enabled=false;wait(1 *bca)dca:disconnect()caa.Transparency=1
daa.Transparency=1;_ba.Transparency=1
game:GetService("Debris"):AddItem(a_a,3 *bca)end,function(aaa)
a_a.Mesh.Scale=
Vector3.new(0.1,0.1,0.1)+Vector3.new(aaa,aaa,aaa)*1.65 end,{dc.clientHitboxToServerHitboxReference.Value},
nil,self.projectileGravityMultipler)return true end;return cc