local ba=game:GetService("HttpService")
local ca=game:GetService("ReplicatedStorage")local da=require(ca.modules)local _b=da.load("network")
local ab=require(script.verify)script.verify:Destroy()
local function bb(cb,db)
if
string.sub(db,1,1)=="$"and
string.len(db)>6 and string.len(db)<10 then
if game.MarketplaceService:PlayerOwnsAsset(cb,2376885433)then
local _c=ab.Verify(cb,db)if _c then return _c end end end end
_b:create("{840FF608-DD62-4F28-9840-FBA87D59FF69}","RemoteFunction","OnServerInvoke",bb)return{}