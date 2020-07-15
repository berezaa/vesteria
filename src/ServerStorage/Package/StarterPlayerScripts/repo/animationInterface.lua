local ac={}ac.clientAnimations={}
local bc=script.Parent.Parent:WaitForChild("assets")local cc=game:GetService("ReplicatedStorage")
local dc=require(cc:WaitForChild("modules"))local _d=dc.load("network")
local ad=cc:WaitForChild("characterAnimations")local bd={}local cd={}local dd={}
do
for aaa,baa in pairs(bc.animations:GetChildren())do
local caa=require(baa)
for daa,_ba in pairs(caa)do
if _ba.animationId and not _ba.animationId_2 then
local aba=Instance.new("Animation")aba.AnimationId=_ba.animationId;aba.Name=daa;if
not ad:FindFirstChild(daa)then aba.Parent=ad end;_ba.animation=aba elseif _ba.animationId and
_ba.animationId_2 then local aba=Instance.new("Animation")
aba.AnimationId=_ba.animationId;aba.Name=daa;local bba=Instance.new("Animation")
bba.AnimationId=_ba.animationId_2;bba.Name=daa.."_2"if not ad:FindFirstChild(aba.Name)then
aba.Parent=ad end;if not ad:FindFirstChild(bba.Name)then
bba.Parent=ad end;_ba.animation={aba,bba}end end;dd[baa.Name]=caa end end
local function __a(aaa,baa,caa)
if dd[baa]and dd[baa][caa]then local daa=dd[baa][caa]
if
typeof(daa.animation)=="Instance"then
local _ba=aaa:LoadAnimation(daa.animation)
_ba.Priority=daa.priority or Enum.AnimationPriority.Movement;_ba.Looped=daa.looped or false;_ba.Name=caa
_ba:AdjustSpeed(daa.speed or 1)return _ba elseif typeof(daa.animation)=="table"then
local _ba=aaa:LoadAnimation(daa.animation[1])
_ba.Priority=daa.priority or Enum.AnimationPriority.Movement;_ba.Looped=daa.looped or false;_ba.Name=caa
local aba=aaa:LoadAnimation(daa.animation[2])
aba.Priority=daa.priority or Enum.AnimationPriority.Movement;aba.Looped=daa.looped or false;aba.Name=caa
_ba:AdjustSpeed(daa.speed or 1)return{_ba,aba}end end;return nil end
local function a_a(aaa,baa)local caa={}
for daa,_ba in pairs(dd[aaa])do
if typeof(_ba.animation)=="Instance"then
local aba=baa:LoadAnimation(_ba.animation)
aba.Priority=_ba.priority or Enum.AnimationPriority.Movement;aba.Looped=_ba.looped or false;aba.Name=daa
aba:AdjustSpeed(_ba.speed or 1)caa[daa]=aba elseif typeof(_ba.animation)=="table"then
local aba=baa:LoadAnimation(_ba.animation[1])
aba.Priority=_ba.priority or Enum.AnimationPriority.Movement;aba.Looped=_ba.looped or false;aba.Name=daa
local bba=baa:LoadAnimation(_ba.animation[2])
bba.Priority=_ba.priority or Enum.AnimationPriority.Movement;bba.Looped=_ba.looped or false;bba.Name=daa
aba:AdjustSpeed(_ba.speed or 1)bba:AdjustSpeed(_ba.speed or 1)
caa[daa]={aba,bba}end end;return caa end
function ac:getAnimationsForAnimationController(aaa,...)local baa={}local caa={...}for daa,_ba in pairs(caa)do if dd[_ba]then
baa[_ba]=a_a(_ba,aaa)end end;return baa end
function ac:registerAnimationsForAnimationController(aaa,...)local baa={}local caa={...}for daa,_ba in pairs(caa)do if dd[_ba]then
baa[_ba]=a_a(_ba,aaa)end end;bd[aaa]=baa;return baa end;function ac:getAnimationsForAnimationController(aaa)return bd[aaa]end;function ac:deregisterAnimationsForAnimationController(aaa)if
aaa then bd[bd]=nil end end
function ac:stopPlayingAnimationsByAnimationCollectionName(aaa,baa)
for caa,daa in
pairs(aaa[baa])do
if typeof(daa)=="Instance"then daa:Stop()elseif typeof(daa)=="table"then for _ba,aba in pairs(daa)do
aba:Stop()end end end end
function ac:stopPlayingAnimationsByAnimationCollectionNameWithException(aaa,baa,caa)
if aaa[baa]then
for daa,_ba in pairs(aaa[baa])do
if
typeof(_ba)=="Instance"then if not caa or _ba.Name~=caa then _ba:Stop()end elseif
typeof(_ba)=="table"then if not caa or _ba[1].Name~=caa then for aba,bba in pairs(_ba)do
bba:Stop()end end end end end end
function ac:replicateNonPlayerAnimationSequence(aaa,baa,caa,daa)
if ac.clientAnimations[aaa]and
ac.clientAnimations[aaa][baa]then
self:stopPlayingAnimationsByAnimationCollectionName(ac.clientAnimations,"emoteAnimations")_d:fire("playNonPlayerAnimationSequence",aaa,baa)
if caa and
typeof(ac.clientAnimations[aaa][baa])=="Instance"then local _ba
_ba=ac.clientAnimations[aaa][baa].Stopped:connect(function()
_ba:disconnect()caa()end)end end;if dd[aaa]and dd[aaa][baa]then
_d:fireServer("replicateNonPlayerAnimationSequence",aaa,baa,daa)end end;function ac:replicatePlayerAnimationSequence(aaa,baa,caa,daa)
ac:replicateClientAnimationSequence(aaa,baa,caa,daa)end
local b_a={"swordAnimations","staffAnimations","daggerAnimations","bowAnimations","greatswordAnimations","dualAnimations","swordAndShieldAnimations"}local function c_a(aaa)for baa,caa in pairs(b_a)do if caa==aaa then return true end end
return false end
function ac:replicateClientAnimationSequence(aaa,baa,caa,daa)
if
dd[aaa]and dd[aaa][baa]then
if c_a(aaa)then daa=daa or{}
daa.attackSpeed=
_d:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","nonSerializeData").statistics_final.attackSpeed or 0 end
_d:fire("{E030A052-D0AC-42A9-A9C5-97BD70690281}",aaa,baa,daa)
_d:fireServer("{721D8B67-F3EC-4074-949F-32BC2FA6A069}",aaa,baa,daa)end end
function ac:getPlayingAnimationTracks()
local aaa=_d:invoke("{7FE9D2B7-10FB-4012-8803-C5D8D5E8DFCA}")if aaa then return
aaa.entity.AnimationController:GetPlayingAnimationTracks()end
return{}end
local function d_a(aaa)
local baa=(aaa or _d:invoke("{7FE9D2B7-10FB-4012-8803-C5D8D5E8DFCA}")).entity.AnimationController;ac.clientAnimations={}
for caa,daa in pairs(dd)do if not string.match(caa,"_noChar")then
ac.clientAnimations[caa]=a_a(caa,baa)end end end
local function _aa()ac.getSingleAnimation=__a;ac.getSingleAnimationCluster=a_a
ac.rawAnimationData=dd
local aaa=_d:invoke("{7FE9D2B7-10FB-4012-8803-C5D8D5E8DFCA}")if aaa then d_a(aaa)end
spawn(function()
_d:connect("{8BABF769-4B51-49E3-9501-B715DD0790C7}","Event",d_a)end)end;spawn(_aa)return ac