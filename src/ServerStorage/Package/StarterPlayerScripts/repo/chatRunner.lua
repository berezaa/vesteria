local aa={}local ba=game:GetService("ReplicatedStorage")
local ca=require(ba.modules)local da=ca.load("network")local _b=ca.load("utilities")
da:connect("{006F08C2-1541-41ED-90BE-192482E14530}","OnClientEvent",function(ab)
game.StarterGui:SetCore("ChatMakeSystemMessage",ab)end)
da:connect("{9B043874-1259-453E-8E06-187B17931220}","OnClientEvent",function(ab,bb,cb,db)
if bb and db then
if bb==game.Players.LocalPlayer then
_b.playSound("kill",
ab.Character and ab.Character.PrimaryPart)
da:fire("{97822377-6CF7-4275-B2B8-3E4E2E50F11C}",{text="You "..db.." "..ab.Name.."!",textColor3=Color3.fromRGB(255,93,61)})end end end)return aa