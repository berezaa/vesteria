
local c=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local d=c.load("mapping")
return
{id=15,QUEST_VERSION=3,questLineName="Catapult Mechanic",questLineImage="",questLineDescription="The catapult at the Redwood Pass Warrior camp is broken. I'll fix it.",requireQuests={},repeatableData={value=false,timeInterval=0},requireClass=
nil,objectives={{requireLevel=13,giverNpcName="Captain Bronzeheart",handerNpcName="Captain Bronzeheart",objectiveName="Catapult Mechanic",completedText="Talk to Captain Bronzeheart.",completedNotes="Talk to Captain Bronzeheart",handingNotes="Quest completed!",level=14,expMulti=.4,goldMulti=1,rewards={{id=150,stacks=1}},steps={{triggerType="item-collected",requirement={id=143,amount=1}}},localOnFinish=function(_a)
if
workspace:FindFirstChild("Catapult")then
workspace:FindFirstChild("Catapult").FrontBowl.manifest.Transparency=0
workspace:FindFirstChild("Catapult").FrontBowl.manifest.CanCollide=true
workspace:FindFirstChild("Catapult").FrontBowl.manifest.dec1.Transparency=0
workspace:FindFirstChild("Catapult").FrontBowl.manifest.dec1.CanCollide=true
workspace:FindFirstChild("Catapult").FrontBowl.manifest.dec2.Transparency=0
workspace:FindFirstChild("Catapult").FrontBowl.manifest.dec2.CanCollide=true end end}},dialogueData={responseButtonColor=Color3.fromRGB(255,207,66),dialogue_unassigned_1={{text="At ease, private. We had a little accident with our catapult here. Whole thing is fried. It runs on 100% renewable Guardian Core energy though, should be an easy fix. We just need a single Guardian Core and this puppy will be back up and running and no time. Would you fetch us a core?"}},dialogue_active_1={{text="Did you find that Guardian Core yet?"}},dialogue_objectiveDone_1={{text="You have the core? Fantastic work, soldier. In return for your contribution, my troops will let you use the catapult to fling yourself free of charge. Really an underrated mode of transportation if you ask me."}},options={{response_unassigned_accept_1="Will do",response_unassigned_decline_1="Negative",dialogue_unassigned_accept_1={{text="That's what I like to hear! Just politely, uh, \"ask\" one of the Guardians if they'll let you borrow one of their cores."}},dialogue_unassigned_decline_1={{text="Well in that case, scram!"}}}}}}