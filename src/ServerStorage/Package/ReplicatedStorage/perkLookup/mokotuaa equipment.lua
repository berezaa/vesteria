local bb=require(game.ReplicatedStorage.modules)
local cb=bb.load("network")local db=bb.load("tempData")local _c=bb.load("events")local function ac(cd)return
"perk_rhythmDamage_"..cd end;local function bc(cd)
return"perk_rhythmStun_"..cd end
local function cc(cd)return"perk_rhythmDefense_"..cd end;local function dc(cd)return"perk_rhythmMana_"..cd end;local function _d(cd)return
"perk_rhythmSplinter_"..cd end;local function ad(cd)
return"perk_rhythmAttackSpeed_"..cd end
local bd={sharedValues={layoutOrder=0,subtitle="Equipment Perk",color=Color3.fromRGB(235,131,82)},perks={["rhythmDamage"]={title="Rhythmic Ferocity",description="Every 4th basic attack deals extra damage.",onEquipped=function(cd,dd,__a)if
__a~="1"then return end;local a_a={hits=0}
a_a.guid=_c:registerForEvent("playerWillDealDamage",function(b_a,c_a)
if b_a~=cd then return end;if c_a.sourceType~="equipment"then return end
a_a.hits=a_a.hits+1
if a_a.hits==4 then a_a.hits=0;c_a.damage=c_a.damage*2 end end)db:set(cd,ac(__a),a_a)end,onUnequipped=function(cd,dd,__a)if
__a~="1"then return end;local a_a=db:get(cd,ac(__a))
_c:deregisterFromEvent(a_a.guid)db:delete(cd,ac(__a))end},["rhythmStun"]={title="Rhythmic Concussion",description="Every 4th basic attack hit stuns the victim.",onEquipped=function(cd,dd,__a)
local a_a={hits=0}
a_a.guid=_c:registerForEvent("playerWillDealDamage",function(b_a,c_a)if b_a~=cd then return end;if
c_a.sourceType~="equipment"then return end;local d_a=cd.Character;if not d_a then return end
local _aa=d_a.PrimaryPart;if not _aa then return end;a_a.hits=a_a.hits+1
if a_a.hits==4 then a_a.hits=0
cb:invoke("{964385B0-1F06-4732-A494-F5D6F84ABC61}",c_a.target,"stunned",{duration=1,modifierData={walkspeed_totalMultiplicative=
-1}},_aa,"equipment",213)end end)db:set(cd,bc(__a),a_a)end,onUnequipped=function(cd,dd,__a)
local a_a=db:get(cd,bc(__a))_c:deregisterFromEvent(a_a.guid)
db:delete(cd,bc(__a))end},["rhythmDefense"]={title="Rhythmic Tenacity",description="Every 4th hit suffered deals half damage.",onEquipped=function(cd,dd,__a)
local a_a={hits=0}
a_a.guid=_c:registerForEvent("playerWillTakeDamage",function(b_a,c_a)if b_a~=cd then return end;a_a.hits=a_a.hits+1
if
a_a.hits==4 then a_a.hits=0;c_a.damage=c_a.damage/2 end end)db:set(cd,cc(__a),a_a)end,onUnequipped=function(cd,dd,__a)
local a_a=db:get(cd,cc(__a))_c:deregisterFromEvent(a_a.guid)
db:delete(cd,cc(__a))end},["rhythmMana"]={title="Rhythmic Invocation",description="Every 4th ability used costs no mana.",onEquipped=function(cd,dd,__a)
local a_a={uses=0}
a_a.guid=_c:registerForEvent("playerWillUseAbility",function(b_a,c_a)if b_a~=cd then return end;a_a.uses=a_a.uses+1;if
a_a.uses==4 then a_a.uses=0;c_a.manaCost=0 end end)db:set(cd,dc(__a),a_a)end,onUnequipped=function(cd,dd,__a)
local a_a=db:get(cd,dc(__a))_c:deregisterFromEvent(a_a.guid)
db:delete(cd,dc(__a))end},["rhythmSplinter"]={title="Rhythmic Splintering",description="Only every 4th shot uses an arrow.",onEquipped=function(cd,dd,__a)if
__a~="1"then return end;local a_a={uses=0}
a_a.guid=_c:registerForEvent("playerWillUseArrow",function(b_a,c_a)
if b_a~=cd then return end;a_a.uses=a_a.uses+1;if a_a.uses==4 then a_a.uses=0;c_a.needsArrow=true else
c_a.needsArrow=false end end)db:set(cd,_d(__a),a_a)end,onUnequipped=function(cd,dd,__a)if
__a~="1"then return end;local a_a=db:get(cd,_d(__a))
_c:deregisterFromEvent(a_a.guid)db:delete(cd,_d(__a))end},["rhythmAttackSpeed"]={title="Rhythmic Acceleration",description="Every 4th hit temporarily boosts attack speed.",onEquipped=function(cd,dd,__a)if
__a~="1"then return end;local a_a={hits=0}
a_a.guid=_c:registerForEvent("playerWillDealDamage",function(b_a,c_a)
if b_a~=cd then return end;if c_a.sourceType~="equipment"then return end;local d_a=cd.Character;if
not d_a then return end;local _aa=d_a.PrimaryPart;if not _aa then return end
a_a.hits=a_a.hits+1
if a_a.hits==4 then a_a.hits=0
cb:invoke("{964385B0-1F06-4732-A494-F5D6F84ABC61}",_aa,"empower",{duration=2,modifierData={attackSpeed=0.25}},_aa,"item",210)end end)db:set(cd,ad(__a),a_a)end,onUnequipped=function(cd,dd,__a)if
__a~="1"then return end;local a_a=db:get(cd,ad(__a))
_c:deregisterFromEvent(a_a.guid)db:delete(cd,ad(__a))end}}}return bd