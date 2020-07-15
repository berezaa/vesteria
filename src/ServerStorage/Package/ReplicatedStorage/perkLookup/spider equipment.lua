local ba=require(game.ReplicatedStorage.modules)
local ca=ba.load("network")local da=ba.load("utilities")local _b=92;local ab=52
local bb={sharedValues={layoutOrder=0,subtitle="Equipment Perk",color=Color3.fromRGB(147,40,234)},perks={["causticwounds"]={title="Caustic Wounds",description="Basic attacks inflict poison damage.",onDamageGiven=function(cb,db,_c,ac,bc)
local cc=game.Players:GetPlayerFromCharacter(cb.Parent)if not cc then return end
local dc=ca:invoke("{E465467C-BAB6-411A-B0AB-4EF4B37914E9}",cc,1)if dc.id~=ab then return end
if ac:FindFirstChild("poisoned")==nil and
bc.sourceType=="equipment"then
if
ac and
ac:FindFirstChild("health")and ac:FindFirstChild("maxHealth")then
if ac.health.Value>0 then
local _d,ad=require(game.ReplicatedStorage.modules.network):invoke("{964385B0-1F06-4732-A494-F5D6F84ABC61}",ac,"poison",{duration=3,healthLost=
1 *bc.damage},cb,"perk",52)
if _d then local bd=Instance.new("BoolValue")bd.Name="poisoned"
bd.Parent=ac;game.Debris:AddItem(bd,3)
da.playSound("bubbles",ac)local cd=script.poison:Clone()cd.Parent=ac;cd:Emit(50)
cd.Enabled=true
spawn(function()wait(3)if cd then cd.Enabled=false end end)game.Debris:AddItem(cd,5)end;return _d end end end end},["webbedshots"]={title="Webbed Shots",description="Ranged attacks slow enemies.",onDamageGiven=function(cb,db,_c,ac,bc)
local cc=game.Players:GetPlayerFromCharacter(cb.Parent)if not cc then return end
local dc=ca:invoke("{E465467C-BAB6-411A-B0AB-4EF4B37914E9}",cc,1)if dc.id~=_b then return end
if ac and ac:FindFirstChild("health")and
ac:FindFirstChild("maxHealth")then
if ac.health.Value>0 then
local _d,ad=require(game.ReplicatedStorage.modules.network):invoke("{964385B0-1F06-4732-A494-F5D6F84ABC61}",ac,"empower",{duration=3,modifierData={walkspeed_totalMultiplicative=
-0.35}},ac,"perk",92)if _d then local bd=script.slow:Clone()bd.Parent=ac;bd:Emit(30)
game.Debris:AddItem(bd,3)end;return true end end end},["venombomb"]={title="Venom Bomb",description="Magic bombs leave behind damaging venom.",apply=function(cb)
cb.VENOM_BOMB=true end},["manathief"]={title="Mana Thief",description="Basic attacks steal Mana.",onDamageGiven=function(cb,db,_c,ac,bc)
if
bc.sourceType=="equipment"then
if ac and cb:FindFirstChild("mana")and
cb:FindFirstChild("maxMana")then
if ac:FindFirstChild("mana")and
ac:FindFirstChild("maxMana")then
cb.mana.Value=math.clamp(cb.mana.Value+5,0,cb.maxMana.Value)
ac.mana.Value=math.clamp(ac.mana.Value-5,0,ac.maxMana.Value)return true else
cb.mana.Value=math.clamp(cb.mana.Value+2,0,cb.maxMana.Value)end end end end}}}return bb