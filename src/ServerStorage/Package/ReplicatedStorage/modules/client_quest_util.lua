local dc=game:GetService("ReplicatedStorage")
local _d=game:GetService("CollectionService")local ad=game:GetService("RunService")
local bd=require(dc:WaitForChild("questLookup"))
local cd=require(game.ReplicatedStorage:WaitForChild("modules"))local dd=cd.load("network")local __a=cd.load("tween")
local a_a=cd.load("utilities")local b_a=cd.load("mapping")
local c_a=require(game.ReplicatedStorage:WaitForChild("itemData"))
for bba,cba in pairs(script:GetChildren())do local dba=require(cba)end;local d_a={}
local function _aa(bba)
local cba=dd:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","quests")
for dba,_ca in pairs(cba.active)do
if _ca.id==bba then local aca=0;local bca=0
for cca,dca in
pairs(_ca.objectives[_ca.currentObjective].steps)do aca=aca+1;if dca.requirement.amount<=dca.completion.amount then bca=bca+
1 end end
if bca>0 and bca==aca and
_ca.objectives[_ca.currentObjective].started then return b_a.questState.objectiveDone else
if
_ca.objectives[_ca.currentObjective].started then return b_a.questState.active else return b_a.questState.unassigned end;return b_a.questState.active end end end;for dba,_ca in pairs(cba.completed)do
if _ca.id==bba then return b_a.questState.completed end end
return b_a.questState.unassigned end;function d_a.getPlayerQuestStateByQuestId(bba)return _aa(bba)end
local function aaa(bba)
local cba=dd:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","quests")for dba,_ca in pairs(cba.active)do
if _ca.id==bba then if _ca.objectives[_ca.currentObjective]then return
_ca.currentObjective end end end;return-1 end;function d_a.getQuestObjective(bba)return aaa(bba)end
local function baa(bba)
local cba=dd:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","quests")local dba
for _ca,aca in pairs(cba.active)do if aca.id==bba then
if
aca.objectives[aca.currentObjective].started then return aca.currentObjective else return aca.currentObjective*-1 end end end;return-1 end;function d_a.getQuestObjectiveAndStarted(bba)return baa(bba)end
local function caa(bba,cba)
local dba=bd[bba]if cba==-1 then cba=1 end;return
dba.objectives[cba].requireLevel or 1 end;function d_a.getQuestLevelReq(bba,cba)return caa(bba,cba)end;local function daa(bba)
local cba=bd[bba]return cba.requireClass end;function d_a.getQuestClassReq(bba)
return daa(bba)end;local function _ba(bba)local cba=bd[bba]return
{unpack(cba.requireQuests)}end;function d_a.getQuestRequiredQuests(bba)return
_ba(bba)end
local function aba(bba)local cba=bd[bba]return cba.repeatableData.value,
cba.repeatableData.timeInterval end;function d_a.getQuestRepeatData(bba)return aba(bba)end
function d_a.canPlayerInventoryObtainItem(bba)
local cba=dd:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","inventory")local dba=c_a[bba].category
for aca,bca in pairs(cba)do if bca.id==bba then return true end end;local _ca=0
for aca,bca in pairs(cba)do if bca.category==dba then _ca=_ca+1 end end;if _ca>=20 then return false end;return true end
function d_a.masterCanStartQuest(bba)local cba=aaa(bba)
local dba=dd:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","level")
local _ca=dd:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","quests").completed
local aca=dd:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","class")local bca=caa(bba,cba)local cca=daa(bba)local dca=_ba(bba)local _da,ada=aba(bba)if
cba==-1 then cba=1 end;if dba<bca then return false end
if cca and cca~=aca then return false end
if#dca>0 then
for bda,cda in pairs(dca)do local dda=false
for __b,a_b in pairs(_ca)do if a_b.id==cda then dda=true end end;if not dda then return false end end end
if _da then
local bda=dd:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","quests").active;local cda;for dda,__b in pairs(bda)do
if __b.id==bba and __b.canStartAfterTime then if __b.canStartAfterTime>
os.time()then return false end end end end
if bba==22 then local bda=false
local cda=dd:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","quests").active
for __b,a_b in pairs(cda)do if a_b.id==22 then bda=false end end;local dda=false
if not bda then
local __b=dd:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","inventory")
for a_b,b_b in pairs(__b)do if b_b.id==187 then dda=true end end;if not dda then return false end end end;return true end;return d_a