local d={}
d.suffixes={"k","M","B","T","qd","Qn","sx","Sp","O","N","de","Ud","DD","tdD","qdD","QnD","sxD","SpD","OcD","NvD","Vgn","UVg","DVg","TVg","qtV","QnV","SeV","SPG","OVG","NVG","TGN","UTG","DTG","tsTG","qtTG","QnTG","ssTG","SpTG","OcTG","NoTG","QdDR","uQDR","dQDR","tQDR","qdQDR","QnQDR","sxQDR","SpQDR","OQDDr","NQDDr","qQGNT","uQGNT","dQGNT","tQGNT","qdQGNT","QnQGNT","sxQGNT","SpQGNT","OQQGNT","NQQGNT","SXGNTL"}
local function _a(ba)local ca=ba<0;ba=math.abs(ba)local da=false
for _b,ab in pairs(d.suffixes)do
if not
(ba>=10 ^ (3 *_b))then ba=ba/10 ^ (3 * (_b-1))
local bb=(
string.find(tostring(ba),".")and string.sub(tostring(ba),4,4)~=".")ba=string.sub(tostring(ba),1,(bb and 4)or 3)..
(d.suffixes[_b-1]or"")da=true
break end end
if not da then local _b=math.floor(ba)ba=tostring(_b)end;if ca then return"-"..ba end;return ba end
function d.setLabelAmount(ba,ca,da)local _b=false;if ca<0 then _b=true;ca=math.abs(ca)end
if da and
da.costType and da.costType~="money"then
ba.icon.Image=da.icon or""
ba.amount.TextColor3=da.textColor or Color3.new(1,1,1)ba.amount.Text=_a(ca)else
if ca>=10 ^6 then
ba.icon.Image="rbxassetid://2536432897"ba.amount.TextColor3=Color3.fromRGB(255,236,123)if
ca>=10 ^8 then
ba.amount.Text=tostring(math.floor(ca/10 ^6))else
ba.amount.Text=tostring(math.floor(ca/10 ^5)/10)end elseif ca>=10 ^3 then
ba.icon.Image="rbxassetid://2535600034"ba.amount.TextColor3=Color3.fromRGB(223,223,223)if
ca>=10 ^5 then
ba.amount.Text=tostring(math.floor(ca/10 ^3))else
ba.amount.Text=tostring(math.floor(ca/10 ^2)/10)end else
ba.icon.Image="rbxassetid://2535600080"ba.amount.TextColor3=Color3.fromRGB(255,170,149)
ba.amount.Text=tostring(math.floor(ca))end end
if _b then ba.amount.Text="-"..ba.amount.Text end
local ab=
game.TextService:GetTextSize(ba.amount.Text,ba.amount.TextSize,ba.amount.Font,Vector2.new(0,0)).X+2
local bb=ba:FindFirstChild("padding")and ba.padding.Value or 0
ba.amount.Size=UDim2.new(0,ab+bb,ba.amount.Size.Y.Scale,
ba.amount.Size.Y.Offset+bb)end;d.labels={}local aa=0
function d.subscribeToPlayerMoney(ba)local ca
ba.MouseEnter:connect(function()
if aa>999 then if not
ba.Parent:FindFirstChild("exactMoney")then return end;local da=tick()ca=da
ba.Parent.exactMoney.Visible=true;wait(10)
if ca==da then ba.Parent.exactMoney.Visible=false end end end)
ba.MouseLeave:connect(function()if
not ba.Parent:FindFirstChild("exactMoney")then return end
ba.Parent.exactMoney.Visible=false end)table.insert(d.labels,ba)end
function d.init(ba)local ca=ba.network
function d.subscribeToPlayerMoney(_b)
local ab=ca:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","gold")d.setLabelAmount(_b,ab)aa=ab
if
_b.Parent:FindFirstChild("exactMoney")then _b.Parent.exactMoney.Text=math.floor(aa)
local bb=game.TextService:GetTextSize(_b.Parent.exactMoney.Text,_b.Parent.exactMoney.TextSize,_b.Parent.exactMoney.Font,Vector2.new(0,0)).X
_b.Parent.exactMoney.Size=UDim2.new(0,bb+16 +10,0,26 +10)local cb
_b.MouseEnter:connect(function()if aa>999 then local db=tick()cb=db
_b.Parent.exactMoney.Visible=true;wait(10)
if cb==db then _b.Parent.exactMoney.Visible=false end end end)
_b.MouseLeave:connect(function()_b.Parent.exactMoney.Visible=false end)end;table.insert(d.labels,_b)end
local function da(_b,ab)
if _b=="gold"then aa=ab
for bb,cb in pairs(d.labels)do d.setLabelAmount(cb,ab)
if
cb.Parent:FindFirstChild("exactMoney")then cb.Parent.exactMoney.Text=math.floor(aa)
local db=game.TextService:GetTextSize(cb.Parent.exactMoney.Text,cb.Parent.exactMoney.TextSize,cb.Parent.exactMoney.Font,Vector2.new(0,0)).X
cb.Parent.exactMoney.Size=UDim2.new(0,db+16 +10,0,26 +10)end end end end
da("gold",ca:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","gold"))d.subscribeToPlayerMoney(script.Parent)
ca:connect("{B5BFDE4F-1C2E-4D65-ACB4-277DB309BF6D}","Event",da)end;return d