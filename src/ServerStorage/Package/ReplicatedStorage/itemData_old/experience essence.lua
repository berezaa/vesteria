
local _a=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local aa=_a.load("network")local ba=30;local ca=60 *30
return
{id=174,name="Experience Essence",nameColor=Color3.fromRGB(237,98,255),rarity="Legendary",image="",description="Grant yourself and nearby players 10% bonus EXP for up to half an hour.",useSound="potion",activationEffect=function(da)
if
da.Character and da.Character.PrimaryPart and
da.Character.PrimaryPart.health.Value>0 then
local _b=script.particleContainer.expExplosionFX:Clone()_b.Parent=da.Character.PrimaryPart;for ab,bb in pairs(_b:GetChildren())do
bb.Enabled=true end
delay(1,function()for ab,bb in pairs(_b:GetChildren())do
bb.Enabled=false end
delay(2,function()_b:Destroy()end)end)
for ab,bb in pairs(game.Players:GetPlayers())do
if
bb.Character and
bb.Character.PrimaryPart and(bb.Character.PrimaryPart.Position-
da.Character.PrimaryPart.Position).magnitude<=
ba then
local cb,db=aa:invoke("{964385B0-1F06-4732-A494-F5D6F84ABC61}",bb.Character.PrimaryPart,"empower",{duration=ca,modifierData={wisdom=0.15}},da.Character.PrimaryPart,"item",174)end end;return true,"Successfully applied"end;return false,"Character is invalid."end,buyValue=40,sellValue=20,canStack=true,canBeBound=true,canAwaken=false,isImportant=false,category="consumable"}