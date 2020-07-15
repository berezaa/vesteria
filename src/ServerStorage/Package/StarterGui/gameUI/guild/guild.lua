local d={}function d.open()script.Parent.Visible=true end
local _a=game:GetService("HttpService")local aa={member=1,officer=2,general=3,leader=4}
function d.init(ba)local ca=ba.network
function d.open()
if not
script.Parent.Visible then
script.Parent.UIScale.Scale=(ba.input.menuScale or 1)*0.75
ba.tween(script.Parent.UIScale,{"Scale"},(ba.input.menuScale or 1),0.5,Enum.EasingStyle.Bounce)end;ba.focus.toggle(script.Parent)end
script.Parent.close.Activated:connect(function()d.open()end)d.guildData={}
local function da(bb)if bb==""then return nil end
local cb=game.ReplicatedStorage:FindFirstChild("guildDataFolder")
if cb then local db=cb:WaitForChild(bb,3)if db then
local _c=_a:JSONDecode(db.Value)return _c end end end
local function _b(bb,cb)local db=da(cb)
if db==nil then return false,"Guild data not found."end;local _c=db.members;local ac=_c[tostring(bb.userId)]if ac==nil then return false,
"Not a member of guild."end;return ac end
local function ab()
local bb=game.Players.LocalPlayer.guildId.Value;local cb=da(bb)d.guildData=cb
local db=_b(game.Players.LocalPlayer,bb)
script.Parent.Parent.inspectPlayer.content.buttons.guild.Visible=false
if cb and db then local _c=db.rank=="leader"or db.rank=="officer"or
db.rank=="general"
script.Parent.Parent.inspectPlayer.content.buttons.guild.Visible=_c;script.Parent.curve.Visible=true
script.Parent.Parent.right.buttons.openGuild.Visible=true
script.Parent.curve.intro.title.Text=cb.name
script.Parent.curve.intro.notice.value.Text=
cb.notice or"There is no notice at this time."local ac="no one!"for cc,dc in pairs(cb.members)do
if dc.rank=="leader"then ac=dc.name end end;script.Parent.curve.intro.leader.Text=
"led by "..ac
for cc,dc in
pairs(script.Parent.curve.side.members.list:GetChildren())do if dc:IsA("GuiObject")then dc:Destroy()end end;local bc=0
for cc,dc in pairs(cb.members)do
local _d=script.Parent.curve.side.members.example:Clone()_d.content.username.Text=dc.name
local ad=_d.content.level.value;ad.Text="Lvl. "..dc.level
local bd=
game.TextService:GetTextSize(ad.Text,ad.TextSize,ad.Font,Vector2.new()).X+16;ad.Parent.Size=UDim2.new(0,bd,0,20)local cd=dc.class
if cd:lower()==
"adventurer"then _d.content.level.emblem.Visible=false else
_d.content.level.emblem.Visible=true
_d.content.level.emblem.Image="rbxgameasset://Images/emblem_"..cd:lower()end;local dd=aa[dc.rank]or 0;_d.LayoutOrder=5 -dd
_d.content.rank.Image=
"rbxgameasset://Images/rank_"..dc.rank:lower()
_d.Parent=script.Parent.curve.side.members.list;_d.Visible=true;_d.Name=cc;bc=bc+1
_d.Activated:connect(function()
if _d.actions.Visible then
_d.actions.Visible=false else for b_a,c_a in
pairs(script.Parent.curve.side.members.list:GetChildren())do
if c_a:IsA("GuiObject")then c_a.actions.Visible=false;c_a.ZIndex=1 end end
_d.actions.Visible=true;_d.ZIndex=2 end end)local __a=_d.actions.exile
local a_a=aa[_b(game.Players.LocalPlayer,bb).rank]
if a_a<=dd then __a.ImageColor3=Color3.new(0.3,0.3,0.3)
__a.Active=false else
__a.Activated:connect(function()
if __a.Active then __a.Active=false
if
ba.prompting_Fullscreen.prompt(
"Are you sure you wish to EXILE "..dc.name.." from your guild?")then __a.icon.Visible=false;__a.fail.Visible=false
__a.success.Visible=false
local b_a,c_a=ca:invokeServer("{0AE9AA93-FDFB-467D-839E-EC578CA8D574}",tonumber(_d.Name))
if not b_a then
ca:fire("{97822377-6CF7-4275-B2B8-3E4E2E50F11C}",{text=c_a,textColor3=Color3.fromRGB(255,100,100)})__a.fail.Visible=true;wait(0.3)end end
if __a and __a.Parent then __a.Active=true;__a.success.Visible=false
__a.fail.Visible=false;__a.icon.Visible=true end end end)end
for b_a,c_a in pairs(aa)do local d_a=_d.actions:FindFirstChild(b_a)
if d_a then
if a_a<=dd or
a_a<=c_a or c_a==dd then
d_a.ImageColor3=Color3.new(0.3,0.3,0.3)d_a.Active=false else local _aa=tonumber(_d.Name)
d_a.Activated:connect(function()
if d_a.Active then
d_a.Active=false
if
ba.prompting_Fullscreen.prompt("Are you sure you wish to rank "..dc.name..
" to "..b_a:upper().."?")then d_a.icon.Visible=false;d_a.fail.Visible=false
d_a.success.Visible=false
local aaa,baa=ca:invokeServer("{8C82C83C-8EA5-4F8B-90BA-70CBEA15BD68}",_aa,c_a)
if not aaa then
ca:fire("{97822377-6CF7-4275-B2B8-3E4E2E50F11C}",{text=baa,textColor3=Color3.fromRGB(255,100,100)})d_a.fail.Visible=true;wait(0.3)end end
if d_a and d_a.Parent then d_a.Active=true;d_a.success.Visible=false
d_a.fail.Visible=false;d_a.icon.Visible=true end end end)end end end end
script.Parent.curve.side.members.title.Text=
bc.." ".. (bc==1 and"member"or"members")else script.Parent.curve.Visible=false
script.Parent.Parent.right.buttons.openGuild.Visible=false end end;spawn(ab)
game.Players.LocalPlayer.guildId.Changed:connect(ab)
ca:connect("{9590082C-4DE4-47CD-8548-28FED87E836A}","OnClientEvent",ab)
ca:connect("{782A106B-5F02-45F9-95BE-423B80E888BD}","OnClientInvoke",function(bb,cb)
local db=game.ReplicatedStorage:FindFirstChild("guildDataFolder")
if db then local _c=db:FindFirstChild(cb)
if _c then
local ac=_a:JSONDecode(_c.Value)if ac.name then
return ba.prompting.prompt(bb.Name..
" has invited you to join their Guild, "..ac.name..".")end end end;return false end)
script.Parent.curve.intro.leave.Activated:connect(function()
if
ba.prompting_Fullscreen.prompt("Are you sure you wish to LEAVE the guild?")then
local bb,cb=ca:invokeServer("{C3523747-A76C-466F-AE06-499AE786F5B1}",false)
if not bb then
if cb=="confirmAbandon"then
if
ba.prompting_Fullscreen.prompt("Will you ABANDON your guild? It will be dissolved PERMANENTLY, and you will get NO REFUND.")then
bb,cb=ca:invokeServer("{C3523747-A76C-466F-AE06-499AE786F5B1}",true)end end;if not bb then
ca:fire("{97822377-6CF7-4275-B2B8-3E4E2E50F11C}",{text=cb,textColor3=Color3.fromRGB(255,100,100)})end end end end)end;return d