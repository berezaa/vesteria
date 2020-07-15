local ab=game:GetService("Chat")
local bb=game:GetService("Players")local cb=game:GetService("FriendService")
local db=ab:WaitForChild("ClientChatModules")
local _c=require(db:WaitForChild("ChatSettings"))
local ac=require(db:WaitForChild("ChatConstants"))local bc=nil
pcall(function()
bc=require(game:GetService("Chat").ClientChatModules.ChatLocalization)end)if bc==nil then bc={}function bc:Get(ad,bd)return bd end end
local cc=Color3.fromRGB(255,255,255)local dc={ChatColor=cc}
local function _d(ad)
local function bd()if _c.ShowFriendJoinNotification~=nil then
return _c.ShowFriendJoinNotification end;return false end
local function cd(__a,a_a)local b_a=ad:GetSpeaker(__a.Name)
if b_a then
b_a:SendSystemMessage(string.gsub(bc:Get("GameChat_FriendChatNotifier_JoinMessage",string.format("Your friend %s has joined the game.",a_a.Name)),"{RBX_NAME}",a_a.Name),"System",dc)end end
local function dd(__a,a_a)if __a~=a_a then
coroutine.wrap(function()
if __a:IsFriendsWith(a_a.UserId)then cd(__a,a_a)end end)()end end;if bd()then
bb.PlayerAdded:connect(function(__a)local a_a=bb:GetPlayers()
for i=1,#a_a do dd(a_a[i],__a)end end)end end;return _d