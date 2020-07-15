local da=require(game.ReplicatedStorage.modules)
local _b=da.load("network")local ab=da.load("damage")local bb=da.load("utilities")
local cb=require(game.ReplicatedStorage.itemData)local function db(bc)return(bc>6)and(bc<18)end
local function _c(bc)return not db(bc)end
local ac={sharedValues={layoutOrder=0,subtitle="Equipment Perk",color=BrickColor.new("Cool yellow").Color},perks={["overdraw"]={title="Overdraw",description="Fires larger arrows further."},["you look great"]={title="You Look Great",description="Not even the Sun can stand in your way."},["solar wind"]={title="Solar Wind",description="Increases the range of Blink."},["one good hit"]={title="One Good Hit",description="Execute instantly kills low health non-resilient foes."},["aftershock"]={title="Aftershock",description="Adds shockwaves to Ground Slam."},["dunes wisdom"]={title="Dunes Wisdom",description="Regenerate extra mana during the day.",onTimeOfDayUpdated=function(bc,cc,dc)if
not db(cc)then return end;local _d=bc.Character;if not _d then return end
local ad=_d.PrimaryPart;if not ad then return end;local bd=ad:FindFirstChild("mana")
local cd=ad:FindFirstChild("maxMana")if not(bd and cd)then return end;local dd=6
bd.Value=math.min(cd.Value,bd.Value+dd*dc)end},["apogee"]={title="Apogee",description="During the day, deal more damage and regenerate health.",onDamageGiven=function(bc,cc,dc,_d,ad)if
db(game.Lighting.ClockTime)then ad.damage=ad.damage*1.2 end end,onTimeOfDayUpdated=function(bc,cc,dc)if
not db(cc)then return end;local _d=bc.Character;if not _d then return end
local ad=_d.PrimaryPart;if not ad then return end;local bd=ad:FindFirstChild("health")
local cd=ad:FindFirstChild("maxHealth")local dd=ad:FindFirstChild("state")
if not(bd and cd and dd)then return end;if dd.Value=="dead"then return end;local __a=20
bd.Value=math.min(cd.Value,bd.Value+__a*dc)end},["midnight"]={title="Midnight",description="During the night, deal more damage and move faster.",onDamageGiven=function(bc,cc,dc,_d,ad)if
_c(game.Lighting.ClockTime)then ad.damage=ad.damage*1.2 end end,onTimeOfDayUpdated=function(bc,cc,dc)if
not _c(cc)then return end;local _d=bc.Character;if not _d then return end
local ad=_d.PrimaryPart;if not ad then return end
_b:invoke("{964385B0-1F06-4732-A494-F5D6F84ABC61}",ad,"empower",{hideInStatusBar=true,duration=5,modifierData={walkspeed=4}},ad,"perk")end},["twilight"]={title="Twilight",description="Empower Magic Missile to launch Mana Stars."},["acidic arrows"]={title="Acidic Arrows",description="Critical strikes on enemies create a splash of acid.",onCritGiven=function(bc,cc,dc,_d,ad)
local bd=game:GetService("Players"):GetPlayerFromCharacter(bc.Parent)if not bd then return end
local cd=(ad.sourceType=="equipment")and(ad.category=="projectile")if not cd then return end;local dd=12
_b:fireAllClients("{CE48DECD-5222-4973-B0AB-89B662749171}","acidSplash",{position=ad.position,radius=dd,duration=0.25})
local function __a(b_a)local c_a=b_a:FindFirstChild("entityType")if not c_a then return end
c_a=c_a.Value
local d_a={damage=ad.damage/2,sourceType="perk",sourceId=0,damageType="magical",sourcePlayerId=bd.UserId}
if c_a=="monster"then
_b:invoke("{031BE66E-62B6-4583-B409-DCB61C0DA077}",bd,b_a,d_a)else
_b:invoke("{AC8B16AA-3BD2-4B7F-B12C-5558B8857745}",bd,b_a,d_a)end end;local a_a=dd*dd
for b_a,c_a in
pairs(ab.getDamagableTargets(game.Players.LocalPlayer))do local d_a=c_a.Position-ad.position;local _aa=
d_a.X*d_a.X+d_a.Y*d_a.Y+d_a.Z*d_a.Z
if _aa<a_a then __a(c_a)end end end},["dunes courage"]={title="Dunes Courage",description="Deal more damage to non-human Dunes enemies.",onDamageGiven=function(bc,cc,dc,_d,ad)
local bd=_d.Name
if
bd=="Stingtail"or bd=="Deathsting"or bd=="Sandwurm"or bd=="Scarab"then ad.damage=ad.damage*1.2 end end},["bloodcraze"]={title="Bloodcraze",description="Critical hits grant a stacking attack speed bonus.",onCritGiven=function(bc,cc,dc,_d,ad)
local bd=bb.getEntityGUIDByEntityManifest(bc)if not bd then return false end
local cd=_b:invoke("{12EE4C27-216F-434F-A9C3-6771B8E6F6CF}",bd)local dd=0
for __a,a_a in pairs(cd)do if a_a.statusEffectType=="bloodcrazed"then
dd=a_a.statusEffectModifier.stacks end end;dd=math.min(dd+1,6)
_b:invoke("{964385B0-1F06-4732-A494-F5D6F84ABC61}",bc,"empower",{stacks=dd,duration=8,modifierData={attackSpeed=0.05 *dd}},bc,"item",229)end},["weakening venom"]={title="Weakening Venom",description="Melee attacks mark a target to take more damage.",onDamageGiven=function(bc,cc,dc,_d,ad)
if
ad.sourceType=="equipment"then
_b:invoke("{964385B0-1F06-4732-A494-F5D6F84ABC61}",_d,"weakened by venom",{duration=5},bc,"item",230)elseif ad.sourceType=="ability"then
local bd,cd=_b:invoke("{743BBCD2-A0CD-415E-A96E-F6ED58AADD73}",_d,"weakened by venom")if bd then ad.damage=ad.damage*1.5
_b:invoke("{7598B3E9-CD41-4A4D-845C-1A19A35ACBFB}",cd.statusEffectGUID)end end end},["just in case"]={title="Just in Case",description="Increase damage when above 80% health. Does not work in off-hand.",onDamageGiven=function(bc,cc,dc,_d,ad)
local bd=249
local cd=game.Players:GetPlayerFromCharacter(bc.Parent)if not cd then return end
local dd=_b:invoke("{E465467C-BAB6-411A-B0AB-4EF4B37914E9}",cd,1)if dd.id~=bd then return end;local __a=bc:FindFirstChild("health")
local a_a=bc:FindFirstChild("maxHealth")if not(__a and a_a)then return end;local b_a=__a.Value/a_a.Value;if b_a<
0.8 then return end;ad.damage=ad.damage*1.1 end},["not like this"]={title="Not Like This",description="Dramatically increase damage when below 20% health. Works in off-hand.",onDamageGiven=function(bc,cc,dc,_d,ad)
local bd=bc:FindFirstChild("health")local cd=bc:FindFirstChild("maxHealth")
if not(bd and cd)then return end;local dd=bd.Value/cd.Value;if dd>0.2 then return end
ad.damage=ad.damage*1.4 end},["living blade"]={title="Living Blade",description="Basic attacks deal magic damage and scale accordingly.",onDamageGiven=function(bc,cc,dc,_d,ad)if
cc=="equipment"then ad.damageType="magical"end end}}}return ac