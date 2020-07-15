local aa=game:GetService("ReplicatedStorage")
local ba=require(aa.modules)local ca=ba.load("network")
local da={onSelected=function()end,id="startTalkingToShopkeeper",dialogue={{text="Hey, you! I'm a test NPC for Dialogue. How are you?"}},options={["Gross, don't talk to me."]={dialogue={{text="That's not very nice.. :("}},dialogue2={{text="Get out of here whippersnapper!"}}},["That's cool!"]={dialogue={{text="I know."}}},["Give me a sick quest."]={onSelected=function()
end,dialogue={{text="Don't worry, I got you."}}}}}
local _b={dialogue={{text="Greetings Adventurer!"}},options={{response="Today is such a beautiful day!",dialogue={{text="No it isn't, my wife is sick."}}},{questId=2}}}return _b