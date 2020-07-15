local d=require(game.ReplicatedStorage.modules)
local _a=d.load("network")
local aa={id=1,name="Regeneration",activeEffectName="Regenerating",styleText="Regenerating health.",description="",image="rbxassetid://2528902271"}
function aa.execute(ba,ca,da)
local _b=ba.statusEffectModifier.healthToHeal or 10;local ab=ba.statusEffectModifier.duration or 5
local bb=ca:FindFirstChild("health")local cb=ca:FindFirstChild("maxHealth")
if bb and cb then bb.Value=math.clamp(bb.Value+
_b/ab/da,0,cb.Value)end end;return aa