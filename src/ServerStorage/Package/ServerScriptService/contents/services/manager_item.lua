local dba={}local _ca=game:GetService("ReplicatedStorage")
local aca=require(_ca.modules)local bca=aca.load("network")local cca=aca.load("placeSetup")
local dca=aca.load("physics")local _da=aca.load("utilities")
local ada=aca.load("configuration")local bda=aca.load("economy")
local cda=game:GetService("ServerStorage")local dda=_ca.itemData;local __b=require(_ca.itemAttributes)
local a_b=require(dda)local b_b=require(_ca.monsterLookup)
local c_b=cca.getPlaceFolder("items")local function d_b(b_c)local c_c=dda:FindFirstChild(b_c.Name)
if c_c then return require(c_c)end end
local _ab={cca.getPlaceFoldersFolder()}
bca:create("{2ABFAB8F-ADB5-403F-B04E-FBFAD43EE8D4}","RemoteEvent")
local function aab(b_c,c_c)
local d_c=bca:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",b_c)
if d_c then local _ac=0
for aac,bac in pairs(d_c.inventory)do local cac=a_b[bac.id]if
cac and cac.category==c_c then _ac=_ac+1 end end;return _ac<25 end;return false end;local bab=10;local cab={}
local function dab(b_c,c_c,d_c)
if not c_c or c_c.Parent~=c_b then
return false,"item does not exist"elseif cab[c_c]then return false,"attempt to pick-up an item someone else is picking up"elseif not
c_c:FindFirstChild("metadata")then return false,"attempt to pick-up an invalid item"elseif not
_da.playerCanPickUpItem(b_c,c_c,d_c)then return false,"can't pick-up this item"end;local _ac=d_b(c_c)
if _ac then cab[c_c]=true;local aac;local bac,cac,dac
if not _ac.autoConsume then
local _bc,abc=_da.safeJSONDecode(c_c.metadata.Value)
if _bc then aac=abc
bac,cac=bca:invoke("{669C024B-B819-48D3-AC3D-84873A639D84}",b_c,{},0,{abc},0,nil,{overrideItemsRecieved=true})else aac=_ac;bac,cac=false,"failed to decode metadata"end else aac=_ac;bac,cac,dac=_ac.activationEffect(b_c,c_c)end
bca:fireClient("{00C8A0C1-B9BF-4E80-BA56-5A4370445636}",b_c,aac,bac,dac,nil,cac)
if bac then
bca:fire("{9485849D-EE15-40A1-B8BB-780E42059ED2}",b_c,"item-collected",{id=_ac.id,amount=1})
if c_c:FindFirstChild("owners")then
if
c_c.owners:FindFirstChild(tostring(b_c.userId))then
c_c.owners[tostring(b_c.userId)]:Destroy()else for abc,bbc in pairs(c_c.owners:GetChildren())do if bbc.Value==b_c then
bbc:Destroy()end end end end
if not c_c:FindFirstChild("pickupBlacklist")then
local abc=Instance.new("Folder")abc.Name="pickupBlacklist"abc.Parent=c_c end;local _bc=Instance.new("BoolValue")
_bc.Name=tostring(b_c.userId)_bc.Value=true;_bc.Parent=c_c.pickupBlacklist
if


c_c:FindFirstChild("singleOwnerPickup")or not c_c:FindFirstChild("owners")or#c_c.owners:GetChildren()==0 then c_c:Destroy()elseif c_c:FindFirstChild("created")and

(os.time()-c_c.created.Value)>=ada.getConfigurationValue("timeForAnyonePickupItem")then
c_c:Destroy()end end;cab[c_c]=nil;return bac,cac,dac end end
local function _bb(b_c,c_c)
if

b_c.Character==nil or b_c.Character.PrimaryPart==nil or
b_c.Character.PrimaryPart:FindFirstChild("state")==nil or
b_c.Character.PrimaryPart.state.Value=="dead"then return false,"Invalid player or dead"end;if
not c_c or not _da.playerCanPickUpItem(b_c,c_c)then return false,"Unable to pick up"end
if
b_c.Character and b_c.Character.PrimaryPart and c_c and
typeof(c_c)=="Instance"and
c_c:IsDescendantOf(c_b)then
if
_da.magnitude(
b_c.Character.PrimaryPart.Position-c_c.Position)<=bab*1.1 then return dab(b_c,c_c,false)else return false,"Too far away"end end;return false,"Invalid"end
local function abb(b_c)
if b_c:IsA("BasePart")then
for c_c,d_c in pairs(b_c:GetChildren())do
if d_c:IsA("BasePart")then
local _ac=Instance.new("Motor6D")_ac.Part0=b_c;_ac.Part1=d_c;_ac.C0=CFrame.new()
_ac.C1=d_c.CFrame:toObjectSpace(b_c.CFrame)_ac.Parent=d_c;d_c.CanCollide=false;d_c.Anchored=false end end elseif b_c:IsA("Model")then local c_c=b_c.PrimaryPart
for d_c,_ac in pairs(b_c:GetChildren())do
if
_ac:IsA("BasePart")and _ac~=c_c then local aac=Instance.new("Motor6D")
aac.Part0=c_c;aac.Part1=_ac;aac.C0=CFrame.new()
aac.C1=_ac.CFrame:toObjectSpace(c_c.CFrame)aac.Parent=_ac;_ac.CanCollide=false;_ac.Anchored=false;_ac.Parent=c_c end end;b_c=c_c end;return b_c end
local function bbb(b_c,c_c)local d_c=a_b[b_c.id]
if c_c then c_c=abb(c_c)else
if d_c.equipmentType=="arrow"then
if
b_c.stacks==1 then c_c=d_c.module.manifest:Clone()
c_c.CanCollide=false;c_c.Anchored=false else
c_c=game.ReplicatedStorage.entities.ArrowUpperTorso2.quiver:Clone()c_c.Anchored=false;c_c.CanCollide=false;local dac=b_c.stacks or 0
local _bc=math.clamp(
math.floor(
dac/ada.getConfigurationValue("arrowsPerArrowPartVisualization"))+1,0,ada.getConfigurationValue("maxArrowPartsVisualization"))
local abc=360 /ada.getConfigurationValue("maxArrowPartsVisualization")
for ai=1,_bc do local bbc=d_c.module.manifest:Clone()
bbc.CanCollide=false;bbc.Anchored=false;bbc.Parent=c_c;local cbc,dbc=math.random()*2 -1,
math.random()*2 -1
local _cc=Instance.new("Motor6D",c_c)_cc.Name="projectionWeld"_cc.Part0=c_c;_cc.Part1=bbc
_cc.C0=c_c.Attachment.CFrame
_cc.C1=CFrame.Angles(cbc*math.rad(15),0,dbc*math.rad(15))end end elseif d_c.module:FindFirstChild("manifest",true)then
c_c=d_c.module:FindFirstChild("manifest",true):Clone()c_c=abb(c_c)elseif d_c.module:FindFirstChild("container")then
local dac=d_c.module.container.PrimaryPart;c_c=dac:Clone()c_c:ClearAllChildren()
for _bc,abc in
pairs(dac:GetChildren())do
if abc:IsA("BasePart")then local bbc=abc:Clone()
local cbc=Instance.new("Motor6D")cbc.Part0=bbc;cbc.Part1=c_c;cbc.C0=CFrame.new()
cbc.C1=dac.CFrame:toObjectSpace(abc.CFrame)cbc.Parent=bbc;bbc.Anchored=false;bbc.CanCollide=false;bbc.Parent=c_c end end
for _bc,abc in pairs(d_c.module.container:GetChildren())do
if abc~=
dac then local bbc=abc:Clone()local cbc=Instance.new("Motor6D")
cbc.Part0=c_c;cbc.Part1=bbc;cbc.C0=CFrame.new()
cbc.C1=abc.CFrame:toObjectSpace(dac.CFrame)cbc.Parent=c_c;bbc.Anchored=false;bbc.CanCollide=false
for dbc,_cc in
pairs(bbc:GetChildren())do
if _cc:IsA("BasePart")then local acc=Instance.new("Motor6D")
acc.Part0=bbc;acc.Part1=_cc;acc.C0=CFrame.new()
acc.C1=_cc.CFrame:toObjectSpace(bbc.CFrame)acc.Parent=_cc;_cc.CanCollide=false;_cc.Anchored=false end end;bbc.Parent=c_c end end else
error("attempt to drop item with invalid drop format")end end;c_c.Name=d_c.module.Name;c_c.Anchored=false;c_c.CanCollide=false;if
b_c.id==1 then
if b_c.value>=1000 then c_c.Color=Color3.fromRGB(160,160,160)end end
local _ac=_ca.entities.itemMask:Clone()_ac.Name="HumanoidRootPart"_ac.RootPriority=100
_ac.CustomPhysicalProperties=PhysicalProperties.new(5,1,0.7)_ac.Parent=c_c;_ac.Size=Vector3.new(c_c.Size.X*1.1,c_c.Size.Y*1.1,
c_c.Size.Z*1.1)
local aac=Instance.new("Motor6D")aac.Part0=c_c;aac.Part1=_ac;aac.Parent=c_c;aac.Name="MASK_MOTOR"
local bac=b_c.dye
if bac then
c_c.Color=Color3.new(c_c.Color.r*bac.r/255,
c_c.Color.g*bac.g/255,c_c.Color.b*bac.b/255)
for dac,_bc in pairs(c_c:GetDescendants())do
if _bc:IsA("BasePart")then if bac then
_bc.Color=Color3.new(
_bc.Color.r*bac.r/255,_bc.Color.g*bac.g/255,_bc.Color.b*
bac.b/255)end end end end;local cac=(math.sqrt(c_c.Size.X*c_c.Size.Y)+
math.sqrt(c_c.Size.Z,c_c.Size.Y))
if not
b_c.isNotDropping then local dac=d_c
if
(dac.rarity and dac.rarity=="Rare")or(dac.category and
dac.category=="equipment")then dac.soulboundDrop=true;for _cc,acc in
pairs(script.rareItem:GetChildren())do acc:Clone().Parent=c_c end else
local _cc=script.Rays:Clone()local acc=Instance.new("Attachment")
acc.Axis=Vector3.new(1,0,0)acc.SecondaryAxis=Vector3.new(0,1,0)_cc.Parent=acc
acc.Parent=c_c;_cc.Size=NumberSequence.new(cac*1.3)
local bcc=script.Sparkles:Clone()bcc.Parent=acc end;local _bc=Instance.new("PointLight")_bc.Brightness=1.5
_bc.Range=8;_bc.Parent=_ac;local abc
if c_c:IsA("BasePart")then abc=c_c elseif c_c:IsA("Model")and(c_c.PrimaryPart or
c_c:FindFirstChild("HumanoidRootPart"))then
local _cc=
c_c.PrimaryPart or c_c:FindFirstChild("HumanoidRootPart")if _cc then abc=_cc end end;local bbc=Instance.new("Attachment",c_c)bbc.Position=Vector3.new(0,
_ac.Size.Y/2,0)
local cbc=Instance.new("Attachment",c_c)
cbc.Position=Vector3.new(0,-_ac.Size.Y/2,0)local dbc=script.Trail:Clone()dbc.Attachment0=bbc
dbc.Attachment1=cbc;dbc.Enabled=true;dbc.Parent=c_c end;c_c.Anchored=false;return c_c end;local cbb=Random.new(os.time())
local dbb=game:GetService("HttpService")
local function _cb(b_c,c_c,d_c,_ac)
if a_b[b_c.id]then _ac=bbb(b_c,_ac)local aac,bac;local cac=0
local dac,_bc=_da.safeJSONEncode(b_c or{})local abc=Instance.new("StringValue",_ac)abc.Name="metadata"
abc.Value=_bc;dca:setWholeCollisionGroup(_ac,"items")
while
not aac and cac<5 do cac=cac+1
local cbc=Ray.new((
CFrame.new(c_c)*
CFrame.Angles(0,math.rad(math.random(1,360)),0)*CFrame.Angles(0,0,math.rad(20))*CFrame.new(0,0,-math.random()*3)).p,Vector3.new(0,
-5,0))
aac,bac=workspace:FindPartOnRayWithIgnoreList(cbc,_ab)end;if not bac then bac=c_c end
_ac.CFrame=CFrame.new(bac)+Vector3.new(0,0.5,0)
_ac.HumanoidRootPart.CFrame=CFrame.new(bac)+Vector3.new(0,0.5,0)
if d_c and#d_c>0 then local cbc=Instance.new("Folder")cbc.Name="owners"
for dbc,_cc in
pairs(d_c)do
if _cc and _cc.Parent==game.Players then
local acc=Instance.new("ObjectValue")acc.Name=tostring(_cc.userId)acc.Value=_cc;acc.Parent=cbc end end;cbc.Parent=_ac end;local bbc=Instance.new("IntValue")bbc.Name="created"
bbc.Value=os.time()bbc.Parent=_ac
if a_b[b_c.id].petsIgnore then
local cbc=Instance.new("BoolValue")cbc.Name="petsIgnore"cbc.Value=true;cbc.Parent=_ac end;game.Debris:AddItem(_ac,4 *60)
if b_c.value then
local cbc=Instance.new("IntValue")cbc.Name="itemValue"cbc.Value=b_c.value;cbc.Parent=_ac end
if b_c.source then local cbc=Instance.new("StringValue")
cbc.Name="itemSource"cbc.Value=b_c.source;cbc.Parent=_ac end;_ac.Parent=c_b;return _ac end end
bca:create("{78025E79-97CB-44A8-B433-4A2DDD1FEE21}","BindableFunction","OnInvoke",_cb)local acb=Random.new()
local function bcb(b_c)if not b_c then return end;local c_c=b_b[b_c.Name]
if c_c then
c_c=require(c_c)
for d_c,_ac in pairs(c_c.lootDrops)do if _ac.spawnChance>acb:NextNumber()then if a_b[_ac.id]then
_cb(_ac,b_c.Position)end end end end end;local ccb=1;local dcb={}
local function _db(b_c,c_c,d_c,_ac,aac)
local bac=bca:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",b_c)
local cac=bca:invoke("{2C5A5D42-77F2-4839-B960-1C1D5AAB73AA}",b_c,c_c,d_c)
if bac and cac and(not _ac or cac.id==_ac)then
local dac=a_b[cac.id]
if
dac.category=="consumable"or dac.activationEffect~=nil then
if
bca:invoke("{525D23EC-4205-463F-9570-0244085FD9B6}",b_c.Character and b_c.Character.PrimaryPart)then return false,"User is stunned."end
if tick()- (dcb[b_c]or 0)>=
ccb*math.clamp(1 -
bac.nonSerializeData.statistics_final.consumeTimeReduction,0,1)then dcb[b_c]=tick()
local _bc,abc=dac.activationEffect(b_c,aac)
if _bc then
if bac.nonSerializeData.statistics_final.itemUseGain10PercentDEF then
local cbc,dbc=bca:invoke("{964385B0-1F06-4732-A494-F5D6F84ABC61}",b_c.Character.PrimaryPart,"empower",{duration=5,modifierData={defense=
bac.nonSerializeData.statistics_final.equipmentDefense*0.1}},b_c.Character.PrimaryPart,"perk",0)end;local bbc="item:"..dac.module.Name
if
dac.category~="miscellaneous"then
local cbc=bca:invoke("{669C024B-B819-48D3-AC3D-84873A639D84}",b_c,{{id=cac.id,position=cac.position,stacks=1}},0,{},0,bbc)end else
bca:fireClient("{006F08C2-1541-41ED-90BE-192482E14530}",b_c,{Text="Failed to use item: "..abc or"no error.",Font=Enum.Font.SourceSans,Color=Color3.fromRGB(216,161,107)})end;return _bc,abc end;return false,"consume on cooldown"elseif dac.category=="equipment"then end;return false,"Item is not activatable."end;return false,"Failed to activate item."end
local function adb(b_c,c_c,d_c,_ac)
if not _ac then warn("Failed to supply inventoryModule")return false end;if not _ac.Parent:IsA("BasePart")then
warn("inventoryModule.Parent is not BasePart")return false end
local aac=bca:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",b_c)if not aac then return false end;local bac=c_c.costInfo;local cac;local dac
local _bc=require(_ac)
do local cbc=false
for dbc,_cc in pairs(_bc)do local acc;local bcc;if typeof(_cc)=="string"then acc=_cc elseif
typeof(_cc)=="table"then acc=_cc.itemName;bcc=_cc end
if
a_b[acc]==a_b[c_c.id]then
if bac and bac.costType then
if bcc and
bac.costType==bcc.costInfo.costType then dac=_cc.cost;cac=_cc;cbc=true end elseif
not(bcc and bcc.costInfo and bcc.costInfo.costType)then cbc=true end end end
if not cbc then return false,"could not find item in shop inventory!"end end
if typeof(c_c)~="table"or not c_c.id then return false end;local abc=a_b[c_c.id]
local bbc=math.clamp(math.floor(d_c or 1),1,(abc.stackSize or 99)*20)
if
b_c and c_c and typeof(c_c)=="table"and d_c and
type(d_c)=="number"and d_c>=1 and d_c==bbc then d_c=bbc
local cbc=a_b[c_c.id]if not cbc or cbc.cantBuy then return false end
local dbc="shop:"..cbc.module.Name;local _cc,acc;local bcc;local ccc={id=c_c.id}
if cac then bcc=cac.costInfo;if cac.attributes then
for dcc,_dc in
pairs(cac.attributes)do if not ccc[dcc]then ccc[dcc]=_dc end end end end
if cac and bcc and bcc.costType and dac then
if bcc.costType=="item"then local dcc=math.clamp(d_c,1,
cbc.stackSize or 99)ccc.stacks=dcc
_cc,acc=bca:invoke("{669C024B-B819-48D3-AC3D-84873A639D84}",b_c,{{id=bcc.costId,stacks=
dac*d_c}},0,{ccc},0,dbc)elseif bcc.costType=="ethyr"then local dcc=aac.globalData
local _dc=math.clamp(d_c,1,cbc.stackSize or 99)
if dcc.ethyr and dcc.ethyr>=dac*_dc then ccc.stacks=_dc
_cc,acc=bca:invoke("{669C024B-B819-48D3-AC3D-84873A639D84}",b_c,{},0,{ccc},0,dbc)
if _cc then dcc.ethyr=dcc.ethyr-dac*d_c
aac.nonSerializeData.setPlayerData("globalData",dcc)
spawn(function()
bca:invoke("{DC1AA741-408D-49CF-87F9-CD63B55E82D7}",b_c,"ethyr",-dac*d_c,dbc)end)end end end else
local dcc=1 -
math.clamp(aac.nonSerializeData.statistics_final.merchantCostReduction,0,1)ccc.stacks=d_c
_cc,acc=bca:invoke("{669C024B-B819-48D3-AC3D-84873A639D84}",b_c,{},
math.clamp((cbc.buyValue or 1)*dcc,1,math.huge)*d_c,{ccc},0,dbc)end;return _cc,acc end;return false,"Failed to purchase item."end
local function bdb(b_c,c_c,d_c)if not b_c then return false end
local _ac=bca:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",b_c)if not _ac then return false end;local aac=nil;for bac,cac in pairs(_ac.inventory)do
if
cac.position==c_c.position and cac.id==c_c.id then aac=cac;break end end
if aac and
typeof(aac)=="table"and d_c==d_c and d_c and type(d_c)==
"number"then
d_c=math.floor(math.clamp(d_c or 1,1,999))local bac=a_b[aac.id]if not bac or bac.cantSell then return false elseif
bac and not bac.canStack then d_c=1 end
local cac="shop:"..bac.module.Name;local dac=bda.getSellValue(bac,aac)
local _bc=bca:invoke("{669C024B-B819-48D3-AC3D-84873A639D84}",b_c,{{id=aac.id,position=aac.position,stacks=d_c}},0,{},
(dac)*d_c,cac)if _bc and aac.id==138 then
bca:fire("{FCCADF22-0B79-446B-930B-55313877CCCA}",b_c,10)end;return _bc end;return false,"Failed to sell item."end
local function cdb(b_c,c_c,d_c,_ac,aac)
local bac=game.Players:GetPlayerFromCharacter(b_c.Parent)if c_c and c_c>0 then _da.healEntity(b_c,b_c,c_c)
_da.playSound("item_heal",b_c)end
if d_c and d_c>0 then
b_c.mana.Value=math.min(
b_c.mana.Value+d_c,b_c.maxMana.Value)_da.playSound("item_mana",b_c)end;return true end
bca:create("{AB4CDDDB-D1C5-46A3-8B72-F09379DDD79F}","BindableFunction","OnInvoke",cdb)local function ddb(b_c)dcb[b_c]=0 end;local function __c(b_c)dcb[b_c]=nil end
local function a_c()
game.Players.PlayerAdded:connect(ddb)
for b_c,c_c in pairs(game.Players:GetPlayers())do ddb(c_c)end
game.Players.PlayerRemoving:connect(__c)
bca:create("{F3035FC5-80F8-43B8-B9DF-A1D38267D047}","BindableFunction","OnInvoke",bbb)
bca:create("{25AC3715-858A-45E0-AA01-86637A049ED3}","RemoteFunction","OnServerInvoke",_db)
bca:create("{FD23A09C-B336-406B-9121-6B80F7AF6EE8}","RemoteFunction","OnServerInvoke",_db)
bca:create("{346E0AEC-179E-46F7-A37F-910E02933FDD}","RemoteFunction","OnServerInvoke",adb)
bca:create("{E78B3F0F-50E6-4DAD-83C1-CC9AC8419699}","RemoteFunction","OnServerInvoke",bdb)
bca:create("{F74B377B-619C-4700-BB20-F930BA740C50}","RemoteFunction","OnServerInvoke",_bb)
bca:create("{B06FCFDD-64FD-433B-AB30-2D8D53F68A95}","RemoteFunction","OnServerInvoke",_bb)
bca:create("{9C17E666-62A0-4E6C-BCF3-B10CB1CCC44B}","BindableFunction","OnInvoke",dab)
bca:create("{00C8A0C1-B9BF-4E80-BA56-5A4370445636}","RemoteEvent")
bca:create("{32937BC1-CC17-495B-B878-D4F114692178}","BindableEvent","Event",function()end)end;a_c()return dba