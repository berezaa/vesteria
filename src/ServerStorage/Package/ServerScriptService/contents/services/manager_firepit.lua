local ac={}local bc=game:GetService("CollectionService")
local cc=game:GetService("ReplicatedStorage")local dc=require(cc.itemData)local _d=require(cc.modules)
local ad=_d.load("network")local bd=_d.load("utilities")local cd=_d.load("configuration")
local dd=require(game.ServerStorage.statusEffectsV3)local __a=bc:GetTagged("firepit")local a_a={}local b_a=15
local c_a={icon="rbxassetid://595268981",modifierData={manaRegen=2,healthRegen=80},DO_NOT_SAVE=true}local function d_a(aaa)a_a[aaa]=nil end
local function _aa()
game.Players.PlayerRemoving:connect(d_a)
while true do
if#__a>0 then
for aaa,baa in pairs(game.Players:GetPlayers())do
if baa.Character and
baa.Character.PrimaryPart then local caa,daa=false,b_a
for _ba,aba in pairs(__a)do
local bba=(
baa.Character.PrimaryPart.Position-aba.Position).magnitude
if bba<b_a and
(not aba:FindFirstChild("Fire")or aba.Fire.Enabled)then caa=true;daa=bba;break end end
if caa~=not not a_a[baa]then
if caa then
local _ba,aba=ad:invoke("{964385B0-1F06-4732-A494-F5D6F84ABC61}",baa.Character.PrimaryPart,"empower",c_a,baa.Character.PrimaryPart,"firepit",0)
if _ba then local bba=Instance.new("BoolValue")bba.Name="isTargetImmune"
bba.Value=true;bba.Parent=baa.Character.PrimaryPart;a_a[baa]=aba end else if
baa.Character.PrimaryPart:FindFirstChild("isTargetImmune")then
baa.Character.PrimaryPart.isTargetImmune:Destroy()end
local _ba=ad:invoke("{7598B3E9-CD41-4A4D-845C-1A19A35ACBFB}",a_a[baa])a_a[baa]=nil end elseif caa and daa<3 then
local _ba=dd.createStatusEffect(baa.Character.PrimaryPart,nil,"ablaze",{damage=10,duration=10},"firepit-ablaze")if _ba then _ba:start()end end end end end;wait(0.75)end end;spawn(_aa)return ac