
local _b=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")local ab=game:GetService("Debris")
local bb=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local cb=bb.load("network")local db=bb.load("damage")
local _c=bb.load("placeSetup")local ac=bb.load("tween")
local bc=_c.awaitPlaceFolder("entities")
local cc={id=33,name="Mystic Binding",image="rbxassetid://2574315061",description="Entangle a target in a mystic binding, immobilizing them.",mastery="Longer binding.",maxRank=1,statistics={[1]={cooldown=1,range=16,manaCost=0,duration=1,damageMultiplier=1.4,tier=1}},windupTime=1,securityData={playerHitMaxPerTag=64,projectileOrigin="character"},disableAutoaim=true}
function createEffectPart()local dc=Instance.new("Part")dc.Anchored=true
dc.CanCollide=false;dc.TopSurface=Enum.SurfaceType.Smooth
dc.BottomSurface=Enum.SurfaceType.Smooth;return dc end
function lightningSegment(dc,_d,ad)local bd=0.5;local cd=createEffectPart()cd.BrickColor=ad
cd.Material=Enum.Material.Neon;local dd=(_d-dc).magnitude;local __a=(dc+_d)/2
cd.Size=Vector3.new(0.25,0.25,dd)cd.CFrame=CFrame.new(__a,_d)cd.Parent=bc
ac(cd,{"Transparency"},1,bd)ab:AddItem(cd,bd)end
function cc:execute_server(dc,_d,ad)if not dc.Character then return end
local bd=dc.Character.PrimaryPart;if not bd then return end;local cd=bd.Position
local dd=_d["ability-statistics"]["range"]local __a=_d["ability-statistics"]["duration"]
local a_a=game.Players:GetPlayerByUserId(_d["cast-player-userId"])
if cd and a_a then local b_a=db.getDamagableTargets(a_a)local c_a={}
for d_a,_aa in pairs(b_a)do local aaa=(
_aa.Position-cd).magnitude;if aaa<=dd then
cb:invoke("{964385B0-1F06-4732-A494-F5D6F84ABC61}",_aa,"mystically bound",{duration=__a},bd,"ability",self.id)end end end end
function cc:execute(dc,_d,ad,bd)local cd=dc.PrimaryPart;if not cd then return end
local dd=cb:invoke("{CA61CBF0-3B04-4617-8D2D-50C80D51AB19}",dc.entity)local __a=dd["1"]and dd["1"].manifest;if not __a then return end
local a_a=__a:FindFirstChild("magic")if not a_a then return end;local b_a=a_a:FindFirstChild("castEffect")if not
b_a then return end;b_a.Enabled=true
local c_a=dc.entity.AnimationController:LoadAnimation(_b["mage_holdInFront"])c_a:Play()if ad then
cb:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",true)end;wait(self.windupTime)if ad then
cb:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",false)end;c_a:Stop(0.25)b_a.Enabled=false
local d_a=script.cast:Clone()d_a.Parent=cd;d_a:Play()
ab:AddItem(d_a,d_a.TimeLength)
cb:invokeServer("{0650EB64-0176-4935-9226-F83AA6EF8464}",_d,self.id,bd)end;return cc