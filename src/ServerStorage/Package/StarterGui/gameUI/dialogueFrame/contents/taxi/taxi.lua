local b={}
function b.init(c)local d=c.network;local _a=c.utilities
local aa=d:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","locations")local ba;local ca=script.Parent.contents;local da=0
for ab,bb in pairs(aa)do local cb=tonumber(ab)
if
cb~=game.PlaceId then local db=_a.originPlaceId(cb)
local _c=script.Parent.sample:Clone()_c.Name=ab
_c.LayoutOrder=math.floor((os.time()-bb.visited)^0.25)_c.location.Text="-"
_c.BGHolder.BG.Image=
"https://www.roblox.com/Thumbs/Asset.ashx?width=768&height=432&assetId="..db;_c.BGHolder.BG.Visible=true
spawn(function()
local ac=game.MarketplaceService:GetProductInfo(db,Enum.InfoType.Asset)if ac then _c.location.Text=ac.Name end end)_c.location.Visible=true;_c.Parent=ca;_c.Active=true
_c.Selectable=true;_c.Visible=true;da=da+1;_c.location.TextWrapped=true
_c.Activated:connect(function()
d:invoke("{53738740-803A-4D59-8661-4E64C37B334E}","spawns",{taxiLocation=ab,taxiLocationName=_c.location.Text})end)end end
if da<12 then
for i=da,11 do local ab=script.Parent.sample:Clone()
ab.Name="empty"ab.BGHolder.BG.Visible=false;ab.location.Visible=false
ab.empty.Visible=true;ab.LayoutOrder=999;local bb=Instance.new("StringValue")
bb.Name="tooltip"bb.Value="Undiscovered location"bb.Parent=ab;ab.Parent=ca;ab.Active=true
ab.Selectable=true;ab.Visible=true;da=da+1
ab.Activated:connect(function()
d:invoke("{53738740-803A-4D59-8661-4E64C37B334E}","undiscovered")end)end end;local _b=math.ceil(da/2)
ca.CanvasSize=UDim2.new(0,0,0,_b*
(
ca.UIGridLayout.CellSize.Y.Offset+ca.UIGridLayout.CellPadding.Y.Offset)+10)end;return b