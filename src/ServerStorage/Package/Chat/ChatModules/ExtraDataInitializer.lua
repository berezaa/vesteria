local ab=false;local bb=">="
local cb={["Developer"]={TagText="Developer",TagColor=Color3.fromRGB(255,174,11),Priority=9},["Moderator"]={TagText="Moderator",TagColor=Color3.fromRGB(0,170,0),Priority=7},["Contributor"]={TagText="Contributor",TagColor=Color3.fromRGB(255,0,100),Priority=8},["Tester"]={TagText="Tester",TagColor=Color3.fromRGB(225,203,255),Priority=7},["Roblox Staff"]={TagText="Roblox",TagColor=Color3.fromRGB(255,85,85),Priority=6},["Roblox Star"]={TagText="Star",TagColor=Color3.fromRGB(255,230,101),Priority=5},["Alpha"]={TagText="α",TagColor=Color3.fromRGB(234,55,58),Priority=2},["Beta"]={TagText="β",TagColor=Color3.fromRGB(140,140,140),Priority=1}}
local db={["Dev Orange"]={ChatColor=Color3.fromRGB(255,154,103),Priority=5},["Admin Yellow"]={ChatColor=Color3.fromRGB(255,215,0),Priority=4},["Contributor Blue"]={ChatColor=Color3.fromRGB(156,247,255),Priority=3},["Tester Purple"]={ChatColor=Color3.fromRGB(225,203,255),Priority=2},["Intern Blue"]={ChatColor=Color3.fromRGB(175,221,255),Priority=1}}
local _c={Gamepasses={},Badges={},Teams={},Groups={{GroupId=4238824,Rank=254,ChatColor=db["Dev Orange"]},{GroupId=4238824,Rank=5,ChatColor=db["Contributor Blue"]},{GroupId=4238824,Rank=3,ChatColor=db["Tester Purple"]},{GroupId=1200769,ChatColor=db["Admin Yellow"]},{GroupId=2868472,Rank=100,ChatColor=db["Intern Blue"]},{GroupId=4199740,ChatColor=db["Intern Blue"]}},Players={{UserId=
-1,ChatColor=db["Admin Yellow"]}}}
local ac={Gamepasses={},Badges={{BadgeId=2124445897,Tags={"Alpha"}},{BadgeId=2124469268,Tags={"Beta"}}},Teams={},Groups={{GroupId=1200769,Tags={"Roblox Staff"}},{GroupId=4199740,Tags={"Roblox Star"}},{GroupId=4238824,Rank=254,Tags={"Developer"}},{GroupId=4238824,Rank=5,Tags={"Contributor"}},{GroupId=4238824,Rank=3,Tags={"Tester"}}},Players={{UserId=9221415,Tags={"Contributor"}},{UserId=
-1,Tags={"Contributor","VIP"}}}}
local function bc(ad,bd)
assert(type(bd)=="nil"or type(bd)=="number","requiredRank must be a number or nil")
return
function(cd)
if cd and cd.UserId then local dd=cd.UserId;local __a=false
local a_a,b_a=pcall(function()
if bd then
if bb==">="then
__a=cd:GetRankInGroup(ad)>=bd elseif bb==">"then __a=cd:GetRankInGroup(ad)>bd elseif bb=="<"then __a=
cd:GetRankInGroup(ad)<bd elseif bb=="<="then
__a=cd:GetRankInGroup(ad)<=bd end else __a=cd:IsInGroup(ad)end end)if not a_a and b_a then
print("Error checking in group: "..b_a)end;return __a end;return false end end
local function cc()if _c.Groups then
for ad,bd in pairs(_c.Groups)do bd.IsInGroup=bc(bd.GroupId,bd.Rank)end end
if ac.Groups then for ad,bd in pairs(ac.Groups)do
bd.IsInGroup=bc(bd.GroupId,bd.Rank)end end end;cc()local dc=game:GetService("Players")
function GetSpecialChatColor(ad)
local bd=Color3.new(1,1,1)local cd=0
if _c.Players then local dd=dc:FindFirstChild(ad)
if dd then
for __a,a_a in pairs(_c.Players)do if dd.UserId==
a_a.UserId then
if a_a["ChatColor"]["Priority"]>cd then
cd=a_a["ChatColor"]["Priority"]bd=a_a["ChatColor"]["ChatColor"]end end end end end
if _c.Groups then
for dd,__a in pairs(_c.Groups)do
if __a.IsInGroup(dc:FindFirstChild(ad))then if
__a["ChatColor"]["Priority"]>cd then cd=__a["ChatColor"]["Priority"]
bd=__a["ChatColor"]["ChatColor"]end end end end
if _c.Teams then local dd=dc:FindFirstChild(ad)
if dd then
for __a,a_a in pairs(_c.Teams)do
local b_a=game:GetService("Teams"):FindFirstChild(a_a.Team)if dd.Team==b_a then
if a_a["ChatColor"]["Priority"]>cd then
cd=a_a["ChatColor"]["Priority"]bd=a_a["ChatColor"]["ChatColor"]end end end end end
if _c.Gamepasses then
for dd,__a in pairs(_c.Gamepasses)do local a_a=dc:FindFirstChild(ad)
if
game:GetService("MarketplaceService"):UserOwnsGamePassAsync(a_a.UserId,__a.GamepassId)then
if __a["ChatColor"]["Priority"]>cd then
cd=__a["ChatColor"]["Priority"]bd=__a["ChatColor"]["ChatColor"]end end end end
if _c.Badges then
for dd,__a in pairs(_c.Badges)do local a_a=dc:FindFirstChild(ad)
if
game:GetService("BadgeService"):UserHasBadgeAsync(a_a.UserId,__a.BadgeId)then
if __a["ChatColor"]["Priority"]>cd then
cd=__a["ChatColor"]["Priority"]bd=__a["ChatColor"]["ChatColor"]end end end end;return bd end
function GetSpecialTags(ad)local bd={}local cd=0
if ac.Players then local __a=dc:FindFirstChild(ad)
if __a then
for a_a,b_a in
pairs(ac.Players)do
if __a.UserId==b_a.UserId then
for c_a,d_a in pairs(cb)do
for _aa,aaa in pairs(b_a.Tags)do
if aaa==c_a then
if ab then
table.insert(bd,d_a)if d_a["Priority"]>cd then cd=d_a["Priority"]end else if
d_a["Priority"]>cd then bd={d_a}cd=d_a["Priority"]end end end end end end end end end
if ac.Groups then
for __a,a_a in pairs(ac.Groups)do
if a_a.IsInGroup(dc:FindFirstChild(ad))then
for b_a,c_a in
pairs(cb)do
for d_a,_aa in pairs(a_a.Tags)do
if _aa==b_a then
if ab then table.insert(bd,c_a)if
c_a["Priority"]>cd then cd=c_a["Priority"]end else if c_a["Priority"]>cd then
bd={c_a}cd=c_a["Priority"]end end end end end end end end
if ac.Teams then local __a=dc:FindFirstChild(ad)
if __a then
for a_a,b_a in pairs(ac.Teams)do
local c_a=game:GetService("Teams"):FindFirstChild(b_a.Team)
if __a.Team==c_a then
for d_a,_aa in pairs(cb)do
for aaa,baa in pairs(b_a.Tags)do
if baa==d_a then
if ab then
table.insert(bd,_aa)if _aa["Priority"]>cd then cd=_aa["Priority"]end else if
_aa["Priority"]>cd then bd={_aa}cd=_aa["Priority"]end end end end end end end end end
if ac.Gamepasses then
for __a,a_a in pairs(ac.Gamepasses)do local b_a=dc:FindFirstChild(ad)
if
game:GetService("MarketplaceService"):UserOwnsGamePassAsync(b_a.UserId,a_a.GamepassId)then local c_a={}
for d_a,_aa in pairs(cb)do
for aaa,baa in pairs(a_a.Tags)do
if baa==d_a then
if ab then table.insert(bd,_aa)if
_aa["Priority"]>cd then cd=_aa["Priority"]end else if
_aa["Priority"]>cd then bd={_aa}cd=_aa["Priority"]end end end end end end end end
if ac.Badges then
for __a,a_a in pairs(ac.Badges)do local b_a=dc:FindFirstChild(ad)
if
game:GetService("BadgeService"):UserHasBadgeAsync(b_a.UserId,a_a.BadgeId)then local c_a={}
for d_a,_aa in pairs(cb)do
for aaa,baa in pairs(a_a.Tags)do
if baa==d_a then
if ab then table.insert(bd,_aa)if
_aa["Priority"]>cd then cd=_aa["Priority"]end else if
_aa["Priority"]>cd then bd={_aa}cd=_aa["Priority"]end end end end end end end end;local dd={}if#bd>1 then
for i=cd,1,-1 do for __a,a_a in pairs(bd)do if a_a["Priority"]==i then
table.insert(dd,a_a)end end end else dd=bd end;return dd end
local function _d(ad)
local bd={Color3.new(253 /255,41 /255,67 /255),Color3.new(1 /255,162 /255,255 /255),Color3.new(
2 /255,184 /255,87 /255),BrickColor.new("Bright violet").Color,BrickColor.new("Bright orange").Color,BrickColor.new("Bright yellow").Color,BrickColor.new("Light reddish violet").Color,BrickColor.new("Brick yellow").Color}
local function cd(_aa)local aaa=0
for index=1,#_aa do
local baa=string.byte(string.sub(_aa,index,index))local caa=#_aa-index+1;if#_aa%2 ==1 then caa=caa-1 end;if
caa%4 >=2 then baa=-baa end;aaa=aaa+baa end;return aaa end;local dd=0
local function __a(_aa)return bd[( (cd(_aa)+dd)%#bd)+1]end
local function a_a(_aa)local aaa=_aa:GetPlayer()if aaa then
if aaa.Team~=nil then return aaa.TeamColor.Color end end;return __a(_aa.Name)end
ad.SpeakerAdded:connect(function(_aa)local aaa=ad:GetSpeaker(_aa)if not
aaa:GetExtraData("NameColor")then
aaa:SetExtraData("NameColor",a_a(aaa))end
if
not aaa:GetExtraData("ChatColor")then local baa=GetSpecialChatColor(_aa)if baa then
aaa:SetExtraData("ChatColor",baa)end end;if not aaa:GetExtraData("Tags")then local baa=GetSpecialTags(_aa)
aaa:SetExtraData("Tags",baa)end end)local b_a={}
dc.PlayerAdded:connect(function(_aa)
local aaa=_aa.Changed:connect(function(baa)
local caa=ad:GetSpeaker(_aa.Name)
if caa then
if
baa=="TeamColor"or baa=="Neutral"or baa=="Team"then caa:SetExtraData("NameColor",a_a(caa))
local daa=GetSpecialTags(_aa.Name)caa:SetExtraData("Tags",daa)end end end)b_a[_aa]=aaa end)
dc.PlayerRemoving:connect(function(_aa)local aaa=b_a[_aa]
if aaa then aaa:Disconnect()end;b_a[_aa]=nil end)
local c_a=game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents")local d_a=Instance.new("RemoteEvent")d_a.Name="Toggle"
d_a.Parent=c_a
d_a.OnServerEvent:Connect(function(_aa,aaa)local baa=ad:GetSpeaker(_aa.Name)
if aaa=="Tags"then
if
not
baa:GetExtraData("Tags")or not baa:GetExtraData("Tags")[1]then local caa=GetSpecialTags(_aa.Name)
baa:SetExtraData("Tags",caa)else baa:SetExtraData("Tags",{})end elseif aaa=="Color"then
if not baa:GetExtraData("ChatColor")then
local caa=GetSpecialChatColor(_aa.Name)if caa then baa:SetExtraData("ChatColor",caa)end else
baa:SetExtraData("ChatColor",false)end end end)end;return _d