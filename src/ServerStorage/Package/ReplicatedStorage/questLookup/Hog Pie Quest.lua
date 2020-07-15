
local aa=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local ba=aa.load("mapping")local ca=aa.load("network")
local da=aa.load("utilities")local _b=aa.load("tween")
return
{id=13,QUEST_VERSION=1,questLineName="Baker's Assistant",questLineimage="",questLineDescription="Gertrude needs some baking help.",requireQuests={},repeatableData={value=false,timeInterval=0},requireClass=
nil,objectives={{requireLevel=7,giverNpcName="Gertrude",handerNpcName="Gertrude",objectiveName="Baker's Assistant",completedText="Return to Gertrude.",completedNotes="I have gathered the Hog Meat and Sugar for Gertrude's meat pie. I should return to her.",handingNotes="Gertrude has another task for me.",level=8,expMulti=1,goldMulti=0,rewards={{id=8,stacks=20},{id=88,stacks=4}},steps={{triggerType="item-collected",requirement={id=144,amount=8}},{triggerType="item-collected",requirement={id=146,amount=1}}},localOnFinish=function(ab)
spawn(function()
if
workspace:FindFirstChild("cut_cauldron")then
local bb=workspace:FindFirstChild("cut_cauldron").PrimaryPart
for i=1,8 do local _c=script.cut_meat:Clone()_c.Position=bb.Position+
Vector3.new(0,3,0)_c.Size=_c.Size*1.2
_c.Parent=workspace;_c.swoosh:Play()
_b(_c,{"Position"},bb.Position,0.4)wait(.4)if _c and _c.Parent then _c:Destroy()end end;local cb=script.cut_sugar:Clone()cb.Parent=workspace;cb.Position=
bb.Position+Vector3.new(0,3,0)_b(cb,{"Orientation"},Vector3.new(
-90,90,0),0.3)
cb.swoosh:Play()wait(.3)cb.Water.Enabled=true;wait(1.5)
cb.Water.Enabled=false;wait(.2)if cb and cb.Parent then cb:Destroy()end
local db=script.cut_pie:Clone()db.Position=bb.Position;db.Parent=workspace;_b(db,{"Position"},bb.Position+
Vector3.new(0,3,0),0.3)
db.Sparkles:Emit(5)db.ray:Emit(3)db.awe:Play()wait(2.5)if db and db.Parent then
db:Destroy()end end end)end},{requireLevel=7,giverNpcName="Gertrude",handerNpcName="Skull Crusher",objectiveName="Baker's Assistant Part 2",completedText="",completedNotes="Gertrude needs me to deliver the pie to her son in the Warrior Stronghold. I must travel through the Redwood Pass to reach him.",handingNotes="",hideAlert=true,level=8,expMulti=.8,goldMulti=2,rewards={{id=26,stacks=1},{id=56,stacks=1}},steps={{triggerType="item-collected",requirement={id=141,amount=1},hideNote=true,hideAlert=true}}}},dialogueData={responseButtonColor=Color3.fromRGB(255,207,66),dialogue_unassigned_1={{text="Hello there stranger. Say, would you mind helping a little old lady bake a pie?"}},dialogue_active_1={{text="Did you gather the 8 Hog Meat and the Bag of Sugar for the pie? Fight the Hogs until you do. It's going to be quite the big tasty pie!"}},dialogue_objectiveDone_1={{text="Splendid! Time to \"bake\"!"}},dialogue_unassigned_2={{text="The pie isn't for you or me I'm afraid. It's for my son! Would you bring it to him?"}},dialogue_active_2={{text="Hey... you don't have a pie with you. Did you have room in your inventory to hold it?"}},dialogue_objectiveDone_2={{text="Mom baked me a pie? AWESOME!"}},options={{response_unassigned_accept_1="Sure thing!",response_unassigned_decline_1="Get lost granny",dialogue_unassigned_accept_1={{text="Splendid! I'm making my boy's favorite meat pie, but I'm missing the two most important ingredients: Sugar and Hog Meat! One of those Hogs broke into my kitchen and stole my last bag of sugar! Would you get it back for me? While you're at it, be a dear and also collect 8 Hog Meat."}},dialogue_unassigned_decline_1={{text="Well! How rude!"}},response_unassigned_accept_2="Of course!",response_unassigned_decline_2="Not today granny",dialogue_unassigned_accept_2={{text="Hip hip hurray! My boy is a big strong warrior. You can find him at the Warrior Stronghold after the Redwood Pass. Just follow the path all the way through until you reach him! Thanks a ton, sugarplum!"}},dialogue_unassigned_decline_2={{text="Oh dear me!"}}}}}}