local ba={}ba.isActive=false;if script.Parent.Name=="exit"then
ba.interactPrompt="Exit"else ba.interactPrompt="Enter"end
ba.instant=true;local ca=game.Players.LocalPlayer
local da=require(game.ReplicatedStorage:WaitForChild("modules"))local _b=da.load("network")local ab=da.load("utilities")
local function bb()
for cb,db in
pairs(game.CollectionService:GetTagged("door"))do
if db~=script.Parent and db.Parent and db.Parent.Name==
script.Parent.Parent.Name then return db end end end
function ba.init()local cb=bb()
if cb and ca.Character and ca.Character.PrimaryPart then
if
game.ReplicatedStorage.sounds:FindFirstChild("door")then ab.playSound("door",ca.Character.PrimaryPart)end
ca.Character:SetPrimaryPartCFrame(
ca.Character.PrimaryPart.CFrame-
ca.Character.PrimaryPart.Position+cb.Position+cb.CFrame.lookVector*8)end end;function ba.close()end;return ba