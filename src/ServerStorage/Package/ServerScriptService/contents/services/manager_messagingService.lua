local bb={}local cb=game:GetService("HttpService")
local db=game:GetService("ReplicatedStorage")local _c=require(db.modules)local ac=_c.load("network")
local bc=_c.load("utilities")local cc={}local dc=game:GetService("RunService")
local function _d(cd,dd,__a)if
not dc:IsRunMode()then
ac:invoke("{79598458-CED2-488B-A719-1E295449F68E}",cd,dd,__a)end end
local function ad(cd)
local dd,__a=pcall(function()local a_a=Instance.new("IntValue")a_a.Name="referrals"
local b_a=ac:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",cd)if b_a and b_a.globalData and b_a.globalData.referrals then
a_a.Value=b_a.globalData.referrals end;a_a.Parent=cd;local c_a,d_a
repeat
c_a,d_a=pcall(function()
if
cc[cd.Name]then cc[cd.Name]:Disconnect()cc[cd.Name]=nil end
cc[cd.Name]=game:GetService("MessagingService"):SubscribeAsync(
"user-"..tostring(cd.userId),function(_aa)
local aaa,baa=pcall(function()local caa=_aa.Data;local daa=caa.referredUserId
local _ba=caa.referredUsername
if daa then
local aba=ac:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",cd)
if aba then local bba=aba.globalData
if bba then
if bba.referredUserIds then
for _ca,aca in pairs(bba.referredUserIds)do
if aca==daa then
local bca="A user ("..
cd.Name..") attempted to double refer."
ac:invoke("{79598458-CED2-488B-A719-1E295449F68E}",cd,"debug",bca)
cd:Kick("Attempt to refer an already-referred user")return false end end end
local cba,dba=pcall(function()
game:GetService("MessagingService"):PublishAsync("acceptedReferrals",caa.referredUserId)end)
if cba then
ac:fireAllClients("{006F08C2-1541-41ED-90BE-192482E14530}",{Text="✉️ "..cd.Name..
" just referred ".. (_ba or"???").."!",Font=Enum.Font.SourceSansBold,Color=Color3.fromRGB(23,234,118)})local _ca={{id=166,stacks=1}}
spawn(function()
game.BadgeService:AwardBadge(cd.userId,2124469284)end)
local aca=ac:invoke("{669C024B-B819-48D3-AC3D-84873A639D84}",cd,{},0,_ca,0,"gift:referral",{})
if not aca then
if cd.Character and cd.Character.PrimaryPart then
local bca=ac:invoke("{78025E79-97CB-44A8-B433-4A2DDD1FEE21}",{id=166},
cd.Character.PrimaryPart.Position+
cd.Character.PrimaryPart.CFrame.lookVector*2,{cd})end end
ac:invoke("{6A0193EE-9965-481B-BD03-C21883D9F0A2}",cd,"referral:accepted")bba.referrals=(bba.referrals or 0)+1;bba.referredUserIds=
bba.referredUserIds or{}
table.insert(bba.referredUserIds,daa)
aba.nonSerializeData.setPlayerData("globalData",bba)a_a.Value=bba.referrals
ac:fireClient("{BC18AF47-3634-4FA8-B5D3-2BDED15718FD}",cd,{text="You referred ".. (_ba or"???")..
" to Vesteria!",textColor3=Color3.new(0,0,0),backgroundColor3=Color3.fromRGB(23,234,118),backgroundTransparency=0,textStrokeTransparency=1,font=Enum.Font.SourceSansBold},6,"ethyr1")end end end end end)
if not aaa then
_d(cd,"error","messagingService subscription error: "..baa)warn("Subscription error:",baa)end end)end)if not c_a then
_d(cd,"error","messagingService subscription failed: "..d_a)end;wait(15)until c_a or
cd.Parent~=game.Players end)if not dd then
_d(cd,"error","Error setting up messagingService: "..__a)end end
local function bd(cd)local dd=0;local __a=0;for a_a,b_a in pairs(cc)do dd=dd+1
if
b_a and(a_a==cd.Name or
game.Players:FindFirstChild(a_a)==nil)then b_a:Disconnect()cc[a_a]=nil;__a=__a+1 end end end
game.Players.PlayerRemoving:connect(bd)
ac:connect("{2ECD2D2F-8941-4664-B665-7ED91347531F}","Event",ad)return bb