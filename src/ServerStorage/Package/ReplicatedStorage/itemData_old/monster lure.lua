
local ab=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local bb=ab.load("network")local cb=ab.load("detection")
local db=ab.load("projectile")local _c=ab.load("utilities")local ac=50;local bc=220;local cc=3;local dc=10 *60
local function _d(ad,bd)local cd={}
local dd=require(game.ReplicatedStorage.monsterLookup)
for __a,a_a in pairs(ad:GetChildren())do
for b_a,c_a in pairs(a_a:GetChildren())do
if
c_a:IsA("BasePart")then local d_a=cb.projection_Box(c_a.CFrame,c_a.Size,bd)
local _aa=(d_a-bd).magnitude
if _aa<ac then local aaa,baa=string.match(a_a.Name,"(.+)-(%d+)")
if
aaa and baa and dd[aaa]and
not(dd[aaa].boss or dd[aaa].doNotLure)then
table.insert(cd,{monsterType=aaa,selectionWeight=math.ceil((ac-_aa)/2)+baa})end end end end end;return cd end
return
{id=173,name="Monster Lure",nameColor=Color3.fromRGB(237,98,255),rarity="Legendary",image="rbxassetid://3283950664",description="A vase of mystical aromatic sticks that attracts the strongest nearby monsters",useSound="potion",stackSize=9,tier=4,consumeTime=0,activationEffect=function(ad)
if
game.PlaceId==3303140173 then return false,"Lures won't work here."end
if ad.Character and ad.Character.PrimaryPart and
ad.Character.PrimaryPart.health.Value>0 then
local bd=workspace.placeFolders:FindFirstChild("spawnRegionCollections")
if bd then
local cd=_d(bd,ad.Character.PrimaryPart.Position)
if cd and#cd>0 then
local dd=workspace.placeFolders:FindFirstChild("activeMonsterLures")
if dd and#dd:GetChildren()<cc then
local __a,a_a,b_a=db.raycast(Ray.new(ad.Character.PrimaryPart.Position,Vector3.new(0,
-50,0)),{workspace.placeFolders})
if __a then
local c_a=bb:invoke("{F3035FC5-80F8-43B8-B9DF-A1D38267D047}",{id=173,isNotDropping=true})c_a.Anchored=true
c_a.CFrame=CFrame.new(a_a,a_a-b_a)*CFrame.Angles(math.pi/2,-
math.pi/2,0)*CFrame.new(0,
c_a.Size.Y/2,0)c_a.Parent=dd
local d_a=bb:invoke("{0A040B75-B4E3-4DED-A038-B72DCD22ED1D}","Hitbox",c_a.Position-Vector3.new(0,3,0),
nil,{isPassive=true,isDamageImmune=true,specialName=ad.Name.."'s Lure"})
if d_a.manifest then d_a.manifest.Anchored=true
game.Debris:AddItem(d_a.manifest,dc)game.Debris:AddItem(c_a,dc)else c_a:Destroy()return false,
"Failed to spawn lure."end
bb:fireAllClients("{006F08C2-1541-41ED-90BE-192482E14530}",{Text=""..ad.Name.." just activated a monster lure!",Font=Enum.Font.SourceSansBold,Color=Color3.fromRGB(234,81,232)})c_a.Anchored=true;c_a.Size=c_a.Size;c_a.CFrame=c_a.CFrame
spawn(function()local _aa=0
while bc>_aa do if
c_a.Parent==nil then break end
wait((dc/bc)* (math.random(95,105)/100))local aaa=c_a.Position+
Vector3.new(math.random(-25,25),0,math.random(-25,25))
local baa=_c.selectFromWeightTable(cd)
local caa,daa=db.raycast(Ray.new(c_a.Position,aaa-c_a.Position),{workspace.placeFolders})
if baa and not caa then
local _ba=bb:invoke("{0A040B75-B4E3-4DED-A038-B72DCD22ED1D}",baa.monsterType,aaa,nil,{giant=math.random(1,270)==77,superGiant=
math.random(1,3400)==777,gigaGiant=math.random(1,10000)==7777},function(aba)
aba.specialName=
"Lured ".. (aba.specialName or baa.monsterType)aba.level=aba.level+1
aba.scale=(aba.scale or 1)+0.2;aba.baseDamage=(aba.baseDamage or 1)*1.25;aba.healthMulti=(
aba.healthMulti or 1)*1.5;aba.baseSpeed=(aba.baseSpeed or 1)*
1.1
aba.bonusLootMulti=(aba.bonusLootMulti or 1)*2;aba.bonusXPMulti=(aba.bonusXPMulti or 1)*1.5 end)
if _ba then _aa=_aa+1;if _ba.manifest then local aba=script.Smoke:Clone()
aba.Parent=_ba.manifest end end end end end)return true,"Successfully activated Lure.. Get ready to fight."else return false,
"You're not standing on the ground."end else return false,
"This map already has the maximum number of lures it can support ("..tostring(cc).."), try again later."end else return false,"Not nearby any monsters to lure."end else return false,"Monsters don't spawn here."end end;return false,"Character is invalid."end,buyValue=40,sellValue=1000,canStack=true,canBeBound=true,canAwaken=false,isImportant=false,category="consumable"}