
local b={perks={["holymagic"]={layoutOrder=1,title="Holy Magic",subtitle="Cleric Perk",color=Color3.fromRGB(235,198,48),description="Mage Ability upgrade.",class="cleric"},["colosseum"]={layoutOrder=2,title="Colosseum Blessing",subtitle="Location Perk",color=Color3.fromRGB(226,166,61),description="Take 50% less damage.",condition=function(c)
return
game.PlaceId==2496503573 or game.PlaceId==4042381342 end,apply=function(c)
c.damageTakenMulti=c.damageTakenMulti*0.5 end},["battydagger"]={layoutOrder=1,title="Nocturnal Flight",color=Color3.fromRGB(77,34,89),description="Shunpo has no cooldown."}}}return b