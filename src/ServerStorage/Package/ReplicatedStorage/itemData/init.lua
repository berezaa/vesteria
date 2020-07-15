local _a=game:GetService("CollectionService")
local aa=require(game.ReplicatedStorage:WaitForChild("modules"):WaitForChild("levels"))local ba=0;local ca={}
do
for da,_b in pairs(script:GetChildren())do
if
_b:FindFirstChild("container")then
for cb,db in pairs(_b.container:GetChildren())do
if db:IsA("BasePart")then
if db.Name==
"Head"then db.Transparency=1 else db.Material="Glass"db.Transparency=0.5
db.Reflectance=0.2;db.Color=Color3.new(1,1,1)end
if _a:HasTag(db,"interact")then _a:RemoveTag(db,"interact")end end end end;local ab=require(_b)
if ab.category=="equipment"then local cb=0
if ab.equipmentSlot==1 or
ab.equipmentSlot==8 then cb=7 elseif ab.equipmentSlot==2 then cb=3 end
if ab.equipmentType=="greatsword"then elseif ab.equipmentType=="shield"then end;ab.maxUpgrades=ab.maxUpgrades or cb end;local bb="misc"
if ab.category=="equipment"then if ab.equipmentSlot==1 then
bb=ab.equipmentType or"sword"end elseif ab.category=="consumable"then
if ab.applyScroll then bb="scroll"end end;ab.itemType=ab.itemType or bb;if _b:FindFirstChild("container")and not
_b.container.PrimaryPart then
_b.container.PrimaryPart=_b.container:FindFirstChildWhichIsA("BasePart")end
ab.module=_b;if ca[ab.id]then
warn("CONFLICT OF ITEM IDS @",ab.id,ab.name,ca[ab.id].name)end;ca[ab.id]=ab;ca[_b.Name]=ab;if
ab.id>ba then ba=ab.id end end end;print("HIGHEST ID >>>",ba)return ca