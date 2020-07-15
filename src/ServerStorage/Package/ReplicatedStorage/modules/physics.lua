local _a={}local aa=game:GetService("PhysicsService")local ba={}
function _a:getCollisionGroup(da)
local _b,ab=pcall(aa.GetCollisionGroupId,aa,da)
if not _b then _b,ab=pcall(aa.CreateCollisionGroup,aa,da)end;if _b and not ba[da]then ba[da]=true end
return _b and ab or nil end
function _a:setWholeCollisionGroup(da,_b)if da:IsA("BasePart")then
aa:SetPartCollisionGroup(da,_b)end;for ab,bb in pairs(da:GetChildren())do
self:setWholeCollisionGroup(bb,_b)end end
function _a:removeWholeCollisionGroup(da,_b)if da:IsA("BasePart")then
aa:RemoveCollisionGroup(da,_b)end;for ab,bb in pairs(da:GetChildren())do
self:removeWholeCollisionGroup(bb,_b)end end
local function ca()
if game:GetService("RunService"):IsClient()then return end;_a:getCollisionGroup("passthrough")
_a:getCollisionGroup("items")_a:getCollisionGroup("characters")
_a:getCollisionGroup("pvpCharacters")_a:getCollisionGroup("monsters")
_a:getCollisionGroup("monstersLocal")_a:getCollisionGroup("npcs")
_a:getCollisionGroup("antiJumpHitbox")_a:getCollisionGroup("fishingSpots")
aa:CollisionGroupSetCollidable("items","items",false)
aa:CollisionGroupSetCollidable("items","characters",false)
aa:CollisionGroupSetCollidable("items","monsters",false)
aa:CollisionGroupSetCollidable("items","npcs",false)
aa:CollisionGroupSetCollidable("items","fishingSpots",false)
aa:CollisionGroupSetCollidable("antiJumpHitbox","antiJumpHitbox",true)
aa:CollisionGroupSetCollidable("characters","Default",true)
aa:CollisionGroupSetCollidable("characters","monsters",false)
aa:CollisionGroupSetCollidable("characters","characters",true)
aa:CollisionGroupSetCollidable("characters","fishingSpots",false)
aa:CollisionGroupSetCollidable("pvpCharacters","Default",true)
aa:CollisionGroupSetCollidable("pvpCharacters","monsters",false)
aa:CollisionGroupSetCollidable("pvpCharacters","pvpCharacters",true)
aa:CollisionGroupSetCollidable("passthrough","items",false)
aa:CollisionGroupSetCollidable("passthrough","npcs",false)
aa:CollisionGroupSetCollidable("passthrough","monsters",false)
aa:CollisionGroupSetCollidable("passthrough","monstersLocal",false)
aa:CollisionGroupSetCollidable("passthrough","characters",false)end;ca()return _a