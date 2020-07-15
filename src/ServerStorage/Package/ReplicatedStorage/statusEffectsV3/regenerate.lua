local _a={description="Heal over time."}
local aa=game:GetService("ReplicatedStorage")local ba=require(aa.modules)local ca=ba.load("events")function _a.__onStatusEffectBegan(da,_b)
end;function _a.__onStatusEffectEnded(da,_b)end
function _a.__onStatusEffectTick(da,_b)local ab=
da.data.amount/da.data.duration;local bb=da.entity
if bb then
local cb={amount=ab*_b,isImmuneToReduction=false}ca.fireEventLocal("beforeEntityHealed",bb,cb)bb.Humanoid.Health=
bb.Humanoid.Health+cb.amount
print('heal in tick',_b,cb.amount)ca.fireEventLocal("afterEntityHealed",bb,cb)end end;return _a