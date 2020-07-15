
local c=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local d=c.load("network")
return
{id=134,name="Life Essence",rarity="Common",image="",description="Life stolen by a Warlock.",useSound="fireIgnite",activationEffect=function(_a)
if
_a and _a.Character and _a.Character.PrimaryPart then
local aa=d:invoke("{0A040B75-B4E3-4DED-A038-B72DCD22ED1D}","Undead",
_a.Character.PrimaryPart.Position+
_a.Character.PrimaryPart.CFrame.lookVector*5,nil,{master=_a})if aa then return true,"Successfully activated."end
return false,"Monster failed to spawn."end;return false,"character is invalid."end,buyValue=5,sellValue=1,canStack=false,canBeBound=false,canAwaken=false,isImportant=false,category="consumable"}