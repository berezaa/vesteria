
local ca={description="Lose health over time! Jump into water to put out.",doesStack=true}local da=game:GetService("ReplicatedStorage")
local _b=require(da.modules)local ab=_b.load("network")local bb=_b.load("entityUtilities")
local cb=_b.load("events")local db={}
function ca.__onStatusEffectBegan(_c)
local ac=bb.getEntityManifestByEntityGUID(_c.targetEntityGUID)if not ac then return end;local bc=script.emitter:Clone()
bc.Name="ablazeEmitter"bc.Parent=ac;db[_c.guid]=_c
coroutine.wrap(function()
while db[_c]and _c.isActive do
local cc=bb.getEntityManifestByEntityGUID(_c.targetEntityGUID)
if cc then
local dc,_d,ad,bd=workspace:FindPartOnRayWithWhitelist(Ray.new(cc.Position,Vector3.new(0,-cc.Size.Y/2 -3,0)),{workspace.Terrain})if bd==Enum.Material.Water then _c:stop()break end
wait(1.5)else break end end end)()end
function ca.__onStatusEffectEnded(_c)db[_c.guid]=nil
local ac=bb.getEntityManifestByEntityGUID(_c.targetEntityGUID)if not ac then return end;if ac:FindFirstChild("ablazeEmitter")then
ac.ablazeEmitter:Destroy()end end;function ca.__onClientStatusEffectBegan(_c)end
function ca.__onClientStatusEffectEnded(_c)end
function ca.__onStatusEffectTick(_c,ac)local bc=_c.data.damage/_c.data.duration
local cc=bb.getEntityManifestByEntityGUID(_c.targetEntityGUID)
local dc=bb.getEntityManifestByEntityGUID(_c.sourceEntityGUID)
if cc then
local _d={damage=bc*ac*_c.stacks,sourceType="status",sourceId=_c.id,damageType="physical",sourceEntityGUID=_c.sourceEntityGUID}local ad=cc:FindFirstChild("entityType")if not ad then return end
ad=ad.Value
if ad=="monster"then
ab:invoke("{031BE66E-62B6-4583-B409-DCB61C0DA077}",nil,cc,_d)else
ab:invoke("{AC8B16AA-3BD2-4B7F-B12C-5558B8857745}",nil,cc,_d)end end end;return ca