local da={}local _b=game:GetService("HttpService")
local ab=game:GetService("ReplicatedStorage")local bb=require(ab.modules)local cb=bb.load("Network")
local db=bb.load("utilities")local _c=require(ab.questLookupNew)local ac={}
function da.completeQuest(bc,cc)end
function da.returnPlayerQuestData(bc)local cc=ac[bc]
if cc then return cc elseif not cc and
game.Players:FindFirstChild(bc.Name)then da.loadQuestData(bc)return
da.returnPlayerQuestData(bc)end end;function da.loadQuestData(bc)end;function da.saveQuestData(bc)end;return da