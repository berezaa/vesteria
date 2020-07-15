local ca=require(game.ReplicatedStorage.modules)
local da=ca.load("network")local _b=ca.load("tempData")local ab=ca.load("events")
local bb=ca.load("utilities")local cb=Random.new()
local db={sharedValues={layoutOrder=0,subtitle="Equipment Perk",color=Color3.fromRGB(234,102,84)},perks={["inoculation"]={title="Inoculation",description="10% chance to heal 200 HP when damaged.",onDamageTaken=function(_c,ac,bc,cc,dc)
if
dc.damage>1 and cb:NextNumber()<=0.1 then wait(0.1)
pcall(function()
bb.healEntity(cc,cc,200)local _d=script.heal:Clone()_d.Parent=cc;_d:Emit(30)
game.Debris:AddItem(_d,3)bb.playSound("item_heal",cc)end)end end},["resonance"]={title="Resonance Charms",description="Restore 35% of damage taken as MP.",onDamageTaken=function(_c,ac,bc,cc,dc)
if
dc.damage>1 then wait(0.1)
pcall(function()local _d=math.floor(dc.damage*0.35)
local ad
if cc.mana.Value+_d>cc.maxMana.Value then ad=cc.maxMana.Value-
cc.mana.Value else ad=_d end
cc.mana.Value=math.min(cc.mana.Value+_d,cc.maxMana.Value)
if ad>=10 then local bd=script.manaEmitter:Clone()bd.Parent=cc
bd:Emit(math.floor(math.clamp(
3 *ad^ (1 /2),1,50)))game.Debris:AddItem(bd,3)
bb.playSound("item_mana",cc,nil,{volume=0.3,maxDistance=100,emitterSize=7})end end)end end},["reckless"]={title="Reckless",description="Deal and recieve 120% damage.",onDamageTaken=function(_c,ac,bc,cc,dc)dc.damage=
dc.damage*1.2 end,onDamageGiven=function(_c,ac,bc,cc,dc)
dc.damage=dc.damage*1.2 end}}}return db