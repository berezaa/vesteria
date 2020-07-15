
local b={[2064647391]={{response="Where's your horse?",dialogue={{text="Taximan Dave doesn't need a horse, silly!"}}}},[2546689567]={{response="Where's your swimsuit?",dialogue={{text="Taximan Dave doesn't get to have fun, silly!"}}}},[2470481225]={{response="Where's your coat?",dialogue={{text="Taximan Dave doesn't get cold, silly!"}}}},[4653017449]={{response="Where's your cart?",dialogue={{text="Taximan Dave doesn't need a cart, silly!"}}}}}
return
{sound="npc_male_ahaa",id="startTalkingTo",canExit=true,dialogue={{text="Greetings Adventurer! You know me, the one and only Taximan Dave! I can take you to any location that you've visited before."}},options=function(c)
local d=c.utilities;local _a=c.network
local aa={{canExit=true,id="choose",response="Let's go somewhere.",responseButtonColor=Color3.fromRGB(234,174,53),dialogue={{text="Alright Adventurer! Where would you like me to take ya?"}},taxiMenu=true,options={{id="undiscovered",dialogue={{text="There's a lot of places that I don't know how to get to yet. Maybe if you discover them you can tell me how to get there!"}},moveToId="choose"},{id="spawns",dialogue=function(ca,da)return
{{text="Alright! Where in"},{text=da.taxiLocationName,font=Enum.Font.SourceSansBold},{text="should I take ya?"}}end,canExit=true,options=function(ca,da)
local _b=_a:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","locations")local ab=_b[da.taxiLocation]local bb={}
for cb,db in pairs(ab.spawns)do
if db.text then
table.insert(bb,{response=db.text,dialogue=function(_c)
local ac=_a:invokeServer("{DB56D367-BDA8-48A4-B6F5-D042CC5A3AD4}",da.taxiLocation,cb)
if ac then return{{text="Giddy up, lets go!"}}else return
{{text="I can't help you right now. Sorry!"}}end end})end end;return bb end}}}}local ba=b[d.originPlaceId(game.PlaceId)]
if ba then for ca,da in
pairs(ba)do table.insert(aa,da)end end;return aa end}