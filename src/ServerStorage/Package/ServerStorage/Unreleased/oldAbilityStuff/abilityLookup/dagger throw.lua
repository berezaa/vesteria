
local ab=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local bb=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local cb=bb.load("projectile")local db=bb.load("placeSetup")
local _c=bb.load("client_utilities")local ac=bb.load("network")local bc=bb.load("damage")
local cc=db.awaitPlaceFolder("entityManifestCollection")local dc=game:GetService("HttpService")
local _d={id=10,name="Dagger Throw",image="rbxassetid://2528902271",description="Throw your dagger at an enemy!",damageType="physical",equipmentTypeNeeded="dagger",castType="skill-shot",castingAnimation=ab.rock_throw_upper_loop,windupTime=0.3,maxRank=5,cooldown=2,cost=10,projectileSpeed=150,statistics={[1]={damageMultiplier=1,range=50,cooldown=1,manaCost=15},[2]={damageMultiplier=1.15},[3]={damageMultiplier=1.3},[4]={damageMultiplier=1.45},[5]={damageMultiplier=1.7}},securityData={maxHitLockout=1,projectileOrigin="character"}}function _d._serverProcessDamageRequest(ad,bd)
if ad=="dagger-hit"then return bd,"physical","projectile"end end
function _d:onCastingBegan__client(ad)if not ad or not
ad:FindFirstChild("entity")or not
ad.entity:FindFirstChild("AnimationController")then
return end
local bd=ad.entity.AnimationController:LoadAnimation(self.castingAnimation)bd:Play()return ad.entity["RightHand"]end
function _d:onCastingEnded__client(ad)
if
not ad or not ad:FindFirstChild("entity")or
not ad.entity:FindFirstChild("AnimationController")then return end;for bd,cd in
pairs(ad.entity.AnimationController:GetPlayingAnimationTracks())do
if cd.Animation==self.castingAnimation then cd:Stop()end end end
function _d:execute(ad,bd,cd,dd)
if not ad:FindFirstChild("entity")then return end
local __a=ac:invoke("{CA61CBF0-3B04-4617-8D2D-50C80D51AB19}",ad.entity)local a_a=__a["1"]and __a["1"].manifest
if not a_a then return end
local b_a=ad.entity.AnimationController:LoadAnimation(ab.dagger_throw)b_a:Play()wait(self.windupTime)if
not ad:FindFirstChild("entity")then return end;local c_a=a_a:Clone()c_a.Anchored=true
c_a.Parent=db.getPlaceFolder("entities")local d_a=a_a.Position
local _aa,aaa=cb.getUnitVelocityToImpact_predictiveByAbilityExecutionData(d_a,self.projectileSpeed,bd)a_a.Transparency=1
cb.createProjectile(d_a,_aa,self.projectileSpeed,c_a,function(baa,caa,daa)if daa then
c_a.CFrame=
CFrame.new(caa,caa+daa)*CFrame.Angles(math.pi/2,0,0)end
game:GetService("Debris"):AddItem(c_a,1)
if cd then
if baa then
local _ba,aba=bc.canPlayerDamageTarget(game.Players.LocalPlayer,baa)if _ba and aba then
ac:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",aba,caa,"ability",self.id,"dagger-hit",dd)end end end end,function(baa)return
CFrame.Angles(
8 * ( (math.sin(baa*math.pi*2)+1)/2),0,0)end)wait(0.5)a_a.Transparency=0 end;return _d