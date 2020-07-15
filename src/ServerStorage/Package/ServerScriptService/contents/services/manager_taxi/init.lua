local cb=game:GetService("ReplicatedStorage")
local db=require(cb:WaitForChild("modules"))local _c=db.load("network")local ac=db.load("utilities")local bc
local function cc()
bc=workspace:FindFirstChild("Taximan Dave",true)if not bc then return end;local __a=script.dialogue:Clone()
__a.Parent=bc.UpperTorso end
_c:create("{19502DA2-D3DF-4B47-9C3D-1901CA66820E}","BindableFunction","OnInvoke",cc)cc()
local function dc(__a,a_a,b_a)if not bc then return end;if(not __a.Character)or
(not __a.Character.PrimaryPart)then return end
if
(
__a.Character.PrimaryPart.Position-bc.PrimaryPart.Position).magnitude>=100 then return end
local c_a=_c:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",__a)if not c_a then return false end;local d_a=c_a.locations[a_a]if
d_a and d_a.spawns and d_a.spawns[b_a]then
_c:invoke("{B8DB181F-39DB-4695-BAAB-5AF049CC046D}",__a,tonumber(a_a),b_a,
nil,"taxi")end end
_c:create("{DB56D367-BDA8-48A4-B6F5-D042CC5A3AD4}","RemoteFunction","OnServerInvoke",dc)local _d=5
local ad={portFidelio={name="Port Fidelio",id=2546689567},warriorStronghold={name="Warrior Stronghold",id=2470481225},treeOfLife={name="Tree of Life",id=3112029149},nilgarf={name="Nilgarf",id=2119298605},mushtown={name="Mushtown",id=2064647391},hog={name="The Gauntlet",id=3360349837,condition=function(__a)
local a_a=_c:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",__a)if a_a.flags.completedGauntlet then return true else
return false,"Sorry, haven't been able to get up that way since the bandits moved in."end end},guildHall={priceOverride=10,name="Guild Hall",id=4653017449,condition=function(__a)
local a_a=__a:FindFirstChild("guildId")
if(not a_a)or(a_a.Value=="")then return false,"You're not in a guild, silly!"end;a_a=a_a.Value
local b_a=_c:invoke("{E27BCFB9-6E3A-43F2-B2B7-5DCE385BD801}",__a,a_a)
if not b_a then return false,"Couldn't find your guild data, silly!"end;if b_a.level<3 then
return false,"Sorry, I don't do work for small-time guilds. Get a level 3 guild, silly!"end
if not b_a.hallLocation then return
false,"Uh, you might want to have a guild hall first, silly!"end;return true end,travelFunction=function(__a)
local a_a=__a:FindFirstChild("guildId")if not a_a then return end;a_a=a_a.Value;if a_a==""then return end
_c:invoke("{D93DBFF1-1A80-43FD-8B9A-80056868C1ED}",{__a},a_a)end}}
local function bd(__a,a_a,b_a)if not ad[__a]then
error("Invalid connection: "..__a.." is not a valid destination.")end;if not ad[a_a]then
error("Invalid connection: "..a_a..
" is not a valid destination.")end;local c_a=ad[__a]if
not c_a.connections then c_a.connections={}end
c_a.connections[a_a]=b_a;local d_a=ad[a_a]
if not d_a.connections then d_a.connections={}end;d_a.connections[__a]=b_a end;bd("nilgarf","mushtown",2)
bd("nilgarf","portFidelio",3)bd("nilgarf","warriorStronghold",4)
bd("nilgarf","treeOfLife",3)bd("nilgarf","guildHall",1)bd("portFidelio","hog",2)local function cd(__a)for a_a,b_a in
pairs(ad)do if b_a.id==__a then return a_a,b_a end end;return
nil end
local function dd(__a)
local a_a,b_a=cd(ac.originPlaceId(game.PlaceId))if not(a_a and b_a)then
error("Attempted to get taxi data in a place without taxi data.")end;local c_a={}local d_a={}
local function _aa(baa,caa,daa)local _ba=true
local aba=nil;if caa.condition then _ba,aba=caa.condition(__a)end
table.insert(d_a,{id=caa.id,name=caa.name,price=
(b_a.priceOverride)or(caa.priceOverride)or(daa*_d),enabled=_ba,reason=aba,travelFunction=caa.travelFunction})end;local aaa={{id=a_a,distance=0}}
while#aaa>0 do local baa=aaa[1].id
local caa=ad[baa]local daa=aaa[1].distance;table.remove(aaa,1)
if not c_a[baa]then
c_a[baa]=true;if baa~=a_a then _aa(baa,caa,daa)end
for _ba,aba in
pairs(caa.connections or{})do table.insert(aaa,{id=_ba,distance=daa+aba})end end end;return d_a end
_c:create("{64E664EF-B9C3-4E1C-808E-AAA2BB26BD45}","RemoteFunction","OnServerInvoke",dd)return{}