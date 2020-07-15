
local b={sharedValues={layoutOrder=0,subtitle="Equipment Perk",color=Color3.fromRGB(171,47,86)},perks={["airborne"]={title="Airborne",description="1.5x Basic Attack damage while jumping.",onDamageGiven=function(c,d,_a,aa,ba)
if
c:FindFirstChild("state")and c.state.Value=="jumping"then if
ba.sourceType=="equipment"then ba.damage=ba.damage*1.5 end end end},["poisonblink"]={title="Spore Cloud",description="Blink releases a cloud of poisonous spores."},["bounceback"]={title="Bounceback",description="15x Ability Knockback"}}}return b