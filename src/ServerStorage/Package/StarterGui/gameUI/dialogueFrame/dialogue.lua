local dc={}local _d;local ad=script.Parent;local bd=ad.Parent;local cd
local dd=game:GetService("UserInputService")local __a=game:GetService("TextService")
local a_a=game:GetService("ReplicatedStorage")local b_a=require(a_a.questLookup)
local c_a=require(a_a.itemData)local d_a=require(a_a.modules)local _aa=d_a.load("network")
local aaa=d_a.load("mapping")local baa=d_a.load("levels")local caa=d_a.load("utilities")
local daa=d_a.load("client_quest_util")local _ba=d_a.load("localization")local aba
function dc.init(bba)local cba={}cba.network=_aa
cba.utilities=caa;cba.levels=baa;cba.quest_util=daa;cba.mapping=aaa;cd=bba.uiCreator
local function dba()script.Parent.UIScale.Scale=
bba.input.menuScale or 1
if
bba.input.mode.Value=="mobile"then script.Parent.Position=UDim2.new(0.5,0,1,-20)else script.Parent.Position=UDim2.new(0.5,0,1,
-140)end end;local _ca=script:WaitForChild("responseOption")local aca={}
aca.events={}
local function bca(dda,__b,a_b)if dda.id==__b then return dda end;print("$",dda.id,__b,a_b)
if
dda.options then local b_b=dda.options
if type(b_b)=="function"then b_b=b_b(cba,a_b)end
if type(b_b)=="table"and#b_b>0 then for c_b,d_b in pairs(dda.options)do
local _ab=bca(d_b,__b,a_b)if _ab then return _ab end end end end;return nil end
function aca:moveToId(dda,__b)local a_b=bca(_d,dda,__b)if a_b then aca:stopDialogue()
aca:setDialogue(a_b,__b)aca:startDialogue()end end
_aa:create("{53738740-803A-4D59-8661-4E64C37B334E}","BindableFunction","OnInvoke",function(dda,__b)aca:moveToId(dda,__b)end)
local function cca(dda)
local __b=_aa:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","quests")
for a_b,b_b in pairs(__b.active)do
if b_b.id==dda then local c_b=0;local d_b=0
if
b_b.currentObjective>#b_b.objectives then return aaa.questState.completed end
for _ab,aab in
pairs(b_b.objectives[b_b.currentObjective].steps)do c_b=c_b+1;if aab.requirement.amount<=aab.completion.amount then d_b=d_b+
1 end end
if d_b>0 and d_b==c_b and
b_b.objectives[b_b.currentObjective].started then return aaa.questState.objectiveDone else
if
b_b.objectives[b_b.currentObjective].started then return aaa.questState.active else return aaa.questState.unassigned end end end end;for a_b,b_b in pairs(__b.completed)do
if b_b.id==dda then return aaa.questState.completed end end
return aaa.questState.unassigned end
local function dca(dda)
local __b=_aa:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","quests")for a_b,b_b in pairs(__b.active)do
if b_b.id==dda then return b_b.currentObjective end end;return 1 end
local function _da(dda)
local __b=_aa:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","quests")
for a_b,b_b in pairs(__b.active)do if b_b.id==dda then return
b_b.objectives[b_b.currentObjective].started end end;return true end;local function ada(dda)end;function aca:clearEvents()
for dda,__b in pairs(aca.events)do __b:disconnect()end;aca.events={}end
function aca:navigateCurrentDialogueData(dda)if

not self.currentDialogueData or
not self.currentDialogueData.options or not
self.currentDialogueData.options[dda]then return end
self.isPlayingDialogue=false;self:clearEvents()
self:setDialogue(self.currentDialogueData.options[dda])self:startDialogue()end
function aca:stopDialogue()self.isPlayingDialogue=false;self:clearEvents()
ad.Visible=true;bba.focus.toggle(ad)end
function aca:setDialogue(dda,__b)self.rootDialogueData=dda;self.currentDialogueData=dda
self.extraData=__b;self.previousDialogueData=nil end;local bda=false
function aca:acceptQuestRewardsButtonActivated(dda)bda=true
local __b=_aa:invokeServer("{798B395E-3EE4-4AD0-B0AE-FA56E9713C52}",aca.questData.id,self.questData.objectives[self.currentQuestObjective].handerNpcName)
if __b then
if
aca.questData.objectives[self.currentQuestObjective].localOnFinish then
aca.questData.objectives[self.currentQuestObjective].localOnFinish(cba,self.extraData)end;cba.utilities.playSound("questTurnedIn")end;dc.endDialogue()
bba.interaction.stopInteract()bda=false end;local cda
ad.cancel.Activated:Connect(function()dc.endDialogue()
bba.interaction.stopInteract()end)
function aca:startDialogue(dda,__b)if not self.currentDialogueData then return end
script.Parent.UIScale.Scale=1;if self.currentDialogueData.onClose then
aba=self.currentDialogueData.onClose end
local a_b=self.currentDialogueData.Parent and
self.currentDialogueData.Parent.Parent;if a_b and a_b:FindFirstChild("AnimationController")then
_aa:invoke("{08E952A3-3FAA-4AA6-A94D-BCD3F66B7F7B}",a_b)end
if

self.currentDialogueData.sound and self.speaker and self.speaker.PrimaryPart and(dda==nil or dda<=1)then
cba.utilities.playSound(self.currentDialogueData.sound,self.speaker.PrimaryPart)end;local b_b=30
dda=(dda and dda>1)and tostring(dda)or""local c_b=dda==""and 1 or tonumber(dda)
if
self.currentDialogueData.speakerName or self.speaker then
local dbb=(
self.speaker and self.speaker.Name or self.currentDialogueData.speakerName)or
"Someone messed up."
local _cb=__a:GetTextSize(dbb,ad.titleFrame.title.TextSize,ad.titleFrame.title.Font,Vector2.new())ad.titleFrame.title.Text=dbb
ad.titleFrame.Size=UDim2.new(0,_cb.X+20,0,32)end;ad.contents.dialogue:ClearAllChildren()
local d_b=true;local _ab
if self.currentQuestObjective then _ab=self.currentQuestObjective end
local aab="dialogue"..
dda.. (
self.questState and"_"..
aaa.getMappingByValue("questState",self.questState).. (__b and
"_"..__b or"").. (_ab and"_".._ab or"")or"")local bab=self.currentDialogueData[aab]if type(bab)=="function"then
bab=bab(cba,self.extraData)end
if typeof(bab)=="string"then
bab=_ba.translate(bab,ad.contents.dialogue)bab=_ba.convertToVesteriaDialogueTable(bab)end
if bab then local dbb=bab
local _cb,acb=cd.createTextFragmentLabels(ad.contents.dialogue,dbb)
ad.contents.dialogue.Size=UDim2.new(1,0,0,acb+18)b_b=b_b+acb+18;if self.currentDialogueData["dialogue"..c_b+1]then
d_b=false end end;ad.contents.options:ClearAllChildren()b_b=b_b+
10
ad.contents.options.Position=UDim2.new(0,0,0,b_b)local cab=0;local dab,_bb=0,0
local function abb(dbb,_cb,acb,bcb,ccb,dcb,_db,adb)
local bdb=__a:GetTextSize(dbb,_ca.inner.TextSize,_ca.inner.Font,Vector2.new())local cdb=_ca:Clone()
if dbb=="X"then bdb=Vector2.new(10,0)
cdb.inner.Text="X"cdb.inner.Font=Enum.Font.SourceSansBold end;if typeof(dbb)=="string"then
dbb=_ba.translate(dbb,ad.contents.options)end
if dab+ (bdb.X+20)>
ad.contents.options.AbsoluteSize.X then dab=0;_bb=_bb+42 end;cdb.inner.Text=dbb
cdb.Size=UDim2.new(0,bdb.X+30,0,42)cdb.Position=UDim2.new(0,dab,0,_bb)
cdb.Parent=ad.contents.options;local ddb
if _cb then local __c=""if self.currentQuestObjective then
__c="_"..self.currentQuestObjective end
if _cb.responseButtonColor then
cdb.ImageColor3=_cb.responseButtonColor elseif _cb.onSelected then cdb.ImageColor3=Color3.fromRGB(255,210,29)elseif dbb==_cb[
"response_unassigned_accept"..__c]then
cdb.ImageColor3=Color3.fromRGB(150,255,150)ddb="accept"elseif
dbb==_cb["response_unassigned_decline"..__c]then cdb.ImageColor3=Color3.fromRGB(255,150,150)ddb="decline"else end end;if ccb then cdb.ImageColor3=ccb end
table.insert(self.events,dcb and
cdb.Activated:connect(dcb)or
cdb.Activated:connect(function()
if _cb then
if acb and bcb and _db then
self.questState=acb;self.questData=bcb;self.currentQuestObjective=_db end;if _cb.onSelected then _cb.onSelected()end
if ddb=="accept"then
local __c=_aa:invokeServer("{1FF0D39B-3160-4598-B23E-F04DC5CBCF09}",self.questData.id,self.questData.objectives[self.currentQuestObjective].giverNpcName)
if __c then
_aa:fire("{6C4E77E3-E076-46CD-9136-F52BF0A09C5B}",self.questData.id)
if
self.questData.objectives[self.currentQuestObjective].clientOnAcceptQuest then
self.questData.objectives[self.currentQuestObjective].clientOnAcceptQuest(cba,self.extraData)end end end;aca:stopDialogue()aca:setDialogue(_cb)
aca:startDialogue(nil,ddb)else
if adb then bda=true
local __c=_aa:invokeServer("{798B395E-3EE4-4AD0-B0AE-FA56E9713C52}",aca.questData.id,self.questData.objectives[self.currentQuestObjective].handerNpcName)
if __c then
if
aca.questData.objectives[self.currentQuestObjective].localOnFinish then
aca.questData.objectives[self.currentQuestObjective].localOnFinish(cba,self.extraData)end;cba.utilities.playSound("questTurnedIn")end;dc.endDialogue()
bba.interaction.stopInteract()bda=false end;dc.endDialogue()
bba.interaction.stopInteract()end end))cab=cab+1;dab=dab+bdb.X+20 +5 end;local bbb=self.currentDialogueData.options;if
self.currentDialogueData.optionsFunction then
bbb=self.currentDialogueData.optionsFunction(cba,self.extraData)end;if
type(bbb)=="function"then self.currentDialogueData.optionsFunction=bbb
bbb=bbb(cba,self.extraData)end
self.currentDialogueData.options=bbb;ad.bottom.Visible=false
if

self.questState==aaa.questState.objectiveDone or self.questState==aaa.questState.handing then
if self.questData then for adb,bdb in
pairs(ad.contents.rewards.contents:GetChildren())do
if not bdb:IsA("UIListLayout")then bdb:Destroy()end end
local dbb=self.currentQuestObjective
local _cb=self.questData.objectives[dbb].rewards
local acb=self.questData.objectives[dbb].goldMulti
local bcb=self.questData.objectives[dbb].expMulti
local ccb=self.questData.objectives[dbb].level
for adb,bdb in pairs(_cb)do local cdb=c_a[bdb.id]local ddb=bdb.stacks
if cdb then
local __c=script.itemLine_quest:Clone()__c.AutoLocalize=false
local a_c=_ba.translate(cdb.name,ad.contents.rewards)__c.Text=a_c.. (ddb and" x"..ddb or"")
__c.preview.Image=cdb.image;__c.Parent=ad.contents.rewards.contents end end;local dcb=ad.contents.rewards.chest.exp
dcb.Visible=false;if(bcb or 1)>0 then dcb.Visible=true
dcb.Text="+ "..
math.floor(
baa.getQuestEXPFromLevel(ccb or 1)* (bcb or 1)).." EXP"end
if(acb or 1)>0 then
local adb=baa.getQuestGoldFromLevel(
ccb or 1)* (acb or 1)local bdb=script.itemLine_money:clone()
bba.money.setLabelAmount(bdb,adb)bdb.Parent=ad.contents.rewards.contents end;local _db=0;for adb,bdb in
pairs(ad.contents.rewards.contents:GetChildren())do
if bdb:IsA("GuiObject")and bdb.Visible then _db=_db+29 end end;ad.contents.rewards.contents.Size=UDim2.new(1,
-15,0,_db)ad.contents.rewards.Size=UDim2.new(1,0,0,
_db+18 +24)end;ad.contents.rewards.Visible=true
ad.contents.taxi.Visible=false
abb("Accept Rewards",nil,nil,nil,Color3.fromRGB(85,255,76),nil,nil,true)abb("X")
cda=ad.accept.Activated:connect(function()
self:acceptQuestRewardsButtonActivated(self.questData.objectives[self.currentQuestObjective].handerNpcName)end)elseif self.currentDialogueData.taxiMenu then ad.accept.Visible=false
ad.cancel.Visible=false;ad.contents.rewards.Visible=false
ad.contents.taxi.Visible=true else ad.accept.Visible=false;ad.cancel.Visible=false
ad.contents.rewards.Visible=false;ad.contents.taxi.Visible=false
ad.contents.rewards.contents.Size=UDim2.new(0,0,0,0)ad.contents.rewards.Size=UDim2.new(0,0,0,0)
if
self.currentDialogueData.options then
for dbb,_cb in pairs(self.currentDialogueData.options)do local acb=false;local bcb=false
local ccb;local dcb;local _db;local adb
if _cb.questId then _db=b_a[_cb.questId]
if _db and _db.dialogueData then
_cb=_db.dialogueData;dcb=cca(_db.id)adb=dca(_db.id)local bdb=_da(_db.id)
local cdb=_db.objectives[adb].objectiveName;local ddb=self.currentDialogueData.flagForQuest;if
type(ddb)=="function"then ddb=ddb(cba,self.extraData)end
local __c=daa.getQuestObjectiveAndStarted(self.currentDialogueData.flagForQuest)local a_c=true
local b_c=self.currentDialogueData.getObjectiveOptionsTable(cba,self.extraData)if __c<0 then if b_c[__c*-1]==nil then a_c=false end else if b_c[__c]==nil then
a_c=false end end
if
__c<0 and a_c then local c_c=__c*-1;b_c=b_c[c_c]
for d_c,_ac in pairs(b_c)do if _ac.isStarterNPC~=nil and
not _ac.isStarterNPC then a_c=false end end elseif a_c then b_c=b_c[__c]
for c_c,d_c in pairs(b_c)do if
d_c.isHanderNPC~=nil and not d_c.isHanderNPC then a_c=false end end end
if a_c then
if dcb==aaa.questState.completed then acb=true elseif
dcb==aaa.questState.unassigned or not bdb then ccb="[Quest] "..cdb elseif
dcb==aaa.questState.active then ccb="[In-progress] "..cdb elseif dcb==aaa.questState.handing or dcb==
aaa.questState.objectiveDone then
ccb="[Complete] "..cdb end end end else local bdb=false;local cdb;local ddb="response_unassigned"local __c="response_unassigned_accept"
local a_c="response_unassigned_decline"local b_c="response_active"
if self.questData and self.currentQuestObjective then bdb=not
_da(self.questData.id)cdb=self.currentQuestObjective
ddb=ddb.."_"..cdb;__c=__c.."_"..cdb;a_c=a_c.."_"..cdb;b_c=b_c.."_"..cdb end
if self.questState then
if bdb then
if _cb[__c]and _cb[a_c]then bcb=true elseif _cb[ddb]then ccb=_cb[ddb]else acb=true end elseif self.questState==aaa.questState.handing then ccb=_cb.response_handing elseif
self.questState==aaa.questState.active then ccb=_cb[b_c]elseif self.questState==
aaa.questState.unassigned then if _cb[__c]and _cb[a_c]then bcb=true elseif _cb[ddb]then ccb=_cb[ddb]else
acb=true end elseif
self.questState==aaa.questState.completed then acb=true end else ccb=_cb.response end end
if not acb and(ccb or bcb)then
if bcb then local bdb="response_unassigned_accept"
local cdb="response_unassigned_decline"
if self.currentQuestObjective then
bdb="response_unassigned_accept".."_"..self.currentQuestObjective
cdb="response_unassigned_decline".."_"..self.currentQuestObjective end;abb(_cb[bdb],_cb,dcb,_db,nil,nil,adb)
abb(_cb[cdb],_cb,dcb,_db,nil,nil,adb)else abb(ccb,_cb,dcb,_db,nil,nil,adb)end end end end end;ad.contents.next.Visible=false
if not d_b then
ad.contents.options.Visible=false;ad.contents.next.Visible=true
ad.contents.next.inner.Text="→"ad.contents.next.tooltip.Value="Next"
table.insert(self.events,ad.contents.next.Activated:connect(function()self:startDialogue(
c_b+1)end))elseif cab>0 then ad.contents.options.Visible=true
ad.contents.next.Visible=false
if
self.currentDialogueData.canExit and(not self.questState or
(self.questState~=
aaa.questState.handing and self.questState~=aaa.questState.objectiveDone))then abb("X")end elseif self.currentDialogueData.moveToId then
local dbb=bca(_d,self.currentDialogueData.moveToId)
if dbb then ad.contents.options.Visible=false
ad.contents.next.Visible=true;ad.contents.next.inner.Text="→"
ad.contents.next.tooltip.Value="Next"
table.insert(self.events,ad.contents.next.Activated:connect(function()
aca:stopDialogue()aca:setDialogue(dbb)aca:startDialogue(nil,__b)end))else ad.contents.options.Visible=false
ad.contents.next.Visible=true;ad.contents.next.inner.Text="X"
ad.contents.next.tooltip.Value="Exit"
table.insert(self.events,ad.contents.next.Activated:connect(function()
dc.endDialogue()bba.interaction.stopInteract()end))end elseif
not self.questState or self.questState~=aaa.questState.handing then ad.contents.options.Visible=false
ad.contents.next.Visible=true;ad.contents.next.inner.Text="X"
ad.contents.next.tooltip.Value="Exit"
table.insert(self.events,ad.contents.next.Activated:connect(function()
dc.endDialogue()bba.interaction.stopInteract()end))end;b_b=b_b+_bb
ad.contents.options.Size=UDim2.new(1,0,0,_bb+42)ad.bottom.Size=UDim2.new(1,0,0,_bb+52)
ad.bottom.Visible=true;local cbb=0
for dbb,_cb in pairs(ad.contents:GetChildren())do if
_cb:IsA("GuiObject")and _cb.Visible then local acb=_cb.Size.Y.Offset
if acb>0 then cbb=cbb+acb+
ad.contents.UIListLayout.Padding.Offset end end end;ad.Size=UDim2.new(0,400,0,cbb+36)ad.Visible=false;dba()
bba.focus.toggle(ad)
if bba.input.mode.Value=="xbox"and
(
game.GuiService.SelectedObject==nil or not
game.GuiService.SelectedObject:IsDescendantOf(script.Parent))then
game.GuiService.SelectedObject=bba.focus.getBestButton(ad.contents)end end;function aca:setSpeaker(dda)self.speaker=dda end
function dc.beginDialogue(dda,__b)
aca.questState=nil;aca.questData=nil;aca:stopDialogue()
aca:setDialogue(__b)
if dda then
local a_b=dda.Parent:FindFirstChild("HumanoidRootPart")
if a_b and a_b.Parent:IsA("Model")then
local b_b=a_b.Position+
a_b.CFrame.lookVector*3.5 +Vector3.new(0,1.75,0)local c_b=a_b.Position+Vector3.new(0,1.25,0)
local d_b=CFrame.new(b_b,c_b)
_aa:invoke("{DA5389FD-E8D2-4381-81F2-C8B1EA5D6A5F}",d_b)end;aca:setSpeaker(dda.Parent)end;_d=__b
_aa:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",true)aca:startDialogue()
for a_b,b_b in pairs(ad:GetDescendants())do if
b_b:IsA("TextLabel")or b_b:IsA("TextButton")then b_b.TextScaled=false
b_b.TextWrapped=false end end end
_aa:create("{81F1B7CC-530F-4DC7-B68D-B35304E4648B}","BindableFunction","OnInvoke",dc.beginDialogue)
function dc.endDialogue()script.Parent.Visible=false;if aba then
aba(cba,aca.extraData)aba=nil end
_aa:invoke("{08E952A3-3FAA-4AA6-A94D-BCD3F66B7F7B}",nil)aca:stopDialogue()_d=nil
_aa:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",false)end end;return dc