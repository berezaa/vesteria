
local b={id=307,name="Poison Arrow",rarity="Common",image="rbxassetid://2744225103",description="For shooting things. But with poison.",canStack=true,canBeBound=false,canAwaken=false,equipmentType="arrow",equipmentPosition=12,buyValue=10,sellValue=3,stackSize=999,isImportant=false,category="equipment"}
function b.onHit(c,d,_a)
local aa,ba=require(game.ReplicatedStorage.modules.network):invoke("{964385B0-1F06-4732-A494-F5D6F84ABC61}",d,"poison",{duration=3,healthLost=
0.5 *_a.damage},c,"perk",52)end;return b