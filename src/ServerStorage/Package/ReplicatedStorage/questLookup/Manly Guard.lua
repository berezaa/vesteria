
local c=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local d=c.load("mapping")
return
{id=4,QUEST_VERSION=2,questLineName="A Respected Guard",questLineImage="",questLineDescription="Greg, the City Guard, has tasked me to gather Elder Beards from the Elder Shrooms in the Mushroom Forest.",requireQuests={},repeatableData={value=false,timeInterval=0},requireClass=
nil,objectives={{requireLevel=6,giverNpcName="Greg, the City Guard",handerNpcName="Greg, the City Guard",objectiveName="A Respected Guard",completedText="Return to Greg, the City Guard.",completedNotes="Return to Greg, the City Guard",handingNotes="Quest completed!",level=4,expMulti=1,goldMulti=1,rewards={{id=24}},steps={{triggerType="item-collected",requirement={id=10,amount=10}}},localOnFinish=function(_a)
spawn(function()
if
workspace:FindFirstChild("Greg, the City Guard")and
workspace["Greg, the City Guard"]:FindFirstChild("Head")then if
workspace["Greg, the City Guard"].Head:FindFirstChild("ShroomPeople")then
workspace["Greg, the City Guard"].Head.ShroomPeople.Transparency=0 end;if
workspace["Greg, the City Guard"].Head:FindFirstChild("ShroomPeople2")then
workspace["Greg, the City Guard"].Head.ShroomPeople2.Transparency=0 end end end)end}},dialogueData={responseButtonColor=Color3.fromRGB(255,207,66),dialogue_unassigned_1={{text="Hey bud. Ya know, it's real hard to get some respect around here as a City Guard. Think you could help me out? I'll make it worth your time."}},dialogue_active_1={{text="Hey! Come back when you have those"},{text="10 Elder Beards.",font=Enum.Font.SourceSansBold},{text="I've heard from some of the other guards that theres a hideout with tons of beared Shrooms somewhere..."}},dialogue_objectiveDone_1={{text="My word! These are perfect! I'll be truely respected as a city guard with these. Here, take this... maybe you'll get some respect now too."}},options={{response_unassigned_accept_1="No problem my man.",response_unassigned_decline_1="Sorry, can't help.",dialogue_unassigned_accept_1={{text="I knew you'd be able to help me. I've heard there's a hideout somewhere in the forest populated by massive Shrooms with some manly beards. Get me 10 of them."}},dialogue_unassigned_decline_1={{text="Ugh. Guess I'll have to find a more RESPECTABLE adventurer."}}}}}}