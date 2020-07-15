local _a=game:GetService("ReplicatedStorage")
local aa=require(_a.modules)local ba=aa.load("network")
local ca={id=1,name="Test Quest",questType="findAndReturn",steps={[1]={stepData={stepType="findAndReturn",objective="Apple",timeLimit=0}},[2]={stepData={stepType="killMonster",objective="Baby Shroom",timeLimit=0}}},startData={triggerType="npc",trigger="Test NPC"},finishData={triggerType="npcReturn",trigger="Test NPC"}}function ca:beginQuest(da)end;function ca:beginQuestServer(da)end;function ca:endQuest(da)end;function ca:endQuestServer(da)
end;return ca