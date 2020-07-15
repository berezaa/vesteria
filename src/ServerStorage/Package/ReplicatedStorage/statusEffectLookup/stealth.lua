
local cb=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local db=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local _c=db.load("projectile")local ac=db.load("placeSetup")
local bc=db.load("client_utilities")local cc=db.load("network")local dc=db.load("events")
local _d=ac.awaitPlaceFolder("monsterManifestCollection")local ad=ac.awaitPlaceFolder("entities")
local bd=game:GetService("HttpService")
local cd={id=5,name="Stealth",activeEffectName="Stealthed",styleText="This unit is stealthed.",description="",image="rbxassetid://2528902271",statusEffectApplicationData={duration=8}}local dd="stealthStatusEffectVisualEffectTag"
function cd.__clientApplyStatusEffectOnCharacter(__a)
if not __a or not
__a:FindFirstChild("entity")then return false end;local a_a=1
do
if game.Players.LocalPlayer.Character and
game.Players.LocalPlayer.Character.PrimaryPart then
local b_a=
__a.clientHitboxToServerHitboxReference.Value==game.Players.LocalPlayer.Character.PrimaryPart;if b_a then a_a=0.8 else a_a=1 end end end
for b_a,c_a in pairs(__a.entity:GetChildren())do if c_a:IsA("BasePart")and c_a~=
__a.entity.PrimaryPart then c_a.Transparency=a_a
c_a.Material=Enum.Material.Glass end end end
function cd.__clientApplyTransitionEffectOnCharacter(__a)if
not __a or not __a:FindFirstChild("entity")then return false end;local a_a=1
do
if

game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character.PrimaryPart then
local _aa=__a.clientHitboxToServerHitboxReference.Value==
game.Players.LocalPlayer.Character.PrimaryPart;if _aa then a_a=0.8 else a_a=1 end end end;local b_a=Instance.new("BoolValue")b_a.Name=dd
b_a.Parent=__a.entity.PrimaryPart;local c_a=10;local d_a={}
spawn(function()
for i=1,c_a do if not b_a.Parent then return end;local _aa=a_a*i/c_a
for aaa,baa in
pairs(__a.entity:GetDescendants())do
if
baa:IsA("BasePart")and baa~=__a.entity.PrimaryPart then baa.Transparency=_aa;baa.Material=Enum.Material.Glass elseif
baa:IsA("RopeConstraint")then baa.Visible=false end end;wait(1 /30)end;cd.__clientApplyStatusEffectOnCharacter(__a)end)end
function cd.__clientRemoveStatusEffectOnCharacter(__a)
local a_a=__a.entity.PrimaryPart:FindFirstChild(dd)if a_a then a_a:Destroy()end
for b_a,c_a in
pairs(__a.entity:GetDescendants())do
if
c_a:IsA("BasePart")and c_a~=__a.entity.PrimaryPart then c_a.Transparency=0;c_a.Material=Enum.Material.SmoothPlastic elseif
c_a:IsA("RopeConstraint")then c_a.Visible=true end end end
function cd.onStarted_server(__a,a_a)local b_a=Instance.new("BoolValue",a_a)
b_a.Name="isStealthed"b_a.Value=true
if a_a and a_a:FindFirstChild("entityType")and
a_a.entityType.Value=="character"then
local c_a=game.Players:GetPlayerFromCharacter(a_a.Parent)
local function d_a(_aa)if _aa~=c_a then return end;local aaa=_aa.Character;if not aaa then return end
local baa=aaa.PrimaryPart;if not baa then return end;if baa==a_a then
cc:invoke("{7598B3E9-CD41-4A4D-845C-1A19A35ACBFB}",__a.statusEffectGUID)end end
__a.__eventGuids={dc:registerForEvent("playerUsedAbility",function(_aa,aaa)
local baa=require(game.ReplicatedStorage.abilityLookup)local caa=baa[aaa]
if not caa.doesNotBreakStealth then d_a(_aa)end end),dc:registerForEvent("playerWillUseBasicAttack",d_a),dc:registerForEvent("playerWillTakeDamage",d_a)}
__a.__damageEventGuid=dc:registerForEvent("playerWillDealDamage",function(_aa,aaa)if _aa~=c_a then return end
if
aaa.sourceType=="equipment"then
aaa.damage=aaa.damage*__a.statusEffectModifier.damageMultiplier;dc:deregisterEventByGuid(__a.__damageEventGuid)end end)end end
function cd.onEnded_server(__a,a_a)if a_a:FindFirstChild("isStealthed")then
a_a.isStealthed:Destroy()end
if

a_a and a_a:FindFirstChild("entityType")and a_a.entityType.Value=="character"then
for c_a,d_a in pairs(__a.__eventGuids)do dc:deregisterEventByGuid(d_a)end
delay(1,function()dc:deregisterEventByGuid(__a.__damageEventGuid)end)
local b_a=game.Players:GetPlayerFromCharacter(a_a.Parent)if not b_a then return end
if b_a.Character and b_a.Character.PrimaryPart and
b_a.Character.PrimaryPart:FindFirstChild("isStealthed")then
b_a.Character.PrimaryPart.isStealthed:Destroy()end end end;return cd