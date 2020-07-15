local ca={}local da={}ca.interactions=da
local function _b(_c)
local ac=workspace.CurrentCamera:WorldToScreenPoint(_c)local bc=workspace.CurrentCamera.ViewportSize;return

ac.Z>0 and ac.X>0 and ac.Y>0 and ac.X<=bc.X and ac.Y<=bc.Y end;function ca.interact()end;local ab;local bb=false
local cb=CFrame.new(1.63647461,0.723526001,-8.12826347,-0.796550155,-
0.0972865224,0.596693575,-0,0.986967802,0.160917893,-0.604572475,0.128179163,-0.78616941)
local db={["rbxassetid://2267538527"]={useBody=true},["rbxassetid://2345613400"]={useBody=false},["rbxassetid://2861532980"]={useBody=true},["rbxassetid://3539593106"]={useBody=true},["rbxassetid://3539592561"]={useBody=true},["rbxassetid://3539591914"]={useBody=true},["rbxassetid://3244862244"]={useBody=false},["rbxassetid://2510524077"]={useBody=false},["rbxassetid://3165415763"]={useBody=false}}
function ca.init(_c)local ac;local bc;local cc=_c.network
local dc=game:GetService("CollectionService")
for cd,dd in pairs(dc:GetTagged("interact"))do table.insert(da,dd)end
dc:GetInstanceAddedSignal("interact"):connect(function(cd)
table.insert(da,cd)end)
dc:GetInstanceRemovedSignal("interact"):connect(function(cd)
for dd,__a in pairs(da)do if
__a==cd then table.remove(da,dd)end end end)ca.currentInteraction=nil;local _d=script.Parent.interact
function ca.stopInteract()
_d.Parent=script.Parent;local cd=ca.currentInteraction
if cd and cd.Parent then
if
game.CollectionService:HasTag(cd.Parent,"treasureChest")then elseif cd.Parent:FindFirstChild("clientHitboxToServerHitboxReference")then
_c.playerInteract.hide()elseif cd:FindFirstChild("interactScript")then
local dd=require(cd.interactScript)dd.close(_c)elseif
game.CollectionService:HasTag(cd,"teleportPart")then
local dd=cc:invoke("{CEDFACDA-571C-466E-ABA0-F8C24326B4EF}")
if dd then if dd.isClientPartyLeader then
cc:invokeServer("{FDAD7B5A-1DB0-4879-9677-FA4C0DEDB98D}")end end elseif cd.Parent.Name=="Shopkeeper"then _c.shop.close(true)
cc:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",false)elseif cd:FindFirstChild("dialogue")then
_c.dialogue.endDialogue(cd.dialogue)_c.shop.close(true)end end;ca.currentInteraction=nil
cc:invoke("{DA5389FD-E8D2-4381-81F2-C8B1EA5D6A5F}",false)
cc:invoke("{6AE8FB7E-9DA0-489D-BBD3-0A56102AC4E4}",false)end
cc:create("{482554AA-A0DC-4395-89D0-547A4E1D8214}","BindableFunction","OnInvoke",ca.stopInteract)local ad
local function bd()local cd=game.Players.LocalPlayer.Character
if
cd and cd.PrimaryPart then local dd;local __a=7;local a_a=""
if ca.currentInteraction and
ca.currentInteraction:IsA("BasePart")then
local b_a=(cd.PrimaryPart.Position-
ca.currentInteraction.Position).magnitude;if
game.CollectionService:HasTag(ca.currentInteraction,"teleportPart")then __a=20 end
if
ca.currentInteraction:FindFirstChild("range")then __a=ca.currentInteraction.range.Value end
if b_a<=__a+1.5 then script.Parent.Adornee=ca.currentInteraction
script.Parent.Enabled=true;a_a="Leave"
if ca.currentInteraction:FindFirstChild("interactScript")then
local c_a=require(ca.currentInteraction.interactScript)a_a=c_a.leavePrompt or a_a elseif ca.currentInteraction.Parent and
ca.currentInteraction.Parent:FindFirstChild("clientHitboxToServerHitboxReference")then a_a="Cancel"elseif
dc:HasTag(ca.currentInteraction,"seat")then a_a="Get up"end;_c.interactShell.show(_d)
script.Parent.Enabled=false else ca.stopInteract()script.Parent.Adornee=nil
script.Parent.Enabled=false end else local b_a=999;local c_a=-1
for d_a,_aa in pairs(da)do
if
_aa:IsA("BasePart")and _aa:IsDescendantOf(workspace)then
local aaa=_aa:FindFirstChild("priority")and _aa.priority.Value or 1
if _aa.Parent:FindFirstChild("clientHitboxToServerHitboxReference")then aaa=0 end
local baa=(cd.PrimaryPart.Position-_aa.Position).magnitude
if aaa>c_a then
local caa=_aa:FindFirstChild("range")and _aa.range.Value or 8;if baa<=caa then dd=_aa;b_a=baa;c_a=aaa end end
if aaa>=c_a and baa<b_a and _b(_aa.Position)then dd=_aa;b_a=baa end end end
if dd then
local d_a=dd:FindFirstChild("range")and dd.range.Value or 8
if
(b_a<=d_a or game.CollectionService:HasTag(dd,"teleportPart"))then script.Parent.Adornee=dd;a_a="Interact"
if
game.CollectionService:HasTag(dd.Parent,"treasureChest")then a_a="Open"elseif dd:FindFirstChild("interactScript")then
local _aa=require(dd.interactScript)
if
_aa.interactPrompt and type(_aa.interactPrompt)=="string"then a_a=_aa.interactPrompt;a_a=a_a:sub(1,1):upper()..
a_a:sub(2):lower()end elseif game.CollectionService:HasTag(dd,"teleportPart")then a_a="Travel"elseif
dd.Parent.Name=="Shopkeeper"then a_a="Shop"elseif dd:FindFirstChild("PromptOverride")then
a_a=dd:FindFirstChild("PromptOverride").Value elseif dd:FindFirstChild("dialogue")then if dd:FindFirstChild("OverridePrompt")then
a_a=dd:FindFirstChild("OverridePrompt").Value else a_a="Talk"end elseif
dc:HasTag(dd,"seat")then a_a="Sit"end
if a_a then
if dd~=ad then local _aa=dd
if

_aa.Parent and _aa.Parent:FindFirstChild("AnimationController")and _aa.Parent:FindFirstChild("greeting")then
local aaa=_aa.Parent.AnimationController:LoadAnimation(_aa.Parent.greeting)
if aaa then local baa=Instance.new("BoolValue")baa.Name="beingGreeted"
baa.Parent=_aa.Parent;aaa.Looped=false;aaa.Priority=Enum.AnimationPriority.Action
aaa:Play()local caa
caa=aaa.Stopped:connect(function()caa:disconnect()
if baa then baa:Destroy()end end)end end end;ad=dd;script.Parent.Enabled=true else
script.Parent.Enabled=false;ad=nil end
if
ab and not
(dd.Parent and dd.Parent:FindFirstChild("clientHitboxToServerHitboxReference"))then ab=false;_c.playerInteract.hide()ad=nil end else script.Parent.Enabled=false;if ab then
_c.playerInteract.hide()end;ad=nil end else script.Parent.Enabled=false;if ab then
_c.playerInteract.hide()end;ad=nil end end
if a_a then _d.value.Text=a_a;_d.valueMobile.Text=a_a
local b_a=game.TextService:GetTextSize(_d.value.Text,_d.value.TextSize,_d.value.Font,Vector2.new())_d.description.Size=UDim2.new(0,b_a.X+56,0,36)
local c_a=game.TextService:GetTextSize(_d.valueMobile.Text,_d.valueMobile.TextSize,_d.valueMobile.Font,Vector2.new())_d.button.Size=UDim2.new(0,b_a.X+30,0,38)end end end
game:GetService("RunService").Heartbeat:connect(bd)
function ca.interact()local cd=script.Parent.Adornee
if ca.currentInteraction==cd then
ca.stopInteract()else ca.currentInteraction=cd
if
(script.Parent.Enabled or ab)and cd then if cd:FindFirstChild("helloSound")then
_c.utilities.playSound(cd.helloSound.Value,cd)end;local dd
local __a=cd.Parent:FindFirstChild("AnimationController")
if
cd.Parent and __a and cd.Parent:FindFirstChild("talk")then
dd=cd.Parent.AnimationController:LoadAnimation(cd.Parent.talk)elseif __a then
dd=cd.Parent.AnimationController:LoadAnimation(script.defaulttalk)end
if dd and cd.Parent:FindFirstChild("idle")and
db[cd.Parent:FindFirstChild("idle").AnimationId]then if not
db[cd.Parent:FindFirstChild("idle").AnimationId].useBody then
dd=cd.Parent.AnimationController:LoadAnimation(script.defaulttalk_noarm)end
local b_a=.5;local c_a=Instance.new("BoolValue")c_a.Name="beingGreeted"
c_a.Parent=cd.Parent;dd.Looped=false;dd.Priority=Enum.AnimationPriority.Action
dd:Play(b_a)
spawn(function()wait(0.5)local d_a=__a:GetPlayingAnimationTracks()
for _aa,aaa in
pairs(d_a)do if aaa.Animation and aaa.Animation.Name=="greeting"then
aaa:Stop()end end end)
game.Debris:AddItem(c_a,dd.Length/dd.Speed)end;local a_a=cd:FindFirstChild("dialogue")
if
game.CollectionService:HasTag(cd.Parent,"treasureChest")then ca.stopInteract()
cc:invoke("{52EA54C2-60BA-461B-8A07-678C59CAD99F}",cd.Parent)elseif cd:FindFirstChild("interactScript")then
local b_a=require(cd.interactScript)b_a.init(_c)if b_a.instant then ca.stopInteract()end elseif

cd.Parent and cd.Parent:FindFirstChild("clientHitboxToServerHitboxReference")then
local b_a=cd.Parent:FindFirstChild("clientHitboxToServerHitboxReference")
if b_a.Value and b_a.Value.Parent then
local c_a=game.Players:GetPlayerFromCharacter(b_a.Value.Parent)
if not c_a and b_a.Value:FindFirstChild("mirrorValue")and
b_a.Value.mirrorValue.Value and
b_a.Value.mirrorValue.Value.Parent then
c_a=game.Players:GetPlayerFromCharacter(b_a.Value.mirrorValue.Value.Parent)end;if c_a then _c.playerInteract.activate(c_a)
ca.stopInteract()end end elseif game.CollectionService:HasTag(cd,"teleportPart")then
local b_a=cc:invoke("{CEDFACDA-571C-466E-ABA0-F8C24326B4EF}")
if b_a then
if b_a.isClientPartyLeader then
cc:invokeServer("{C8FF76F3-4805-4CB9-8AD8-BF8F5539EDE0}",cd)else
_c.notifications.alert({text="Only the party leader can teleport the party!",textColor=Color3.fromRGB(255,170,170)},2)ca.stopInteract()end end elseif cd.Parent and cd.Parent.Name=="Shopkeeper"then
_c.shop.open(cd)elseif a_a then _c.dialogue.beginDialogue(cd,require(a_a))elseif
dc:HasTag(cd,"seat")then
cc:invoke("{1676D160-1E78-4D25-BD95-49CEC36F7D16}",cd)end end end end;_d.button.Activated:connect(ca.interact)end;return ca