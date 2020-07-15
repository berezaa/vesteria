local da={}local _b=game:GetService("HttpService")
local ab=game.ReplicatedStorage;local bb=require(ab.modules)local cb=bb.load("network")
local db=bb.load("utilities")local _c=bb.load("ability_utilities")
local ac=require(ab.abilityLookup)
function da.abilityKeyPressed(bc)local cc=game.Players.LocalPlayer;local dc=cc.Character
local _d=dc.PrimaryPart;if not cc or not dc or not _d or not bc then
return false,"nill player/abilityId"end;local ad=ac[bc]if not ad then
return false,"invalid_abilityId"end;local bd,cd=_c.canPlayerCast(cc,bc)
if bd then
print(
"Player CAN cast ability with id: "..tostring(bc))local dd=_b:GenerateGUID()local __a=db.safeJSONEncode(dd)
local a_a=cc:GetMouse().Hit.Position;local b_a=tick()local c_a={}
local d_a={caster=cc,casterCharacter=dc,casterRoot=_d,casterStates=c_a,castTick=b_a,abilityId=bc,abilityGuid=dd,abilityGuidJSON=__a,targetPosition=a_a}ad:execute(d_a,true)
cb:invoke("requestAbilityStateUpdate","begin",d_a)else warn(cd)end end;function da.init()end;return da