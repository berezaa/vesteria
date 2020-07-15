
local da=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local _b=da.load("network")local ab=da.load("effects")
local bb=da.load("tween")local cb=script.Sounds;local db=script.Animations;local _c=script.Effects
local ac={id=1,name="Test Ability",image="rbxassetid://2528903781",description="This is just a test buff ability",animationName={"cast","prayer"},windupTime=1,maxLevel=15,statistics={healing=5,distance=10,manaCost=30,cooldown=4,increasingStat="healing",increaseExponent=0.2},prerequisites={playerLevel=1,classRestricted=false,developerOnly=false,abilities={}}}
function ac:execute(bc,cc)local dc=bc.casterCharacter;local _d=bc.abilityGuid;if
not dc or not bc or not cc or not _d then return false end;if
not dc.PrimaryPart then return false end;local ad=dc.PrimaryPart
local bd=_b:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",dc)local cd=ab.hideWeapons(dc.entity)
if cc then
_b:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",true)
delay(self.windupTime,function()
_b:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",false)end)end
local dd=dc.entity.AnimationController:LoadAnimation(db.prayer)dd:Play()local __a=cb.cast;__a.Parent=ad;__a:Play()
game.Debris:AddItem(__a,__a.TimeLength)wait(self.windupTime)dd:Stop(0.5)cd()local a_a=cb.prayer
a_a.Parent=ad;a_a:Play()
game.Debris:AddItem(a_a,a_a.TimeLength)local b_a=bc["statistics"]["radius"]local c_a=b_a*2;return true,
self.statistics.cooldown end;function ac:execute_server(bc,cc,dc)end;return ac