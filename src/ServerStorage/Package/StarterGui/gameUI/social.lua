local _a={}_a.friends={}
_a.places={["Main Menu"]=2376885433,["Free Demo"]=2015602902,["Mushtown"]=2064647391,["Mushroom Forest"]=2035250551,["Mushroom Grotto"]=2060360203,["The Clearing"]=2060556572,["Altdorf"]=2119298605,["Farmlands"]=2180867434,["Enchanted Forest"]=2260598172,["Redwood Pass"]=2376890690,["Seaside Path"]=2093766642,["Testing Environment"]=2061558182}local aa=_a.places;local function ba(da)
for _b,ab in pairs(aa)do if ab==da then return true end end end
local ca=game.Players.LocalPlayer
function _a.init(da)
local function _b()
local ab,bb=pcall(function()local cb=ca:GetFriendsOnline()local db={}for _c,ac in pairs(cb)do
if
ac.IsOnline and ac.PlaceId and ba(ac.PlaceId)then db[ac.VisitorId]=ac end end;_a.friends=db end)
if not ab then warn("Failed to fetch online friends")warn(bb)end end
spawn(function()_b()while wait(30)do _b()end end)end;return _a