local ab=game:GetService("ReplicatedStorage")
local bb=ab:WaitForChild("abilityAnimations")local cb=require(ab:WaitForChild("modules"))
local db=cb.load("projectile")local _c=cb.load("placeSetup")
local ac=cb.load("client_utilities")local bc=cb.load("network")local cc=cb.load("damage")
local dc=game:GetService("HttpService")
local _d={id=18,manaCost=50,name="Dark Binding",image="rbxassetid://2528902271",description="Bind your enemy's soul to do your bidding.",damageType="magical",castType="skill-shot",castingAnimation=bb.rock_throw_upper_loop,animationName={"rock_throw_upper","rock_throw_lower"},windupTime=0.2,maxRank=5,cooldown=2,projectileSpeed=45,projectileGravityMultipler=0.0001,statistics={[1]={damageMultiplier=2,manaCost=50,range=40,cooldown=10}}}
function _d._serverProcessDamageRequest(ad,bd)return bd,"physical","magical"end
function _d:onCastingBegan__client(ad)
if
not ad or not ad:FindFirstChild("entity")or
not ad.entity:FindFirstChild("AnimationController")then return end
local bd=ad.entity.AnimationController:LoadAnimation(self.castingAnimation)bd:Play()local cd=ab.rockToThrow:Clone()
cd.Name="CASTING_PROJECTION_ROCK"cd.Anchored=false;cd.Parent=ad.entity
local dd=Instance.new("Motor6D")dd.Part0=cd;dd.Part1=ad.entity["RightHand"]dd.C1=CFrame.new(0,
-cd.Size.Y/2,0)dd.Parent=cd
local __a=bc:invoke("{CA61CBF0-3B04-4617-8D2D-50C80D51AB19}",ad.entity)local a_a=__a["1"]and __a["1"].manifest;if a_a then
a_a.Transparency=1 end;return cd end
function _d:onCastingEnded__client(ad)
if
not ad or not ad:FindFirstChild("entity")or
not ad.entity:FindFirstChild("AnimationController")then return end;for dd,__a in
pairs(ad.entity.AnimationController:GetPlayingAnimationTracks())do
if __a.Animation==self.castingAnimation then __a:Stop()end end;if
ad.entity:FindFirstChild("CASTING_PROJECTION_ROCK")then
ad.entity.CASTING_PROJECTION_ROCK:Destroy()end
local bd=bc:invoke("{CA61CBF0-3B04-4617-8D2D-50C80D51AB19}",ad.entity)local cd=bd["1"]and bd["1"].manifest
if cd then cd.Transparency=0 end end
function _d:execute(ad,bd,cd,dd)
if not ad:FindFirstChild("entity")then return end
local __a=bc:invoke("{CA61CBF0-3B04-4617-8D2D-50C80D51AB19}",ad.entity)local a_a=__a["1"]and __a["1"].manifest;if a_a then
a_a.Transparency=0 end
local b_a=script.upperHandChain:Clone()
do b_a.Parent=ad.entity["RightUpperArm"]
local caa=Instance.new("Weld")caa.Part0=b_a;caa.Part1=b_a.Parent;caa.Parent=b_a end;local c_a=script.handChain:Clone()do
c_a.Parent=ad.entity["RightHand"]local caa=Instance.new("Weld")caa.Part0=c_a;caa.Part1=c_a.Parent
caa.Parent=c_a end;for caa,daa in
pairs(self.animationName)do
local _ba=ad.entity.AnimationController:LoadAnimation(bb[daa])_ba:Play()end;if
cd then
bc:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",true)end;wait(self.windupTime)if not
ad:FindFirstChild("entity")then return end
if a_a then a_a.Transparency=0 end
local d_a=game.ReplicatedStorage.rockToThrow:Clone()d_a.Parent=_c.getPlaceFolder("entities")
local _aa=ad.entity["RightHand"].Position
local aaa,baa=db.getUnitVelocityToImpact_predictiveByAbilityExecutionData(_aa,self.projectileSpeed,bd,self.projectileGravityMultipler)
db.createProjectile(_aa,aaa,self.projectileSpeed,d_a,function(caa,daa)
game:GetService("Debris"):AddItem(d_a,2 /30)b_a:Destroy()c_a:Destroy()
if cd then
bc:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",false)
if caa then
local _ba,aba=cc.canPlayerDamageTarget(game.Players.LocalPlayer,caa)if _ba and aba then
bc:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",aba,daa,"ability",self.id,nil,dd)end end end end,
nil,nil,nil,self.projectileGravityMultipler)end;return _d